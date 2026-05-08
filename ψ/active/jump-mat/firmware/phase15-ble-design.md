# Phase 1.5 BLE Design — Jump Mat

**Status**: Design only. No code yet. Written 2026-05-08 by Aree during NimBLE self-study (Toey's permission, parts shipping).
**Goal**: Port the validated Phase 1 Serial firmware to add a NimBLE GATT server, **compatible with Chronopic-4 BLE protocol** so the existing Chronojump desktop client works unchanged. Bonus: any phone BLE inspector (nRF Connect, LightBlue) can also read.
**Library**: `h2zero/NimBLE-Arduino` (50% less flash, 100KB less RAM vs the bluedroid `BLEDevice.h`)

---

## 1. Compatibility decision: clone Chronopic-4 UUIDs

We adopt the **exact same UUIDs** as `chronojump-refs/Communication.md`. Reasons:
- Chronojump desktop already speaks this protocol — zero client work
- Toey's phone via nRF Connect can subscribe to a known UUID
- Future Chronojump updates remain compatible

Future identity question: do we want our own UUIDs to brand the device differently? (Phase 2+ business angle decision; not a Phase 1.5 concern.)

---

## 2. Service map (simplified — switch-mat has no IR, single sensor)

### Service 1: Sensor data
- **Service UUID**: `b0f3d089-3ce3-4ed6-9920-43afae288982`
- **Characteristic UUID**: `19a8d494-a941-4ae3-99c0-28e9d352a170`
- **Properties**: `READ | NOTIFY`
- **Format (UTF-8 text)**: `0:<signed_micros>` per Chronopic-4 wire format
  - `0` = sensor index (we only have one, but keep the prefix for client compat)
  - Negative = leaving the mat (HIGH→LOW transition, takeoff)
  - Positive = landing on the mat (LOW→HIGH transition, landing)
  - Example: `0:-450123` (450ms flight just ended, takeoff event)
- **CCCD** auto-created by NimBLE when `NOTIFY` flag set

### Service 2: Commands
- **Service UUID**: `7ddcf4e4-acad-4935-bc53-5e29e3a130bf`
- **Command Characteristic**: `1a2ae85a-8118-4644-9e3b-387122d8cd9e` — `WRITE | WRITE_NR`
- **Output Characteristic**: `3bf2da15-f408-414f-a8dd-8cf1590b4a4a` — `READ | NOTIFY`
- **Format**: `[command]:[argument];` (UTF-8 text, terminator `;`)

---

## 3. Command set — keep / drop

The Chronopic-4 reference firmware (`4Platforms.ino`) has commands for IR LED control, multi-device sync, and NeoPixel RGB. Switch mat has none of these, so most are dropped.

### Keep (relevant to switch mat)
| Command | Purpose | Notes |
|---|---|---|
| `get_version:` | Returns `Aree-JumpMat-1.5` (or whatever version we set) | trivial |
| `start_capture:` | Begins data streaming, prints initial sensor state | mirrors `4Platforms.ino` line 253 |
| `end_capture:` | Stops streaming | mirrors line 265 |
| `set_debounce:[us];` | Update debounce window without reflashing | useful for tuning per mat construction batch |
| `get_battery_level:` | Returns battery % | hooks to TP4056 voltage divider once we add ADC reading; placeholder OK for v1.5 |
| `setBLEName:[name];` | Rename device + restart BLE | nice-to-have (Toey may want "ToeyMat" instead of "Aree-JumpMat") |
| `restart:` | `ESP.restart()` | safety + recovery |

### Drop (rod-style only)
- `setIRPower`, `setPulsePeriod`, `startPulsing`, `endPulsing` — no IR LEDs in switch mat
- `setAndMode`, `setOrMode` — single sensor, no logic gate
- `sync`, `delay` — multi-device timing sync, irrelevant for 1 mat
- `set_rgb` — no NeoPixels (Phase 1 build uses single onboard LED only)
- `sleep`, `wakeup` — defer to Phase 2 (low-power mode needs separate research; battery isn't a Phase 1.5 priority)

---

## 4. Connection parameters (NimBLE specifics)

From the smoke-test snippet:
```
pServer->updateConnParams(handle, 24, 48, 0, 180);
```
Translates to: 30–60 ms connection interval, 0 slave latency, 1800 ms supervision timeout. Good balance for sensor streaming where we want low-latency notify but don't want radio thrashing the battery during idle.

For the jump mat:
- **During capture**: 24-48 (30-60 ms) — fast enough for jump events (flight ~300-500 ms gives many notify slots)
- **Idle**: leave default — let the central (phone/desktop) negotiate

Advertising:
- Interval: NimBLE default ~150 ms (not over-tweaked Phase 1.5)
- Name: `Aree-JumpMat` (or `setBLEName` chosen)
- Advertise both service UUIDs in the ADV packet so clients can filter

---

## 5. Skeleton structure (file layout, no code yet)

When we write Phase 1.5, the sketch grows from `jumpmat_phase1/jumpmat_phase1.ino` to:

```
ψ/active/jump-mat/firmware/jumpmat_phase15/
├── jumpmat_phase15.ino       # main sketch — setup() + loop() + sensor logic (mostly Phase 1 code)
├── ble.cpp / ble.h            # BLE init, server callbacks, characteristic helpers
├── commands.cpp / commands.h  # parse + dispatch [command]:[arg]; protocol
└── README.md                  # flash + verify procedure (extend Phase 1's)
```

Splitting into multiple files is only worth it if `.ino` exceeds ~300 lines. Phase 1 was ~120 lines + BLE adds ~150 = ~270 → close to threshold. Single file is also fine. Decide at write time.

### Wire format flow

```
Phase 1 today                         Phase 1.5 plan
───────────────                       ──────────────────────────────
sensor change                         sensor change
  ↓                                     ↓
debounce 10ms                         debounce 10ms (unchanged)
  ↓                                     ↓
Serial.print("Jump #N | ...")         (a) Serial.print(...)        ← keep for debug
                                      (b) sprintf("0:%ld", phaseDuration)
                                      (c) sensorChar->setValue(buf)
                                      (d) sensorChar->notify()
```

Phase 1 firmware stays intact for testing. BLE is **additive**: same ISR/debounce produces both Serial line and BLE notify.

---

## 6. Library install

Phase 1.5 build needs NimBLE-Arduino installed via arduino-cli:

```
arduino-cli lib install "NimBLE-Arduino"
```

Verify before flashing:
```
arduino-cli lib list | grep -i nimble
```

(Note: Chronopic-4 reference uses Arduino's `BLEDevice.h` — the bluedroid stack. We deliberately switch to NimBLE for memory headroom on ESP32 WROOM-32 which has tighter RAM than the S3 the reference targets.)

---

## 7. Test plan

### Unit-ish (without phone, just Serial)
1. Flash Phase 1.5 sketch
2. Serial monitor → confirm `Phase 1.5 ready, advertising as Aree-JumpMat`
3. Press mat with hand → see Serial line `Jump #N` AS BEFORE (Phase 1 path still works)

### BLE connection (phone)
4. Open nRF Connect on phone → scan → find `Aree-JumpMat`
5. Connect → enumerate services → confirm both service UUIDs present
6. Subscribe to sensor data char (`19a8d494-...`) → press mat → see notify packets in nRF Connect
7. Write `get_version:` to command char → read output char → see version string

### Chronojump desktop (when ready)
8. Open Chronojump → BLE devices → see `Aree-JumpMat` listed
9. Connect → run a test session → confirm jump events register

### Pass criteria
- Sensor notify packets match Serial output (same numbers, same signs, same order)
- No notify packet loss during fast jumps (rapid presses)
- Phase 1's Sargent calibration still passes from Serial output (BLE doesn't break the existing Phase 1 contract)

---

## 8. Open questions / TBD

1. **WROOM-32 RAM headroom with NimBLE**: smoke test compile will tell us. Phase 1 uses 6% RAM. NimBLE adds ~10-20% typical. Should fit comfortably.
2. **Battery monitoring**: Chronopic-4 has a TP4056 + voltage divider chain to ADC. We have TP4056 in the power chain but not yet a voltage sense circuit. `get_battery_level` will return placeholder until that wiring is added (Phase 2 candidate).
3. **Multiple simultaneous BLE clients**: NimBLE supports it, but is it useful? Probably no for v1.5 — phone OR desktop, not both.
4. **Notify queue overflow**: if a jump produces 2 fast transitions (takeoff + landing within a few ms), can NimBLE notify both? Yes — NimBLE buffers internally. Will verify in test step 6.
5. **Service discovery latency**: first connect on iOS sometimes takes 3-5 sec to enumerate. Don't troubleshoot until we observe it.

---

## 9. References

- `ψ/learn/projects/jump-mat/chronojump-refs/Communication.md` — Chronopic-4 BLE protocol spec (UUIDs, commands)
- `ψ/learn/projects/jump-mat/chronojump-refs/4Platforms.ino` — reference firmware (4-sensor, S3, bluedroid; we keep the structure, swap stack)
- `ψ/active/jump-mat/firmware/jumpmat_phase1/jumpmat_phase1.ino` — current Phase 1 Serial-only firmware
- NimBLE-Arduino library: `/h2zero/nimble-arduino` (Context7 ID; benchmark 89.5)
- Chronojump license is GPL-2.0 — if we publish firmware, ours must be GPL too. (Phase 2 business decision.)

---

## 10. When to write the code

**Trigger**: Phase 1 passes Sargent calibration (target: Day 4, when parts arrive 3-7 days from 2026-05-07).
**Effort estimate**: 2-3 hours for sketch + nRF Connect smoke test. Chronojump desktop verification adds another 1 hour.
**Aree's commitment**: this design doc is locked enough that the build can proceed without a re-design pass.
