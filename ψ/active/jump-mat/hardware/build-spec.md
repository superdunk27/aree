---
date: 2026-05-07
status: Phase 1 spec ready (awaiting parts order + Toey equipment confirmation)
phase: 1 (jump height only, max accuracy)
---

# Jump Mat — Build Specification (Phase 1)

## Goal

**Pure jump height measurement, max accuracy.** No RSI, no multi-jump, no asymmetry — just height.

## Architecture

Path A++ — Chronopic-4 protocol-compatible switch mat
- ESP32-WROOM-32 reads single GPIO pin (binary contact sensing)
- BLE notification (Phase 1.5) or Serial output (Phase 1)
- Compatible with Chronojump desktop app for free validation

---

## 1. Mat Construction

### 1.1 Final dimensions
**40×30cm landing area** = 2 pairs side-by-side (4 PCBs total)

```
       40 cm
   ┌────────────┬────────────┐
   │   pair 1    │   pair 2    │   30 cm
   │   20×30cm   │   20×30cm   │
   └────────────┴────────────┘
```

### 1.2 Materials per mat (full build)

| Item | Spec | Quantity |
|---|---|---|
| PCB Epoxy single-side | 20×30cm × 1.5mm FR4 | 4 sheets |
| Foam tape 2-sided | 1.5mm thick × 1cm wide | 1 roll (5-10m) |
| Vinyl/PVC cover | 1mm thick, 45×35cm | 1 sheet |
| Plywood/MDF base | 5mm thick, 45×35cm | 1 sheet |
| Anti-slip rubber feet | dome with backing | 4 pcs |

### 1.3 Spacer pattern (foam tape on each pair)

```
       ┌──────────────────────────────┐
       │##############################│  ← perimeter top
       │#                            #│
       │#       ช่อง A                #│  ← contact window 1
       │#                            #│
       │##############################│  ← cross bar (15cm from top)
       │#                            #│
       │#       ช่อง B                #│  ← contact window 2
       │#                            #│
       │##############################│  ← perimeter bottom
       └──────────────────────────────┘
        20 cm wide × 30 cm long
```

- 4 perimeter strips + 1 cross bar = 2 contact windows per pair
- 4 windows total across 2 pairs

### 1.4 Layer stack (top → bottom)

| # | Layer | Why |
|---|---|---|
| 1 | Vinyl/PVC cover 1mm | Grip + dust protection + does not absorb impact |
| 2 | PCB top (copper-down) | Top sensor electrode |
| 3 | Foam tape spacer 1.5mm (grid pattern) | Keeps electrodes separated when idle |
| 4 | PCB bottom (copper-up) | Bottom sensor electrode |
| 5 | Plywood/MDF 5mm base | Rigid backing, prevents oscillation |
| 6 | Rubber feet × 4 corners | Mat does not slide during jumps |

### 1.5 Solder positions

**Diagonal arrangement** (no internal short risk):

| Pair | Wire | Position (top-down view) | PCB face |
|---|---|---|---|
| 1 | Red | Top-Left (TL) | Top PCB copper (down face after assembly) |
| 1 | Black | Bottom-Right (BR) | Bottom PCB copper (up face) |
| 2 | Red | Top-Right (TR) | Top PCB copper |
| 2 | Black | Bottom-Left (BL) | Bottom PCB copper |

**Bonus**: Both black wires meet near the seam between pairs → easy to join.

### 1.6 Solder technique (critical — bump must not affect contact zone)

- Use **24 AWG** wire (not 22 AWG) — smaller solder bump
- Solder **at the corner under tape coverage** (not in open contact zone)
- Use minimal solder (drop the size of a pin head)
- Cut 5mm notch in tape edge at each wire exit
- Foam tape compresses around bump → preserves uniform spacer height in contact windows

### 1.7 Wire combination (parallel wiring of 2 pairs)

```
   Pair 1 red ─┬─→ junction ─→ to ESP32 GPIO 4
   Pair 2 red ─┘

   Pair 1 black ─┬─→ junction ─→ to ESP32 GND
   Pair 2 black ─┘
```

Junction made by twisting + soldering wire ends + heat shrink.

---

## 2. ESP32 Wiring

### 2.1 Connections (5 wires + 2 components)

```
                            ESP32-WROOM-32
                            ┌─────────────────┐
                            │                  │
   3V3 ───[10kΩ]───┐         │  3V3 pin    ●─┤  (1) pull-up source
                   │         │                  │
   Mat red ────────┤────────│  GPIO 4    ●─┤   (2) sensor input
                   │         │                  │
                   └─[100nF]─┤                  │   (3) noise filter
                            │  GND       ●─┤
   Mat black ────────────── │                  │   (4) sensor return
                            │                  │
   MT3608 OUT+ ──────────── │  VIN       ●─┤   (5) 5V power
                            │                  │
   MT3608 OUT- ──────────── │  GND       ●─┤   (6) power return
                            │                  │
                            └─────────────────┘
```

### 2.2 Pin mapping (ESP32-WROOM-32 DOIT V1)

