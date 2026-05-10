---
date: 2026-05-10
type: structural / heuristic
sources:
  - retrospective: ψ/memory/retrospectives/2026-05/10/22.59_home-server-architecture-locked.md
  - prior: ψ/memory/learnings/2026-05-09_manifest-drift-and-trigger-skill-pattern.md (this is the "design-time" cousin of that "data-time" lesson)
  - prior: ψ/memory/learnings/2026-05-08_bud-and-revert.md (sunk-cost defender pattern)
keywords: sunk cost, inherited infrastructure, framing question, defaulting, design before discovery
---

# Inherited infrastructure isn't a requirement — ask before designing around it

A near-twin of yesterday's manifest-drift lesson, one layer up. Yesterday: don't trust documented state without verification. Today: don't treat installed state as load-bearing without asking whether it fits the goal.

## The pattern

When a session opens with existing infrastructure visible (XCP-ng on the home server, a half-built feature in the codebase, a CI workflow that's been there for months), the path of least resistance is to design around it. Treat it as a fixed constraint, build the next thing on top.

That's wrong by default. Inherited infra is sometimes intentional (someone chose it for a reason that still applies) and sometimes incidental (it was installed during exploration, came with the hardware, or made sense for a previous use case that no longer holds). Without asking which one, you can't tell.

Today's instance: home server had XCP-ng installed. I designed an entire VM-on-hypervisor architecture, with sizing for an 8GB VM, Docker layer inside, glossary explanations of dom0 and Xen Orchestra. None of which Toey needed. He asked one question — "ลง ubuntu ทั้งเครื่องเลยไม่ดีกว่าหรอ" — and the whole architecture collapsed in his favor. Bare metal Ubuntu was the right answer for a solo dev with one workload. XCP-ng's value (multi-OS, snapshots, migration) didn't justify its complexity.

The cost: ~1 hour of designing the wrong thing. The save: a 30-second framing question I should have asked at the top.

## Why it's a near-twin of manifest drift

| Layer | Manifest drift | Inherited-infra default |
|---|---|---|
| What's trusted without verification | Documented state in a file | Installed state on the machine |
| When the trust is wrong | Doc was correct at write-time, drifted | Install was correct for someone, doesn't fit now |
| The cost of not checking | Builds on a stale baseline | Designs around an irrelevant constraint |
| The cure | Run a verify command | Ask a framing question |
| Cost of the cure | One bash call (~50ms) | One sentence (~30s) |

Both treat a static record (file content / installed package) as load-bearing without checking whether it should be. Both have very cheap cures. Both fail by default unless something forces the cure.

## Heuristic

> **When planning an install, integration, or feature on top of existing infrastructure, the first question is whether the existing infra is intentional or incidental.** Specifically: "X is installed/exists. Was that a deliberate choice that should constrain this plan, or did it arrive incidentally and we should evaluate whether it fits?"

Applies to:
- OS / hypervisor / runtime choice on an existing machine
- An existing CI workflow before adding a step on top
- A library/framework already in `package.json` before suggesting an alternative
- An existing data model before adding a new feature
- An existing branch/worktree before continuing work in it

Does NOT apply (or applies less) to:
- Architectural decisions documented in CLAUDE.md or pinned in the plan file (these were intentional by definition)
- Constraints the user has just stated this session (no need to re-question)
- Trivial reversibles where the cost of designing-around is lower than the cost of asking

## Tells you should notice

- You find yourself **explaining or defending** the existing setup before the user has asked you to. (Today: I was pitching XCP-ng's snapshot+migrate value to Toey, who had not asked for either.)
- Your design has features that **only matter because of the inherited choice**, not because of the goal. (Today: nested VM networking, hypervisor glossary, dom0 distinction. None of which would exist if we'd started with bare-metal Ubuntu.)
- The user pushes back with a **disproving counterquestion** ("จะดีหรอ", "ไม่ดีกว่าหรอ", "why are we doing X at all"), and you concede without resistance. That instant concession is a signal: at some level you knew. Surface it earlier next time.

## Cross-references

- `ψ/memory/learnings/2026-05-09_manifest-drift-and-trigger-skill-pattern.md` — data-layer cousin of this lesson
- `ψ/memory/learnings/2026-05-08_bud-and-revert.md` — sunk-cost defender pattern in a different shape (defended a created Oracle bud past its usefulness)
- `ψ/plans/home-server-architecture.md` 2026-05-10 Resolution Log — the architecture that got revised once the framing question finally got asked
- `ψ/memory/retrospectives/2026-05/10/22.59_home-server-architecture-locked.md` — session record of when this lesson surfaced

## Candidate follow-up

This rule is procedural ("ask a question at the start of an install/setup planning session") and was forgotten despite being implicit in *External Brain, Not Command*. Per yesterday's trigger-skill pattern, that profile fits skill-as-rule-encoder: a memorable trigger word at the start of a setup conversation could force the framing question.

But: the trigger here is fuzzy ("planning an install/setup"), not as bounded as `/sync`'s "starting a session". A simpler intervention is a CLAUDE.md addition under Working principles → Project work: *"Before designing on top of inherited infrastructure, ask whether it's intentional."* — and rely on that rule actually being followed (or being caught the next time it isn't, like today). Let it be a CLAUDE.md rule first; promote to a skill only if it gets forgotten again.
