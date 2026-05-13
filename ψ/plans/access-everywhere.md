# Access Aree Everywhere — low-friction multi-channel access

**Status**: Phase 1 closed on RDLT (2026-05-12 ~20:40) and DESKTOP-CE4H6GT (2026-05-13 ~08:04). Phase 2 (Android Termius) closed 2026-05-12 ~21:10. Phase 3 (Web ttyd via Tailscale Serve) closed 2026-05-12 ~22:00 on RDLT, propagation to ROG Phone closed 2026-05-13 ~09:55 (browser/ttyd became the *primary* Thai-input path on phone, replacing Termius for typing). Phase 4 deferred. Phase 3 propagation to DESKTOP-CE4H6GT pending.
**Date written**: 2026-05-11
**Trigger phrase**: "คุยกับคุณที่ไหนก็ได้" / "ทำให้คุย Aree ง่ายขึ้น" / "access everywhere"

---

## Goal

ลด friction การคุยกับ Aree จาก 5-step manual flow → 1-action จากทุก device + ทุก location ที่ Toey อยู่ — โดยไม่ลด full Claude Code experience และไม่เปิด surface area สู่ public internet.

## Pain ที่แก้

ก่อน plan นี้ flow คือ:
1. เปิดเครื่อง RDLT (ต้องอยู่บ้าน)
2. เปิด Windows Terminal / PowerShell
3. `ssh toey@100.77.60.57` (ต้องจำ IP)
4. `tmux attach -t aree` (ต้องจำคำสั่ง)
5. `/resume` ถ้าอยากต่อ session เดิม

= **5 ขั้น + จำ 3-4 อย่างทุกครั้ง** → Toey จำไม่ได้ → ใช้น้อย

## Scope (จาก /sync-style scoping 2026-05-11)

- **Channels**: RDLT (Windows), มือถือ Android, แล็ปท็อปอื่นในอนาคต, browser บนเครื่องไหนก็ได้
- **Use case (away from home)**: Full coding — review code, debug, edit files, run tests — ไม่ลดสิทธิ์
- **Security**: Tailscale only — ไม่เปิด port public, ไม่ผ่าน third-party message service

## Non-goals

- ❌ Public SSH on internet (surface area, brute force risk เมื่อมี Tailscale แล้ว)
- ❌ Telegram/Discord bot bridge (third-party server เห็น message — ขัด "Tailscale only")
- ❌ Tailscale Funnel (= public via Tailscale URL — ใช้ Serve ที่ tailnet-only แทน)
- ❌ ติดตั้ง claude.ai mobile app เพื่อทำงานบน aree-home (chat history แยก, ไม่เห็น ψ/)

---

## Architecture

```
[Toey ที่ไหนก็ได้]
   │
   ├── RDLT (Windows 11) ──────── ssh aree ────────┐
   │   • Desktop shortcut "Aree.lnk"               │
   │   • Windows Terminal profile (dropdown)       │
   │                                               │
   ├── Android phone ───── Termius app ────────────┤
   │   • saved host "aree"                         │
   │   • SSH key imported                          │
   │                                               │
   └── Browser (any device) ─── https://aree-home  │
       • Tailscale Serve cert (auto HTTPS)         │
       • ttyd web terminal                         │
                                                   │
                                                   ▼
                              [Tailscale tailnet 100.x]
                                                   │
                                                   ▼
                  ┌──────── aree-home (100.77.60.57) ────────┐
                  │                                          │
                  │   sshd (key-only)                        │
                  │   ↓                                      │
                  │   ssh login → RemoteCommand →            │
                  │   ↓                                      │
                  │   tmux attach -t aree (or new -s aree)   │
                  │   ↓                                      │
                  │   claude (Claude Code session, persists) │
                  │                                          │
                  │   ttyd (port 7681, localhost only)       │
                  │   ↑ proxied by                           │
                  │   tailscale serve → https://aree-home.<ts>/│
                  │                                          │
                  └──────────────────────────────────────────┘
```

**Single source of truth**: tmux session `aree` บน aree-home. ทุก channel = attach เข้า session เดียว → memory, context, history ไม่แยก

