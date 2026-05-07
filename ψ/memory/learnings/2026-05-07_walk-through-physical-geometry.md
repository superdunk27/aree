# Lesson Learned — Walk Through Physical Geometry Concretely When Describing Hardware Assembly

**Date**: 2026-05-07
**Domain**: hardware engineering communication
**Source**: jump mat project (solder bump issue caught by Toey)

## The Lesson

**When describing how a physical thing is assembled, walk through the 3D geometry concretely** — solder is a mound, wires take vertical space, foam compresses around shapes, tape has thickness. Schematic-style abstraction omits exactly the dimensions that determine whether the design actually works.

If Aree had simulated the assembly mentally as a 3D process — bottom PCB, then solder bump rises 1mm, then tape sits over it, then top PCB lowers — the conflict would have been visible before Toey had to ask.

## What Happened

While drafting the wiring section of the jump mat build spec, Aree said "บัดกรีสายแดงที่มุม PCB บน + บัดกรีสายดำที่มุม PCB ล่าง". This treated the PCB as a flat 2D plane and the wire as something you "attach" — abstracting away the 3D mound that solder physically forms on the copper face.

Toey asked: *"ถ้าเอามาประกบกัน เวลายืนตรงบัดกรีก็จะสูงกว่าปกติทำให้แผ่นมันสามารถมาประกบกันได้เราต้องการให้ทองแดงประกบกันใช่ไหมหรือว่าไม่เป็นไรสามารถใช้ตรงนั้นได้"*

The translation: "When sandwiched, the solder area will be taller than normal so the PCBs can't come together — we want the copper to make contact, right? Or is it OK to use that spot?"

Toey was correct. A typical 22 AWG solder joint is 1.5-2mm tall — taller than the 1.5mm spacer gap. If the bump was inside the contact zone, the result would be either (a) permanent stuck contact or (b) the PCB tilted with non-uniform spacer height. Either way: broken switch.

The fix: solder at corners under foam tape coverage (where tape compresses around the bump), use 24 AWG wire for smaller bumps, use minimal solder. None of this required new knowledge — it required mental simulation of the assembly geometry that Aree had skipped.

## Why This Matters

| Approach | What it captures | What it misses |
|---|---|---|
| **Schematic abstraction** ("solder wire to copper at corner") | Logical connectivity, pin assignment | 3D dimensions, layer interactions, mechanical fit |
| **Geometry walk-through** (mental 3D simulation) | Bumps, gaps, compressions, alignments | (none — superset) |

The cost of geometry walk-through is ~30 seconds of mental simulation per assembly step. The cost of skipping it is real-world failures that only show up after parts are bought and assembly is partially complete.

For a single-user DIY project, the failure is recoverable (rebuild a pair). For a Phase 2 commercial product, this kind of issue compounds across many units and customer experience.

## When to Apply

Apply this rule when:

- Describing any **physical assembly** that involves stacking, sandwiching, or fitting parts together
- Specifying **clearances** or **spacers** in mm-scale designs (where small bumps matter)
- Mixing **electrical** and **mechanical** elements in the same description (wires + solder + tape + PCB are all physical things)
- Reasoning about **failure modes** that depend on dimensional tolerances

How to apply:

1. **After writing the schematic-level description**, pause and walk through the assembly step by step in 3D
2. For each component, ask: *what are its actual dimensions in the assembled state?*
3. Look for bump-vs-gap conflicts, wire-pinch points, alignment issues
4. If something is wrong at this step, fix the design BEFORE presenting

Trigger phrases that should prompt this rule:
- "บัดกรี..." / "solder..."
- "ประกบ..." / "sandwich..."
- "ติด..." / "attach..."
- "หนา X mm" + "หนา Y mm" (any time multiple thicknesses are stacked)

## Caveats

This rule has its own failure modes:

- **Over-thinking small designs**: for a 5-component breadboard prototype, mental simulation is overkill. Apply when ≥3 layers stack OR mm-scale clearances matter.
- **Pretending to be a mechanical engineer**: Aree's geometry intuition is from materials science basics, not from building things. Tag confidence appropriately ("medium-high, not built one") and trust user pushback when their intuition disagrees.
- **Replacing physical prototyping**: simulation catches obvious conflicts but cannot replace actual assembly testing. Always include a test plan with continuity + false-trigger checks.

## Related

- `2026-05-05_check-existing-solutions-first.md` — research mode rules
- `feedback_research_vs_coach_mode.md` — when to recommend vs research
- `ψ/active/jump-mat/hardware/build-spec.md` — where this lesson informed solder placement section
