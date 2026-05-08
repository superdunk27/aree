# Home Server Architecture — Aree always-on

**Status**: Planning. Not executed yet. Toey to trigger when ready (probably during jump-mat parts wait, 3-7 วันจาก 2026-05-07).
**Date written**: 2026-05-08
**Trigger phrase**: "ทำ home server" / "ตั้ง Aree ให้รัน 24 ชม."

---

## Goal

ย้าย Aree ไปอยู่บนเครื่อง dedicated เปิด 24/7 ที่บ้าน. Toey สั่งงานผ่าน:
- 💻 Laptop (เครื่องที่ใช้ทุกวัน) — SSH
- 📱 Phone — SSH หรือ chat-bot wrapper
- 🖥️ Desktop เครื่องอื่น — SSH

ผลลัพธ์:
- ไม่ต้องสลับเครื่องเพื่อทำงานต่อ
- Cross-instance memory drift หายไป (writer คนเดียว)
- เครื่อง client devices กลายเป็น thin clients — ไม่ต้องลง toolchain ครบ

---

## Constraints

- **Existing hardware**: Toey มีคอมอีกเครื่องอยู่แล้ว (ไม่ต้องซื้อใหม่)
- **Network**: ใช้บ้านเป็นหลัก, เผื่อ access จากออฟฟิศ/ข้างนอกได้
- **Skill**: Toey = intermediate; คุ้น Windows, Linux ใหม่
- **Phone usage**: ยังไม่ระบุชัด — เริ่มที่ "เผื่อใช้ก็ได้"
- **No commercial pressure**: ทำเพื่อตัวเอง, ทำเสร็จเร็วไม่สำคัญเท่าทำให้ดี

---

## OS Decision

### Recommendation: Windows + WSL2 Ubuntu (top pick สำหรับ Toey)

| Pros | Cons |
|---|---|
| Toey คุ้น Windows host | Windows Update ยังต้องตั้งให้ pause |
| WSL2 = Linux ของจริง สำหรับ Aree's stack | นิดหน่อยกินทรัพยากรมากกว่า pure Linux |
| ของ Windows ที่มีอยู่แล้ว (winget, Visual Studio, etc.) ใช้ต่อได้ | |
| ทดลองก่อนได้ (ไม่ต้อง wipe + reinstall) | |

### Alternative: Pure Linux (Ubuntu Server 24.04 LTS)

ถ้าตัดสินใจไป Linux เต็มตัว:
- **Ubuntu Server 24.04 LTS** — มี community ใหญ่สุด, LTS 5 ปี, Node/Bun tested
- หรือ **Debian 12** — ถ้าอยาก stable + set-and-forget

ไม่แนะนำ: NixOS / Arch / Alpine / Mint Desktop (ระบุเหตุผลในการสนทนาวันที่ plan เขียน)

### Sub-decision (ทำเมื่อพร้อม)

Toey เลือก:
- [ ] WSL2 (เริ่มเร็ว, ทดลองง่าย)
- [ ] Pure Linux (ทำให้สุด)

---

## Stack ที่ต้องลงบน home server

### Core (ทุก option)
- **OpenSSH server** — remote access จาก laptop/phone
- **tmux** — persistent session (รัน Claude Code ใน tmux → disconnect ก็ไม่หาย)
- **Node.js** (v20+) + **Bun** (latest) — runtime สำหรับ Claude Code + MCP + skills
- **git** + **gh CLI** — repo management
- **Tailscale** — VPN-style network (zero-config, encrypted, ไม่ต้อง port-forward)

### Aree-specific
- Claude Code CLI
- Oracle skills full profile (`npx arra-oracle-skills@26.4.18 install -g -p full`)
- MCP servers: context7, playwright, firecrawl, plugin:oh-my-claudecode:t (ตาม machines.md)
- arduino-cli + ESP32 core (ถ้าจะใช้ home server flash firmware ก็ลง — ไม่งั้น skip)

### Optional / nice-to-have
- **Docker** (สำหรับ Playwright browsers ถ้าใช้บ่อย)
- **Caddy** หรือ **Cloudflare Tunnel** (ถ้าอยาก web UI access แทน SSH-only)
- **Telegram bot wrapper** (ถ้า phone usage บ่อย — ดู section ถัดไป)

---

## Network — ตัวเลือก remote access

### Option 1 — Tailscale (แนะนำ)
- ลง Tailscale ที่ home server + laptop + phone
- ทุกเครื่องเห็นกันใน Tailscale network (เหมือน LAN ส่วนตัว)
- เข้ารหัส end-to-end, zero config, ไม่ต้องเปิด port router
- ฟรีสำหรับ <100 devices

### Option 2 — Cloudflare Tunnel + Web Terminal
- รัน `ttyd` หรือ `Wetty` (web-based terminal) บน home server
- Cloudflare Tunnel expose URL ที่มี auth
- เข้าผ่าน browser มือถือได้ ไม่ต้องลง app

### Option 3 — Local LAN only (ง่ายสุด)
- ใช้ได้เฉพาะที่บ้าน (ไม่ต้อง access จากข้างนอก)
- SSH เฉพาะ IP local (192.168.x.x)
- เหมาะถ้า Toey อยู่บ้านเป็นหลัก

ผม recommend **Tailscale** — middle ground ระหว่าง simple + remote access ได้

---

## Phone UX

นี่คือจุดที่ความสบายต่างกันมาก:

### Approach A — SSH client (เริ่มต้น)
- Android: **Termux** + **Termius**
- iOS: **Blink Shell** หรือ **Termius**
- ใช้ได้แต่พิมพ์ command บนมือถือเจ็บ
- เหมาะ: command สั้น ๆ, ดู status, สั่ง git pull

### Approach B — Telegram bot wrapper (ถ้าใช้บ่อย)
- เขียน Node script: รับข้อความจาก Telegram → ส่งให้ tmux session ผ่าน `tmux send-keys` → reply กลับ Telegram
- UX = แชทปกติบนมือถือ
- Effort: ~2-4 ชม. setup ครั้งแรก
- Library: `node-telegram-bot-api` หรือ `grammy`

### Approach C — เลื่อนเรื่อง phone ไว้
- ใช้ laptop เป็นหลัก, phone ค่อยพิจารณาทีหลัง
- เหมาะถ้าไม่แน่ใจว่าจะใช้ phone บ่อยจริงไหม

ผม recommend: **เริ่ม A** (Termux/Termius) → ถ้ารู้สึกใช้ phone บ่อยแล้วเจ็บ → ค่อยทำ B (Telegram bot)

---

## Persistence config (สำคัญ)

### tmux session ที่ survive reboot
- ใช้ **tmux-resurrect** + **tmux-continuum** plugin
- Auto-save layout + restore on tmux start
- ถ้าเครื่อง reboot → tmux เปิดเอง (systemd service) → resurrect ดึง layout กลับมา → Claude Code session กลับมาด้วย

### auto-start on boot
- Linux: `systemd` service file รัน tmux + claude code
- WSL2: ต้องเปิด WSL ก่อน → ใช้ `wsl --boot` กับ Task Scheduler
- Windows: Task Scheduler

### Power settings
- Linux: ไม่ต้องตั้ง — default ไม่ sleep
- Windows: Settings → Power → "Never sleep", "Never hibernate", disable USB selective suspend

---

## Migration plan (เมื่อพร้อม)

### Phase 1 — Setup home server (~2-3 ชม.)
1. ติดตั้ง OS (Windows ที่มี, หรือ install Linux ใหม่)
2. ลง core stack: OpenSSH, tmux, Node, Bun, git, gh, Tailscale
3. Clone aree repo
4. Setup Oracle skills + MCP (ใช้ machines.md template)
5. ตั้ง systemd / Task Scheduler ให้ Claude Code session start on boot

### Phase 2 — Test remote access (~30 นาที)
1. SSH จาก laptop ผ่าน Tailscale → enter tmux session → talk to Aree
2. Verify cross-machine git workflow ยังทำงาน
3. Phone test: ลง Termux/Termius → SSH เข้าได้

### Phase 3 — Decommission writer role on other machines (~30 นาที)
1. Update `machines.md` — home server section + mark client devices as "thin client" (read-only / occasional)
2. Update CLAUDE.md cross-instance rules ให้สะท้อน single-writer architecture
3. Stop git pulling on client devices unless ต้องการ

### Phase 4 (optional) — Phone UX upgrade
1. ถ้าใช้ SSH บนมือถือเจ็บ → setup Telegram bot wrapper
2. หรือ web terminal ผ่าน Cloudflare Tunnel

---

## Open questions ที่ Toey ต้องตอบก่อนเริ่ม

1. **OS**: WSL2 หรือ Pure Linux?
2. **Phone usage prediction**: A (SSH only), B (Telegram bot), หรือ C (เลื่อน)?
3. **Network scope**: บ้านอย่างเดียว หรือออกข้างนอกด้วย?
4. **Hardware specs ของเครื่องสำรอง**: RAM? Disk? CPU? — เพื่อ check resource sufficiency
5. **Timeline**: จะเริ่มเมื่อไร? (ระหว่างรอ jump-mat parts น่าจะดี)

---

## Risks / things to watch

- **Power outage** — UPS เล็ก ๆ ก็ดี (~1,000-2,000฿) สำหรับ graceful shutdown
- **Internet down** — Aree ใช้งานไม่ได้ (ไม่ใช่ปัญหา local-only)
- **Anthropic API outage** — Aree ตอบช้า/ไม่ได้, แต่ tmux session + git ยังทำงานได้
- **Security**: SSH key auth (ไม่ password) + Tailscale's encrypted network = ปลอดภัยพอสำหรับ personal use
- **Backup**: เครื่องเสีย → repo ก็ยังอยู่บน GitHub. Per-instance memory ที่ home server = recreate ได้จาก ψ/memory/personal-context.md mirror

---

## Reference

- `ψ/active/machines.md` — current state of Aree's machines, will need new section for home server
- `ψ/memory/personal-context.md` — durable context for cross-instance use
- `ψ/memory/learnings/2026-05-08_cross-instance-state-via-git.md` — why git is the only reliable sync layer
- Tailscale: https://tailscale.com/kb/installation
- WSL2: `wsl --install -d Ubuntu`
- tmux + plugins: https://github.com/tmux-plugins/tpm

---

## When to revisit this plan

- Toey พูดเรื่องนี้อีกครั้ง → re-read this file ก่อนเสนอแผน detail
- Hardware specs ได้แล้ว → update "Constraints" section
- เลือก OS แล้ว → ลบ alternatives ออก, เก็บแค่ตัวที่เลือก
- ลงมือ Phase 1 → snapshot timeline ใน history section ใหม่ของไฟล์นี้

ไฟล์นี้ append-only หลัง execution เริ่ม (Nothing is Deleted).