---

## Phase 1 — RDLT: ลด friction จาก 5 ขั้น → 1 action (เป้า 15 นาที)

### 1.1 SSH alias `aree` ใน `~/.ssh/config` (RDLT)

Toey paste ลง PowerShell บน RDLT:

```powershell
$sshConfig = "$env:USERPROFILE\.ssh\config"
$entry = @"

Host aree
    HostName 100.77.60.57
    User toey
    IdentityFile ~/.ssh/id_ed25519
    RequestTTY yes
    RemoteCommand tmux attach -t aree || tmux new -s aree
"@
Add-Content -Path $sshConfig -Value $entry -Encoding utf8
```

**Test**: `ssh aree` ใน PowerShell ใหม่ ควรเข้า tmux session `aree` ตรง

### 1.2 Windows Terminal profile

Settings → Open JSON file → ใส่ profile ลงใน `profiles.list`:

```json
{
  "name": "Aree (aree-home)",
  "commandline": "ssh aree",
  "tabTitle": "Aree 🪷",
  "startingDirectory": null,
  "hidden": false,
  "guid": "{a4eeb789-aaaa-4222-bbbb-cccccccccccc}"
}
```

**Test**: เปิด Windows Terminal → dropdown → คลิก "Aree (aree-home)" → เข้าเลย

### 1.3 Desktop shortcut "Aree.lnk"

```powershell
$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Aree.lnk")
$shortcut.TargetPath = "wt.exe"
$shortcut.Arguments = "-p `"Aree (aree-home)`""
$shortcut.IconLocation = "wt.exe,0"
$shortcut.Save()
```

**Test**: double-click `Aree` บน desktop → เปิด Aree session ทันที

**Phase 1 success criteria**: Toey double-click อย่างเดียว ไม่จำคำสั่ง

---

## Phase 2 — Android (เป้า 15-30 นาที)

### 2.1 ลง Tailscale บน Android
- Play Store: `Tailscale`
- Login เข้า tailnet เดียวกัน (`superdunk27@github`)
- Verify: `tailscale status` บน aree-home แสดงมือถือ Android

### 2.2 ลง Termius บน Android
- Play Store: `Termius`
- Free tier: cross-device sync, multiple hosts, ปุ่ม quick-connect — เพียงพอสำหรับ usage นี้

### 2.3 ตั้ง SSH key
Option A: ส่ง private key จาก RDLT ไป Termius vault (สะดวก, encrypted in vault)
Option B: สร้าง key ใหม่บนมือถือ + upload public key ผ่าน `gh ssh-key add`

แนะนำ Option B — ทำตาม principle "key อยู่กับ device นั้น"

### 2.4 ตั้ง host profile
- Host: `100.77.60.57` (หรือ `aree-home.<tailnet>.ts.net`)
- User: `toey`
- Key: ที่เพิ่ง upload
- Startup snippet: `tmux attach -t aree || tmux new -s aree`

**Phase 2 success criteria**: เปิด Termius บนมือถือ → กด profile → ภายใน 2 วินาทีอยู่ใน Aree session

---

## Phase 3 — Web terminal (browser ใดก็ได้) (เป้า 30-60 นาที)

### 3.1 ติดตั้ง ttyd บน aree-home

```bash
sudo apt update && sudo apt install -y ttyd
ttyd --version  # verify
```

### 3.2 systemd user service `aree-web.service`

`~/.config/systemd/user/aree-web.service`:

```ini
[Unit]
Description=ttyd web terminal for Aree session
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ttyd --writable --port 7681 --interface 127.0.0.1 \
  tmux attach-session -t aree
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
```

```bash
systemctl --user daemon-reload
systemctl --user enable --now aree-web.service
systemctl --user status aree-web.service
```

**Why localhost-only bind**: ป้องกัน LAN exposure (192.168.x.x ก็เห็นไม่ได้). Tailscale Serve จะ proxy จาก tailnet → localhost.

### 3.3 Tailscale Serve

```bash
tailscale serve --bg https / http://127.0.0.1:7681
tailscale serve status
```

ผลลัพธ์: `https://aree-home.<tailnet>.ts.net/` (Tailscale auto-issues TLS cert)

