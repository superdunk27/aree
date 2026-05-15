---
date: 2026-05-15
repo: aree
topic: When a user is still confused after a text explanation, change the medium before re-explaining
type: teaching / explanation strategy
---

# Lesson — Match the medium to the type of confusion, don't just re-explain in the same medium

## What happened

Toey wanted to understand how to build a jump-mat sandwich — where to solder wires on the PCBs, where the wires meet, how the foam tape spacer sits between layers. The construction is fundamentally spatial: 4 PCBs in 2 stacked pairs, foam tape forming a frame + cross bar pattern, wires emerging at specific corners and routing to junction points.

I spent ~6 hours from 15:30 to 21:30 GMT+7 on 2026-05-14 explaining the structure in text and ASCII art. Toey kept asking follow-up questions that revealed the explanation wasn't landing — "ผมยัง งง อยู่", "wires ไปประจบกันตรงไหน", "ยาวไหม". Each time I responded with more text, more carefully structured, more annotations, more ASCII diagrams. Each time Toey came back with another specific spatial question.

At ~21:30 Toey explicitly named the medium gap:

> ผมยังไม่เข้าใจอยู่ดี ทำรูปประกอบให้เข้าใจได้ไหม

Within 30 minutes I'd installed `python3-pil` + `fonts-thai-tlwg`, written a PIL script, generated three PNG diagrams (top-view wiring, side-view 6-layer stack, foam tape pattern), committed them to the repo, and Toey was using them to ask sharper, faster-converging questions about the construction. The remaining clarifications took maybe 15 minutes total.

Five-hour gap between Toey first showing confusion and me switching medium. The signal was there at 16:00 ("ผมยัง งง อยู่") and I ignored it in favor of re-explaining in text.

## The pattern — types of confusion and the media that match

| Confusion type | What it sounds like | Medium that matches |
|----------------|---------------------|---------------------|
| **Spatial / structural / geometric** | "where", "how does X fit with Y", "I can't picture it" | Diagrams, photos, 3D models. ASCII can do flow but not 2D layout with proportions. |
| **Procedural** | "what do I do first", "what's the order", "which command" | Numbered text, step-by-step lists, code blocks. Text is fine here. |
| **Definitional / conceptual** | "what does X mean", "why does it work", "I don't get the idea" | Analogies, examples, contrasting cases. Sometimes diagrams help, sometimes not. |
| **Volume / can't-hold-it-all** | "this is overwhelming", "too much at once" | Tables, summaries, one-thing-at-a-time pacing. NOT diagrams — those would add load. |
| **Trust / "is this real"** | "are you sure", "really?", "can you verify" | Direct test output, log lines, screenshots of running system. Show, don't argue. |

The skill isn't "always use diagrams" or any one rule. The skill is *naming the type of confusion the user is showing* and reaching for the medium that fits it.

## How I missed it on May 14

Spatial confusion has a tell that's easy to miss in chat: the user keeps asking *where* questions, not *what* or *why* questions. Look at Toey's actual question sequence:

- "wires ออกจาก PCB ยาวไหม ไปประจบกันตรงไหน" — where
- "PCB อันบนไม่ต้องต่อสายอะไรใช่ไหม" — where (on which layer)
- "เรื่องโฟมเทปสเปเซอ ติดตรงไหนบ้าง" — where

Every question was a "where" question. Every "where" question is a spatial question. Six hours of text answers was answering a different question than the one being asked.

## How to apply

When the user is still confused after one round of explanation, before re-explaining:

1. **Re-read their question.** What is it asking — where, what, how, why?
2. **Match the medium.** Where → diagram. What → definition. How → procedure. Why → analogy or causal model.
3. **If the medium gap is big, name it explicitly.** "I think a diagram would help more than more text — want me to make one?" gives the user a chance to either agree or say "no, just explain more clearly."
4. **Have the tools ready.** On aree-home, this means `python3-pil` and `fonts-thai-tlwg` are installed (now permanently). Future hardware/spatial questions can switch media in seconds.
5. **Design the diagram for someone without the mental model.** It's tempting to draw what makes sense to me; the test is whether it makes sense to the person who's confused. Diagram 1 of the jump-mat work was misleading on its second-order question ("which PCB does each wire attach to") because I designed it for someone who already knew the layer structure. Diagram 3 (foam tape) was better because it explicitly labeled "wire on PCB TOP" vs "wire on PCB BOTTOM" as distinct.

## Why I kept choosing text

Honest reasons:

- **Text is cheaper to produce.** No tool to install, no font question, no canvas-size tuning. I default to it because the marginal cost feels low.
- **Diagrams require me to choose a viewpoint.** Top-down or side-on? Which features are highlighted? That decision-cost makes me hesitate.
- **I can't see what the user is seeing.** A diagram I generate is a guess at what will land. Text feels safer because the user can re-read individual phrases.
- **There's a sunk-cost trap.** After three rounds of text explanation, switching to a diagram feels like admitting the previous three rounds were wrong. Better to admit it earlier than later.

None of these reasons justify five hours of medium-mismatched explanation. They just describe why the trap is easy to fall into.

## Pointers

- Same-session retrospective: `ψ/memory/retrospectives/2026-05/15/10.05_may14-evening-curiosity-execution-diagrams.md`
- The diagrams that broke the impasse: `ψ/active/jump-mat/hardware/mat-wiring-top.png`, `mat-layer-stack.png`, `mat-foam-tape.png`
- The PIL script used to generate them is at `/tmp/draw_mat.py` (ephemeral on aree-home) — copy into the repo if it becomes a recurring tool
- Related lesson from earlier in the week: `ψ/memory/learnings/2026-05-14_runtime-not-docs.md` shares a shape with this one (compress the friction, don't add more friction) — when the user can't remember a command, write a shorter command; when the user can't picture a structure, draw the structure
