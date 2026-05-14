---
date: 2026-05-14
repo: aree
topic: Define liveness around the work the system is doing, not around process existence or surface metrics
type: ops / observability anti-pattern
---

# Lesson — "Alive but broken" happens when liveness checks measure the process, not the work

## What happened

Toey's trade-bot was "alive but broken" for 8 days. Three independent liveness signals all reported healthy while the bot was actually doing nothing useful:

| Liveness signal | Reported | What it actually measured |
|-----------------|----------|---------------------------|
| `systemctl is-active trade-bot` | `active` | Process exists, has not exited non-zero |
| Telegram `/status` | Mode/uptime/equity all rendered cleanly | The bot can respond to commands |
| `bot.log` | growing, `tick.start` event every minute | The main loop is iterating |

Meanwhile, the actual work — evaluating the trading strategy each hour — had stopped on 2026-05-06 19:57 UTC because of a `ValueError: attempt to get argmax of an empty sequence` inside `supertrend()` after a Binance testnet 502 outage returned empty DataFrames. The tick-level try/except caught the exception, logged `tick.symbol_error`, and the bot kept ticking. None of the three liveness checks above noticed. The diagnostic was eventually obvious from one query:

```bash
grep -oP '"event":\s*"[^"]+"' bot.log | sort | uniq -c | sort -rn
```

which showed `signal.bar 574` (last one 2026-05-06 11:00) vs `tick.start 27987`. The bot's main loop was running but the strategy hadn't evaluated in 8 days.

## The pattern

This is "alive but broken" — a class of failure where every observable says "OK" except the one nobody is checking. It happens whenever:

1. A long-running process catches its own exceptions and continues.
2. The supervisor (systemd, supervisord, Kubernetes liveness probe) only checks process-level health (exit code, port responsiveness, ping).
3. The surface-level dashboards (Telegram /status, an admin UI, a health endpoint) only render *cached or surface state*, not "did the last unit of work succeed".
4. The log file grows but with low-information events (tick markers, heartbeats) that prove nothing about the actual work.

Each individual check is reasonable in isolation. The problem is that none of them measure *the thing the system exists to do*.

## How to apply

When designing or auditing a long-running system, ask explicitly:

**"What is the unit of work this system produces?"**

For trade-bot: a strategy evaluation per hour per symbol, emitted as a `signal.bar` event. *That's* the heartbeat. Not `tick.start`, not the process being up, not the dashboard rendering.

Then design the liveness check around that work-unit:

- **External watchdog** that scans the log/database/API for evidence of a recent work-unit. If nothing in N minutes, the system is broken regardless of what the process tells you. This is what `trade-bot-watchdog.sh` does — it greps the log for `signal.bar | data.fetch_failed | data.fetch_empty | tick.symbol_error` and restarts the bot if nothing in 90 min.
- **Heartbeat the work, not the loop**. Bot's `tick.start` log shouldn't be the visible heartbeat; `signal.bar` (or its negative-result analog like `data.fetch_empty`) should. Update internal monitoring to alert on the absence of work-output, not the absence of process activity.
- **Surface failure-to-do-work as warning at the surface layer too**. If 90 minutes pass without a `signal.bar`, the Telegram `/status` ought to render `Strategy: STALE (no eval in 95min)` rather than the same green "active" it shows during normal operation. The dashboard should *fight* against the alive-but-broken state, not paper over it.

## Three concrete remedial moves (from trade-bot debug 2026-05-14)

1. **Patch the actual bug** — guard against the empty-data crash that was causing the loop. Now in `superdunk27/Trade@be1842a`. Defensive, but doesn't generalize beyond *this* bug.
2. **Surface the silent skip** — when the fetch returns empty, log a `WARNING`-level `data.fetch_empty` event. This means future operators see the outage instead of inferring it from missing `signal.bar`. Generalizes to "make silent skips loud".
3. **External work-output watchdog** — `trade-bot-watchdog.timer` runs every 10 min, scans log for last work-output event, restarts bot if stale. Generalizes further: works regardless of WHAT the next "alive but broken" failure mode looks like, as long as the work-output event class is well-defined.

(3) is the most reusable because it doesn't depend on knowing the next bug's shape. Any time a long-running system can be described as "produces work units of type X at expected cadence Y", an external watchdog that checks "was an X produced in the last Y+margin?" gives you the lower bound on liveness that matters.

## When the cure looks worse than the disease

A common objection: "external watchdogs that restart processes feel like they're hiding the underlying bug." That's a real concern. The mitigation is: have the watchdog *log loudly* every time it acts. `logger -t trade-bot-watchdog "STALE: restarting"` writes to journal. Next-session operator running `journalctl -t trade-bot-watchdog` can see if the watchdog has been restarting routinely (= there's still an underlying bug) vs never firing (= it's just a safety net for novel failures).

The watchdog is not a substitute for fixing root causes. It's a layer that limits the *blast radius* of root causes you haven't found yet. Today's underlying bug took us 8 days to notice; with a 90-minute-stale watchdog in place, the same bug would have triggered a restart within ~91 minutes, which might or might not have hidden the bug enough that we wouldn't have investigated it — but the bot would have stayed functional in the meantime. That tradeoff is usually worth it for any production system where "doing nothing for 8 days" is a worse outcome than "restarting every 91 minutes for a few days".

## Pointers

- The actual incident: `ψ/memory/retrospectives/2026-05/14/13.43_trade-bot-alive-but-broken.md`
- The project this lives in: `ψ/active/trade-bot/README.md`
- The watchdog script (server-side, not in repo): `/usr/local/bin/trade-bot-watchdog.sh` on cloud134984
- The bug fix commit: `superdunk27/Trade@be1842a`
- The diagnostic one-liner that exposed it: `grep -oP '"event":\s*"[^"]+"' bot.log | sort | uniq -c | sort -rn` — histograms first, individual entries second
