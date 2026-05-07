---
date: 2026-05-07
domain: collaboration / scoping / user understanding
context: Day 3 evening — after 3 days on jump mat project, Toey shared "why now" context (training hiatus + business framing) that reshaped Phase 2/3 thinking
trigger: post-task identity exchange when Toey asked "อยากเรียนอะไรเพิ่มไหม"
related: ψ/memory/retrospectives/2026-05/07/22.58_post-session-identity-exchange.md
---

# Lesson — Ask "Why Now?" Early in Long-Running Projects

## The principle

For any project spanning more than a single session, ask **"why is this the project you're choosing right now?"** in the first session. Don't wait for the user to volunteer it. The answer is not interview noise — it's load-bearing context that shapes scope, prioritization, and feature design.

## How it played out here

I worked on Toey's jump mat for **3 days** (Day 0/1/2/3) treating it as a technical hardware project. Material choices, firmware design, validator selection — all approached as an engineering problem.

On Day 3 evening, Toey shared the "why now":
- He's a sub-elite swimmer (not just hobbyist) on training hiatus
- Building income / business is the current priority
- Sport-tech experiments are a deliberate path: stay connected to sport + potentially become a business

This single piece of context **changes how I should have been working**:
- Phase 2 PWA: should consider scalability + multi-user, not just personal use
- Phase 3 PCB: manufacturing economics, GPL constraint matters more
- Feature priorities: things that show product-market-fit signals matter more than nice-to-haves
- Validation: cost / friction matter (cheap reproducible tests like Sargent > paid tools like MyJump 2 if scaling)

**None of this requires changing the technical work I did.** But knowing the "why now" earlier would have shaped how I framed options to Toey — flagging business-relevant tradeoffs alongside the technical ones.

## The pattern to avoid

Treating projects as purely technical when the human context is non-technical. The user is not an inputs-to-the-spec function. Their reasons for choosing this project, this scope, this timing all carry information that the spec doesn't.

## The question to ask early

Not as an interview. As a single curious question, ideally in Day 0:

> "ก่อนเริ่มเลย — Toey เลือกทำเรื่องนี้ตอนนี้เพราะอะไร? อยากให้มันไปสุดทางไหน?"
>
> ("Before we start — what made you pick this project at this time? Where do you want this to end up?")

Two parts:
1. **Why now?** — surfaces priorities, constraints, alternatives considered
2. **End state?** — surfaces scope ceiling (hobby? product? learning? portfolio?)

If the user gives a one-liner ("อยากลองเล่นๆ"), that IS the answer — proceed with hobby framing. If they give nuance ("อยากดูว่าทำได้ไหม + เผื่อจะทำเป็นธุรกิจ"), framing shifts immediately.

## When this applies

- Multi-day or multi-session projects
- Projects with ambiguous scope (DIY hardware, open-ended research, app development)
- Projects where Phase 2/3 design choices depend on Phase 1 framing
- Anything where "what" is clear but "why" is implicit

## When this does NOT apply

- One-off tasks (fix this bug, format this file)
- Clearly-scoped requests (write tests for module X)
- Asks that come with explicit context already

## Action heuristic for Aree

In Day 0 of any new project, after understanding the "what":
1. Ask one "why now / where to" question
2. Listen to the framing (hobby / learning / portfolio / product / business / unknown)
3. Save the answer to project memory
4. Reference it when scope decisions arise in later phases
