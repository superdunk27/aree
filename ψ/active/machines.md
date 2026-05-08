# Aree's Machines

Cross-instance state manifest. Aree updates a machine's section whenever it installs/removes/configures something on that machine. Aree at session start runs `$env:COMPUTERNAME` (Windows) or `hostname` to identify the current machine, looks up the section, and orients itself.

**Convention**: Append-only history at the bottom of each machine section. Current state at the top.

---

## DESKTOP-CE4H6GT

**Aliased**: (Toey's working machine — set today 2026-05-08)
**OS**: Windows 11
**Last-updated**: 2026-05-08 09:45 GMT+7 (sync from machine-2026-05-07 complete)

### Current state

| Layer | Value |
|---|---|
| Node | v24.14.0 |
| Bun | 1.3.13 |
| npx | 11.9.0 |
| winget | v1.28.240 |
| Oracle skills | full (42) — `arra-oracle-skills@26.4.18` |
| MCP servers | `context7`, `playwright`, `plugin:oh-my-claudecode:t` |
| MCP claude.ai | Google Drive / Calendar / Gmail (needs auth — not used yet) |
| arduino-cli | 1.4.1 (`/c/Program Files/Arduino CLI/arduino-cli.exe`) |
| ESP32 core | esp32:esp32 3.3.8 (installed via arduino-cli) |

### Removed / Excluded
- `oracle-v2` MCP — never installed here (was broken on the other machine, removed there)
- Chronojump — not installed here (deprioritized 2026-05-07 due to UX)

### History
- **2026-05-08 09:30–09:45** — Sync from machine-2026-05-07 (this conversation): upgraded skills standard→full, added context7+playwright MCP, installed arduino-cli 1.4.1 + ESP32 core 3.3.8. Setup instigated by Toey saying "ทำให้คอมเครื่องนี้เหมือนเมื่อคืน".

---

## machine-2026-05-07 (hostname TBD)

**Aliased**: (Toey's machine used 2026-05-07 — hostname to be confirmed next time it's used)
**OS**: Windows 11 (assumed — uses winget)
**Last-updated**: 2026-05-07 22:58 GMT+7

### Current state (reconstructed from retro)

| Layer | Value |
|---|---|
| Node | ✅ (version not recorded) |
| Bun | ✅ |
| Oracle skills | full (42) — `arra-oracle-skills@26.4.18` |
| MCP servers | `context7`, `playwright`, `plugin:oh-my-claudecode:t` |
| arduino-cli | 1.4.1 |
| ESP32 core | installed (~200MB+) |
| Chronojump | installed → deprioritized (UX too clunky) |

### Removed / Excluded
- `oracle-v2` MCP — removed 2026-05-07 (was misconfigured as stdio, actually HTTP — broken)

### History
- **2026-05-07 evening** — Day 3 jump mat work session. Setup expansion: skills standard→full, MCP +context7 +playwright -oracle-v2, arduino-cli + ESP32 core via winget. Documented in `ψ/memory/retrospectives/2026-05/07/22.29_jump-mat-day3-setup-firmware-validators.md`.

---

## How to use this file

### When Toey switches machines
1. `git pull`
2. `/recap`
3. Aree runs `$env:COMPUTERNAME`, finds the section here
4. If the section is missing or outdated, Aree proposes sync (and updates this file after)

### When Aree installs/removes/configures something
1. Do the action
2. Update the machine's "Current state" table at top of its section
3. Append a dated entry to that machine's "History"
4. Commit (so the next machine sees it via `git pull`)

### Adding a new machine
1. First-time login: Aree runs `$env:COMPUTERNAME`, doesn't find a section → creates one
2. Snapshots current state into the table
3. Commits

---

## Cross-instance gap notes

- `~/.claude/projects/.../memory/` is **per-instance, not synced** — each Claude Code installation has its own. Important context worth carrying across instances must be dumped to `ψ/inbox/<YYYY-MM-DD>_<topic>.md` per CLAUDE.md rule.
- This `machines.md` lives in the repo, so it auto-syncs via git across all instances.
- Future improvement candidate: a script `bun ψ/active/machines/scan.ts` that auto-detects current machine state and updates this file (Option C from the design discussion). For now manual updates are fine.
