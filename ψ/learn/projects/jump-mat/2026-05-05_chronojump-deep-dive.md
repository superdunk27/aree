---
date: 2026-05-05
domain: projects/jump-mat
type: external research deep-dive
session: home evening, evaluating Chronojump as base platform
status: technical analysis
sources:
  - https://github.com/GNOME/chronojump
  - https://gitlab.gnome.org/GNOME/chronojump
  - https://github.com/GNOME/chronojump/tree/master/chronopic-firmware
  - https://github.com/GNOME/chronojump/tree/master/chronopic-tests
  - https://github.com/GNOME/chronojump/tree/master/arduino/WiJump
  - https://github.com/GNOME/chronojump/tree/master/arduino/4Platforms
  - https://github.com/GNOME/chronojump/blob/master/src/chronopic.cs
  - https://github.com/GNOME/chronojump/blob/master/src/modes/jump.cs
  - https://chronojump.org/construction-contact-platform/
---

# Chronojump deep-dive: how open is it really?

The TL;DR up front: **Chronojump is genuinely open source, end-to-end, including the Chronopic firmware**. The protocol is trivial (5 bytes, 9600 baud), already ported to ESP32 inside their own repo, and reproducible in an afternoon. The only thing they "withhold" is electrical detail in the marketing-page DIY guide — and that's just a documentation gap, not an IP wall, because the firmware itself tells you exactly what the MCU expects on its input pin.

## 1. Repo inventory

| Repo | Owner | Lang | License | Last commit | Notes |
|------|-------|------|---------|-------------|-------|
| **chronojump** | GNOME (mirror of gitlab.gnome.org/GNOME/chronojump) | C# | **GPL-2.0** | 2026-03-03 | The mothership: desktop app + firmware + Arduino ports + manuals. ~1.2 GB. **30 commits since 2026-01-01** — actively developed. |
| chronojump-docs | GNOME | TeX | GPL | 2023-09 | Manual sources |
| ChronoPic_mbed | DiazGopar | C++ | (no license file) | 2016 | Third-party port to mbed; useful reference, not authoritative |
| ylatuya/chronojump | Personal fork | C# | GPL | 2023 | Frozen personal dev fork |

**Authoritative source**: GitLab GNOME (the GitHub mirror is read-only). Primary author: **Xavier de Blas** (xaviblas@gmail.com), original Chronopic firmware by Juan González (2005).

## 2. Software stack

- **Desktop app**: C# / Mono / GTK#, builds with `chronojump.sln`. Database is SQLite. R-scripts for stats. Some Python helpers for the importer. Ships on Linux/Mac/Windows.
- **License**: GPL-2.0-or-later (uniformly, with copyright headers naming Juan González 2005 + Xavier de Blas 2014–2025).
- **Communication layer**: `src/chronopic.cs` (legacy) + `src/chronopic2016.cs` + `src/chronopicDetect.cs`. New ESP32-based devices use `bluetoothCapture.cs` + `ble.py`.
- **Hardware abstractions** in src: `forcePlatform.cs`, `forceSensorDynamics.cs`, `fourPlatformsCaptureManage.cs`, `RFID.cs`, `beepTestCaptureManage.cs` — they already support force plates, force sensors, photocells, encoders, RFID.

## 3. Chronopic protocol — fully decoded

From `chronopic-tests/chronopic.c` (host side, GPL Juan González 2005), `chronopic-firmware-c/chronopic-firmware-multitest.c` (PIC firmware), and `src/chronopic.cs` (current desktop):

**Serial config**: 9600 baud, 8N1 (`SPBRG=0x19` with 4 MHz crystal in firmware; `cfsetospeed B9600` host-side).

**Two message types** — both ASCII headers + binary payload:

