# Build Log — Jump Mat (Chronopic-Compatible)

Append-only chronological log. Newest entries at top.

---

## 2026-05-08 (morning) — Day 3.5: Phase 1.5 BLE design + new machine sync

**Status**: Phase 1 unchanged (still waiting on parts). Phase 1.5 design locked.
**Active session**: Aree (with Toey)

### Done today
- Sync from machine-2026-05-07 to DESKTOP-CE4H6GT — both machines now identical (skills full, context7+playwright MCP, arduino-cli 1.4.1, ESP32 core 3.3.8)
- Created `ψ/active/machines.md` cross-instance state manifest + CLAUDE.md sync rule
- Smoke-tested context7 + playwright MCP — both pass
- **Wrote `firmware/phase15-ble-design.md`** — Phase 1.5 BLE port design doc, no code yet
  - Decision: clone Chronopic-4 UUIDs (compat with existing Chronojump desktop client + nRF Connect)
  - Library: `h2zero/NimBLE-Arduino` (50% less flash, 100KB less RAM than bluedroid)
  - Service map simplified: 1 sensor (Chronopic-4 has 4), no IR commands, no NeoPixel commands
  - Command set: keep `get_version, start/end_capture, set_debounce, get_battery_level, setBLEName, restart`. Drop IR/sync/RGB/AND-OR commands.
  - Trigger: code Phase 1.5 only after Phase 1 passes Sargent calibration

### Pending Toey
- Nothing (waiting on parts)

### Next session
1. Wait for parts (PCB×4, capacitor 100nF, plywood)
2. Day 4 build: solder + assemble + flash Phase 1 + Sargent calibrate
3. If Phase 1 passes: code Phase 1.5 from design doc (~2-3 hr est.)

---

## 2026-05-07 (evening) — Day 3: Materials locked + firmware skeleton

**Status**: Phase 1 ready to build when shipped parts arrive
**Active session**: Aree (with Toey)

### Done today
- Confirmed all materials in hand or shipping (zero additional purchase needed)
- Material substitutions finalized:
  - Top cover: vinyl 1mm → **industrial PVC anti-slip mat 1.5mm** (Toey already had 150×100cm sheet)
  - Base: rubber feet × 4 → **EVA mat 60×40×10mm full-sheet** under plywood (anti-slip + damping in one)
  - Plywood: 45×35×5mm spec → **30×60×6mm** (bigger and stiffer, no issue)
- Phase 1 decisions locked: **Serial output + breadboard prototype**
- BLE deferred to Phase 1.5 (after Serial validation)
- Updated `hardware/build-spec.md` with actuals (sections 1.2, 1.4, 7, 8, 9)
- **Wrote firmware skeleton** at `firmware/jumpmat_phase1.ino`
  - Single sensor on GPIO 4 (2 PCB pairs wired in parallel = appears as 1 contact)
  - External 10kΩ pull-up + 100nF noise filter (per build spec)
  - Polling + software debounce 10ms (simpler than reference's hw_timer interrupts)
  - 100ms flight threshold (VALD SmartJump pattern)
  - Output: `Jump #N | Flight: 0.XXX s | Height: XX.X cm`
  - Onboard LED (GPIO 2) shows mat state (HIGH = on mat)
- Wrote `firmware/README.md` with flash instructions + test plan + calibration procedure

### Setup work (parallel, this session)
- Pulled cross-instance handoff from VS Code extension (`2d22c86`)
- Updated Oracle skills `standard` (13) → `full` (42)
- Added MCP servers: **Context7** (library docs) + **Playwright** (browser automation)
- Removed broken `oracle-v2` MCP entry (was misconfigured as stdio — actually HTTP server)
- Updated `CLAUDE.md` Installed Skills + MCP sections

### Pending Toey before parts arrival
- Nothing required — all materials confirmed, firmware ready

### Next session (when PCBs / capacitor / plywood arrive)
1. Solder wires to PCB corners (per build-spec section 1.5 diagonal pattern)
2. Apply foam tape grid spacer (perimeter + cross bar = 2 windows per pair)
3. Assemble layer stack on plywood + EVA base + PVC top cover
4. Breadboard ESP32 + 10kΩ + 100nF + power chain
5. Adjust MT3608 to 5V output (BEFORE connecting to ESP32)
6. Flash `jumpmat_phase1.ino`
7. Run test plan (build-spec section 6 + firmware/README.md)
8. Calibrate against phone slow-mo 240fps

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
