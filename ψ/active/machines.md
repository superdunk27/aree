# Aree's Machines

Cross-instance state manifest. Aree updates a machine's section whenever it installs/removes/configures something on that machine. Aree at session start runs `$env:COMPUTERNAME` (Windows) or `hostname` to identify the current machine, looks up the section, and orients itself.

**Convention**: Append-only history at the bottom of each machine section. Current state at the top.

---

## DESKTOP-CE4H6GT

**Aliased**: (Toey's working machine — set today 2026-05-08)
**OS**: Windows 11
**Last-updated**: 2026-05-08 ~16:00 GMT+7 (added Firecrawl MCP + documented PubMed E-utilities)

### Current state

| Layer | Value |
|---|---|
| Node | v24.14.0 |
| Bun | 1.3.13 |
| npx | 11.9.0 |
| winget | v1.28.240 |
| Oracle skills | full (42) — `arra-oracle-skills@26.4.18` |
| MCP servers | `context7`, `playwright`, `firecrawl`, `plugin:oh-my-claudecode:t` |
| MCP claude.ai | Google Drive / Calendar / Gmail (needs auth — not used yet) |
| arduino-cli | 1.4.1 (`/c/Program Files/Arduino CLI/arduino-cli.exe`) |
| ESP32 core | esp32:esp32 3.3.8 (installed via arduino-cli) |
| Web research APIs | NCBI E-utilities (curl, no key, free) |

### Web research stack (2026-05-08)
| Tool | Type | Auth | Use case |
|---|---|---|---|
| Jina Reader | curl `r.jina.ai/<url>` | none | Default for non-PMC web content |
| Firecrawl MCP | `firecrawl_scrape` / `firecrawl_search` | API key in `~/.claude.json` env | PMC, paywalls, JS-rendered pages, anywhere Jina is blocked |
| Context7 MCP | `context7__query-docs` | none | Library docs (Bun, NimBLE, etc.) |
| Playwright MCP | `playwright__browser_*` | none | Full browser automation, screenshots |
| WebSearch | Anthropic built-in | none | Source discovery |
| WebFetch | Anthropic built-in | none | Tier 6 only — page overview, NEVER for technical content |
| NCBI E-utilities | curl `eutils.ncbi.nlm.nih.gov/entrez/eutils/...` | none | Medical / sport science papers (esearch, efetch, esummary) |

### Removed / Excluded
- `oracle-v2` MCP — never installed here (was broken on the other machine, removed there)
- Chronojump — not installed here (deprioritized 2026-05-07 due to UX)

### Pending sync (on next visit)
- **Skills**: upgrade `full (42)` → `lab (47)` via `npx -y arra-oracle-skills@26.4.18 install -g -y -p lab` to match TOEY (home). +18 skills: `/contacts`, `/dream`, `/feel`, `/fleet`, `/harden`, `/i-believed`, `/inbox`, `/machines`, `/mailbox`, `/morpheus`, `/release`, `/schedule`, `/vault`, `/warp`, `/watch`, `/work-with`, `/worktree`, `/wormhole`. See `ψ/memory/learnings/2026-05-08_oracle101-gap-review.md` for context.
- **CLAUDE.md changes**: pulled via `git pull` automatically — Workflow patterns subsection + Brain Structure (added `metrics/`, `plans/`).

### History
- **2026-05-08 09:30–09:45** — Sync from machine-2026-05-07: skills standard→full, +context7 +playwright MCP, arduino-cli 1.4.1 + ESP32 core 3.3.8
- **2026-05-08 ~16:00** — Web research stack expansion: +Firecrawl MCP (smoke-tested vs Jina-blocked PMC paper, scraped 269KB content successfully), documented NCBI E-utilities pattern. Filled the gap surfaced during morning's strength-for-swim-sprint research where Jina banned PMC anonymous access.

---

## TOEY

**Aliased**: Toey's home machine (hostname confirmed 2026-05-08 — was previously "machine-2026-05-07 hostname TBD")
**OS**: Windows 11 Pro 10.0.26200
**User**: toey0
**Last-updated**: 2026-05-08 ~22:30 GMT+7 (skills full→lab, MCP audit, hostname confirmed)

### Current state

| Layer | Value |
|---|---|
| Node | v24.14.1 |
| Bun | 1.3.13 |
| npx | 11.11.0 |
| winget | v1.28.240 |
| Oracle skills | **lab (47)** — `arra-oracle-skills@26.4.18` (upgraded today from 29 actual / "full" claim) |
| MCP servers | `context7` ✓, `playwright` ✓, `firecrawl` ✓, `plugin:oh-my-claudecode:t` ✓ |
| MCP claude.ai | Google Drive / Calendar / Gmail (needs auth — not used yet) |
| arduino-cli | 1.4.1 (`C:\Program Files\Arduino CLI\arduino-cli.exe`) |
| ESP32 core | esp32:esp32 3.3.8 |
| Chronojump | installed → deprioritized (UX too clunky, dropped 2026-05-07) |
| yt-dlp | NOT installed (needed for `/watch` skill — install if/when used) |
| ffmpeg | NOT installed |

### Removed / Excluded
- `oracle-v2` MCP — removed 2026-05-07 (was misconfigured as stdio, actually HTTP — broken)

### Gaps vs DESKTOP-CE4H6GT (work machine)
- ✅ **Firecrawl MCP** — installed 2026-05-08. Now matches work machine. API key stored in `~/.claude.json` env (per-machine, not in repo).
- ⚠️ Skills count differs: TOEY = lab (47), DESKTOP = full (42). On next work-machine session, propose upgrade DESKTOP → lab (47) so both match. Tracked in DESKTOP's "Pending sync" section above.

### History
- **2026-05-07 evening** — Day 3 jump mat work session. Setup expansion: skills standard→full, MCP +context7 +playwright -oracle-v2, arduino-cli + ESP32 core via winget. Documented in `ψ/memory/retrospectives/2026-05/07/22.29_jump-mat-day3-setup-firmware-validators.md`.
- **2026-05-08 ~22:30** — Hostname confirmed = TOEY (was TBD). Skills upgraded full→lab via `npx arra-oracle-skills@26.4.18 install -g -y -p lab` (29→47, +18 skills documented in `ψ/memory/learnings/2026-05-08_oracle101-gap-review.md`). ψ/metrics/ created. CLAUDE.md updated with workflow patterns from oracle101 Ch 06B-10.
- **2026-05-08 ~22:45** — Firecrawl MCP installed (matched DESKTOP-CE4H6GT). Local skill `.claude/skills/sync.md` created — typing `sync` or `/sync` in any session triggers cross-machine state check + propose alignment.

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
