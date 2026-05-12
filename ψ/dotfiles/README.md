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

# Reload tmux if a session is already running
tmux source-file ~/.tmux.conf 2>/dev/null
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