| ESP32 pin | Function | Notes |
|---|---|---|
| GPIO 4 | Sensor input | Safe pin (no boot strap, no flash) |
| GPIO 2 | Onboard LED (status) | Already on board, no external connection |
| VIN | 5V power input | From MT3608 OUT+ |
| 3V3 | 3.3V regulated output | Source for pull-up |
| GND | Ground (multiple pins) | All grounds tied together |

---

## 3. Power Chain

```
USB charger 5V
    │
    ↓ (USB-C cable)
TP4056 module (charging + protection)
    │
    ↓
18650 holder
    │
    ↓
Power switch (SPDT)
    │
    ↓
MT3608 boost (3.7V → 5V)
    │
    ↓
ESP32 VIN (5V)
```

**Switch placement**: between 18650 (+) and MT3608 IN+ — turns off ESP32 power but TP4056 can still charge battery via USB when off.

**Adjust MT3608 output to 5V** (using onboard potentiometer + multimeter) BEFORE connecting to ESP32.

---

## 4. Prototype Strategy

### Phase 1 (now): Breadboard
- ESP32 plugs into 400-hole breadboard
- Components (resistor, capacitor) + jumper wires
- Easy to debug and modify

### Phase 2 (later): Perfboard with female headers
- ESP32 still removable
- Permanent solder of components
- More durable for actual use

---

## 5. Build Sequence

```
1. Order parts (3-7 days shipping)
2. While waiting:
   - Aree writes firmware skeleton (port from 4Platforms.ino S3 → WROOM-32)
   - Aree finalizes wiring diagram
3. When parts arrive:
   - Day 1: Prepare PCBs (clean copper, sand edges)
   - Day 1: Solder wires to corners (4 PCBs total)
   - Day 1: Apply foam tape pattern + assemble sandwiches
   - Day 1: Mount on plywood + rubber feet + vinyl cover
   - Day 2: Breadboard ESP32 + components + power chain
   - Day 2: Adjust MT3608 to 5V
   - Day 2: Connect mat to ESP32
4. Test plan (next section)
```

---

## 6. Test Plan

| # | Test | Expected | Action if fail |
|---|---|---|---|
| 1 | Multimeter continuity, mat idle | Open circuit (∞Ω) | Check for false contact (tape too thin or solder bump too tall) |
| 2 | Multimeter continuity, mat stepped | Closed circuit (~0Ω) | Check solder joints + wire integrity |
| 3 | False trigger test (mat on floor, ESP32 monitoring) | GPIO 4 stays HIGH | Tape compression issue or noise |
| 4 | Edge test (step on each quadrant) | All 4 quadrants close circuit | Spacer pattern unbalanced |
| 5 | Bounce test (rapid step/release × 100) | All events captured | Debounce too aggressive, or mechanical bounce |
| 6 | Accuracy test (jump + phone slow-mo 240fps) | < 5cm difference | Tune flight-time threshold |
| 7 | Chronojump desktop validation (free!) | Reading matches | Protocol compatibility issue |

---

## 7. Pending Decisions (before final build)

| # | Decision | Options | Aree recommendation |
|---|---|---|---|
| 1 | Display strategy Phase 1 | Serial / BLE / OLED / hybrid | **Serial** for debug, then BLE Phase 1.5 |
| 2 | Enclosure approach | Separate box / built-in / breadboard | **Breadboard** Phase 1, perfboard later |
| 3 | Phase 1 deliverable | Just height value / + history app | **Just height** (per Toey's stated goal) |

---

## 8. Equipment Checklist (Toey to confirm holdings)

### Critical (must have)
- [ ] Soldering iron + solder wire
- [ ] Multimeter
- [ ] Wire stripper or cutter
- [ ] Cutter knife + scissors

### Components (often leftover from past projects)
- [ ] Resistor 10kΩ × 1
- [ ] Capacitor 100nF × 1
- [ ] Breadboard 400 holes
- [ ] Jumper wires dupont (M-M, M-F)
- [ ] Hookup wire 24 AWG (red + black)
- [ ] Heat shrink tubes

### Mat materials (likely all new purchase)
- [ ] PCB Epoxy 20×30cm × 4 (FR4 single-side 1.5mm)
- [ ] Foam tape 2-sided 1.5mm
- [ ] Vinyl/PVC sheet 1mm
- [ ] Plywood/MDF 5mm 45×35cm
- [ ] Rubber feet × 4

### Optional
- [ ] Hand drill / Dremel (for through-hole soldering alternative)
- [ ] Flux paste
- [ ] Isopropyl alcohol 99% (for cleaning copper)
- [ ] Fine sandpaper #400

---

## 9. Cost Estimate

| Scenario | Range |
|---|---|
| Best case (have soldering iron + multimeter) | ~1,060-1,860฿ |
| Worst case (need to buy everything) | ~1,660-3,160฿ |

(Toey already has: ESP32 WROOM-32, MT3608, 18650, holder, switch — saves ~600-900฿)

---

## References

- Reference firmware: `ψ/learn/projects/jump-mat/chronojump-refs/4Platforms.ino`
- Communication protocol: `ψ/learn/projects/jump-mat/chronojump-refs/Communication.md`
- Market research: `ψ/learn/projects/jump-mat/2026-05-06_market-research.md`
- Older 2026-05-05 docs: see `00_ACCURACY_WARNING.md` before quoting
