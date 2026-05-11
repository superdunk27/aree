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

---

## 2026-05-10 Resolution Log (decisions made, not yet executed)

Plan revisited Sunday 10 May 2026 morning + evening. Decisions locked, install paused at "boot from USB" step (Toey to resume later).

### Hardware (resolved)
- **Server**: 128GB RAM, was running XCP-ng (no data to keep — wipe authorized)
- **Display + keyboard + mouse** attached (needed for OS install)
- **Network**: connected, host IP under XCP-ng was `192.168.79.14` (will likely change after Ubuntu install via DHCP)

### OS decision (resolved)
- ❌ **XCP-ng**: rejected — overkill for solo daily use. The hypervisor's value (multi-OS, snapshots, migration) doesn't justify its complexity for one user, one workload type. Toey caught this — I had defaulted to "keep what's installed" (sunk-cost trap).
- ❌ **WSL2**: rejected — was option in original plan, not relevant once we go bare metal Linux.
- ✅ **Ubuntu Server 24.04 LTS bare metal** — full 128GB RAM directly, simpler admin (one OS, SSH-direct), Docker for per-project isolation instead of VMs.

### Sizing (resolved — bumped from initial proposal)
- Original (under XCP-ng VM model): 8GB RAM / 4 vCPU / 50GB disk
- Revised (bare metal): full machine, 128GB RAM available; ~200GB+ for `~/projects/` (rest for system + Docker images)
- Rationale: Toey expects multiple projects in future. Don't shrink artificially when the box has plenty.

### Architecture (resolved)
```
[Laptop/Phone] —Tailscale—> [aree-home (Ubuntu bare metal)]
                              ├── tmux + Aree (Claude Code, native)
                              ├── ~/projects/aree/ (this repo)
                              ├── ~/projects/<future projects>/
                              └── Docker (per-project services: postgres, redis, browsers, etc.)
                                          —git push—> GitHub
```

### Installer choices (locked, awaiting Toey at server)
- Hostname: `aree-home`
- Username: `toey`
- Disk encryption: ❌ no (LUKS passphrase at every boot is friction for an always-on server)
- Storage: Use entire disk + LVM + ext4 (no ZFS/BTRFS for now — simpler default; add `restic` for backup later)
- SSH: ✅ install OpenSSH server during install
- SSH key import: ✅ from GitHub user `superdunk27` (pulls existing ed25519 pub key)
- Featured snaps: ❌ none (Docker via official apt repo, not snap)

### Stack to install post-boot (queued, paste-ready when Toey resumes)
- System: update + upgrade, set static IP (replace DHCP)
- Network: Tailscale → join personal tailnet
- Runtimes: Node 20+, Bun, git, gh CLI, tmux
- Container: Docker Engine + Docker Compose (apt, official repo)
- Aree: Claude Code CLI, `arra-oracle-skills@26.4.18 install -p lab`, MCP servers (context7, playwright, firecrawl, oh-my-claudecode)
- Persistence: systemd user service for tmux + claude code start on boot
- Repo: `git clone git@github.com:superdunk27/aree.git ~/projects/aree`

### Phone UX (resolved — Approach A first)
- Start: SSH client (Termux Android / Blink Shell or Termius iOS)
- Defer Telegram bot wrapper until Toey actually uses phone enough to justify 2-4h of bot setup

### Status as of 2026-05-10 ~23:00
- ✅ Ubuntu Server 24.04 ISO downloaded and written to USB by Toey
- ⏸️ Install paused — Toey going to bed before booting from USB
- 📋 Next session: boot installer at server, walk through with above choices, then SSH from RDLT and run the queued stack install

### Cross-reference
- `ψ/memory/retrospectives/2026-05/10/<HH.MM>_home-server-architecture-locked.md` — session retro
- `ψ/memory/learnings/2026-05-10_sunk-cost-when-inheriting-infra.md` — lesson on defaulting to "use what's there" vs "use what fits"

---

## 2026-05-11 Phase 2 Paste-Ready (closes friction-3 from previous retro)

Sequence below assumes Ubuntu Server 24.04 has booted, OpenSSH was installed during install, SSH key was imported from GitHub `superdunk27`.

### Stage 0 — At server: get IP, then move to RDLT for SSH

```bash
# At server console (login as toey)
ip -4 addr show | grep -E 'inet ' | grep -v 127.0.0.1
# → note the 192.168.x.x address
```

```powershell
# From RDLT (this machine)
ssh toey@<ip>
# should connect with the imported GitHub key, no password
```

