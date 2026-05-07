# Jump Mat Firmware

## Files

- **`jumpmat_phase1.ino`** — Phase 1 firmware. Serial output, no BLE.
  - Target: ESP32-WROOM-32 DOIT V1
  - 1 sensor (GPIO 4), polling + software debounce
  - Filters flights < 100ms (VALD threshold)
  - Output format: `Jump #N | Flight: 0.XXX s | Height: XX.X cm`

## How to flash

1. Open Arduino IDE
2. Boards Manager → install **esp32** (Espressif Systems)
3. Tools → Board → **ESP32 Dev Module** (or "DOIT ESP32 DEVKIT V1")
4. Tools → Port → COM port that appears when ESP32 plugged in
5. Open `jumpmat_phase1.ino` → Upload
6. Tools → Serial Monitor → set baud to **115200**

## Test plan

| # | Test | Expected output |
|---|------|-----------------|
| 1 | Boot with no mat connected | `Initial state: IN_AIR` (pull-up holds HIGH) |
| 2 | Short GPIO 4 to GND | `Initial state: ON_MAT` |
| 3 | Flick GPIO 4 quickly (<100ms) | `[FILTERED]` message |
| 4 | Press 200ms then release | `Jump #1 | Flight: 0.200 s | Height: 4.9 cm` |
| 5 | Real jump (mat connected) | Reasonable height (15-50cm range) |

## Calibration

Target: < 5cm difference vs phone slow-mo at 240fps.

Procedure:
1. Record jump with phone at 240fps from side
2. Count frames mat-leaves to mat-touches
3. Flight = frames / 240 seconds
4. Height = 9.81 * flight^2 / 8 * 100 cm
5. Compare to firmware Serial output

If error > 5cm, check:
- Mechanical: tape compression uniform? solder bumps not bottoming out?
- Electrical: false triggers from noise (raise debounce to 20ms)?
- Threshold: lower MIN_FLIGHT_MS to 80ms if missing real short jumps

## Phase 1.5 (next)

- Add BLE service (Chronopic-4 protocol — see `chronojump-refs/Communication.md`)
- Validate against Chronojump desktop app (free, gold standard)
- Then move to perfboard + project box (Phase 2)