| Direction | Byte 0 | Bytes 1..4 | Meaning |
|-----------|--------|------------|---------|
| PIC→PC (event) | `'X'` (0x58) | `[state(0/1)] [t_HH] [t_H] [t_L]` | State change. `state=1` ON (foot down), `state=0` OFF (in air). 24-bit timestamp in **units of 8 µs** since last event. |
| PC→PIC (status req) | `'E'` | — | "What's current state?" |
| PIC→PC (status reply) | `'E'` | `[state]` | Reply to `'E'` request |
| PC→PIC (port scan) | `'J'` | — | Returns `'J'` — used to identify Chronopic |
| PC→PIC (get version) | `'V'` | — | Returns `"2.1\n"` |
| PC→PIC (get debounce) | `'a'` | — | Returns 1 byte (0..255, units of 10 ms) |
| PC→PIC (set debounce) | `'b'` `[N]` | — | Set debounce to N×10 ms |
| reaction-time cmds | `'R'/'r'/'S'/'s'/'T'/'t'/'l'/'f'/...` | — | Control reaction-time LEDs (irrelevant for us) |

**Time decode** (from `chronopic.c` line 160 and identical in `chronopic.cs`):
```
t_ms = (trama[2]*65536 + trama[3]*256 + trama[4]) * 8 / 1000
```

That's it. **Total protocol surface for jump-mat use: ~6 commands.**

### Emulation feasibility on ESP32: **EASY**

Reasoning: (a) 9600 baud is laughably slow for ESP32; (b) the only timing-critical part is timestamping the input edge to ~ms accuracy, which ESP32 does in hardware via `gpio_isr_handler` or `attachInterrupt` — easier than on a PIC; (c) Chronojump itself has already ported it (`arduino/WiJump/WiJump-V-0.4.ino` for IR barriers, `arduino/4Platforms/4Platforms.ino` for the new contact platforms); (d) the desktop app does port-detect by sending `'J'` and expecting `'J'` back, which is a 4-line Arduino sketch.

**Effort estimate**: working "fake Chronopic" that fools the desktop app on a single contact mat — **half a day to a day** for someone comfortable with Arduino + serial. The hardest part is matching the debounce semantics so jumps register correctly.

## 4. Firmware availability

Everything is open. In `chronopic-firmware/`:
- `chronopic-firmware-c/chronopic-firmware-multitest.c` — 1044 lines of C for **PIC16F876A** (SDCC compiler), with full ISR for timer0 (debounce), port-B change interrupt (input edge), timer1 (24-bit timestamp), serial RX/TX. GPL.
- `chronopic-firmware-c/chronopic-firmware-20MHz.c` — encoder variant
- `.hex` files prebuilt
- Bootloader sources, programming tools (pyburn, pydownloader)
- `howto-bootloader-and-firmware.txt` — 312 lines of build notes (mostly Catalan/Spanish, dated, but the SDCC compile recipe is in `howto_compile.txt`)

**Hardware design files**: schematics and PCB Gerbers are **NOT** in this GitHub mirror. The `hardware/` dir at repo root only contains `LoadCellADC/`, `RaceAnalyzer/`, `Wichro/`. Chronopic itself is a small board around a PIC16F876A; the schematic has been published in academic papers (Buscà et al.) and in older PDFs on chronojump.org but isn't shipped as KiCad files. **Chronopic is essentially a PIC + USB-serial chip — you don't need their PCB to talk to their software.**

The new generation `Chronopic 4.0` (ESP32-S3) is in `arduino/4Platforms/4Platforms.ino`, copyright 2024 Xavier Padullés. **Open source on day one**, BLE (Service UUIDs in `arduino/WiJump/Communication.md`) + USB-serial fallback at 115200.

## 5. Algorithms

**Jump detection** is split: the firmware just reports debounced state-changes with timestamps. **All physics is in the desktop app**, which is a *gift* if we want to reuse the math:

- `src/event.cs` + `src/modes/jump.cs` — `Jump` class stores `tv` (flight time), `tc` (contact time), `fall` (drop height for DJ).
- `src/stats/djQ.cs` and friends — derived metrics.
- Height: `h = g * tv² / 8` (standard Bosco). Power: Sayers/Lewis formulas. RSI = jumpHeight / contactTime.
- Filtering: in firmware, configurable debounce (default 50 ms); the host-side `chronopic.cs` discards invalid frames and re-syncs.

