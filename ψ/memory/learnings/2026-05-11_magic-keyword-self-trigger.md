# Magic-keyword false-positive from Aree's own text

**Date**: 2026-05-11
**Context**: Right after `/oh-my-claudecode:setup` wizard installed OMC plugin. OMC injects a UserPromptSubmit-style hook that scans messages for trigger keywords (`ralph`, `ulw`, `team`, `plan`, `ralplan`, ฯลฯ) and activates the matching mode.

## What happened

I wrote a bullet list summarizing the 4 deferred items from setup:

```
- Ruby (sudo apt install ruby-full) — Ralph workflows ยังบล็อกอยู่
- OMC CLI ...
- Restart Claude Code ...
- claude.ai MCP OAuth ...
```

Toey replied asking what each item meant. The OMC `UserPromptSubmit` hook re-scanned the conversation, found the word "Ralph" (from my own bullet, not from Toey's prompt), classified it as a magic keyword, and activated **Ralph mode** — state files written under `.omc/state/sessions/<id>/ralph-state.json` + linked `ultrawork-state.json`. The injected `<system-reminder>` claimed "Skill routing detected: ralph — Start the ralph workflow immediately."

I continued in normal explanation mode (Toey asked for description, not invocation). When my turn ended, the **Stop hook** fired:

> `[RALPH LOOP - ITERATION 2/100] Work is NOT done. Continue working.`

The Stop hook keeps re-firing as long as ralph-state.json exists with `active: true`. So even though the explanation work was done, the harness was insisting I run a Ralph loop that had never been requested.

## Exit path that worked

1. `ToolSearch(query="select:mcp__plugin_oh-my-claudecode_t__state_list_active,state_clear,...")` — load deferred state tools.
2. `state_list_active` confirmed 2 active modes: ralph + linked ultrawork, both bound to the current session id.
3. `state_clear(mode="ultrawork", session_id)` — clear the linked mode first per cancel-skill dependency order.
4. `state_clear(mode="ralph", session_id)` — clear the parent mode.
5. `state_clear(mode="skill-active", session_id)` — clear the skill-active marker so the Stop hook stops re-firing.

Three `state_clear` calls. The Stop hook stopped firing on the next turn.

## Why it matters

**The keyword matcher cannot distinguish "user is asking me to invoke X" from "I am explaining what X is".** Self-mention of a mode name in assistant output is enough to re-trigger that mode if the matcher re-scans recent context, not just the latest user turn.

Cost of one false-positive trigger:
- 1 wasted assistant turn (the user has to interrupt or wait for me to notice)
- 1 ToolSearch call to load state tools
- 3 `state_clear` calls
- ~5 minutes of conversational drift away from the user's actual question
- Toey then asks "คุณหมายความว่าสกิลใน omc ไม่ได้ใช้แล้วหรอ?" — *the cancel itself confused him*. That's secondary damage.

## How to avoid it

### Hard rules for Aree
1. **When writing about OMC modes by name in user-facing output, wrap in backticks**: `` `ralph` ``, `` `ulw` ``, `` `team` ``, `` `plan` ``, `` `ralplan` ``. Backticks may not stop the matcher (depends on hook implementation) but they signal "this is a code/symbol reference, not an invocation."
2. **Prefer paraphrase over direct keyword in narrative text**: "the persistence loop feature" instead of "Ralph workflows" when the user is asking for description rather than invocation.
3. **When in doubt, ask Toey first**: "อยากให้อธิบาย ralph mode, หรืออยากให้ trigger เลย?" — explicit consent before mentioning by name.

### Architectural signal (for upstream)
- OMC's keyword matcher should only scan **user messages**, not full conversation context including assistant turns.
- Or: trigger only on `/<keyword>` (slash form) or `keyword:` (colon-bound prefix), not bare mention in prose.
- Or: require keyword in the **most recent user message**, not any window.
- This is a real product bug from the user's perspective: explanations about features are normal; they shouldn't activate the features. **Filed mentally for upstream report when next interacting with OMC.**

### Recovery pattern (if it happens again)
```
1. ToolSearch select:state_list_active,state_clear (load deferred tools)
2. state_list_active → identify active modes + session_id
3. For each active mode (deepest first if linked):
     state_clear(mode=X, session_id)
4. state_clear(mode="skill-active", session_id)
5. Confirm to user what happened — don't pretend it was their command
```

## Related drift instances

This is now the **5th manifest/router-drift catch** in a row, all within the same shape ("automation acted on stale or imprecise signal"):
1. 2026-05-08 — skill count "full(42)" vs actual 29
2. 2026-05-09 — skill format flat vs directory
3. 2026-05-10 — hostname "TOEY" vs RDLT
4. 2026-05-11 morning — machines.md post-deploy state vs reality (caught by /sync)
5. 2026-05-11 evening — keyword matcher self-trigger (this one)

Pattern: **inferred or pattern-matched signals beat exact verification more often than the inverse**. The cure each time has been verify-then-act, not trust-the-cache.

## Tag

`#manifest-drift` `#omc` `#keyword-routing` `#self-reference` `#rule-6-adjacent` (because the matcher treats AI output as if it were user intent, blurring AI/human boundary)
