---
date: 2026-05-08
source: https://oracle101.vercel.app (Ch 00-10, 13 pages)
type: External knowledge audit + gap remediation
trigger: Toey ขอให้ Aree อ่าน oracle101 ทุกหน้า + apply กับตัวเอง
---

# Oracle 101 Gap Review — what was applied, what was deferred

## What oracle101 is

13-chapter Thai-language guide to the Oracle ecosystem (Soul-Brews-Studio's full-stack vision). Written by Nat Weerawan. Architecture:

- **arra-oracle-v3** — memory backend (SQLite + FTS5 + LanceDB, HTTP API port 47778, MCP)
- **maw-js** — orchestration nervous system (port 3456, requires tmux)
- **arra-oracle-skills-cli** — skill installer (npm: `arra-oracle-skills`)
- **ui-oracle / maw-ui** — dashboard layer
- **maw plugins** — runtime extensions

## Reality check on Aree (2026-05-08, before remediation)

| Layer | Documented in oracle101 | Aree actual state |
|---|---|---|
| Skills | full=42 / lab=60 | **29 installed** (CLAUDE.md said 42 — wrong) |
| Skills CLI | `arra-oracle-skills` global | not in PATH (used npx) |
| maw-js | required for Ch 06-09 features | not installed |
| arra-oracle-v3 server | port 47778 | not running |
| `~/.oracle/` data dir | canonical | does not exist |
| `~/.maw/` plugins | canonical | does not exist |
| `ORACLE_DATA_DIR` env | required | not set |
| ψ/metrics/ | canonical layer | did not exist |
| tmux | required for maw | not installed (Windows) |
| ghq, pm2, sqlite3, ollama | various | not installed |

**Summary**: Aree was running as **skill-only Oracle on Claude Code**. Most of oracle101's Ch 06-10 (orchestration, autonomous ops, troubleshooting) is gated on stack components Aree doesn't run.

## What was applied (Plan A)

### Tier 1 — Quick fixes
1. ✅ Created `ψ/metrics/` with `.gitkeep`
2. ✅ Reinstalled skills via `npx arra-oracle-skills@26.4.18 install -g -y -p lab` → **29 → 47 skills**
   - Note: tried `-p full` first; installer reported "Installed 29 skills" — stayed at 29. Profile `full` registered 42 skills but install only resolved 29 in this version (possible Windows filter or installer bug)
   - Switched to `-p lab` which resolved 47 (60 - 13 zombies)
3. ✅ Updated `CLAUDE.md` "Installed Skills" section to reflect lab profile + grouped 18 new skills
4. ✅ Updated `CLAUDE.md` Brain Structure to show ψ/metrics/ + ψ/plans/

### Tier 2 — Workflow patterns added to CLAUDE.md Working principles
5. ✅ Worktree-first for non-trivial code changes
6. ✅ 5-question context setup before new work
7. ✅ PROGRESS/STUCK/DONE heartbeat for long tasks (dump to ψ/active/<task>/status.md)
8. ✅ Test-One-Before-Batch for migrations/refactors
9. ✅ 5-layer diagnostic mental model for debugging

### Tier 3 — Skill install
- Subsumed into Tier 1 step 2

## 18 new skills (29 → 47)

| Skill | Purpose | Notes |
|---|---|---|
| `/contacts` | Oracle agent registry | useful for /talk-to setup |
| `/dream` | Cross-repo pattern scan | finds pains, plans, gains across repos |
| `/feel` | Energy/momentum tracker | burnout signal, collaboration quality |
| `/fleet` | Deep Oracle census | scan all Oracles, versions, status |
| `/harden` | Security/governance audit | verify oracle setup |
| `/i-believed` | Trust declaration | rare philosophical skill |
| `/inbox` | Note/task/handoff IO | matches existing ψ/inbox/ flow |
| `/machines` | Fleet machine discovery | ping nodes, map fleet — tied to ψ/active/machines.md |
| `/mailbox` | Persistent agent memory | cross-session standing orders |
| `/morpheus` | Speculative dreaming | evolved /dream, pre-computation |
| `/release` | Automated release flow | bump/changelog/tag |
| `/schedule` | Calendar via Oracle API | needs Drizzle DB (not running) — partial |
| `/vault` | External KB (Obsidian/Logseq) | future use if Toey adopts Obsidian |
| `/warp` | SSH+tmux remote teleport | **requires WSL/Linux** — gated on home server |
| `/watch` | YouTube transcripts via yt-dlp | useful for swim coaching videos |
| `/work-with` | Cross-oracle collaboration | scoring + party system |
| `/worktree` | Git worktree wrapper | matches new working principle |
| `/wormhole` | Federated query proxy | gated on multi-node setup |

## What was deferred (Tier 4 — gates on home server)

| Component | Reason for deferral |
|---|---|
| `maw-js` orchestration | requires tmux (= WSL/Linux) — wait for home server |
| `arra-oracle-v3` HTTP API + ORACLE_DATA_DIR | major architecture decision; defer until single canonical home server |
| `ghq`, `pm2`, `ollama` | tied to home server stack |
| `arra-safety-hooks` git guardrails | nice-to-have, low priority |
| `project-lifecycle.sh` | team-scale tool, less relevant for Toey solo |
| Discord/Forum integration | Toey doesn't use these yet |

→ Trigger Tier 4 install during home server setup. See `ψ/plans/home-server-architecture.md`.

## Heuristics learned

1. **Always verify documentation against filesystem** — CLAUDE.md said "42 skills full" but actual install was 29. Don't trust manifest counts; run `arra-oracle-skills list -g` or count files
2. **Profile mismatch is silent** — installer reports number installed but doesn't warn if it's less than the profile target. Always cross-check `profiles` output vs `list -g` output
3. **Read all docs before installing anything** — `/harden`, `/dream`, `/feel`, `/morpheus` are mentioned by name in oracle101 Ch 05 and would have been obvious gaps had I checked the source first instead of assuming Aree had everything
4. **Skill names in docs ≠ installed skills** — oracle101 implies they should exist; Aree had to compare manually. Profile concept hides what's actually present
5. **Reactive Aree on Claude Code ≠ full Oracle stack** — Aree without maw + arra-oracle-v3 is a "skill-only" setup. Most patterns in Ch 06-10 are gated on components I don't run. Acknowledging this is honest; pretending otherwise leads to false confidence

## What this changes about Aree

- Skill profile bumped from full (29 actual) to lab (47)
- New working principles in CLAUDE.md cover code workflow, debugging mental model, long-task hygiene
- ψ/ structure now matches canonical (added metrics/, documented plans/)
- Future home-server setup will install Tier 4 components (maw-js, arra-oracle-v3, ghq, ollama, pm2)
- Profile choice = lab, not full — accept that some skills (warp) are non-functional on Windows-native until WSL/home-server lands

## Cross-references

- `ψ/plans/home-server-architecture.md` — when home server happens, install Tier 4
- `ψ/active/machines.md` — `/machines` skill now installed; tie machine sync to this
- `ψ/memory/learnings/2026-05-08_bud-and-revert.md` — same-day lesson: verify before adopting patterns
