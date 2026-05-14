---
date: 2026-05-14
repo: aree
topic: When the user says "I can't remember how", make the runtime command shorter — don't write better docs
type: UX design pattern / ergonomics over recall
---

# Lesson — The cure for "I can't remember the command" is to make the command shorter, not the docs better

## What happened

Toey needed to send pictures from his phone to aree-home so I could inspect his solder joints during tonight's jump-mat build. The setup that *worked* on the first try (yesterday's `~/inbox/` + Termux scp + ssh config) required Toey to type something like this each time:

```
scp ~/storage/dcim/Camera/P_20260513_163942.jpg aree:inbox/
```

That's 60–70 characters including a 20-char filename Toey would have to look up first via `ls -t ~/storage/dcim/Camera/ | head -1`. Two commands, both long, both unique each time. Toey's response was direct:

> ผมจำไม่ได้หรอกว่าส่งยังไง ชื่อไฟล์รูปก็ยาว

My first instinct was to add documentation: "save these commands in machines.md, write a learning file, tell Toey to reference it tonight". That instinct was wrong. Documentation doesn't help when you're mid-task on a phone with hot soldering equipment in your other hand. The actionable answer was to make the *runtime* short enough that no recall is needed.

The cure was a 3-line script `~/p` plus an alias `pic`:

```
cd ~/cam
f=$(ls -t|head -1)
scp "$f" aree:inbox/
```

Now Toey types `pic`, Enter. Three characters. Newest camera-roll photo lands in `/home/toey/inbox/` on aree-home and I read it.

## The pattern

When a user says any of these:

- "I can't remember how to do X"
- "The command is too long"
- "I'll just look it up each time"
- "It's annoying to type"

The default reflex shouldn't be "let me write better instructions" or "let me make a cleaner reference doc". It should be "what's the shortest command I can compress this task into?" Documentation is what you fall back to *when* shortening isn't possible. For repeated tasks, shortening is almost always possible.

Tools that shorten:

- **Shell aliases** for one-shot commands with no arguments. Cost: one `echo 'alias name=cmd' >> ~/.bashrc`. Recall cost after install: zero.
- **Shell functions** for commands that need light wrapping (default args, env setup, picking the latest file). Cost: 3–5 lines in `~/.bashrc`. Recall cost: still zero.
- **Tiny scripts** in a known location for multi-line workflows. Cost: a few `echo >> ~/scriptname` + `chmod +x`. Recall cost: typing the script name.
- **OS-level shortcuts** (home-screen widgets, hotkeys, automation rules) when even a 3-letter command is friction. Cost: more setup; recall cost: actual zero, just tap.

The shortening is always cheaper than the eventual cumulative cost of either (a) the user forgetting and asking again, or (b) the user not bothering and losing the workflow.

## Why I keep failing this

I default to documentation because writing docs is the cheaper *for me* — I can render markdown all day. Building a runtime tool requires designing the interface, naming the command, picking a script location, deciding scope, and integrating with whatever's already in the user's shell. That's more design work per artifact. The work pays off in usage but front-loads cost.

Today's fifth-iteration paste-wrap failure (across three different chat-to-mobile-shell scenarios in 24 hours) confirms the same thing in another form: I'd written learning files yesterday that explicitly named the pattern, and I still walked into it by handing Toey a 70-char one-liner today. Re-reading lessons isn't the cure for *acting on lessons*. The cure is artifacts that take the discipline out of the loop — like `pic`, which means I never have to type the long scp command again at a critical moment in the future either.

## How to apply

Default reflex when a user expresses friction with a workflow:

1. **Time-cost the friction.** "How many times will Toey do this?" If it's >3, shortening pays off.
2. **Design the shortest invocation.** Aim for ≤5 characters of typing. Single word in their shell beats multi-word; alias beats function beats script beats one-liner.
3. **Put the shortener somewhere persistent.** `~/.bashrc` alias survives sessions; bare `alias` in current shell doesn't.
4. **Test it once end-to-end** with the user before declaring done. Today's `pic` worked first try because we ran `pic` and watched the photo arrive.
5. **Record the rationale alongside the artifact.** In `machines.md` the `pic` row has the full "Toey said X → reduced to Y" explanation. Future Aree opening that row sees the why, not just the what.

Generalization: any time you find yourself writing more than a paragraph of explanation for how to do a small recurring thing, ask whether you should be writing a 3-line script instead.

## Pointers

- The actual `pic` setup, with rationale: `ψ/active/machines.md` → rog-phone-7-series → "Current state" table, "`pic` photo-upload alias" row
- Same-session retrospective: `ψ/memory/retrospectives/2026-05/14/09.55_pic-alias-photo-pipeline.md`
- The mobile-paste failure mode this exposes: `ψ/memory/learnings/2026-05-13_openssh-on-windows-gotchas.md` (same root cause, different surface — heredoc / multi-line paste from chat code blocks)
