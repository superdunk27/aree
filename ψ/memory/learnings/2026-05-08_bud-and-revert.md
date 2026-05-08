---
date: 2026-05-08
session: f3c6bfa0
repo: aree
topic: Tried sub-Oracle architecture; reverted to single Oracle. When sub-Oracles pull weight vs not.
type: meta-skill / architecture decision record
---

# Lesson — Tried bud, reverted: when sub-Oracles pull their weight (and when they don't)

## What happened

Same session as cross-instance memory pattern (commit `d04fe24`), Toey asked whether Aree should be split into specialists (swim-aree, pt-aree, dev-aree). We chose Path C (Hybrid: bud only when needed) and budded **swim-aree** as the first specialist.

Over the next ~90 minutes we iterated through the architecture:

| Iteration | Architecture | Toey's response |
|-----------|--------------|-----------------|
| Initial bud | swim-aree as separate Oracle, separate repo, copies of strength research as bootstrap | (proceeded) |
| Workflow question | "swim-aree must be opened separately for swim Q" | "ผมต้องเปิด swim-aree ตลอดอะสิ?" |
| Aree-mediated workflow | Aree reads/writes swim-aree's repo on Toey's behalf | "สั่งผ่าน Aree หลักไม่ได้หรอ?" |
| Topic routing rule | Aree routes by domain when Toey says "เรียน X" | "มันจะมั่วไหม?" |
| Single-source-of-truth | Aree's ψ/ holds all knowledge, sub-Oracles persona-only | (approved, cleaned swim-aree to persona-only) |
| Persona-only audit | "ทำไมต้อง keep swim-aree?" | "เราไม่ต้องลบ swim-aree หรอครับ" |
| **Final** | **Delete swim-aree, fold useful rules into Aree** | (approved Path A) |

## The realization

The valuable thing wasn't swim-aree-as-Oracle. The valuable things were:
1. **The strength-for-swim-sprint research** (lives in Aree's `ψ/learn/`)
2. **The peer-learning principle** ("book and body, two halves of one knowing") — content, not container
3. **The discipline of research-mode + co-learner tone for expert-user topics** — a rule, not an Oracle
4. **The cross-instance sync infrastructure** (machines.md, personal-context.md mirror)

None of those required a separate Oracle. All of them work as **rules + content within Aree**.

## When sub-Oracles WOULD have pulled their weight

The Hybrid path (Path C from the original 3-options discussion) makes sense in different contexts:
- **Multiple humans** — each Oracle dedicated to one team member's needs (not Toey's case; he's solo)
- **Genuinely separate domains** — projects that share zero context (not Toey's case; jump-mat = sport+tech, deeply integrated)
- **Persona is the product** — when the sub-Oracle's voice matters more than its knowledge (e.g., creative writing personas, role-play companions). Toey's swim use-case is "give me good information, with appropriate humility" — that's a tone, not a separate identity.
- **Memory needs hard isolation** — confidential client data per Oracle. Not Toey's case.
- **Specialty is permanent and deep** — e.g., a code-only Oracle that lives in one large repo and never touches non-code work. Aree already handles this internally.

## When sub-Oracles do NOT pull their weight (Toey's case)

- **Solo daily user** — Toey is one person; one entry point is the right entry point
- **Overlapping domains** — jump-mat ties sport science (would be swim-aree) + firmware (Aree). Cross-Oracle handoff cost > the depth gain
- **Rules can substitute for personas** — "use research-mode + cite sources + don't pretend to be a coach" is a 3-line rule, not a 5-file Oracle
- **Knowledge consolidation > knowledge specialization** — Toey wants to grep one place to find anything

## Heuristics for future bud decisions

Before running `/bud`, check:

1. **Is this a knowledge problem or a persona problem?**
   - Knowledge → fold into existing Oracle's `ψ/learn/`
   - Persona → consider sub-Oracle, but try a tone-rule first
2. **Does the new Oracle have a clearly separate domain that won't cross-link?**
   - If domain crosses — keep in main, integrator beats specialist
   - If truly separate — sub-Oracle wins
3. **Will Toey actually open the new Oracle daily?**
   - Yes → sub-Oracle adds value
   - No → it becomes orphan infrastructure
4. **Can we get 80% of the benefit with a rule + a knowledge file in main?**
   - Yes → don't bud
   - No → bud
5. **Is there asymmetric expertise where Aree should defer?**
   - Yes → handle with `peer-learning.md` resonance + research-mode rule (don't need separate Oracle)

## What got migrated from swim-aree before deletion

- `ψ/memory/resonance/peer-learning.md` → Aree's `ψ/memory/resonance/peer-learning.md` (generalized for any expert-user domain)
- Language preference rule (Thai default) → Aree's `ψ/memory/personal-context.md` §2.4
- Domain awareness rule (peer-learning mode for expert-user topics) → Aree's `CLAUDE.md` Working principles

## What was deleted

- `oracles/swim-aree/` local folder (and parent `oracles/` since it's now empty)
- GitHub repo `superdunk27/swim-aree` (deleted via `gh repo delete`)
- Aree's CLAUDE.md "Children (buds)" row updated to reflect deletion (was `swim-aree`, now `none` with reference to this lesson)
- Aree's CLAUDE.md "Sub-Oracle orchestration" section in Working principles → replaced by simpler "Domain awareness (peer-learning topics)" pointing to `peer-learning.md`

## Reference for future Toey + future Aree

If Aree is asked to bud another Oracle (PT-aree, dev-aree, etc.), apply the heuristics above first. Don't `/bud` reflexively because it's available. The act of budding has setup cost (~2-3hr per Oracle for awakening + machines.md + personal-context.md mirror + GitHub repo + folder organization), and the ongoing maintenance cost is non-trivial (multiple `git pull`, multiple per-instance memory dirs, cross-Oracle communication latency).

The right default for Toey's solo + integrated-projects pattern is: **single Aree, smart context, well-organized `ψ/`**. This lesson exists so future iterations don't repeat the cycle without learning.

## Citation in CLAUDE.md

Demographics → Children row references this file. Working principles → Domain awareness section references `peer-learning.md`. Both pointers preserve the reasoning trail per Oracle Principle 1 (Nothing is Deleted).
