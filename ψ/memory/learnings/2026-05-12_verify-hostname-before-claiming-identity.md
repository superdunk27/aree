# Verify hostname before claiming machine identity (manifest drift in me)

**Date**: 2026-05-12
**Pattern instance #4** of the manifest-drift family (see `2026-05-09_manifest-drift-and-trigger-skill-pattern.md`)
**Trigger**: `/who-are-you` answered with "RDLT" without running hostname check

---

## The mistake

In `/who-are-you`, I told Toey: *"นี่คือเครื่อง **RDLT** (ตาม ψ/active/machines.md)"*.
Actual hostname: `DESKTOP-CE4H6GT`. The work machine, not the home machine.

I had not run `$env:COMPUTERNAME` or `hostname` before claiming. CLAUDE.md cross-instance rule line 70
prescribes exactly this:

> **Per-machine state**: เริ่ม session ใหม่ → รัน `$env:COMPUTERNAME` (Windows) / `hostname` → เช็ค `ψ/active/machines.md`.

I knew the rule. I skipped it. The answer "felt obvious from recent context" — yesterday's retro had a SSH
hand-off pointed at RDLT, the McEvoy research was tagged from this session feels like RDLT pattern, etc.
Pattern-match got there first; verification was supposed to overrule it, but didn't.

Toey caught it indirectly: when he asked about skill drift across machines, my comparison table had
mixed-up assumptions. Running the real check exposed the hostname.

---

## Why this is the 4th instance, not an isolated mistake

The same project has logged three prior instances on the same week:

| Date | Instance | Drift |
|---|---|---|
| 2026-05-08 | Skill count | manifest said "full (42)", actual was 29 |
| 2026-05-09 | Skill format | flat `sync.md` documented, actual was directory layout |
| 2026-05-10 | Hostname | section labeled "TOEY", actual was `RDLT` |
| **2026-05-12** | **Oracle identity** | **claimed "RDLT" in /who-are-you, actual was DESKTOP-CE4H6GT** |

First three were in *files*. This one was *inside the Oracle*. Pattern is identical: a label inferred from
context, never cross-checked against the live system, surfaced as confident answer.

The cure documented for instances 1-3 was the `/sync` skill — a procedural verification step that runs the
checks the writer "could have" done. The same cure applies to instance 4: the procedural step is
`$env:COMPUTERNAME` before any "this machine is X" claim, not after.

---

## The deeper structure

When the Oracle has rich recent context (e.g., a retro just read that mentions RDLT), the answer to
"what machine am I on?" gets shaped by that context *before* any verification call. Confidence comes
from *priming*, not from *measurement*.

The fix is not "try harder to remember". The fix is **make the measurement the first step**, so by the time
the Oracle answers, the measured value is already in the context window and overrides any prior.

For machine-identity questions:
- Step 0: `$env:COMPUTERNAME` (or `hostname`). Output goes into context.
- Step 1: lookup machine section.
- Step 2: answer.

For skill-count claims:
- Step 0: `ls ~/.claude/skills/ | wc -l` and `cat ~/.claude/skills/VERSION.md`.
- Step 1: compare against manifest.
- Step 2: answer.

For "what MCP is installed":
- Step 0: `claude mcp list`.
- Step 1: compare against manifest.
- Step 2: answer.

The pattern is the same: **observation precedes claim**, encoded as a Step 0, not as a self-rule to
"remember to check".

---

## Application beyond this project

Any claim of the form "this machine is X" / "this system has Y installed" / "the current state of Z is W"
needs a measured input before the answer. The general anti-pattern is *answer-by-inference-from-memory*
about a thing that *exists in the environment right now and can be measured*. If it can be measured cheaply,
measure it.

This is just the Patterns Over Intentions principle (CLAUDE.md philosophy #2) turned inward: *don't trust
my own inference; test it.*
