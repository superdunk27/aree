# Build Log — Jump Mat (Chronopic-Compatible)

Append-only chronological log. Newest entries at top.

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
