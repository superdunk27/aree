---
date: 2026-05-13
repo: aree
topic: Termius Android can't render Thai combining marks — root cause + ttyd browser workaround
type: client-bug diagnosis / workaround
---

# Lesson — Termius Android cannot render Thai combining marks; route to ttyd in browser instead

## Symptom

Toey on ROG Phone 7 Series via Termius (free tier) typing Thai at bash prompt sees consonants duplicated when followed by a combining vowel/tone mark:

- Types "ผมชื่อ" → display shows **"ผมชชชื่อ"**
- Hits Enter → bash receives the **correct** "ผมชื่อ" (no duplication in the transmitted bytes)
- Same on every Termius font (tried all of them)
- Same outside tmux too — pure Termius client-side render bug
- RDLT (Windows Terminal) and DESKTOP do NOT exhibit this

## Root cause

Thai script uses **combining characters** (U+0E30–U+0E4E range — vowels above/below and tone marks) that must overlay the preceding base consonant. Proper rendering requires Unicode **text shaping**: the terminal asks the shaper "given base + combining marks, what cluster do I draw, in how many cells?"

Termius's Android text renderer does not do this shaping. It draws each code point in its own cell and, on receiving the combining mark, re-emits the base consonant alongside it instead of composing them into a single grapheme cluster. Result: visual duplication.

Confirmation it is **render-only**:
1. Bytes on the wire are correct (Enter commits the un-duplicated text to bash and to chat with Aree).
2. Switching Termius font does nothing — it is the renderer, not the font's glyph coverage.
3. The same SSH endpoint viewed from any *other* client (Windows Terminal, Chrome / ttyd) renders Thai perfectly.

inputrc fixes (`convert-meta off`, `enable-bracketed-paste`) and tmux refresh tricks (Ctrl-L, `r` alias = `tmux refresh-client; clear`) cannot fix this — they are all server-side, and the bug is in the client's draw path.

## Workaround (chosen)

Open `https://aree-home.tail9e69b1.ts.net/` in **Chrome on Android** instead of Termius. Chrome renders the terminal via ttyd (Phase 3 of `ψ/plans/access-everywhere.md`) and uses Android's system text-shaping pipeline (Noto Sans Thai + HarfBuzz). Thai renders correctly. Same tmux session `aree`, same persistent Claude Code, just a different viewport.

Phase 3 server-side was already closed on 2026-05-12 ~22:00; only the phone propagation was pending. Verified working 2026-05-13.

## Alternatives considered

| Option | Verdict |
|--------|---------|
| Tolerate visual duplication | Bytes are correct, but unreadable in practice → reject |
| Different Termius font | All fonts produced the same bug → not a font issue |
| Different SSH client (JuiceSSH / Termux) | Plausible, but requires re-setup of host + key + UI relearn → defer |
| ttyd in browser | Zero extra setup (server ready), Android system shaper handles Thai natively → **chosen** |

## Diagnostic pattern (reusable)

When a terminal client garbles a non-Latin script:

1. **Check bytes vs render** — does `cat > file` produce a clean file on the server? If yes, the wire is fine; the bug is on the client's draw side.
2. **Try every font** — if all fonts behave identically, it is the renderer (text shaper), not the font glyphs.
3. **Try the same endpoint from a different client** — if a second client renders correctly, the server is innocent; the first client owns the bug.
4. **Prefer a viewport with a real shaping pipeline** — browsers (HarfBuzz) and OS-native terminal emulators tend to handle complex scripts correctly. Mobile SSH apps often don't.

## UX caveats moving to browser

- Right-click → browser context menu (not paste). Use long-press → Paste on mobile.
- Drag-select → browser text selection (not tmux). Mouse copy/paste flows differ.
- The browser tab inherits tmux's smallest-attached-client size — multi-attach sessions can squeeze the viewport.

## Pointers

- Plan: `ψ/plans/access-everywhere.md` (Phase 3 — Web ttyd via Tailscale Serve)
- Phase 2 setup of Termius itself: same plan, Phase 2 resolution log
- Earlier attempts at server-side Thai fixes: commit `71e2dc1` (inputrc) and `e215641` (`r` refresh alias) — both useful for Windows clients, neither helps the Termius render bug

## Follow-up (2026-05-13 afternoon) — Termux as the actual primary

The browser/ttyd path solved the Thai render problem, but ttyd in Chrome has a separate friction: tmux `mouse on` swallows touch swipe events, so scrolling tmux scrollback requires entering tmux copy-mode (which on a phone means `Ctrl-b [` — and Chrome's virtual keyboard does not surface Ctrl easily).

In the same session we tried **Termux** as a third phone path:

- Install Termux from **F-Droid** (the Play Store build has been deprecated since 2020 — verified, it does not work).
- `pkg install openssh tmux git nano`, then `ssh-keygen -t ed25519` for a per-device key (`rog-phone-termux`, fingerprint `bCmeXA5gxsLVhWqaF+Upd9jNwsFeYK+No73TwNbpLxk`), then append the pubkey to aree-home `~/.ssh/authorized_keys` (now 4 keys total: `gh:superdunk27`, DESKTOP, ROG-Termius, ROG-Termux).
- Connect with `ssh -i ~/.ssh/id_ed25519_aree toey@100.77.60.57` — aree-home's bashrc auto-attach takes over and lands inside tmux session `aree`.
- Alias `aree` saved into Termux's `~/.bashrc` for one-word reconnect.

Outcome: Termux renders Thai correctly (verified — typing "โย่วๆๆๆ" shows no consonant duplication), **and** touch-swipe scrolls the tmux scrollback usefully (fast but acceptable; for precise scrollback use `Ctrl-b [` → `Vol-Up + P/N` for PgUp/PgDn → `q` to exit copy-mode).

### Revised recommendation (mobile primary path)

| Path | Thai input | Scrolling | When to use |
|------|-----------|-----------|-------------|
| **Termux + ssh** | ✓ correct | ✓ touch swipe + tmux copy-mode | **Primary daily driver** — Ctrl available in extra-keys row, Linux-side niceties |
| Chrome + ttyd | ✓ correct | partial (tmux mouse blocks browser scroll) | Fallback if Termux is unavailable or for a quick browser-only device |
| Termius (free tier) | ✗ duplicates | toolbar limited | Demoted to last-resort fallback |

### Two gotchas worth recording

1. **Heredoc paste from chat code blocks breaks** when the user's terminal interprets the markdown's soft-wrap as hard newlines: leading whitespace appears before the `EOF` terminator and bash never sees the end-of-heredoc. Symptom: bash sits at the `>` PS2 prompt indefinitely; everything after the would-be terminator (including `chmod`) gets eaten as heredoc body, partially writing the destination file. **Workaround**: prefer single-line `printf` or short `echo >> file` calls over heredocs when guiding a phone user through copy-paste; or have them use `nano` interactively.
2. **A malformed `~/.ssh/config` breaks every `ssh` invocation**, even bare ones with all options passed on the command line, because ssh parses the config before dispatching. Symptom: `no argument after keyword "remotecommand"` / `Bad configuration option`. Fix: `rm ~/.ssh/config` and either re-create cleanly with `nano` or skip the config entirely and rely on a shell alias to the long `ssh -i ... user@ip` form.
