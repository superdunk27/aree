# dotfiles — Aree fleet shell + tmux configuration

Backups of machine-level configuration that Aree maintains on aree-home (and
potentially other nodes in the future). These live in git so a reinstall, a
fresh server, or a teleport to another machine doesn't lose the friction
reduction we built up.

## Why source-from-git rather than copy-into-home

The home-directory file (`~/.tmux.conf`, `~/.bashrc`) is **a thin wrapper**
that sources the canonical copy from this repo:

- `~/.tmux.conf` contains exactly one effective line:
  `source-file -q ~/projects/aree/ψ/dotfiles/tmux.conf`
- `~/.bashrc` keeps the Ubuntu default content + appends:
  `[ -f ~/projects/aree/ψ/dotfiles/bashrc-aree-home.sh ] && . ~/projects/aree/ψ/dotfiles/bashrc-aree-home.sh`

Effects:
- Edit `ψ/dotfiles/*` and `git push` → all machines that source-from-git pick
  up the change on next `git pull` + `tmux source-file ~/.tmux.conf`.
- Repo not yet cloned (e.g. brand-new machine, pre-bootstrap) → `-q` and the
  `[ -f ... ] &&` guards mean the source lines silently skip. Login still works.
- Single source of truth lives in git history. `git blame` shows when and why
  each tweak landed.

## Files

| File | What it configures |
|------|---------------------|
| `tmux.conf` | mouse on, 50k history, OSC 52 clipboard sync, right-click paste behavior tuned for Windows Terminal / Termius |
| `bashrc-aree-home.sh` | SSH-aware auto-attach into tmux session `aree` (server-side workaround for Termius free-tier missing startup-command field) |
| `aree-web.service` | systemd user unit that runs ttyd → tmux `aree` on `127.0.0.1:7681` so Tailscale Serve can proxy it as `https://aree-home.tail9e69b1.ts.net/` for browser access |
| `aree-install.ps1` | Windows client installer — creates Windows Terminal profile `Aree (aree-home)` + `Desktop\Aree.lnk` shortcut for 1-action access to the Aree tmux session. Idempotent. The canonical "live" copy that clients `scp` from also sits at `~/aree-install.ps1` on aree-home; this is the disaster-recovery copy in git. |
| `inputrc` | bash readline config — fixes Thai/UTF-8 input on terminals (especially mobile Termius) by setting `convert-meta off` so backspace deletes one Thai character not one UTF-8 byte. Adds `enable-bracketed-paste` for safer pasting. |

## Install / Restore on a fresh aree-home

After `git clone` of the aree repo to `~/projects/aree`:

```bash
# tmux.conf
cat > ~/.tmux.conf <<'EOF'
# Source the shared Aree tmux config from git.
# -q makes this a no-op if the repo isn't checked out yet.
source-file -q ~/projects/aree/ψ/dotfiles/tmux.conf
EOF

# .bashrc — append the source line (don't replace the existing Ubuntu default)
cat >> ~/.bashrc <<'EOF'

# Aree fleet dotfiles
[ -f ~/projects/aree/ψ/dotfiles/bashrc-aree-home.sh ] && . ~/projects/aree/ψ/dotfiles/bashrc-aree-home.sh
EOF

# .inputrc — readline config (Thai UTF-8 fix)
cat > ~/.inputrc <<'EOF'
$include ~/projects/aree/ψ/dotfiles/inputrc
EOF

# Reload tmux if a session is already running
tmux source-file ~/.tmux.conf 2>/dev/null
# To apply inputrc in current shell: `bind -f ~/.inputrc`. New shells pick it up automatically.
```

## Install / Restore Phase 3 (browser channel via ttyd + Tailscale Serve)

```bash
# 1. Install ttyd
sudo apt update && sudo apt install -y ttyd

# 2. Disable the apt-shipped system service that grabs port 7681 as root
sudo systemctl disable --now ttyd.service
sudo systemctl mask ttyd.service

# 3. Install our user service from the repo backup
mkdir -p ~/.config/systemd/user
cp ~/projects/aree/ψ/dotfiles/aree-web.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now aree-web.service

# 4. Configure Tailscale Serve (first time per tailnet may need admin enable)
sudo tailscale serve --bg http://127.0.0.1:7681
tailscale serve status
```

Visit `https://aree-home.tail9e69b1.ts.net/` from any device on the tailnet.
If a Windows client can't resolve the hostname (Tailscale DNS not adopted),
fall back to a static entry in `C:\Windows\System32\drivers\etc\hosts`:
`100.77.60.57 aree-home.tail9e69b1.ts.net` (admin PowerShell).

## Install / Restore Phase 1 on a Windows client (WT profile + Desktop shortcut)

Prerequisite: `~/.ssh/config` already has a `Host aree` block on the client
(Step 1.1 of the access-everywhere plan) and the client's pubkey is in
aree-home's `~/.ssh/authorized_keys`. Verified by `ssh -o RemoteCommand=none aree hostname` → `aree-home`.

From PowerShell on the Windows client:

```powershell
scp -o RemoteCommand=none aree:aree-install.ps1 .
powershell -ExecutionPolicy Bypass -File .\aree-install.ps1
```

The script is idempotent — re-run is safe (skips profile/shortcut creation if
they already exist). It backs up `settings.json` to
`settings.json.backup.<timestamp>` before editing.

**Keeping the on-server copy in sync**: edits should be made here in
`ψ/dotfiles/aree-install.ps1`. After committing + pushing, on aree-home:

```bash
cp ~/projects/aree/ψ/dotfiles/aree-install.ps1 ~/aree-install.ps1
```

Or one-shot symlink (do this once, then `git pull` keeps everything in sync):

```bash
mv ~/aree-install.ps1 ~/aree-install.ps1.orig
ln -s ~/projects/aree/ψ/dotfiles/aree-install.ps1 ~/aree-install.ps1
```

## When to add a file here

- Configuration that lives outside the repo (in `~`, `/etc`, etc.) and is
  costly to recreate from memory.
- Tweaks that should travel with Aree across machines.
- Things that are *not* secrets — keep API keys, tokens, and credentials out
  of the repo. Per-machine secret state belongs in `~/.claude.json` env or
  similar per-host stores.

## When NOT to add a file here

- Anything in `/etc/` that needs root or that's specific to one machine's
  hardware (e.g. systemd unit files for `aree.service` if they reference
  absolute paths). Document those in `ψ/active/machines.md` history instead.
- Files containing fingerprints to Toey's identity beyond what's already in
  the repo (e.g. private SSH keys, OAuth tokens). Never commit private keys.
