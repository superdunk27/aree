---
date: 2026-05-07
from_instance: VS Code Claude Code extension
priority: high
topic: jump mat — Phase 1 build spec ready, awaiting parts order
---

# Handoff — Jump Mat Phase 1 Build Spec Ready

> Cross-instance bridge. This conversation lived in VS Code extension; other Claude instances (Claude Code CLI, claude.ai) cannot see it. Read this first if you are a fresh instance picking up the project.

## TL;DR
Phase 1 build spec finalized 2026-05-07. Toey to confirm equipment + 2 small decisions, then order parts. Aree (next session) writes firmware skeleton + wiring diagram while parts ship 3-7 days.

## Where to start
1. **`ψ/active/jump-mat/hardware/build-spec.md`** — single source of truth (mat spec, ESP32 wiring, power chain, test plan, equipment checklist)
2. `ψ/active/jump-mat/build-log.md` — chronological log
3. `ψ/memory/retrospectives/2026-05/07/16.33_jump-mat-build-spec-finalized.md` — latest retro
4. `ψ/memory/learnings/2026-05-07_walk-through-physical-geometry.md` — meta-skill from this session
5. `ψ/learn/projects/jump-mat/2026-05-06_market-research.md` — market survey

## Phase 1 scope (locked)
- Pure jump height max accuracy
- No RSI / multi-jump / asymmetry — those are Phase 2 candidates

## Architecture
Path A++ — Chronopic-4 protocol-compatible switch mat
- 4× PCB Epoxy 20×30cm × 1.5mm in 2 pairs side-by-side (40×30cm landing)
- Foam tape 1.5mm grid spacer (perimeter + cross bar = 2 windows per pair)
- ESP32-WROOM-32 DOIT V1 (Toey has)
- Power chain: USB → TP4056 → 18650 → switch → MT3608 → ESP32 VIN
- Wiring: GPIO 4 = sensor in, 10kΩ pull-up to 3.3V, 100nF filter to GND

## Pending Toey decisions (3)
1. Equipment checklist — what tools + components Toey owns vs needs to buy (see build-spec.md Section 8)
2. Display strategy Phase 1 — Serial / BLE / OLED / hybrid (Aree recommends Serial for debug → BLE Phase 1.5)
3. Enclosure — breadboard / box / built-in (Aree recommends breadboard Phase 1)

## Aree task while parts ship
1. Port `4Platforms.ino` from ESP32-S3 to ESP32-WROOM-32 (pin remap + NimBLE library config)
2. Add 100ms flight-time threshold filter (per VALD SmartJump pattern from market research)
3. Draft full wiring diagram (mat + ESP32 + power chain) — currently fragmented across discussion

## Critical context for new instance

### /rrr skill not installed
- CLAUDE.md lists `/rrr` as installed skill but it is NOT actually installed yet
- Install via `npx arra-oracle-skills@26.4.18-alpha.22 install -g -y --agent claude-code` if Toey wants
- This session Aree did /rrr manually (retrospective + extracted learning) — works but slower than skill

### WebFetch is lossy
- See `~/.claude/.../memory/feedback_web_research.md`
- Use `curl https://r.jina.ai/<url>` for technical content (raw markdown)
- WebFetch returns AI summaries that drop critical detail

### 2026-05-05 jump-mat docs may have errors
- See `ψ/learn/projects/jump-mat/00_ACCURACY_WARNING.md`
- Those docs were generated from WebFetch summaries before Jina protocol adopted
- Verify against current sources (especially the Chronojump construction page) before quoting

### Hardware reasoning protocol
- `ψ/memory/learnings/2026-05-07_walk-through-physical-geometry.md`
- When describing physical assembly, walk through 3D geometry concretely (solder mounds, wire heights, foam compression) — not schematic abstraction
- Tag confidence "Aree confidence: medium-high, not built one" when reasoning from physics vs experience

## Recent commits
- `5fc1c0a` — Jump Mat: market research + Phase 1 build spec + RRR (this session)
- `2ba82f1` — Jump Mat: pivot to PCB + Jina Reader research protocol + RRR
- `b7d8871` — Jump Mat: pivot to Path A++ (Chronopic-compatible) + project structure + RRR

## Repo state at handoff
Branch: `main` (clean after this commit)
Latest: `5fc1c0a` after this handoff committed and pushed