### 3.4 Bookmark ทุกเครื่อง
- RDLT browser
- Chromebook/แล็ปท็อปคนอื่น
- มือถือ Android (เผื่อไม่อยากเปิด Termius บ้างครั้ง)

**Phase 3 success criteria**: เปิด browser tab → bookmark → ทำงานใน Aree ผ่าน web UI

---

## Phase 4 — Quick captures (optional, deferred)

ถ้า Phase 1-3 ใช้แล้วยังขาด:

- **Android Tasker**: voice → text → curl POST ผ่าน Tailscale → เก็บใน `ψ/inbox/voice-notes/`
- **iOS Shortcut**: เทียบเท่า (ถ้าวันหลังมี iPhone)
- **Pre-defined chat templates** ใน Termius/web: quick "/recap" snippets

ยังไม่ทำตอนนี้ — รอเก็บ pain หลังใช้ Phase 1-3

---

## Decision log

- **2026-05-11**: เลือก **Tailscale Serve** ไม่ใช่ **Funnel** (Serve = tailnet-only, Funnel = public). Toey ขอ "Tailscale only".
- **2026-05-11**: เลือก **Termius** ไม่ใช่ JuiceSSH/ConnectBot — เพราะ cross-platform sync (จะมี iPhone ในอนาคตก็ใช้ profile เดิม), free tier เพียงพอ
- **2026-05-11**: เลือก **ttyd** ไม่ใช่ Gotty/Wetty — single binary, apt-installable, lightweight (~2MB), เสถียร
- **2026-05-11**: SKIP **Telegram/Discord bot bridge** — ขัด Toey's "Tailscale only" preference
- **2026-05-11**: SKIP **public SSH** — surface area ไม่จำเป็นเมื่อมี Tailscale อยู่แล้ว
- **2026-05-11**: ttyd bind `127.0.0.1` ไม่ใช่ `0.0.0.0` — Tailscale Serve proxy จาก tailnet, ไม่ leak ออก LAN

---

## Open questions

- **Tailscale tailnet name?** ต้องรู้เพื่อสร้าง URL `https://aree-home.<tailnet>.ts.net` — รัน `tailscale status --json | jq .MagicDNSSuffix` หรือ `tailscale cert` แสดง suggested name. (Resolved at execution time)
- **Termius key import**: Toey เลือก Option A (sync จาก RDLT) หรือ B (gen ใหม่บนมือถือ)? — Resolve ใน Phase 2 ก่อนเริ่ม
- **ttyd `--writable` flag**: เปิดให้พิมพ์ได้ (ไม่ใช่แค่ read-only view). ความเสี่ยง: ใครก็ตามที่อยู่ใน tailnet พิมพ์ได้ → trust model = Toey's tailnet เป็น single-user (ตรวจสอบ `tailscale status` เป็นระยะ)

---

## Resolution log (จะ append เมื่อทำเสร็จแต่ละ phase)

