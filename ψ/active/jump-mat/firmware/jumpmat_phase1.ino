/*
  Jump Mat — Phase 1 Firmware
  Target: ESP32-WROOM-32 DOIT V1
  Goal: Pure jump height measurement, max accuracy. No RSI, no multi-jump.

  Hardware:
    - GPIO 4: sensor input (mat contact)
        Idle (in air, mat open):  HIGH (pulled up via external 10kΩ to 3V3)
        Pressed (on mat):         LOW  (mat shorts pin to GND)
    - GPIO 2: onboard LED (status indicator)

  Output: Serial @ 115200
    - Boot:    "Jump Mat - Phase 1\n"
    - Initial: "Initial state: ON_MAT|IN_AIR\n"
    - Each valid jump:
        "Jump #N | Flight: 0.534 s | Height: 35.0 cm\n"
    - Filtered (flight < 100ms):
        "[FILTERED] Flight X.X ms < 100ms threshold\n"

  Physics:
    h = g * t^2 / 8   (where t = flight time in seconds, h in meters)
    Assumes takeoff velocity = landing velocity (symmetric flight).

  Ported from: chronojump-refs/4Platforms.ino (ESP32-S3, 4-sensor, BLE)
  Simplifications for Phase 1:
    - Single sensor (2 pairs wired in parallel = appears as 1 contact)
    - No BLE (Phase 1.5 will re-add)
    - No NeoPixel RGB (use built-in LED only)
    - Polling + software debounce (vs hw_timer interrupts in reference)

  Calibration target:
    < 5 cm difference vs phone slow-mo (240fps) measurement
    Validate against Chronojump desktop via BLE in Phase 1.5
*/

const int SENSOR_PIN = 4;
const int LED_PIN = 2;

const unsigned long DEBOUNCE_MS = 10;       // mechanical settling time
const unsigned long MIN_FLIGHT_MS = 100;    // VALD SmartJump false-trigger threshold
const float GRAVITY = 9.81f;                // m/s^2

enum MatState { ON_MAT, IN_AIR };

MatState state = ON_MAT;
unsigned long takeoffMicros = 0;
int lastRaw = HIGH;
int stableState = HIGH;
unsigned long lastChangeMs = 0;
unsigned int jumpCount = 0;

void setup() {
  Serial.begin(115200);
  pinMode(SENSOR_PIN, INPUT);  // external 10kohm pull-up handles bias
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);

  delay(200);  // serial settle
  Serial.println();
  Serial.println("Jump Mat - Phase 1");
  Serial.println("Step on mat, then jump.");

  stableState = digitalRead(SENSOR_PIN);
  lastRaw = stableState;
  state = (stableState == LOW) ? ON_MAT : IN_AIR;
  Serial.print("Initial state: ");
  Serial.println(state == ON_MAT ? "ON_MAT" : "IN_AIR");

  digitalWrite(LED_PIN, state == ON_MAT ? HIGH : LOW);
}

void loop() {
  int raw = digitalRead(SENSOR_PIN);
  unsigned long nowMs = millis();

  if (raw != lastRaw) {
    lastChangeMs = nowMs;
    lastRaw = raw;
  }

  if (raw != stableState && (nowMs - lastChangeMs) >= DEBOUNCE_MS) {
    stableState = raw;
    onTransition(stableState);
  }
}

void onTransition(int newRaw) {
  // newRaw: LOW = on mat, HIGH = in air
  if (newRaw == HIGH && state == ON_MAT) {
    state = IN_AIR;
    takeoffMicros = micros();
    digitalWrite(LED_PIN, LOW);
    return;
  }

  if (newRaw == LOW && state == IN_AIR) {
    unsigned long flightUs = micros() - takeoffMicros;
    state = ON_MAT;
    digitalWrite(LED_PIN, HIGH);

    float flightMs = flightUs / 1000.0f;
    if (flightMs < MIN_FLIGHT_MS) {
      Serial.print("[FILTERED] Flight ");
      Serial.print(flightMs, 1);
      Serial.println(" ms < 100ms threshold");
      return;
    }

    float flightS = flightUs / 1000000.0f;
    float heightCm = (GRAVITY * flightS * flightS) / 8.0f * 100.0f;

    jumpCount++;
    Serial.print("Jump #");
    Serial.print(jumpCount);
    Serial.print(" | Flight: ");
    Serial.print(flightS, 3);
    Serial.print(" s | Height: ");
    Serial.print(heightCm, 1);
    Serial.println(" cm");
  }
}
