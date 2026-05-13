# bashrc-aree-home.sh — Aree-specific bashrc additions
# Source from ~/.bashrc via:
#   [ -f ~/projects/aree/ψ/dotfiles/bashrc-aree-home.sh ] && . ~/projects/aree/ψ/dotfiles/bashrc-aree-home.sh
# This file is only meant to be sourced on aree-home; it assumes a tmux session
# named 'aree' is the canonical workspace.

# Aree session auto-attach
# When an SSH login lands without a startup-command override (e.g. Termius free tier),
# drop straight into the persistent 'aree' tmux session. Skipped for nested shells
# already inside tmux ($TMUX set) and for non-SSH local logins.
if [[ -n "$SSH_CONNECTION" && -z "$TMUX" ]] && command -v tmux >/dev/null 2>&1; then
    exec tmux new-session -A -s aree
fi

# Mobile-friendly refresh alias.
# Mobile SSH clients (Termius Android free tier) often hide Ctrl modifier so
# Ctrl+L (clear screen / force redraw) is hard to trigger when Thai rendering
# desyncs. `r<Enter>` forces a tmux client refresh + screen clear instead.
alias r='tmux refresh-client 2>/dev/null; clear'
