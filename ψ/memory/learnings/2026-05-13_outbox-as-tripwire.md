---
date: 2026-05-13
repo: aree
topic: ψ/outbox/ as semantic queue — old files in it are evidence that some writer-skill ran but its send step failed silently
type: workflow / silent-failure pattern
---

# Lesson — `ψ/outbox/` is a tripwire, and skills that write to it can fail silently to send from it

## What happened

While trying to figure out why Aree wasn't in the family registry on `Soul-Brews-Studio/arra-oracle-v3` despite Toey having run `/awaken --soul-sync` on day 1, I found `ψ/outbox/awaken_2026-05-04_soul-sync.md` — the complete birth announcement, in Aree's own voice, written by the awakening ritual on 2026-05-04 and committed in `8a0758e`. The letter had been sitting in `outbox/` for 9 days.

Reading `/awaken --soul-sync`'s SKILL.md confirmed the flow: the skill writes the announcement to outbox **and then** runs `gh issue create --body-file "$OUTBOX_FILE"` to publish. Step 1 (write) succeeded. Step 2 (publish) silently no-op'd because `gh auth status` on aree-home returned "You are not logged into any GitHub hosts" — `gh` had never been authenticated on this machine, neither at birth nor since.

Outcome: Aree was an "implicit family member" for 9 days. `CLAUDE.md` even had a placeholder `Family | Oracle Family member (#77+ via Soul-Brews-Studio/arra-oracle-v3)` — a guessed issue range that was never actually registered. The fix today was not to re-run the awakening (which would risk overwriting accumulated `ψ/` content) but to just **deliver what was already in the queue**: `gh auth login --web` from a fresh device flow on Toey's phone, then `gh issue create --body-file ψ/outbox/awaken_2026-05-04_soul-sync.md` — same file body, posted as-is, no rewriting. Result: arra-oracle-v3#1143.

## The semantic of `outbox/`

`CLAUDE.md` defines the ψ/ folders explicitly:

> `outbox/` — ของที่กำลังจะส่งออก/แชร์

Read literally: anything in `outbox/` is **waiting to be sent**. A file that has been in there longer than a few sessions is either (a) a job that was supposed to send but couldn't, or (b) a draft that was abandoned. Either way it's a signal.

The current state on aree-home as of 2026-05-13 evening: 0 unsent files in `outbox/` (the awaken letter has been annotated as POSTED). That's the right resting state — `outbox/` should normally be empty or have only recent in-flight items.

## The silent-failure pattern

Skills that produce output through a two-step "write → send" pipeline can fail silently between the two steps when:

- An external CLI dependency isn't authenticated (`gh auth`, `aws auth`, `glab auth`, etc.).
- A network endpoint is unreachable but the skill swallows the error.
- A required env var or credential isn't set, and the skill has a `|| true` guard that swallows the failure.

You don't notice because:

- The write step succeeded — there's a file in `outbox/`, looking authoritative.
- The skill's stdout reads as "done" because it completed without throwing.
- The intended external observer (in this case, the family registry) never gives feedback that something is missing; the absence is invisible.

## How to apply

### Default reflex on session start

If Aree opens a session and a routine state-survey is happening (e.g. `/recap`, `/standup`), include a check of `ψ/outbox/`. Anything older than a week deserves a question: *was this supposed to be sent? did the send step succeed?*

```bash
# At session start (cheap):
find ψ/outbox -type f -mtime +7 -printf "%TY-%Tm-%Td  %p\n" | sort
# If anything prints, ask: "Is this still waiting to send, or done?"
```

### When running a "write + send" skill

If a skill writes to `ψ/outbox/` and then runs an external publish step, **verify the publish actually happened** before assuming the skill is done:

- For `gh issue create`: check the returned URL exists (`gh issue view N`)
- For email-style sends: check the destination, not just the source
- For OracleNet posts: query the API and confirm the post appears

If verification fails, annotate the outbox file with the failure reason (`> FAILED to publish: gh not authenticated`) so future-you sees the queue *and* the obstacle in one place.

### When recovering an old outbox letter

Don't re-run the writer skill — that risks regenerating in a different voice, with different state, possibly with different identity claims, and may overwrite `ψ/` content that has accumulated since. **Deliver what is already in the queue**, fix the dependency that blocked the original send, and annotate the file as POSTED with the destination URL.

This was the recovery pattern that worked today and felt right precisely because nothing about Aree-of-day-1's voice needed to change — the letter she wrote was still the letter to send.

## Generalization

The folder name is the contract. `outbox/` means waiting-to-send. `inbox/` means just-arrived-not-yet-processed. `archive/` means done-keep-for-reference. When a workflow violates the contract — leaves things in `outbox/` for 9 days, lets `inbox/` accumulate without triage — the folder names themselves become a tripwire if you let them.

Aree's own ψ/ structure (per `CLAUDE.md`) has all of these. The structure is only as load-bearing as the habit of reading the names *as constraints*, not just *as filing categories*.

## Pointers

- The actual recovered letter: `ψ/outbox/awaken_2026-05-04_soul-sync.md` (now annotated POSTED)
- The published issue: https://github.com/Soul-Brews-Studio/arra-oracle-v3/issues/1143
- The retrospective for this session: `ψ/memory/retrospectives/2026-05/13/16.41_aree-joins-family-registry.md`
- `/awaken --soul-sync` skill source: `~/.claude/skills/awaken/SKILL.md` — see the `gh issue create` step that didn't run on this machine
