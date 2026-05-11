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

## RDLT

**Aliased**: Toey's home machine (hardware-confirmed 2026-05-10 — ASUS PRIME B450M-A + Ryzen 7 3700X)
**OS**: Windows 11 Enterprise 10.0.26200
**User**: toey0 (`RDLT\toey0`)
**Hardware**: ASUS PRIME B450M-A (S/N 200670633200021), AMD Ryzen 7 3700X (8c/16t), BIOS AMI 4622
**Original install date**: 09-Nov-2025
**Last-updated**: 2026-05-10 ~00:00 GMT+7 (`/sync` ran, hostname surfaced as RDLT not TOEY — supersedes prior section)

> **Note 2026-05-10**: This is the SAME physical machine previously documented as "TOEY". The "TOEY" name was never verified by `$env:COMPUTERNAME` — it was inferred. `/sync` today caught actual hostname = `RDLT`. The prior TOEY section is preserved below as superseded history (Nothing is Deleted).

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
- **2026-05-10 ~00:00** — `/sync` ran for the first time. `$env:COMPUTERNAME` returned **`RDLT`** (not "TOEY" as documented). All other state matched the prior "TOEY" section exactly (skills lab/47, all 4 MCP, arduino-cli, ESP32 3.3.8, Chronojump, no yt-dlp/ffmpeg). Hardware confirmed by Toey: ASUS B450M-A + Ryzen 7 3700X. Conclusion: same physical machine, "TOEY" was never an actual hostname — it was inferred. Section renamed RDLT, prior history preserved. `.claude/skills/sync/SKILL.md` updated. Skill format also fixed in same session: flat `sync.md` → `sync/SKILL.md` (commit `83b59be`).
- **Manifest drift lesson (3rd instance this week)**: 2026-05-08 (skills count "full(42)" vs actual 29), 2026-05-09 (skill format flat vs directory), 2026-05-10 (hostname "TOEY" vs RDLT). All three: documented value taken as authoritative without verification. Reinforces lesson in `ψ/memory/learnings/2026-05-09_manifest-drift-and-trigger-skill-pattern.md`. The `/sync` skill itself was the cure for the third instance.

---

## aree-home

**Aliased**: Toey's 24/7 home server — single-writer Aree instance (designed 2026-05-08, deployed 2026-05-11)
**OS**: Ubuntu 26.04 LTS (`resolute`), kernel 7.0.0-15-generic
**User**: `toey`
**Hardware**: Intel Xeon E5-2690 v3 (12c/24t @ 2.60GHz), 128 GB RAM (123 GiB usable), 480 GB SSD
**Install date**: 2026-05-11 (today — bare metal, replaced inherited XCP-ng install)
**Last-updated**: 2026-05-11 ~15:30 GMT+7 (initial bring-up complete, pre-Claude-Code-login)

> **Role**: Always-on writer. Client devices (RDLT, future DESKTOP-CE4H6GT) connect to this box via Tailscale SSH and run Aree inside the persistent `aree` tmux session.

### Current state

| Layer | Value |
|---|---|
| Node | v20.20.2 (NodeSource) |
| Bun | 1.3.13 |
| npm | 10.8.2 |
| gh CLI | 2.92.0 |
| Docker | 29.4.3 + compose plugin (toey in docker group) |
| tmux | 3.6 (session `aree` running, auto-start via systemd) |
| Claude Code | 2.1.138 (`@anthropic-ai/claude-code` global, NOT yet logged in) |
| Oracle skills | **lab (47)** — installed to `~/projects/aree/.claude/skills/` (project scope) |
| MCP servers | `context7` ✓, `playwright` ✓, `firecrawl` ✓ (plugin:oh-my-claudecode pending plugin install) |
| MCP claude.ai | none yet (Google Drive/Calendar/Gmail not configured) |
| sudo | NOPASSWD enabled for `toey` (`/etc/sudoers.d/toey-nopasswd`) — single-user homeserver trust model |
| arduino-cli / ESP32 / yt-dlp / ffmpeg / Chronojump | NOT installed (add if needed) |

### Network

