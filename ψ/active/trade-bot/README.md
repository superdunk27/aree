# Trade Bot — BTC/ETH live trading bot

**Repo**: https://github.com/superdunk27/Trade (private)
**Discovered by Aree**: 2026-05-14 (when Toey asked "ผมดูมันยังไม่มีการเทรดเลย ยังทำงานอยู่ไหม")
**First commit** (Toey-side): 2026-04-24 (`0853699 feat: BTC/ETH trading bot with Supertrend + 4h HTF + ADX strategy`)
**Aree's first commit** to the repo: 2026-05-14 (`be1842a` — bug fix for the stuck-state issue described below)

## What it is

Live trading bot for **BTC/USDT and ETH/USDT on Binance Spot**, currently in **testnet mode**. Strategy: Supertrend(12,3) flip on 1h + EMA200 + ADX>20 + 4h Supertrend bullish (all four must align). Backtest on 8.68 years of data shows +1,157% (CAGR 33.86%, MaxDD 11%, 547 trades, WR 41%, PF 1.91).

Toey's intent for testnet mode is **execution verification** — confirm the bot actually submits orders to Binance's API surface, not just simulate trades in memory. After testnet behaves correctly for some time he plans to flip `BINANCE_TESTNET=false` and run live.

## Where it lives

- **Host**: cloud134984 (IP 103.107.52.225, rented cloud server, Ubuntu 24.04 noble)
- **Bot path**: `/root/trade-bot/` (proper git clone of `superdunk27/Trade` as of 2026-05-14 ~13:35; previously was a manual scp from Windows, ownership UID 197609)
- **Service**: `systemctl status trade-bot` — Type=simple, Restart=on-failure, runs `/root/trade-bot/.venv/bin/python /root/trade-bot/bot/main.py`
- **Logs**: `/root/trade-bot/bot/logs/bot.log` (structlog JSON, one event per line)
- **State**: `/root/trade-bot/bot/state.json` (equity, positions, last bar timestamps)
- **Env**: `/root/trade-bot/bot/.env` (testnet keys + Telegram token + Postgres/Redis URLs — gitignored)

## How to reach it (Aree → server)

```bash
ssh root@103.107.52.225           # key-based, aree-home pubkey installed in /root/.ssh/authorized_keys
```

Server SSH details:
- Port 22 (default)
- User: `root`
- Auth: aree-home's `~/.ssh/id_ed25519` (added 2026-05-14 ~13:00)
- Server has GitHub deploy key: `cloud134984-trade-bot` (read-only, ed25519 fingerprint `SHA256:7YA942LWyQX3q2O6WVlk3zsJ8sm11oQCNJXSE7mJOq4`) — installed 2026-05-14, allows `git pull` from `git@github.com:superdunk27/Trade.git`

## Telegram interface

Bot exposes interactive commands in Toey's Telegram chat (bot token + chat_id pinned in `.env`):

| Command | Output |
|---------|--------|
| `/status` | Mode, uptime, equity, drawdown, positions, risk |
| `/positions` | Open positions detail |
| `/stats` | Trades, win rate, P&L, ROI |
| `/signal` | Latest signal state per symbol |

Useful as a phone-side dashboard without ssh.

## Bug history (Aree-discovered 2026-05-14)

Four layered bugs together produced "alive but evaluating zero trades for 8 days":

1. **DRY_RUN mismatch**: `.env` had `DRY_RUN=false` but its mtime was 1 second *after* the bot process start (2026-04-27 23:08:28 process vs 23:08:29 file). Bot read the old default `dry_run=True` at boot, then ran for 16 days as a pure simulation. Telegram `/status` showed `Mode: TESTNET` so the mode looked right at the surface. Fix: restart bot. (Done 2026-05-14 ~13:16.)

