# Build Log — Jump Mat (Chronopic-Compatible)

Append-only chronological log. Newest entries at top.

---

## 2026-05-07 — Day 2/3: Build spec finalized

**Status**: Phase 1 spec ready, awaiting parts order + Toey equipment confirmation
**Active session**: Aree (with Toey)

### Done today
- Confirmed Phase 1 scope: pure jump height max accuracy (no RSI / multi-jump / asymmetry)
- Mat construction detailed: 4× PCB 20×30cm Epoxy 1.5mm, 2 pairs side-by-side = 40×30cm landing
- Spacer pattern decided: foam tape 1.5mm perimeter + cross bar = 2 windows per pair
- Layered structure: vinyl/PCB/tape/PCB/plywood/feet (6 layers)
- Solder placement: corner under tape coverage, diagonal arrangement
  - Pair 1: red TL, black BR
  - Pair 2: red TR, black BL
- Solder bump issue identified by Toey + solution (corner under tape compression, 24 AWG wire)
- ESP32 wiring: 5 wires + 10kΩ pull-up + 100nF filter (GPIO 4)
- Power chain: USB → TP4056 → 18650 → switch → MT3608 → ESP32 VIN
- Equipment checklist generated for Toey to verify holdings
- **Build spec** written at `hardware/build-spec.md` — single source of truth

### Key spec points
- PCB: 20×30cm × 4 (Toey found at Shopee, Epoxy/FR4 1.5mm) — total mat 40×30cm
- Wire: 24 AWG (smaller solder bump than 22 AWG)
- Spacer: 1.5mm foam tape (sweet spot rigidity vs trigger sensitivity)
- ESP32: WROOM-32 DOIT V1 (Toey has) — port firmware from S3 reference
- Pins: GPIO 4 (sensor), GPIO 2 (LED), VIN, 3V3, GND

### Pending Toey before parts order
- Confirm ownership: solder iron, multimeter, breadboard, jumper wires, 10kΩ, 100nF
- Decide: display strategy Phase 1 (Serial / BLE / OLED / hybrid)
- Decide: enclosure approach (separate box / built-in / breadboard for Phase 1)

### Next session
1. Toey confirm equipment list → finalize purchase list
2. Order parts (3-7 day shipping)
3. While waiting: Aree writes firmware skeleton + finalizes wiring diagram

---

## 2026-05-06 — Day 1: WebFetch limit + market research + PCB pivot

**Status**: PCB platform confirmed
**Active session**: Aree (with Toey)

### Done
- WebFetch returned 3 contradicting summaries of Chronojump rod-style → discovered tool limitation
- Adopted Jina Reader (`curl https://r.jina.ai/<url>`) protocol for technical content
- Pivoted: rod-style → PCB platform (per Chronojump's own recommendation, found in raw text via Jina)
- Toey found Shopee listing for PCB Epoxy 1.5mm (initially 12x12", later refined to 20×30cm)
- Discussed PCB rigidity vs spacer interaction; copper sheet alternative ruled out (plastic deformation)
- Conducted market research on commercial jump mats (Just Jump, SmartJump/VALD, Hawkin, Output Sports, etc.)

### Key findings
- Switch mat = dominant paradigm in market (8 of 10 surveyed products)
- VALD SmartJump filters flight <100ms (false trigger prevention) — should adopt in firmware
- Just Jump multi-jump fatigue factor pattern — Phase 2 feature candidate
- Phase 2 commercial sweet spot: $200-300 USD undercutting Just Jump (~$400-500)
- Force plate tier (Hawkin, ForceDecks) too far above our paradigm — skip

### Files created
- `ψ/learn/projects/jump-mat/00_ACCURACY_WARNING.md` — flag for 2026-05-05 docs
- `ψ/learn/projects/jump-mat/2026-05-06_market-research.md` — comprehensive survey

---

## 2026-05-05 — Day 0: Architecture decided, project structure created

**Status**: Phase 1 starting
**Active session**: Aree (with Toey)

### Done today
- Reviewed handoff from prior session (jump_mat_build_guide.html foam+foil cross design)
- Analyzed 4 design options (FSR / Velostat / strain gauge / capacitive)
- Compared MyJump 2 vs OptoJump market positioning (video research)
- Researched 12 existing DIY jump-mat / force-plate projects
- Deep-dived Chronojump open-source ecosystem
- **Decision**: Path A++ (Chronopic-compatible switch mat) over Path B (force plate from scratch)
- Created project folder structure at `ψ/active/jump-mat/`
- Fetched 5 reference files from GNOME/chronojump:
  - `4Platforms.ino` — Chronopic 4 firmware (ESP32-S3 + BLE)
  - `Communication.md` — BLE protocol spec
  - `chronopic.cs` — desktop protocol implementation
  - `chronopic-firmware-multitest.c` — original PIC firmware
  - `jumpType.cs` — jump type definitions

### Key findings to remember
- Chronopic 4 uses 115200 baud + text format `[command]:[argument];` (NOT 9600 + 5-byte binary like older Chronopic 1-3)
- BLE Service UUIDs documented in `chronojump-refs/Communication.md`
- Sensor reads use INPUT_PULLDOWN — pressed = HIGH
- Debounce 10ms in interrupt-based timer (Xavier Padullés tuned)
- License GPL-2.0 — firmware must be GPL, but PWA written separately can be closed
- 4-platform architecture in ref firmware = each sensor independent. Can simplify to 1-sensor for Toey's use case.

### Pending decisions (waiting on Toey)
- Mat construction: rod-style / foil sandwich / FSR 4-corner / contact-switch grid?
- ESP32-S3: XIAO compact or standard DevKit?
- Confirm power circuit parts in hand (TP4056, MT3608, 18650, holder)

### Next session
1. Toey decide mat construction option
2. Toey confirm ESP32 + power parts in hand
3. Aree fetch Lazada/Shopee links for chosen parts
4. Order parts (3-7 day shipping)
5. While waiting: study `4Platforms.ino` line-by-line, write build doc with wiring + adapted code

---