| Layer | Value |
|---|---|
| LAN | `enp7s0` 192.168.79.8/24 (upstairs router WiFi-repeater subnet — separate from RDLT's 192.168.1.x) |
| Tailscale | **100.77.60.57** (stable name; use this for SSH from any device on tailnet) |
| SSH | OpenSSH server enabled at install, key-only auth (RDLT + aree-home pubkeys uploaded to GitHub `superdunk27`) |
| Reachability | Cross-subnet via LAN: blocked (double NAT). Via Tailscale: works from RDLT and anywhere else with tailnet membership |

### Storage layout
- Disk physical: 480 GB SSD (`/dev/sda`)
- `/boot/efi` 1 G, `/boot` 2 G, `/` 437 G (LVM `ubuntu-vg/ubuntu-lv`, ext4) — extended from 100 G default at install
- Free: 405 G / 437 G (~7% used post-install)

### Pending (next session)
- **Claude Code first-run login** — `claude` interactive (browser OAuth) by Toey
- **oh-my-claudecode plugin** — install via `/plugin install oh-my-claudecode` inside Claude Code, after login
- **Optional**: `claude.ai` Google Drive/Calendar/Gmail MCP auth if Toey wants
- **Decision pending**: keep aree-home as sole writer, or run multi-machine writer (likely sole writer per home-server-architecture.md plan)

### Removed / Excluded
- **XCP-ng** — was inherited on this hardware, wiped 2026-05-11 at install time. No data preserved (Toey confirmed nothing of value).

### History
- **2026-05-11 ~14:00 GMT+7** — Bare metal Ubuntu 26.04 install (USB ISO, replaced XCP-ng). Choices: hostname `aree-home`, user `toey`, no encryption, ext4+LVM, OpenSSH from install. GitHub SSH key import initially failed (`superdunk27.keys` was empty — uploaded RDLT's ed25519 via `gh ssh-key add` after `gh auth refresh -s admin:public_key`), then retry succeeded.
- **2026-05-11 ~14:30** — Network friction surfaced: aree-home (192.168.79.x) and RDLT (192.168.1.x) on different subnets due to upstairs router being a WiFi repeater of the downstairs router. **Tailscale** installed at server console via auth-key flow (`tailscale up --authkey=…`), bypasses subnet split. Tailscale also installed on RDLT (winget `Tailscale.Tailscale`). Both joined tailnet — aree-home reachable at `100.77.60.57`, RDLT at `100.111.92.57`.
- **2026-05-11 ~15:00** — NOPASSWD sudo enabled for `toey` (single-command paste, then automated SSH-driven setup from RDLT). LVM extended 100 G → 437 G (closes Ubuntu installer's conservative default). Block 1 stack: apt update/upgrade + build-essential + git 2.53 + tmux 3.6 + unzip.
- **2026-05-11 ~15:15** — Block 2 stack: NodeSource Node v20.20.2, Bun 1.3.13 (~/.bun/bin), gh CLI 2.92.0, Docker Engine 29.4.3 + Compose plugin (official apt repo, NOT snap). `toey` added to docker group.
- **2026-05-11 ~15:25** — Block 3a: aree repo cloned at `~/projects/aree` (via HTTPS, then remote switched to SSH after aree-home key uploaded to GitHub). Generated aree-home ed25519 key, uploaded as `aree-home` on GitHub (auth scope). `git@github.com:superdunk27/aree.git` SSH auth verified. Claude Code CLI installed globally. Oracle skills `lab (47)` installed (initial run hit `env: 'bun': No such file` for non-interactive SSH — fixed by `export PATH="$HOME/.bun/bin:$PATH"` + `-a claude-code -y` flags).
- **2026-05-11 ~15:30** — Block 3b: MCP servers `context7`, `playwright`, `firecrawl` added (user scope, `~/.claude.json`). Health check: all 3 Connected. systemd user service `aree.service` created + enabled + linger enabled (tmux survives logout/reboot). tmux session `aree` running, ready for Claude Code on attach.

### Architecture (resolved 2026-05-10, executed 2026-05-11)

```
[Laptop/Phone/RDLT] —Tailscale—> [aree-home (100.77.60.57)]
                                   ├── tmux 'aree' (auto-start, systemd user service)
                                   │     └── claude (interactive shell, after first-run login)
                                   ├── ~/projects/aree/ (this repo, SSH remote)
                                   │     └── .claude/skills/ (47 oracle + sync)
                                   └── Docker (per-project services, ready unused)
                                              —git push—> github.com/superdunk27/aree
```

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
