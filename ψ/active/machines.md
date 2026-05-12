# Aree's Machines

Cross-instance state manifest. Aree updates a machine's section whenever it installs/removes/configures something on that machine. Aree at session start runs `$env:COMPUTERNAME` (Windows) or `hostname` to identify the current machine, looks up the section, and orients itself.

**Convention**: Append-only history at the bottom of each machine section. Current state at the top.

---

## DESKTOP-CE4H6GT

**Aliased**: (Toey's working machine — set today 2026-05-08)
**OS**: Windows 11
**Last-updated**: 2026-05-12 ~14:15 GMT+7 (OMC plugin installed, skills upgraded global lab 47, project-local skills synced via git pull from aree-home)

### Current state

| Layer | Value |
|---|---|
| Node | v24.14.0 |
| Bun | 1.3.13 |
| npx | 11.9.0 |
| winget | v1.28.240 |
| Oracle skills (global) | **lab (47)** — `arra-oracle-skills@26.4.18` (upgraded 2026-05-12 from full 42 → lab 47) |
| Oracle skills (project-local) | **lab (47)** — `.claude/skills/` from `git pull` (committed at aree-home 2026-05-11) |
| MCP servers | `context7` ✓, `playwright` ✓, `firecrawl` ✓, `plugin:oh-my-claudecode:t` ✓ |
| MCP claude.ai | Google Drive / Calendar / Gmail (needs auth — not used yet) |
| **oh-my-claudecode plugin** | **v4.13.7** (installed 2026-05-12 via `/plugin install oh-my-claudecode` from `omc` marketplace) |
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
- (none — all caught up 2026-05-12)

### History
- **2026-05-08 09:30–09:45** — Sync from machine-2026-05-07: skills standard→full, +context7 +playwright MCP, arduino-cli 1.4.1 + ESP32 core 3.3.8
- **2026-05-08 ~16:00** — Web research stack expansion: +Firecrawl MCP (smoke-tested vs Jina-blocked PMC paper, scraped 269KB content successfully), documented NCBI E-utilities pattern. Filled the gap surfaced during morning's strength-for-swim-sprint research where Jina banned PMC anonymous access.
- **2026-05-12 ~14:00 GMT+7** — `git pull` brought 96 files from aree-home + RDLT work (`.claude/skills/` 47 dirs committed project-local, 5 new learnings, 4 new retros, `ψ/plans/access-everywhere.md`, CLAUDE.md workflow patterns). Manifest was 4 days stale.
- **2026-05-12 ~14:10 GMT+7** — `/plugin install oh-my-claudecode` installed plugin v4.13.7 from `omc` marketplace. `/reload-plugins` reported "1 plugin · 1 skill · 24 agents · 24 hooks · 1 plugin MCP server".
- **2026-05-12 ~14:19 GMT+7** — Global skills upgraded: `full (42)` → `lab (47)` via `npx -y arra-oracle-skills@26.4.18 install -g -y -p lab`. Both global and project-local now lab(47). Closes the "Pending sync" item open since 2026-05-08.

---

## RDLT

**Aliased**: Toey's home machine (hardware-confirmed 2026-05-10 — ASUS PRIME B450M-A + Ryzen 7 3700X)
**OS**: Windows 11 Enterprise 10.0.26200
**User**: toey0 (`RDLT\toey0`)
**Hardware**: ASUS PRIME B450M-A (S/N 200670633200021), AMD Ryzen 7 3700X (8c/16t), BIOS AMI 4622
**Original install date**: 09-Nov-2025
**Last-updated**: 2026-05-12 ~20:40 GMT+7 (Phase 1 closed on RDLT: Windows Terminal profile "Aree (aree-home)" + Desktop\Aree.lnk shortcut. End-to-end double-click verified.)

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
| **oh-my-claudecode plugin** | **v4.13.7** at `~/.claude/plugins/marketplaces/omc/` (was installed prior to 2026-05-12, manifest never recorded — confirmed present 2026-05-12 ~19:25) |
| **Tailscale** | 1.x at `100.111.92.57` (node name `rdlt`, online) |
| **SSH alias `aree`** | `~/.ssh/config` set 2026-05-12 → `HostName 100.77.60.57` + `RemoteCommand tmux attach -t aree \|\| tmux new -s aree`. ed25519 key already in aree-home `authorized_keys` since 2026-05-11 install |
| **Windows Terminal profile** | "Aree (aree-home)" → `commandline: ssh aree`. Installed 2026-05-12 via `aree-install.ps1` (scp'd from aree-home). Visible in WT dropdown. |
| **Desktop shortcut** | `~\Desktop\Aree.lnk` → `wt.exe -p "Aree (aree-home)"`. Double-click launches Aree session directly. ✓ end-to-end verified 2026-05-12 |
| arduino-cli | 1.4.1 (`C:\Program Files\Arduino CLI\arduino-cli.exe`) |
| ESP32 core | esp32:esp32 3.3.8 |
| Chronojump | installed → deprioritized (UX too clunky, dropped 2026-05-07) |
| yt-dlp | NOT installed (needed for `/watch` skill — install if/when used) |
| ffmpeg | NOT installed |

### Removed / Excluded
- `oracle-v2` MCP — removed 2026-05-07 (was misconfigured as stdio, actually HTTP — broken)

### Gaps vs DESKTOP-CE4H6GT (work machine)
- ✅ **Firecrawl MCP** — installed 2026-05-08. Now matches work machine. API key stored in `~/.claude.json` env (per-machine, not in repo).
- ✅ **Skills parity** — both at lab (47) since 2026-05-12 (DESKTOP upgraded full(42)→lab(47) earlier today).
- ✅ **OMC plugin parity** — both at v4.13.7 (DESKTOP installed 2026-05-12 ~14:10; RDLT confirmed already present 2026-05-12 ~19:25).
- ✅ **SSH alias parity** — both have `Host aree` block; both pubkeys in aree-home `authorized_keys`.
- ⚠️ **Phase 1 desktop ergonomics** — RDLT done 2026-05-12 ~20:40 (Windows Terminal profile + Desktop\Aree.lnk). DESKTOP pending — same `aree-install.ps1` flow when Toey at DESKTOP next.

### History
- **2026-05-07 evening** — Day 3 jump mat work session. Setup expansion: skills standard→full, MCP +context7 +playwright -oracle-v2, arduino-cli + ESP32 core via winget. Documented in `ψ/memory/retrospectives/2026-05/07/22.29_jump-mat-day3-setup-firmware-validators.md`.
- **2026-05-08 ~22:30** — Hostname confirmed = TOEY (was TBD). Skills upgraded full→lab via `npx arra-oracle-skills@26.4.18 install -g -y -p lab` (29→47, +18 skills documented in `ψ/memory/learnings/2026-05-08_oracle101-gap-review.md`). ψ/metrics/ created. CLAUDE.md updated with workflow patterns from oracle101 Ch 06B-10.
- **2026-05-08 ~22:45** — Firecrawl MCP installed (matched DESKTOP-CE4H6GT). Local skill `.claude/skills/sync.md` created — typing `sync` or `/sync` in any session triggers cross-machine state check + propose alignment.
- **2026-05-10 ~00:00** — `/sync` ran for the first time. `$env:COMPUTERNAME` returned **`RDLT`** (not "TOEY" as documented). All other state matched the prior "TOEY" section exactly (skills lab/47, all 4 MCP, arduino-cli, ESP32 3.3.8, Chronojump, no yt-dlp/ffmpeg). Hardware confirmed by Toey: ASUS B450M-A + Ryzen 7 3700X. Conclusion: same physical machine, "TOEY" was never an actual hostname — it was inferred. Section renamed RDLT, prior history preserved. `.claude/skills/sync/SKILL.md` updated. Skill format also fixed in same session: flat `sync.md` → `sync/SKILL.md` (commit `83b59be`).
- **2026-05-12 ~19:18 GMT+7** — `git pull` brought DESKTOP handoff (`ψ/inbox/2026-05-12_desktop-ssh-handoff.md`). Hostname verified via `$env:COMPUTERNAME` = `RDLT` ✓. Tailnet status: RDLT online (`100.111.92.57`), aree-home online, DESKTOP/phone offline.
- **2026-05-12 ~19:22 GMT+7** — SSH from RDLT → aree-home tested: works with existing ed25519 key from 2026-05-11 install. DESKTOP-CE4H6GT pubkey (`ssh-ed25519 …DK7sad1kfXVzaKfVRDvvyH7l5A2e7XUh9EfyWnsOX4n desktop-ce4h6gt-toey-2026-05-12`) appended to aree-home `~/.ssh/authorized_keys`. Phase 1.1 closes for DESKTOP — first `ssh aree` from work will succeed.
- **2026-05-12 ~19:23 GMT+7** — `Host aree` block written to RDLT's `~/.ssh/config` (HostName 100.77.60.57, RemoteCommand tmux attach). Connectivity tested via `ssh -F config -o RemoteCommand=none aree hostname` → returned `aree-home` ✓. Phase 1.1 closes for RDLT.
- **2026-05-12 ~19:25 GMT+7** — OMC plugin found pre-installed at `~/.claude/plugins/marketplaces/omc/` v4.13.7. Manifest claimed "RDLT pending OMC install" since 2026-05-11 — actually present. **4th manifest drift this week** (see drift lesson note below).
- **2026-05-12 ~20:40 GMT+7** — Phase 1.2 + 1.3 closed on RDLT. `aree-install.ps1` (written on aree-home at `~/aree-install.ps1`, scp'd to RDLT and executed via `powershell -ExecutionPolicy Bypass -File`) created Windows Terminal profile "Aree (aree-home)" and `~\Desktop\Aree.lnk` shortcut. Both tested end-to-end: WT dropdown shows the profile, double-click Desktop\Aree.lnk → Windows Terminal opens → `ssh aree` → tmux session on aree-home. Phase 1 success criteria met: launch via double-click, zero command memorization. Process gotcha for next time: first PowerShell paste landed in CMD (not PowerShell — banner mismatch detected after `Write-Host` errors); second paste hit PowerShell but multi-line block broke on re-paste (`>>` continuation confusion). Final fix was scp + run-from-file approach which becomes the canonical pattern for DESKTOP repeat. Script `~/aree-install.ps1` left on aree-home as reusable installer.
- **Manifest drift lesson (4 instances this week)**: 2026-05-08 (skills count "full(42)" vs actual 29), 2026-05-09 (skill format flat vs directory), 2026-05-10 (hostname "TOEY" vs RDLT), 2026-05-12 (OMC plugin "pending" vs already installed). All four: documented value taken as authoritative without verification. Reinforces lesson in `ψ/memory/learnings/2026-05-09_manifest-drift-and-trigger-skill-pattern.md`. The `/sync` skill itself was the cure for the third instance; today's fix required reading the actual filesystem before claiming state.

---

## aree-home

**Aliased**: Toey's 24/7 home server — single-writer Aree instance (designed 2026-05-08, deployed 2026-05-11)
**OS**: Ubuntu 26.04 LTS (`resolute`), kernel 7.0.0-15-generic
**User**: `toey`
**Hardware**: Intel Xeon E5-2690 v3 (12c/24t @ 2.60GHz), 128 GB RAM (123 GiB usable), 480 GB SSD
**Install date**: 2026-05-11 (today — bare metal, replaced inherited XCP-ng install)
**Last-updated**: 2026-05-11 ~15:45 GMT+7 (post-Claude-Code-login + oh-my-claudecode plugin installed via `/oh-my-claudecode:setup` wizard)

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
| Claude Code | 2.1.138 (logged in this session) |
| Oracle skills | **lab (47)** — installed to `~/projects/aree/.claude/skills/` (project-local, **intentional**: skills committed to repo, sync via `git pull`. Differs from RDLT/DESKTOP which use `~/.claude/skills/` global scope) |
| Local skills | `sync/` (cross-machine state alignment, committed at `.claude/skills/sync/`) |
| MCP servers | `context7` ✓, `playwright` ✓, `firecrawl` ✓, `plugin:oh-my-claudecode:t` ✓ |
| MCP claude.ai | Google Drive / Calendar / Gmail registered (needs OAuth auth — not used yet, same status as RDLT/DESKTOP) |
| oh-my-claudecode plugin | **v4.13.7** (installed via `/plugin install oh-my-claudecode` from `omc` marketplace `github.com/Yeachan-Heo/oh-my-claudecode`) |
| OMC global CLAUDE.md | `~/.claude/CLAUDE.md` (canonical OMC content, overwrite mode — no prior file existed) |
| OMC HUD | `~/.claude/hud/omc-hud.mjs` installed, `statusLine` configured in `~/.claude/settings.json` |
| OMC agent teams | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` enabled in `~/.claude/settings.json` (experimental Claude Code feature) |
| OMC config | `~/.claude/.omc-config.json` — `defaultExecutionMode=ultrawork`, `taskTool=builtin`, team defaults `maxAgents=3 + defaultAgentType=claude` |
| OMC CLI (`omc`) | **NOT installed** — `npm install -g oh-my-claude-sisyphus` failed with EACCES on `/usr/lib/node_modules`. Install via `sudo npm install -g oh-my-claude-sisyphus` when needed (plugin `/oh-my-claudecode:*` commands work without it) |
| sudo | NOPASSWD enabled for `toey` (`/etc/sudoers.d/toey-nopasswd`) — single-user homeserver trust model |
| Ruby | **NOT installed** (Ralph workflows need it — `sudo apt install ruby-full` when wanted, deferred 2026-05-11) |
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
- **Optional**: `claude.ai` Google Drive/Calendar/Gmail MCP auth if Toey wants (servers registered, OAuth flow not run)
- **Optional**: install Ruby (`sudo apt install ruby-full`) if Ralph workflows are wanted
- **Optional**: install OMC CLI (`sudo npm install -g oh-my-claude-sisyphus`) if standalone `omc` commands are wanted
- **Optional**: restart Claude Code to activate OMC HUD statusline (configured but needs restart to render)
- **Decision pending**: keep aree-home as sole writer, or run multi-machine writer (likely sole writer per home-server-architecture.md plan)

### Pending propagation to sister machines
- ~~**oh-my-claudecode plugin** (v4.13.7) — install via `/plugin install oh-my-claudecode` after `/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode`.~~ DESKTOP-CE4H6GT ✅ done 2026-05-12 ~14:10. RDLT ✅ confirmed pre-installed 2026-05-12 ~19:25 (manifest drift — see RDLT history).
- **HUD statusline** — auto-installed by `/oh-my-claudecode:setup` wizard, no manual step needed beyond running the wizard. DESKTOP-CE4H6GT pending: wizard not yet run (plugin installed bare, no setup wizard yet).

### Removed / Excluded
- **XCP-ng** — was inherited on this hardware, wiped 2026-05-11 at install time. No data preserved (Toey confirmed nothing of value).

### History
- **2026-05-11 ~14:00 GMT+7** — Bare metal Ubuntu 26.04 install (USB ISO, replaced XCP-ng). Choices: hostname `aree-home`, user `toey`, no encryption, ext4+LVM, OpenSSH from install. GitHub SSH key import initially failed (`superdunk27.keys` was empty — uploaded RDLT's ed25519 via `gh ssh-key add` after `gh auth refresh -s admin:public_key`), then retry succeeded.
- **2026-05-11 ~14:30** — Network friction surfaced: aree-home (192.168.79.x) and RDLT (192.168.1.x) on different subnets due to upstairs router being a WiFi repeater of the downstairs router. **Tailscale** installed at server console via auth-key flow (`tailscale up --authkey=…`), bypasses subnet split. Tailscale also installed on RDLT (winget `Tailscale.Tailscale`). Both joined tailnet — aree-home reachable at `100.77.60.57`, RDLT at `100.111.92.57`.
- **2026-05-11 ~15:00** — NOPASSWD sudo enabled for `toey` (single-command paste, then automated SSH-driven setup from RDLT). LVM extended 100 G → 437 G (closes Ubuntu installer's conservative default). Block 1 stack: apt update/upgrade + build-essential + git 2.53 + tmux 3.6 + unzip.
- **2026-05-11 ~15:15** — Block 2 stack: NodeSource Node v20.20.2, Bun 1.3.13 (~/.bun/bin), gh CLI 2.92.0, Docker Engine 29.4.3 + Compose plugin (official apt repo, NOT snap). `toey` added to docker group.
- **2026-05-11 ~15:25** — Block 3a: aree repo cloned at `~/projects/aree` (via HTTPS, then remote switched to SSH after aree-home key uploaded to GitHub). Generated aree-home ed25519 key, uploaded as `aree-home` on GitHub (auth scope). `git@github.com:superdunk27/aree.git` SSH auth verified. Claude Code CLI installed globally. Oracle skills `lab (47)` installed (initial run hit `env: 'bun': No such file` for non-interactive SSH — fixed by `export PATH="$HOME/.bun/bin:$PATH"` + `-a claude-code -y` flags).
- **2026-05-11 ~15:30** — Block 3b: MCP servers `context7`, `playwright`, `firecrawl` added (user scope, `~/.claude.json`). Health check: all 3 Connected. systemd user service `aree.service` created + enabled + linger enabled (tmux survives logout/reboot). tmux session `aree` running, ready for Claude Code on attach.
- **2026-05-11 ~15:40 GMT+7** — Claude Code first-run login complete (browser OAuth, in-tmux). claude.ai bundle MCPs auto-registered: Google Drive / Calendar / Gmail (OAuth flow not run yet, status: "needs authentication"). plugin marketplace `omc` added (`/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode`). Plugin `oh-my-claudecode@omc` installed (v4.13.7). `/plugin install` reported "Reloaded: 1 plugin · 1 skill · 24 agents · 24 hooks · 1 plugin MCP server".
- **2026-05-11 ~15:45 GMT+7** — `/oh-my-claudecode:setup` wizard ran (global scope, overwrite mode — no prior `~/.claude/CLAUDE.md` existed). Installed: OMC canonical CLAUDE.md, `omc-reference` skill (`~/.claude/skills/omc-reference/`), HUD wrapper (`~/.claude/hud/omc-hud.mjs` + `lib/config-dir.mjs`), statusLine configured in `~/.claude/settings.json` using `node ${CLAUDE_CONFIG_DIR:-$HOME/.claude}/hud/omc-hud.mjs` (forward slashes, portable). Enabled `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in settings.json. `.omc-config.json` written with `defaultExecutionMode=ultrawork`, `taskTool=builtin`, team defaults `maxAgents=3 + defaultAgentType=claude`. **Failures (non-blocking)**: OMC CLI npm install (`npm install -g oh-my-claude-sisyphus`) failed EACCES on `/usr/lib/node_modules` (needs sudo, deferred); Ruby for Ralph workflows missing (deferred — `sudo apt install ruby-full`).
- **2026-05-11 ~16:00 GMT+7** — `/sync` ran for the first time on aree-home. Hostname `hostname` returned **`aree-home`** ✓ matches manifest section. State diff identified 6 drift/new items vs manifest (Claude Code login, OMC plugin v4.13.7, OMC HUD, agent teams env, OMC global CLAUDE.md, claude.ai MCP triplet now registered) — all are intentional outcomes of the install workflow, not unwanted drift. Decided to **commit `.claude/skills/` (47 oracle + sync local + 2 metadata files) into the repo** — `aree-home` install scope is project-local (`~/projects/aree/.claude/skills/`) intentionally so that the skill set syncs across machines via `git pull` together with `ψ/`. RDLT/DESKTOP continue to use global `~/.claude/skills/` scope; future propagation could converge them to project-local but that's deferred. machines.md updated and committed in the same change.
- **2026-05-12 ~19:22 GMT+7** — DESKTOP-CE4H6GT pubkey appended to `~/.ssh/authorized_keys` (via RDLT → ssh aree-home → echo). authorized_keys now holds 2 keys: aree-home self (`superdunk27@github`) + DESKTOP (`desktop-ce4h6gt-toey-2026-05-12`). RDLT uses the same `superdunk27@github` key already there. Phase 1.1 SSH alias for the whole fleet now functional from all three machines via Tailscale.

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
