# Jump Mat — Chronopic-Compatible Build

**Owner**: Toey
**Started**: 2026-05-05
**Status**: Phase 1 — parts ordering / firmware study
**Architecture**: Path A++ (Switch mat + ESP32 emulating Chronopic 4 + Chronojump desktop validation)

## Goals

| Phase | Target | Status |
|-------|--------|--------|
| 1 | MVP — switch mat + ESP32 + Chronopic 4 protocol → use Chronojump desktop to validate | starting |
| 2 | Custom PWA (Web BLE) parallel to Chronojump desktop | not started |
| 3 (conditional) | Commercial launch as "Chronojump-compatible" jump platform | depends on Phase 1 accuracy |
| 4 (conditional) | Force plate upgrade (4× load cells + HX711) for premium tier | future |

## Architecture (Phase 1)

```
[คนยืนบนแผ่น mat]
        ↓
[Switch mat — 1-4 contact zones]      ← binary detection
        ↓ digital
[ESP32-S3 + INPUT_PULLDOWN GPIO]
        ↓ debounce 10ms (per Chronojump ref)
[Chronopic 4 protocol — text format]
        ↓ Serial 115200 baud + BLE
[Chronojump desktop (Phase 1)]
[+ custom PWA (Phase 2, parallel)]
```

## Why this approach

- **Chronojump desktop validated r=0.999 vs gold-standard force plate** — we inherit this for free by being protocol-compatible
- **Reference firmware exists**: `arduino/4Platforms/4Platforms.ino` (ESP32-S3 + BLE, 2024) — we adapt it
- **License compatible**: GPL-2.0 firmware obligates our firmware to GPL too (acceptable). PWA written separately is NOT a derivative work — can be closed-source.
- **Build time**: 1-2 weeks vs 5 weeks for greenfield force plate
- **Risk**: low — we have validated reference; validation comes for free

## Folder layout

```
.
├── README.md            ← this file
├── build-log.md         ← chronological progress
├── BOM.md               ← bill of materials + cost + sources
├── hardware/            ← schematics, wiring diagrams, photos
├── firmware/            ← ESP32 sketch (adapted from Chronopic 4 ref)
├── pwa/                 ← Web BLE app (Phase 2, separate from GPL)
└── tests/               ← validation results vs MyJump 2 / Chronojump desktop
```

## Key references

- Research summary: `ψ/learn/projects/jump-mat/2026-05-05_research-existing-builds.md`
- Chronojump deep-dive: `ψ/learn/projects/jump-mat/2026-05-05_chronojump-deep-dive.md`
- Reference firmware/protocol: `ψ/learn/projects/jump-mat/chronojump-refs/`
- Original handoff: `ψ/learn/projects/jump-mat/00_handoff.md`
- HTML manual calculator (interim): `ψ/lab/jump-calc.html`

## Decisions (locked, can revisit)

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Sensor type | Switch mat (binary) | r=0.999 proven in Chronojump |
| MCU | ESP32-S3 (matches Chronopic 4 ref) | reference firmware works as-is |
| Communication | BLE + Serial (Chronopic 4 protocol) | both Chronojump desktop + future PWA can read |
| Protocol baud | 115200 | matches Chronopic 4 (NOT 9600 — that's older Chronopic 1-3) |
| Debounce | 10ms (10000μs) per ref firmware | Xavier Padullés tuned this value |
| Mat construction (Phase 1) | TBD — see BOM.md options | balance cost / ease / durability |

## Open questions for Toey

- Which mat construction option (see BOM.md): rod-style (Chronojump original), foil sandwich, FSR 4-corner, or contact-switch grid?
- ESP32-S3 — XIAO compact form-factor or standard DevKit?
- Power circuit reuse from `jump_mat_build_guide.html` (TP4056/MT3608/18650) — confirm parts in hand