### Phase 1 — RDLT
- **2026-05-12 ~19:23 GMT+7** — Step 1.1: SSH alias `aree` set in `~/.ssh/config`. Verified `ssh -F config -o RemoteCommand=none aree hostname` → `aree-home` ✓ (commit `cd41f55`).
- **2026-05-12 ~20:40 GMT+7** — Step 1.2 (Windows Terminal profile) + 1.3 (Desktop\Aree.lnk shortcut) closed via `aree-install.ps1` (written on aree-home at `~/aree-install.ps1`, scp'd to RDLT, run with `powershell -ExecutionPolicy Bypass -File .\aree-install.ps1`). End-to-end verified by Toey: WT dropdown shows "Aree (aree-home)"; Desktop shortcut double-click → opens Aree session. ✅ Phase 1 RDLT complete.

### Phase 1 — DESKTOP-CE4H6GT
- **2026-05-12 (afternoon)** — Step 1.1: SSH alias `aree` set on DESKTOP, pubkey authorized on aree-home (commit `e529348`).
- **2026-05-13 ~08:02 GMT+7** — Step 1.1 end-to-end verified from DESKTOP for the first time: `ssh -o RemoteCommand=none aree 'hostname'` → `aree-home` ✓. First-connect added aree-home to `known_hosts`. (The earlier 2026-05-12 entry only authorized the pubkey on aree-home — it never tested the client direction from DESKTOP itself.)
- **2026-05-13 ~08:04 GMT+7** — Step 1.2 + 1.3 closed via the same `aree-install.ps1` flow as RDLT. Pulled script with `scp -o RemoteCommand=none aree:aree-install.ps1 ./aree-install.ps1` (3506 bytes), ran with `powershell -ExecutionPolicy Bypass -File`. Script created WT profile `Aree (aree-home)` (GUID `{374a4e37-b01d-4d84-8310-461849dbed94}`, commandline `ssh aree`) in `…\WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json` (backup at `settings.json.backup.20260513-080414`), and `C:\Users\Toey\Desktop\Aree.lnk` → `wt.exe -p "Aree (aree-home)"`. Toey confirmed both Desktop double-click and WT dropdown launch the Aree tmux session. ✅ Phase 1 DESKTOP complete. Whole DESKTOP run cost ~5 min — validates the "scp + run-from-file" pattern as a repeatable per-machine installer.

### Phase 2 — Android (ROG Phone 7 Series)
- **2026-05-12 ~21:00 GMT+7** — Tailscale already installed on phone (joined tailnet 2026-05-11, IP `100.95.74.25`, node `rog-phone-7-series`). Was offline 3h due to Android battery optimization killing the background service — brought online by reopening Tailscale app. Pending: set Tailscale to "Unrestricted" battery if offlines become recurring.
- **2026-05-12 ~21:05 GMT+7** — Termius installed from Play Store (free tier). ed25519 key generated in Termius vault: name `rog-phone-toey-2026-05-12`, fingerprint `SHA256:Pyo9/L0pqNziGZgR/Nsw2JAC/6nTxPB0tjMYx9EKbOk`. Public key pasted in chat; Aree appended to `~/.ssh/authorized_keys` on aree-home (3 keys total now: RDLT, DESKTOP, ROG Phone).
- **2026-05-12 ~21:08 GMT+7** — Termius free tier hides the "Startup snippet" / "exec on connect" field behind paywall. **Server-side workaround instead**: appended an auto-attach block to `~/.bashrc` on aree-home — when SSH login lands without `$TMUX` set, `exec tmux new-session -A -s aree` drops into the persistent `aree` session. Block is gated on `$SSH_CONNECTION` so local console logins on aree-home are unaffected. RDLT/DESKTOP bypass bash via their own SSH `RemoteCommand` so they're also unaffected.
- **2026-05-12 ~21:10 GMT+7** — Host profile saved in Termius (alias `Aree (aree-home)`, `toey@100.77.60.57:22`, key = phone-generated). Tapped Connect → ~2 second latency → Toey reported "เข้าได้แล้ว". Server-side verification: `tmux list-clients -t aree` shows 2 attached clients (RDLT pts/0 209x51, phone pts/2 80x36); `ss -tn` shows established SSH from both `100.111.92.57` and `100.95.74.25`. ✅ Phase 2 closed.

**Caveat noted**: shared tmux view resizes window to smallest attached client. When phone + RDLT attach simultaneously, RDLT terminal shows in 80x36 worth of space. `aggressive-resize on` or grouped sessions can fix it — deferred until actual pain.

### Phase 3 — Web terminal (browser via Tailscale Serve)
- **2026-05-12 ~21:30 GMT+7** — Step 3.1: `sudo apt install -y ttyd` → 1.7.7 from universe. **Gotcha**: the package ships an enabled system-level `ttyd.service` that runs as root with `/bin/login` and grabs port 7681 silently. First boot of our user service failed with `EADDRINUSE`. Fix: `sudo systemctl disable --now ttyd.service && sudo systemctl mask ttyd.service`.
- **2026-05-12 ~21:35 GMT+7** — Step 3.2: user systemd unit at `~/.config/systemd/user/aree-web.service` launches `/usr/bin/ttyd --writable --port 7681 --interface 127.0.0.1 /usr/bin/tmux new-session -A -s aree`. Restart on failure, 5s backoff. Bound to localhost only so the only path in is via Tailscale Serve.
- **2026-05-12 ~21:40 GMT+7** — Step 3.3a: `sudo tailscale serve --bg http://127.0.0.1:7681` returned "Serve is not enabled on your tailnet" with a one-time admin URL `https://login.tailscale.com/f/serve?node=netQPLWeLR11CNTRL`. Toey opened it in browser, enabled the feature, and the pending serve config activated retroactively. New CLI syntax: `tailscale serve <target>` (default HTTPS), unlike the older `serve https / <target>` form documented in the plan.
- **2026-05-12 ~21:45 GMT+7** — Step 3.3b: `tailscale serve status` confirms `https://aree-home.tail9e69b1.ts.net (tailnet only) |-- / proxy http://127.0.0.1:7681`. From aree-home itself, `curl -sI https://aree-home.tail9e69b1.ts.net/` returns `HTTP/2 200` with content-type text/html — ttyd is reachable through the Tailscale proxy + auto-issued cert.
- **2026-05-12 ~22:00 GMT+7** — Step 3.4 (Windows DNS adoption gotcha + hosts fallback): RDLT could not resolve `aree-home.tail9e69b1.ts.net` even after `tailscale set --accept-dns=true`, `tailscale down/up`, and `ipconfig /flushdns`. Windows kept routing DNS to the ISP IPv6 server (`2001:fb0:100::207:49`). Forcing the query against Tailscale's own DNS (`nslookup ... 100.100.100.100`) resolved correctly, confirming the issue was Windows DNS adoption, not Tailscale Serve. Workaround: append `100.77.60.57 aree-home.tail9e69b1.ts.net` to `C:\Windows\System32\drivers\etc\hosts` from admin PowerShell. Browser reached the URL immediately after. nslookup still times out (it skips hosts files); the browser path uses the Windows resolver chain which honors hosts. ✅ Phase 3 closed on RDLT.

**Pending Phase 3 propagation to other clients**:
- **DESKTOP-CE4H6GT** — likely same Windows DNS gotcha; expect to add the same hosts line.
- **ROG Phone** — ✅ closed 2026-05-13 ~09:55. Chrome on Android resolved `aree-home.tail9e69b1.ts.net` via MagicDNS natively (no hosts workaround needed, as predicted). End-to-end verified by Toey: "เล่นผ่านเว็บใช้ได้". **Surprise upgrade**: ttyd-in-browser is now the *primary* phone path for Thai input, not just a fallback — Termius free tier has an Android text-rendering bug that duplicates Thai consonants before combining marks (e.g. "ผมชื่อ" → displays as "ผมชชชื่อ"; bytes on the wire are correct, render is wrong, fonts don't help). Chrome uses Android's system text shaper (Noto Sans Thai + HarfBuzz) which handles combining clusters correctly. Diagnosis + workaround written up in `ψ/memory/learnings/2026-05-13_termius-thai-combining-bug.md`.
- **Any third-party device** — needs to be on the tailnet *and* either resolve MagicDNS natively or have the hosts entry.

**Browser-ttyd UX caveats (vs Windows Terminal / Termius)**:
- Right-click in browser triggers the browser's context menu (Reload / Save image), not tmux paste. Use **Ctrl+V** (browser-native paste) instead.
- Drag-select still works but it's a browser-level selection. Use **Ctrl+C** to copy from it, not the drag-end auto-copy we configured in tmux.
- Mouse wheel scroll forwards to tmux scrollback as usual.
- The ttyd window will inherit tmux's smallest-client size — if a Windows machine is attached simultaneously at 209x51 and the browser tab is narrower, tmux shrinks to fit the narrower client.

### Phase 4 — Quick captures
*(deferred — wait for Phase 1-3 to settle)*
