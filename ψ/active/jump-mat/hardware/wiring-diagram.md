---
date: 2026-05-07
purpose: Single-source wiring reference for assembly + debug
companion: build-spec.md (full spec), firmware/jumpmat_phase1.ino (matching code)
---

# Wiring Diagram — Jump Mat Phase 1

**Use this when assembling on the breadboard.** Print or open on phone.
Confidence: medium-high (Aree, derived from spec — not yet validated on hardware).

---

## 1. Full system overview

```
+------------------+       +-----------------+       +------------------+
|  PCB MAT         |       |  ESP32 +        |       |  POWER CHAIN     |
|  (4 PCBs,        |------>|  COMPONENTS     |<------|  (battery/USB)   |
|   2 pairs)       |       |  on breadboard  |       |                  |
+------------------+       +-----------------+       +------------------+
       |                          |                         |
       |                          v                         |
       |                   [Serial USB to                   |
       |                    laptop terminal]                |
       |                                                    |
       +--- 2 wires only:                                   |
            * combined red (sensor)                         |
            * combined black (GND)                          |
                                                            |
                                                  Charging path: USB
                                                  Discharge path: 18650 -> MT3608 -> ESP32
```

---

## 2. Mat wiring (top-down view)

```
                      40 cm
   +----------------------+----------------------+
   |                       |                       |
   |    PAIR 1             |    PAIR 2             |
   |    20 x 30 cm         |    20 x 30 cm         |
   |                       |                       |
   |   R*           .      |   .            R*     |    R = red wire solder
   |   (TL)                |               (TR)    |    B = black wire solder
   |                       |                       |    * = corner under tape
   |                       |                       |        compression
   |   .            B*     |   B*            .     |
   |              (BR)     |   (BL)                |
   |                       |                       |
   +----------------------+----------------------+
                       30 cm

   Pair 1:  red @ Top-Left,   black @ Bottom-Right
   Pair 2:  red @ Top-Right,  black @ Bottom-Left
   (Diagonal — no internal short risk; both blacks meet near seam.)
```

### Pair internal (cross-section)

```
   Red wire enters here (top PCB, copper-down face)
        v
   ===================================  <- PCB top (copper down)
                                                  ^
                                                  | foam tape spacer 1.5mm
                                                  | (4 perimeter strips + 1 cross bar)
   ===================================  <- PCB bottom (copper up)
        ^
   Black wire enters here (bottom PCB, copper-up face)

   Idle: 1.5mm air gap = open circuit (infinite ohms between red and black)
   Pressed: PCBs flex through tape window = closed circuit (~0 ohms)
```

---

## 3. Junction (combine 2 pairs in parallel)

Both pairs wired in parallel = mat acts as one big switch
(stepping on either pair = closes the same circuit ESP32 sees).

```
   Pair 1 RED  -----+
                    +-----[twist + solder + heat shrink]----- to ESP32 GPIO 4
   Pair 2 RED  -----+         (call this junction "RED_BUS")

   Pair 1 BLACK ----+
                    +-----[twist + solder + heat shrink]----- to ESP32 GND
   Pair 2 BLACK ----+         (call this junction "BLACK_BUS")
```

**Where to place junctions**: near the seam between Pair 1 and Pair 2
(both blacks meet there naturally; route reds along the side to meet too).

---

## 4. ESP32 + components on breadboard

```
                               BREADBOARD
   +------------------------------------------------------------+
   |                                                            |
   |   POWER RAILS (red = +, blue = -)                          |
   |   [+]==========================================[+]         |
   |   [-]==========================================[-]         |
   |                                                            |
   |        +-----+-----+-----+-----+-----+-----+               |
   |        | a    b    c    d    e    f    g  ...              |
   |    1   o    o    o    o    o    o    o                     |
   |    2   o    o    o    o    o    o    o                     |
   |        ...                                                 |
   |                                                            |
   |   ESP32-WROOM-32 DOIT V1 (30 pins) straddles the gap       |
   |                                                            |
   +------------------------------------------------------------+

   ESP32 pin map (DOIT V1, 30-pin):

         +------------+
   EN   -|  1     30  |- GPIO 23
   GPIO36-|  2     29  |- GPIO 22
   ...           ...
   GPIO 4-|  ?     ?  |- ...      <-- our sensor pin
   3V3  -|  ?     ?  |- ...
   GND  -|  ?     ?  |- GND
   VIN  -|  ?     ?  |- ...

   (Refer to actual silkscreen on Toey's board — pin layout varies by clone.)
```

### Component placement on breadboard

| Component | One end | Other end | Notes |
|---|---|---|---|
| **R1 (10kΩ pull-up)** | ESP32 3V3 pin | ESP32 GPIO 4 (sensor input) | Holds line HIGH when mat open |
| **C1 (100nF filter)** | ESP32 GPIO 4 | ESP32 GND | Smooths edge noise + sparks |
| **Mat RED_BUS wire** | ESP32 GPIO 4 (same node as R1+C1) | — | Mat closes -> pin pulled LOW |
| **Mat BLACK_BUS wire** | ESP32 GND | — | Sensor return path |
| **MT3608 OUT+** | ESP32 VIN | — | 5V regulated input |
| **MT3608 OUT-** | ESP32 GND | — | Power return |

