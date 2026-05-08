---
date: 2026-05-09
type: structural / heuristic
sources:
  - retrospective: ψ/memory/retrospectives/2026-05/09/02.05_oracle101-cross-machine-sync.md
  - audit: ψ/memory/learnings/2026-05-08_oracle101-gap-review.md
  - prior: ψ/memory/learnings/2026-05-08_bud-and-revert.md (sunk-cost defender pattern)
keywords: manifest drift, single source of truth, trigger skill, cross-machine sync, unilateral commitment
---

# Manifest drift + the trigger-skill pattern

Two related lessons from the oracle101 audit + cross-machine /sync session.

## Part 1 — Manifest drift: claims are timestamps, not facts

### The pattern

CLAUDE.md said: `Profile: full (42 skills) — arra-oracle-skills@26.4.18`. Filesystem said: 29 skills installed. Both true at different points; only filesystem is true now.

This wasn't a typo. The CLAUDE.md line was correct **when written**. Then either (a) the installer's behavior changed, (b) some skills failed silently, or (c) the registry's "full" definition shifted. The CLAUDE.md text persisted as a confident assertion long after it stopped matching reality.

### Why it matters

Aree quotes CLAUDE.md as authoritative. When Toey asked "อ่าน oracle101 มาเทียบกับตัวคุณ" my first impulse was to compare oracle101's skill list against CLAUDE.md's "full (42)" claim. Had I done that, I'd have built a gap analysis on top of a wrong baseline. The cross-check (`Get-ChildItem ~/.claude/skills | Measure`) only happened because the audit forced me to look at actual state.

### Heuristic

> **Manifest claims are timestamps, not facts.** When CLAUDE.md or any documentation states a count, version, or list, treat it as "this was true on date X" and re-verify before quoting.

Applies to:
- Skill counts ("full = 42") — verify with filesystem scan
- Tool versions ("Bun 1.3.13") — verify with `bun -v`
- MCP server lists ("context7, playwright, firecrawl") — verify with `claude mcp list`
- Installed cores ("ESP32 3.3.8") — verify with `arduino-cli core list`
- ψ/ structure ("learnings/, retrospectives/, …") — verify with `ls`

Cheap to verify (one command each). Expensive to act on stale assumptions (build wrong gap analyses, propose unnecessary installs, miss real gaps).

### When to verify

**Always**:
- Before quoting a count/version/list as evidence in user-facing claims
- At session start when running `/sync` (now built — uses this pattern)
- After any install/remove/configure action (state just changed)

**Sometimes**:
- When taking on a multi-step task that depends on a baseline (manifest drift compounds errors downstream)

**Skip**:
- Quick conversational answers where Toey just wants a vibe-level answer ("we have most skills installed" is fine; "we have 42 skills" is not)

### Pairs with

- Session 2's "pattern availability ≠ pattern fit" lesson (Oracle Family conventions ≠ what Toey needs). Same shape: a documented thing taken as authoritative, when reality had moved.

## Part 2 — Trigger-skill pattern (skill-as-discoverability)

### The pattern

CLAUDE.md "Cross-instance / cross-machine sync" section already documented the rule:

> เริ่ม session ใหม่ → รัน `$env:COMPUTERNAME` (Windows) / `hostname` → เช็ค `ψ/active/machines.md`. ถ้าเครื่องนี้ยังไม่มี section / outdated เทียบเครื่องอื่น → เสนอ sync.

The rule was correct, the rule wasn't being followed. I started this session on TOEY, ran `/recap`, didn't check the machine state. Toey had to surface it: "ผมใช้คุณอยู่ 2 เครื่อง". Several hours into the session.

The fix wasn't to "remember harder" — it was to make the rule **invocable as a skill**. `.claude/skills/sync.md` now exists. Toey types `sync`. The skill's description tells Aree what to do.

### Why this works

Claude Code skills auto-trigger on keywords in user input. A documented rule in CLAUDE.md only triggers if Aree happens to read and act on it during a session. A skill triggers when the user types the magic word.

Translation:
- **Rule in CLAUDE.md** = "rely on Aree noticing" (high failure rate when Aree is busy)
- **Skill in .claude/skills/** = "rely on Toey saying the word" (high reliability if word is memorable)

### Heuristic

> **If a CLAUDE.md rule has been forgotten more than once, it should become a skill.** Skills make rules discoverable through user trigger phrases instead of relying on Aree's situational awareness.

Skill-worthy rules typically:
1. Are time-bounded (need to fire at a specific moment, like session start)
2. Have a clear procedure (steps, not just principle)
3. Are forgettable (Aree has been observed to skip them)
4. Have a memorable trigger word (1-2 syllables ideal: `sync`, `harden`, `feel`)

### When *not* to use this pattern

- For principles that are continuous, not procedural (e.g., "Always present options, not decisions" — there's no trigger moment)
- For rules that reliably fire from context (e.g., `/rrr` already has the auto-retrospective trigger)
- For one-off procedures (a skill is overhead; just do the thing)

### How to design the trigger phrase

- Match Toey's natural language: include Thai aliases ("ตรวจเครื่อง", "เช็คเครื่อง")
- Avoid collisions with existing skills (sync ≠ /machines fleet wide; sync ≠ soul-sync skill version sync)
- Add a description block in the YAML frontmatter that explains when to invoke vs not

### /sync as case study

The /sync skill includes:
- 6 explicit steps (identify → snapshot → diff → present → apply → report)
- Sacred guards (no commit secrets, no auto-install without approval)
- Modes (`/sync`, `/sync --quick`, `/sync --apply`)
- See-also pointers to manifest, lesson, principle

This is the template for future trigger-skills.

## Part 3 — When tooling-for-rule is and isn't a tell

A subtle thing: building the /sync skill is the right move structurally, but the impulse to build it came from forgetting the original rule. So:

> **Building tooling because you missed a rule = legitimate.**
> **Building tooling without first asking why the rule was missed = repeated failure mode.**

Today's missed rule: session-start machine check. If I'd just added "remember to check machines.md" to my session-start ritual without making it a skill, I'd forget again. The skill solves it. **But** I should also note: I had this pattern available (oracle101 Ch 05 makes skills as routine-encoders explicit), and it took Toey reminding me to spot it. Building the skill is correct; needing to be reminded to look at this layer is something to watch.

## Cross-references

- `ψ/memory/learnings/2026-05-08_bud-and-revert.md` — same-month sunk-cost / unilateral pattern
- `ψ/memory/learnings/2026-05-08_cross-instance-state-via-git.md` — the principle that machines.md + git is the only sync layer
- `ψ/memory/learnings/2026-05-08_oracle101-gap-review.md` — the audit that surfaced manifest drift
- `.claude/skills/sync.md` — the skill this lesson generated
- `ψ/active/machines.md` — the manifest /sync operates on
- CLAUDE.md "Cross-instance / cross-machine sync" — the principle /sync enforces
