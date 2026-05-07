---
date: 2026-05-07
purpose: Validate jump mat accuracy via Sargent Jump Test (independent measurement)
companion: jumpmat_phase1/jumpmat_phase1.ino
credit: Method proposed by Toey (2026-05-07) — classic Sargent method (Sargent 1921)
---

# Sargent Jump Calibration Protocol

**Why this method**: Sargent measures jump height via vertical reach difference (physical / mechanical), while our mat measures via flight time (electronic / temporal). They are **independent measurement principles**, so agreement between them validates the mat without circular reasoning.

Used by: NFL Combine, NBA Combine, military fitness tests, PE classes — 100+ years of field validation.

---

## Equipment

- **Jump mat** (our DIY) connected via USB to laptop
- **Wall** (smooth, vertical, ~3m clear above)
- **Measuring tape** taped to wall vertically (0 cm at floor level)
- **Post-it Notes** (or chalk on fingertip + masking tape squares)
- **Pencil/pen**
- **Optional**: second person to film + record values

---

## Pre-flight checks

- [ ] Mat assembled and connected (Serial Monitor open at 115200)
- [ ] `Initial state: ON_MAT` shown on Serial when standing on mat (NOT `IN_AIR`)
- [ ] Wall measuring tape readable from where Toey stands
- [ ] No obstacles above (ceiling fan, lights)
- [ ] Footwear consistent (recommend: barefoot OR same shoes for all jumps)

---

## Protocol

### Stage 1 — Standing reach

1. Stand on mat with body **side touching wall** (right-handed: right side to wall)
2. Feet flat on mat, no tiptoes
3. Extend reaching arm **straight up** (do not shrug shoulder beyond natural extension)
4. With other hand, mark the wall at fingertip height with **Post-it #1**
5. Step off the mat, measure: **Stand_cm = position of Post-it #1 above floor**

### Stage 2 — Counter-movement jump (CMJ)

1. Step back onto mat in same position (side to wall)
2. Verify Serial shows `ON_MAT`
3. Hold Post-it #2 in reaching hand
4. **Counter-movement jump**:
   - Quick squat down (~knee 90°)
   - Drive up explosively
   - At peak: stick Post-it #2 on wall at highest fingertip
5. Land back on mat
6. Verify Serial shows: `Jump #N | Flight: X.XXX s | Height: YY.Y cm`
7. Step off, measure: **Peak_cm = position of Post-it #2 above floor**

### Stage 3 — Calculate

```
Sargent_height = Peak_cm - Stand_cm
Mat_height     = Y.Y cm (from Serial)
Delta          = Sargent_height - Mat_height
```

### Stage 4 — Repeat

Do **5 jumps total**. Use a fresh Post-it for each peak (or move #2 down/up). Record both values per jump.

---

## Result interpretation

### Why Sargent is typically HIGHER than mat

| | What it measures |
|---|---|
| **Sargent** | Vertical reach difference at peak fingertip |
| **Mat (flight-time)** | Center-of-mass airborne time → height via `h = g·t²/8` |

During the jump, the body **extends** more than during standing reach (shoulders shrug, torso lengthens, fingertip goes higher relative to COM). This adds typically **3-7 cm** to Sargent reading vs flight-time.

This is well-documented (e.g., Aragón-Vargas 2000, Klavora 2000): correlation r > 0.9, Sargent systematically reads ~5 cm higher.

### Pass / fail criteria

| Delta (Sargent − Mat) | Verdict | Action |
|---|---|---|
| **0 to +10 cm** | ✅ **PASS** (typical 3-7 cm) | Mat is accurate. Done. |
| **Negative** (Sargent < Mat) | ❌ FAIL — mat reads too high | Check: false-trigger debounce, mechanical bounce on landing |
| **+10 to +15 cm** | ⚠️ Borderline | Repeat 10 jumps; check jump form (run-up? not allowed) |
| **> +15 cm** | ❌ FAIL — mat reads too low | Check: missed contact (foam too thick), threshold > 100ms losing real flights |

### What "consistency" means

Even if Delta is large (+8 cm), if it's **consistent across 5 jumps** → mat is reading systematic, calibration possible.
Erratic Delta (e.g., +3, +12, -2, +7, +15) → mat has noise problems → debug before trusting.

---

## Common form errors that break this test

| Error | Why it matters | Fix |
|---|---|---|
| Run-up before jump | flight-time formula assumes vertical takeoff | Stand still, then jump |
| Different shrug at standing vs peak | Adds extra cm to Sargent only | Mark stand reach with deliberate shrug, do same at peak |
| Foot leaves mat at angle | Flight time inflated (still in air longer) | Stand square, jump straight up |
| Reaches different hand at peak vs stand | Asymmetry skews Sargent | Use same hand both stages |
| Lands off-mat | Mat misses landing → flight time keeps growing | Land on mat — mark a target if needed |

---

## Recording template

Copy to a notepad or spreadsheet:

```
Date: ___________   Subject: ___________   Footwear: ___________

Stand_cm = _____ cm

Jump | Peak_cm | Sargent_cm | Mat_cm | Delta_cm
-----+---------+------------+--------+----------
  1  |         |            |        |
  2  |         |            |        |
  3  |         |            |        |
  4  |         |            |        |
  5  |         |            |        |
-----+---------+------------+--------+----------
Avg  |         |            |        |
SD   |         |            |        |

Verdict: PASS / FAIL / RETEST
Notes: _________________________________________
```

---

## After calibration

If passed → mat is validated. Lock firmware, move to Phase 1.5 (BLE for live readout on phone).

If failed → see `firmware/README.md` troubleshooting section. Common fixes:
- Raise debounce 10ms → 20ms (less false triggers)
- Lower MIN_FLIGHT_MS 100 → 80ms (catch shorter jumps)
- Check mechanical: tape compression even? solder bumps not bottoming out?

---

## Future improvements (Phase 2)

- Replace Post-it with phone photo of wall + image processing → automated reach extraction
- Use force plate (rented from sport-science lab) for triple-validation
- Cross-validate with MyJump 2 video method as third independent reading