2. **Empty-data crash in supertrend()**: during a Binance testnet 502 outage on 2026-05-06, the fetch wrapper returned empty DataFrames rather than raising. `strategy.py:supertrend()` called `np.argmax(~np.isnan(a))` on an empty array → `ValueError: attempt to get argmax of an empty sequence`. The try/except at the tick level (main.py) caught it and continued, so systemd never saw a failure to restart on. After the outage cleared, the bot kept ticking with no signal evaluation for 8 days. Fix: commit `be1842a` — guard `if n == 0` and `if not np.any(~np.isnan(a))` before the argmax; also added `data.fetch_empty` WARNING in main.py so the operator sees the outage instead of inferring it from absence of `signal.bar`.

3. **Systemd Restart=on-failure didn't help**: the bot caught its own exceptions and kept looping. systemd's restart policy only fires on non-zero exit, which never happened. Fix: added external watchdog (`trade-bot-watchdog.service` + `.timer`, every 10 min) that scans the log for the last `signal.bar | data.fetch_failed | data.fetch_empty | tick.symbol_error` event and restarts the bot if nothing newer than 90 min, with a grace period of 90 min after each service start.

4. **Testnet has insufficient kline history for EMA200**: even with bugs 1–3 fixed, the bot still couldn't fire a signal because Binance Testnet retains only ~183 bars of 1h klines (~7.6 days), while `strategy.latest_state()` requires `len(df) >= max(ema_len, 50)` = 200 bars to leave warmup. The bot was correctly evaluating each tick but silently returning None at `pd.isna(last["ema200"])` because EMA200 hadn't converged. Verified by running fetch+compute manually on the server: `df_1h=183, signal: None`. Fix: commit `dd20207` on `superdunk27/Trade` adds a separate `data_client` to `Exchange` always pointed at mainnet (OHLCV is a public endpoint, no key needed); orders + balance still go through the testnet-aware `self.client`. After deploy: data_client returns 500 bars from mainnet, strategy evaluates cleanly, first `signal.bar` event in 8 days fired at 2026-05-14 07:14 UTC.

The full diagnostic narrative is in `ψ/memory/retrospectives/2026-05/14/` (the retro for this date).

## Daily-driver checks (for next-session Aree)

```bash
# Are we alive and evaluating?
ssh root@103.107.52.225 'systemctl is-active trade-bot; tail -5 /root/trade-bot/bot/logs/bot.log'

# When did the strategy last actually look at the market?
ssh root@103.107.52.225 'grep "signal.bar" /root/trade-bot/bot/logs/bot.log | tail -1'

# Has the watchdog fired recently?
ssh root@103.107.52.225 'journalctl -t trade-bot-watchdog --since "1 day ago" --no-pager | tail -10'

# Any positions open?
# (Toey can `/positions` in Telegram, or:)
ssh root@103.107.52.225 'cat /root/trade-bot/bot/state.json'
```

## Things still pending

- **Telegram bot token rotation** — not done; Toey paste-leaked it into chat 2026-05-14 in the diagnostic conversation. Blast radius is low (chat_id whitelist prevents command execution, only spoofing of bot replies possible), so deferred at Toey's call. Rotate via @BotFather → `/mybots` → "Revoke current token" if/when convenient.
- **Binance testnet API keys** — also paste-leaked. Testnet = no real money, lowest possible stakes; rotate is hygiene-only.
- **Pre-live checklist** — when Toey decides to flip to live: change `BINANCE_TESTNET=false`, fresh API keys with Spot-only permission (no Withdraw, no Margin), confirm equity bootstrapping, run for several days at smaller risk_pct before scaling.
- **Bot/PostgreSQL/Redis integration** — `.env` references both but actual usage in code wasn't audited. Worth a look before live trading.

## Why this project is here in `ψ/active/` and not `ψ/learn/projects/`

`ψ/active/` is for projects Toey + Aree are actively running and may need to operate. trade-bot meets that bar: live on a server, generates events daily, can fail in ways that need diagnostic intervention. `ψ/learn/projects/` is for projects we're studying as reference (e.g., other people's repos). trade-bot is Toey's own production bot.