**Multi-athlete data model**: SQLite tables; `personID + sessionID + jumpType` keying. Importer in Python (`src/chronojump-importer/`).

What we'd want to study: the **debounce constant choice (50 ms default)** and how they handle false double-bounces on contact mats; the Bosco/RSI formulas in `event.cs`/`jump.cs`; the 4-platform synchronization in `fourPlatformsCaptureManage.cs`.

## 6. License & commercial implications

**GPL-2.0-or-later** across the board (desktop app, firmware, host library, Arduino sketches all carry the standard GPL-2 header).

What this means for Toey:
- ✅ Build a personal jump mat that talks to Chronojump's own desktop app: **fine**, no obligations.
- ✅ Emulate Chronopic on ESP32 using only the protocol (clean-room from the docs above): **fine**, protocols aren't copyrightable.
- ✅ Copy/adapt firmware code into our own ESP32 firmware: **fine, if we ship the source under GPL** when we distribute the device. We don't need to share schematics — only the software.
- ⚠️ Sell a product that **bundles** Chronojump's desktop app or links against `chronopic.cs`: that derivative work must be GPL-2 too. **Not LGPL — full GPL.** This makes it incompatible with a closed-source PWA that talks to it.
- ✅ Sell hardware that **only** speaks the Chronopic protocol on the wire and doesn't ship Chronojump code: **fine**, no GPL trigger.
- ✅ Build our **own** PWA that reads the Chronopic protocol from our firmware: **fine**, our PWA isn't a derivative of Chronojump.

Practical conclusion: **we can ship the hardware commercially without GPL pollution as long as our PWA is independently written**. If we copy-paste their firmware, we ship that firmware as GPL — annoying but not blocking, and arguably good (positions us as a Chronojump-compatible open device).

## 7. Project health

- 30 commits between 2026-01-01 and 2026-03-03. Active.
- Latest commits explicitly working on **Chronopic4 Bluetooth + jumpsSimple integration** — exactly our use case.
- Primary maintainer: Xavier de Blas (`xaviblas@gmail.com`). Hardware lead: Xavier Padullés (`testing@chronojump.org`).
- Forum / mailing list activity: chronojump.org has an active research blog. Issues on the GitLab side, GitHub mirror has 0 issues (read-only).
- No interesting forks for our purpose; the `ylatuya/chronojump` and `smithaaron2000/chronojump-aws` forks are stale (2022–2023) personal experiments.

## 8. Concrete recommendation

**Path A++**: Build a switch mat, emulate Chronopic on ESP32, **and use Chronojump's own desktop app** during R&D. Then build our own PWA in parallel that speaks the same protocol — when the PWA is mature, our hardware is a drop-in replacement that works with both their app and ours.

Why this beats the original Path A/B/C:

1. **De-risks the math entirely.** Toey doesn't have to validate r=0.999 against a force plate himself — Chronojump already did. We piggyback on their validation by being protocol-compatible.
2. **Two-app strategy = double validation.** During development, every jump can be measured by both Chronojump desktop and our PWA. Any divergence is a bug in our PWA, full stop. This is the cheapest possible verification harness.
3. **Force plate (Path B) is later.** The Chronopic protocol is binary state (ON/OFF) — it can't transmit force values. When we add the load-cell platform, we extend our own protocol but keep the contact-mat path Chronopic-compatible. Best of both worlds.
4. **Commercial path stays open.** Our PWA is independently written → not GPL-encumbered → can be SaaS or paid-app later. The firmware is GPL but that's invisible to end-users.

**First milestone (1 weekend)**: ESP32 + a single switch on a breadboard → respond to `'J'`, `'V'`, `'E'`, send `'X'` frames on edge changes → connect Chronojump desktop on Linux laptop → see jumps register. If that works, the rest is mechanical.

**Files to clone first**: `arduino/4Platforms/4Platforms.ino` (Chronopic 4 reference), `chronopic-tests/chronopic.c` (protocol reference), `src/modes/jump.cs` (height/RSI math to port into our PWA later).
