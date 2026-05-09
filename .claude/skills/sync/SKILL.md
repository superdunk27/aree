---
name: sync
description: Cross-machine state check + sync. Compares this machine's actual state (skills, MCP, tools) against ψ/active/machines.md and proposes installs/updates needed to match the sister machine. Use when Toey types "sync", "/sync", "ตรวจเครื่อง", "เช็คเครื่อง", "เช็คสภาพเครื่อง", "machine sync", "sync machines", or starts a session and wants both machines aligned. Do NOT trigger for /machines (that's Oracle fleet networking — different).
---

# /sync — Cross-machine state check & alignment

**Goal**: Make RDLT (home) and DESKTOP-CE4H6GT (work) — Toey's two machines — produce the same Aree behavior. Run this when starting a session and you want to verify the current machine matches the manifest, or after any install/remove/config change.

## Steps

### 1. Identify the machine

```powershell
$env:COMPUTERNAME
```

Hostname maps to a section in `ψ/active/machines.md`:
- `RDLT` — home (was wrongly recorded as `TOEY` until 2026-05-10 — see machines.md history)
- `DESKTOP-CE4H6GT` — work

If hostname is neither → this is a **NEW machine**. Create a new section (don't overwrite existing).
**Always verify with the actual command** — never trust documented hostnames without running `$env:COMPUTERNAME` (this is exactly the lesson that surfaced RDLT — see `ψ/memory/learnings/2026-05-09_manifest-drift-and-trigger-skill-pattern.md`).

### 2. Snapshot current state (parallel where possible)

```powershell
# Versions
node -v; bun -v; npx -v; winget -v

# Oracle skills count
(Get-ChildItem "$env:USERPROFILE\.claude\skills" -Directory).Count

# MCP servers
claude mcp list

# Optional tools
foreach ($t in @("arduino-cli","yt-dlp","ffmpeg")) {
  $f = Get-Command $t -ErrorAction SilentlyContinue
  if ($f) { "$t : $($f.Source)" } else { "$t : NOT FOUND" }
}

# Arduino cores (if installed)
arduino-cli core list 2>$null

# Chronojump
Test-Path "C:\Program Files\Chronojump"
Test-Path "C:\Program Files (x86)\Chronojump"
```

### 3. Diff vs manifest

Read `ψ/active/machines.md`:
- **Section for current machine** → compare snapshot vs documented Current state
- **Sister machine section** → list what the OTHER has that this one doesn't (potential sync gaps)

Output format:
```
=== <CURRENT_HOSTNAME> (current) ===
✓ matching items
Δ drift detected (manifest says X, actual is Y)

=== <SISTER_HOSTNAME> (sister) — what it has that this machine doesn't ===
- Firecrawl MCP
- (etc.)

=== <CURRENT> → <SISTER> — pending sync ===
- (items in this machine's "Pending sync" list for the sister)
```

### 4. Present options

For each gap/drift:
- **install** — run install command, update manifest
- **skip** — note in manifest "Removed/Excluded" with reason
- **defer** — leave as-is, no manifest change

Use AskUserQuestion or inline list. **Sacred rule**: never auto-install services that need API keys without confirming key source first.

### 5. Apply approved actions

- Install missing MCP servers / tools
- Verify each install (e.g., `claude mcp list` after `mcp add`)
- Update `ψ/active/machines.md`:
  - Current state table at top
  - Append dated entry to History
  - Update sister machine's "Pending sync" if this machine has new things
- Stage + commit (sync via git)

### 6. Report

- ✅ Installed: ...
- ⏸️ Skipped: ... (with reason)
- 📋 Pending on other machine: ... (will surface next time)

## Modes

- `/sync` — full check + propose actions
- `/sync --quick` — snapshot + diff only, no install proposal (info mode)
- `/sync --apply` — auto-apply non-key-required installs (still asks for key-required)

## Sacred guards

- **NEVER commit secrets** to repo. API keys go into `~/.claude.json` env (per-machine, not synced). Toey may paste keys in chat — accept them, store in user config, never write to ψ/ or .claude/skills/
- **NEVER auto-install** without Toey's approval (External Brain, not Command)
- **NEVER overwrite** another machine's section in `machines.md` (Nothing Deleted)
- **Match scope to request**: `/sync` is per-machine state alignment; for fleet-wide Oracle networking use `/machines` or `/fleet`

## See also

- `ψ/active/machines.md` — manifest (single source of truth across machines)
- `ψ/memory/learnings/2026-05-08_cross-instance-state-via-git.md` — why git is the only reliable sync layer
- CLAUDE.md "Cross-instance / cross-machine sync" — the principle this skill enforces
