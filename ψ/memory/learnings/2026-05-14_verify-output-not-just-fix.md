---
date: 2026-05-14
repo: aree
topic: "Fixed" means the system produces its intended output, not just that the visible symptoms went away
type: completion-criteria / verification anti-pattern
---

# Lesson — Define "fixed" in terms of the work output, then verify *that* before declaring done

## What happened

At 13:43 I wrote a retro for the trade-bot debug session claiming the work was done. Three bugs were committed and deployed:

1. `DRY_RUN` config mismatch — fixed by restart
2. `supertrend()` ValueError on empty data — fixed by commit `be1842a`
3. systemd `Restart=on-failure` couldn't catch "alive but broken" — fixed by external watchdog

All three symptoms I'd seen in the diagnostic phase were gone. The bot was ticking healthily. The retro's "next steps" said "wait for first signal.bar at 14:00 to confirm strategy evaluation is back." I treated that as routine confirmation and moved on.

At 14:00 Toey checked: no `signal.bar` event. The bot was *still* not doing the work it existed to do. The actual root cause was bug #4 — Binance Testnet retains only ~183 bars of 1h klines, while the strategy needs 200 for EMA200. None of the three fixes I'd committed touched this. The bot was technically fixed at the symptom layer and still functionally broken at the work-output layer.

The fix for bug #4 was committed as `dd20207` (hybrid `data_client` always pointing at mainnet OHLCV while `client` stays on testnet for orders). Deploy + restart, first `signal.bar` fired within seconds of the next tick.

## The pattern

Every time today and yesterday I've claimed "done" for a bug fix, the failure mode has been the same: I stopped at the layer where the *visible symptom* of the bug went away, without verifying that the *deeper symptom* (the system producing its intended output) had also resolved.

| Slice | Visible-symptom layer I stopped at | Work-output layer I missed |
|-------|------------------------------------|----------------------------|
| Termius Thai render bug (yesterday morning) | inputrc loaded → readline state correct | Thai still garbled on phone — wrong device, wrong layer entirely |
| OpenSSH on RDLT (yesterday evening) | port 22 open + handshake works | Username was wrong (`toey` vs `toey0`); auth kept failing |
| Trade-bot bugs 1-3 (today afternoon) | DRY_RUN flipped, supertrend guarded, watchdog installed | No `signal.bar` events because testnet kline data insufficient |

Three consecutive failures of the same shape. Each time the surface fix was correct but insufficient. Each time it took a Toey-side verification ("เป็นเฉพาะโทรศัพท์ครับ" / "Invalid user toey" / "14.00 แล้วครับ") to reveal the layer underneath.

## Why I keep doing it

Honest diagnosis: declaring "done" at the symptom-removal layer is *easier on my context*. The fix shipped, the commit landed, the retro can be written, the conversation can move on. Verifying the work-output layer requires either waiting (which kills momentum) or running an isolated test against the deepest layer of the system (which costs design effort to figure out *what* to test). I keep choosing the cheap-now option and paying the cost when the user catches the gap.

The cure isn't more discipline-in-the-moment. The cure is to make the verification cheap enough that I default to it. Two reusable shapes:

## How to apply

### Shape 1 — Define the system's work-output before declaring done

For any system being fixed, name the *unit of work it produces*. Then declare "done" in terms of *one new unit produced after the fix*.

- Trade-bot: unit of work is a `signal.bar` event per hour. "Fixed" = a fresh `signal.bar` appears within the next hour after restart.
- SSH login: unit of work is a successful `ssh user@host` command returning a shell prompt. "Fixed" = one fresh non-error login after the auth setup.
- Termux Thai input: unit of work is typing Thai and seeing it render correctly. "Fixed" = Toey types a Thai phrase and sends a screenshot of correct rendering.

Without this definition, "fixed" is implicit and slips down to whatever symptom was easiest to remove.

### Shape 2 — Test the deepest layer in isolation

For any bug investigation, run the deepest layer that produces inputs to the visible-bug area, IN ISOLATION, before assuming upstream layers are correct.

Today's example: I should have run `Exchange().fetch_closed_ohlcv("BTC/USDT", "1h", 500)` from a server Python shell *before* assuming the bot would start working after my code changes. Two lines of Python would have shown `df_1h=183 bars` immediately, and the testnet-kline issue would have been visible 30 minutes earlier.

The cost of running the isolated test: tiny. The cost of skipping it: I wrote a wrong retro at 13:43, Toey had to do verification work I should have done, the conversation had to circle back to undo a "done" claim. Net cost: ~30 minutes of work plus the credibility hit of a retracted claim.

## The retro-discipline corollary

Writing a retro is *itself* a "declaring done" action. Retros should not be written at the moment a fix is shipped — they should be written at the moment the fix has been *observed* to do its job. Today's `13.43_trade-bot-alive-but-broken.md` retro was written before the work-output had been verified once. That retro now reads slightly hollow in retrospect — its claims are technically true but its "next steps" turn out to have been the actual work.

Going forward: a retro is allowed only after at least one work-unit has been observed post-fix. Otherwise it's an interim status note, and should be marked as such.

## Pointers

- The case that surfaced this lesson: `ψ/memory/retrospectives/2026-05/14/14.23_testnet-kline-scarcity-hybrid-fix.md`
- The premature retro that triggered the reflection: `ψ/memory/retrospectives/2026-05/14/13.43_trade-bot-alive-but-broken.md`
- Two prior cousins of this lesson (same anti-pattern, different surfaces):
  - `ψ/memory/learnings/2026-05-13_ask-where-before-what.md` (anchored on most-recent commit instead of asking which device)
  - `ψ/memory/learnings/2026-05-14_alive-but-broken-liveness-checks.md` (process-level liveness ≠ work-level liveness)
- The work-output unit for trade-bot is `signal.bar`. The work-output watchdog (`/usr/local/bin/trade-bot-watchdog.sh` on cloud134984) embodies this lesson — it restarts the bot if no work-output event in 90 min, regardless of whether the process appears alive.