### Stage 1 — System update + essentials

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git tmux build-essential ca-certificates gnupg lsb-release unzip
```

### Stage 2 — Tailscale (so we can stop caring about local IP)

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
# → open the auth URL printed in browser, login, approve
tailscale ip -4
# → note the 100.x.x.x address (this is the stable name to SSH to from anywhere)
```

### Stage 3 — Node 20 + Bun + gh CLI

```bash
# Node 20 via NodeSource
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node -v && npm -v

# Bun
curl -fsSL https://bun.sh/install | bash
source ~/.bashrc
bun --version

# gh CLI (official apt)
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/etc/apt/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install -y gh
gh auth login
```

### Stage 4 — Docker Engine + Compose (official apt repo, NOT snap)

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
newgrp docker   # or logout/login
docker --version
```

### Stage 5 — Clone aree repo

```bash
mkdir -p ~/projects && cd ~/projects
# If gh logged in:
gh repo clone superdunk27/aree
# Or plain git (HTTPS, will prompt for credential):
# git clone https://github.com/superdunk27/aree.git
cd aree
```

### Stage 6 — Claude Code CLI + Oracle skills (lab profile)

```bash
# Claude Code CLI (verify command at install time — check docs.anthropic.com/claude-code)
npm install -g @anthropic-ai/claude-code
claude --version

# Login (interactive once — paste the API key or follow auth flow)
claude
# → exit after auth confirmed (Ctrl+C / type /exit)

# Oracle skills — same version as RDLT
cd ~/projects/aree
npx arra-oracle-skills@26.4.18 install -p lab
# → verify 47 skills installed
```

### Stage 7 — MCP servers

> ⚠️ Exact `claude mcp add` syntax may differ by version. If unsure, run `claude mcp --help` first.

```bash
# context7
claude mcp add context7 -- npx -y @upstash/context7-mcp
# playwright
claude mcp add playwright -- npx -y @playwright/mcp@latest
# firecrawl (needs FIRECRAWL_API_KEY)
claude mcp add firecrawl --env FIRECRAWL_API_KEY=<key> -- npx -y firecrawl-mcp
# oh-my-claudecode plugin → install via /plugin in Claude Code interactive

claude mcp list   # verify
```

### Stage 8 — Persistence (tmux + Aree auto-start on boot)

```bash
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/aree.service <<'EOF'
[Unit]
Description=Aree (Claude Code in persistent tmux)
After=network-online.target

[Service]
Type=forking
ExecStart=/usr/bin/tmux new-session -d -s aree -c %h/projects/aree
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable aree.service
sudo loginctl enable-linger toey   # ← critical: lets the service run when toey isn't logged in via tty
systemctl --user start aree.service
systemctl --user status aree.service
```

Attach from anywhere:
```bash
ssh toey@<tailscale-ip>
tmux attach -t aree
# inside tmux: run `claude` to start Aree
# detach: Ctrl+B then D (session keeps running)
```

### Stage 9 — Update machines.md + sync state

```bash
# On RDLT (or via SSH to aree-home), add aree-home section to ψ/active/machines.md
# Then on aree-home: mirror ψ/memory/personal-context.md by reading it (no write needed initially)
```

### Verification checklist

- [ ] `ssh toey@<ip>` works without password (GitHub key auth)
- [ ] `tailscale ip -4` returns 100.x.x.x
- [ ] `node -v` ≥ 20, `bun --version` runs, `gh auth status` shows logged in
- [ ] `docker run --rm hello-world` succeeds without sudo
- [ ] `claude --version` runs, login persisted
- [ ] `npx arra-oracle-skills@26.4.18 list` shows 47 skills (lab profile)
- [ ] `systemctl --user status aree.service` = active (running)
- [ ] Reboot test: `sudo reboot` → SSH back in → `tmux ls` shows `aree` session still alive

### Rough time estimate

- Stages 1-3: ~15 min (mostly apt waits)
- Stage 4 (Docker): ~10 min
- Stages 5-7 (Aree stack): ~20 min if MCP syntax checks needed
- Stage 8 (systemd): ~10 min
- Total: ~1 hour from "logged in to fresh Ubuntu" to "Aree on autopilot"

### Things flagged to verify at install time (not assumed)

- Claude Code CLI exact npm package name (`@anthropic-ai/claude-code` is current — verify with docs)
- `claude mcp add` flag syntax for each server (varies by Claude Code version)
- Tailscale tag/ACL: default tailnet is fine for personal use; consider tagging this node as `tag:server` if family grows
- If Docker `newgrp docker` doesn't take effect → logout/login

