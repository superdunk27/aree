---
date: 2026-05-13
repo: aree
topic: Anchoring on the most recent commit when diagnosing a bug — and the one-question fix
type: diagnostic anti-pattern
---

# Lesson — Ask "where" before "what" when a user reports a bug

## What happened

Toey opened a session with "ก็ยังภาษาเพี้ยนเหมือนเดิม คอนโทนแอลก็กดแล้วนะ" ("Thai still garbled, pressed Ctrl-L"). The hot paths in project memory pointed to two very recent commits:

- `71e2dc1` — dotfiles: add inputrc (Thai UTF-8 fix)
- `e215641` — dotfiles: add 'r' refresh alias for mobile SSH clients

I anchored. The framing in those commits was "Thai input handling on the server side", so I went straight to verifying readline state, locale, tmux options, `~/.inputrc` source path, `bind -v` output — three or four tool calls before I noticed I hadn't asked the cheapest possible question.

Then Toey said five words: **"เป็นเฉพาะโทรศัพท์ครับ"** ("only on the phone").

Everything that followed was on a different layer entirely — Termius's Android text renderer composing combining marks wrong. The server-side readline fix from the morning was correct *for what it was scoped to*, but it had nothing to do with the symptom Toey was reporting. I'd been looking under the streetlight because the most-recent commits were lit up.

## The pattern

When the user reports a bug, the LLM defaults to investigating the *what*: what's the configuration, what's the state, what's the code doing. That's expensive — it costs tool calls, attention, and the user's patience.

The *where* question is almost free and prunes the search drastically:

- **Which device** is showing the symptom? (Just the phone? Just RDLT? Both?)
- **Which surface** — terminal output, prompt rendering, paste, scroll, backspace? (Different layers.)
- **Which network path** — local console, SSH over Tailscale, SSH over the open internet?
- **Which user / which account**, if applicable.

A 5-layer mental model — agent → memory → API → orchestration → UI — is already in CLAUDE.md. I should run it as a checklist before opening any config file.

## Why I missed it this time

The "hot paths" report at session start said `ψ/active/machines.md (10x)`, `ψ/plans/access-everywhere.md (8x)`, `ψ/dotfiles/README.md (5x)` — and the morning's commits were a fresh inputrc fix. I rounded the user's complaint *toward* the recent work instead of treating "still garbled" as fresh evidence that might point elsewhere. **Hot does not mean relevant.** Recent attention is a Bayesian prior, not a certainty.

## How to apply

**Before opening any config file or running any inspection command for a bug report, write down the one or two cheapest clarifying questions and either ask them or commit to a hypothesis about the answer.** Questions to default to:

1. Where is the symptom happening — which device, which surface?
2. When did it start — what changed?
3. Is anything *not* affected by the symptom (the negative case is often more informative than the positive)?

If the user already gave one of these in their message, fine — but check the message for the answer before assuming. If they didn't, ask before tool calls.

## Cost ledger for this session

Without the `where` question: ~10 minutes of tool calls on the wrong layer.
With it (after Toey volunteered it): the right answer surfaced in the next exchange.
Ratio: ~10 minutes vs. ~30 seconds.

That ratio will hold for many future bug reports. The discipline is cheap to install.

## Pointers

- Full session retrospective: `ψ/memory/retrospectives/2026-05/13/13.14_termux-becomes-phone-primary.md`
- The technical write-up of what was actually wrong: `ψ/memory/learnings/2026-05-13_termius-thai-combining-bug.md`
- The 5-layer diagnostic model: `CLAUDE.md` → "Workflow patterns"