### Schematic (text-style)

```
                               +3V3 (ESP32 internal regulator)
                                |
                              [10kΩ R1]
                                |
   MAT RED_BUS  >---------+-----+-----+--------< GPIO 4 (ESP32)
                          |           |
                          |        [100nF C1]
                          |           |
   MAT BLACK_BUS >---------+-----------+--------< GND (ESP32)
                                                        ^
                                                        |
                                              MT3608 OUT-
                                              (also tied to TP4056 GND)
```

**Key node**: GPIO 4 = junction of {R1 to 3V3, C1 to GND, mat RED_BUS}.
On a breadboard, all four wires share the same row.

---

## 5. Power chain (full)

```
   +------------------+
   |  USB-C charger    |  (5V 1-2A wall adapter or laptop port)
   |  5V output       |
   +--------+---------+
            |
            | USB-C cable
            v
   +------------------+
   |  TP4056 module    |  (charging + over/under-voltage protection)
   |   - IN+: USB 5V   |
   |   - IN-: USB GND  |
   |   - B+:  18650 +  |
   |   - B-:  18650 -  |
   |   - OUT+: load +  |  <-- 4.2V (full) to 3.0V (cutoff)
   |   - OUT-: load -  |
   +--------+---------+
            |
            v
   +------------------+
   |  18650 holder     |  (single cell, 3.7V nominal)
   +--------+---------+
            |  +
            v
        [Power switch (SPDT)]   <-- between 18650(+) and MT3608 IN+
            |                        when OFF: ESP32 is off but TP4056
            |                        can still charge battery via USB
            v
   +------------------+
   |  MT3608 boost     |  (3.7V -> 5V, with potentiometer)
   |   - IN+:  switched  |
   |   - IN-:  18650(-)  |
   |   - OUT+: 5V (tune!)|  <-- adjust to 5.0V via pot BEFORE
   |   - OUT-: GND       |       connecting ESP32
   +--------+---------+
            |
            v
   +------------------+
   |  ESP32 VIN pin    |
   |  ESP32 GND pin    |
   +------------------+
```

### Critical safety steps

1. **Tune MT3608 to 5.0V FIRST** (before connecting ESP32)
   - Power MT3608 IN+ from 18650 (or USB benchtop supply)
   - Probe OUT+ with multimeter
   - Turn the brass potentiometer screw clockwise to raise voltage
   - Stop when reading is 5.00 +/- 0.05V
   - *Connecting ESP32 with MT3608 set to 12V will fry it instantly.*

2. **Common ground**: TP4056 OUT-, MT3608 IN-, MT3608 OUT-, and ESP32 GND must all be tied together. Use the breadboard blue rail.

3. **Switch wiring**: SPDT switch ONLY on the +5V/3.7V line — do not interrupt GND.

---

## 6. Wiring sequence (recommended order)

1. **Solder + heat-shrink mat junctions** (red bus, black bus) — off the board
2. **Mount ESP32 on breadboard**, identify GPIO 4 / 3V3 / GND / VIN by silkscreen
3. **Add R1 (10kΩ)**: 3V3 rail to GPIO 4 row
4. **Add C1 (100nF)**: GPIO 4 row to GND rail
5. **Test (no power yet)**: multimeter from GPIO 4 to GND should read ~10kΩ
6. **Wire mat RED_BUS** to GPIO 4 row (same as R1, C1)
7. **Wire mat BLACK_BUS** to GND rail
8. **Test mat (no ESP32 power)**: multimeter from GPIO 4 to GND
   - mat idle: ~10kΩ (R1 dominates)
   - mat pressed: ~0Ω (mat shorts everything)
9. **Build power chain separately**, tune MT3608 to 5V, verify with multimeter
10. **Connect MT3608 OUT to ESP32 VIN/GND**
11. **Plug USB-to-laptop** for Serial monitoring (or supply via TP4056 USB)
12. **Flash firmware**, open Serial Monitor at 115200

---

## 7. Quick troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| Serial silent on boot | Wrong baud rate | Set 115200 in Serial Monitor |
| `Initial state: ON_MAT` with no foot | Mat too sensitive (pressed at idle) | Tape too thin, or pressure on solder bump — re-check spacer |
| `Initial state: IN_AIR` always | Mat never closes | Bad solder joint / wire break / R1 pull-up wrong value |
| Flights all `[FILTERED]` | False edges shorter than 100ms | Raise debounce 10ms -> 20ms in firmware |
| Heights 2-3x larger than expected | Sensor sees release on bounce, not landing | Mechanical bounce — needs damping (foam thicker) |
| ESP32 hot to touch | MT3608 set too high (>5.5V) | Tune down immediately |

---

## References

- Layer stack: `build-spec.md` Section 1.4
- Solder positions: `build-spec.md` Section 1.5-1.6
- Test plan: `build-spec.md` Section 6
- Reference firmware (4-sensor S3): `../../../learn/projects/jump-mat/chronojump-refs/4Platforms.ino`
- Phase 1 firmware (ours): `../firmware/jumpmat_phase1/jumpmat_phase1.ino`
