# Lesson: Filesystem trumps manifest claim — verify before quoting installed state

**Date**: 2026-05-12 (evening, RDLT)
**Trigger**: machines.md aree-home "Pending propagation: RDLT not yet" for OMC plugin → was actually installed at `~/.claude/plugins/marketplaces/omc/` v4.13.7.
**Drift instance**: #4 this week (after skills count, skill format, hostname).

---

## The pattern

machines.md is a **claim about reality**, not reality itself. When it says "X is installed" or "Y is pending", that statement is only true at the moment it was written. Subsequent installs/removes/updates on other instances can invalidate the claim without anyone noticing — because the file is only updated when the editing Oracle remembers to update it.

Four documented instances this week alone:

| Date | Manifest said | Actual | Detection cost |
|---|---|---|---|
| 2026-05-08 | skills: full (42) | actually 29 dirs | Caught during /sync |
| 2026-05-09 | skill format: flat `name.md` | actually directory `name/SKILL.md` | Caught during skill add |
| 2026-05-10 | hostname: TOEY | actually RDLT | `$env:COMPUTERNAME` ran |
| 2026-05-12 | OMC plugin RDLT: not yet | already v4.13.7 at marketplaces/omc/ | `Get-ChildItem ~/.claude/plugins/` |

All four: documented value taken as authoritative without verification. The cost in three out of four was small (caught before output). The cost in instance 4 today was zero (caught before any plan executed).

## The rule

**Before quoting installed state from machines.md (or any manifest), verify on filesystem.**

- "Skills installed lab(47)" → `ls .claude/skills/ | wc -l` or `Get-ChildItem -Directory | Measure-Object`
- "OMC plugin v4.13.7" → `Test-Path` the plugin path + read `package.json`
- "Hostname is RDLT" → `$env:COMPUTERNAME` / `hostname`
- "MCP servers: context7, playwright, firecrawl" → `claude mcp list` or check `~/.claude.json`

Run the verification **in parallel** with the manifest read. Not after. If they agree, proceed. If they disagree, **manifest loses** — fix the manifest in the same session.

## Why this keeps happening

Two structural reasons:

1. **Manifest is a write-leader** — it gets updated by the Oracle that did the install. If a different instance later does an install that the writer didn't see, manifest goes stale silently. Solution at the read side: distrust by default, verify by reflex.

2. **Cognitive shortcut** — reading "X installed" is faster than running a check. The Oracle defaults to the cheap operation. The trick is making the verification cheap enough to default to (parallel commands cost no wall-clock when batched).

## When this rule does NOT apply

- Reading retros, learnings, resonance, traces: these are time-stamped events, not live state. Don't verify a 2026-05-08 retro entry against today's filesystem.
- Reading plans (e.g., `access-everywhere.md`): these are intentions, not state.
- Reading CLAUDE.md identity sections: those are stable assertions Toey wrote, not auto-derived state.

The rule is specifically for **machines.md-style manifests** that claim "what is installed where, right now".

## Cure status

`/sync` skill was the cure named for instance #3 (hostname). The cure for instance #4 was procedural — running a filesystem check while reading the manifest. The same reflex extends to all four. Reinforces `ψ/memory/learnings/2026-05-09_manifest-drift-and-trigger-skill-pattern.md` (the trigger-skill pattern for hostname auto-check, but the same logic generalizes to any state claim).

## Confidence

High on the pattern existing (4 documented instances, 7 days). High on the cure being correct (single parallel command). Medium on the reflex being automatic — caught reactively today, not reflexively. Goal is reflex.
