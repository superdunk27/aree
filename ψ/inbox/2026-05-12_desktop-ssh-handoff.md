# Handoff: Authorize DESKTOP-CE4H6GT pubkey on aree-home

**Date**: 2026-05-12 (Tuesday)
**From instance**: Claude Code on DESKTOP-CE4H6GT (work machine)
**To**: Toey when next at RDLT (home machine) — Phase 1.1 SSH alias completion for DESKTOP
**Status**: PENDING — single command needed on aree-home

---

## Context

Set up DESKTOP-CE4H6GT (work) as a Tailscale + ssh channel to aree-home today. All client-side
done. Server-side authorization needs Toey's hand because aree-home is not currently reachable
from work (work network has no key to ssh in yet — chicken-and-egg).

## What's already in place on DESKTOP-CE4H6GT (work)

- ✅ Tailscale 1.96.3 installed + logged in (`100.120.182.8` on tailnet)
- ✅ SSH ed25519 keypair at `C:\Users\Toey\.ssh\id_ed25519` (private key) + `.pub` (public)
- ✅ `~/.ssh/config` with `Host aree` block (HostName 100.77.60.57, RemoteCommand tmux attach...)
- ❌ Public key is NOT yet in `~/.ssh/authorized_keys` on aree-home → `ssh aree` will fail with "Permission denied (publickey)"

## The public key to authorize

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDK7sad1kfXVzaKfVRDvvyH7l5A2e7XUh9EfyWnsOX4n desktop-ce4h6gt-toey-2026-05-12
```

Fingerprint: `SHA256:E82v1peklgVfwx4NYK1NOc2dEjahYB4uglyosI37fzY`

## Steps for Toey (at RDLT — home machine)

1. `git pull` (this file should be visible after pull)
2. Make sure RDLT can ssh to aree-home (Phase 1.1 hand-off from 2026-05-11 retro — also pending). If RDLT's own ssh alias not set up yet, set that first using the block in `ψ/plans/access-everywhere.md` line 80-87.
3. From RDLT, ssh into aree-home:
   ```
   ssh aree
   # or if alias not set up yet:
   ssh toey@100.77.60.57
   ```
4. On aree-home, append DESKTOP's pubkey to authorized_keys:
   ```bash
   echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDK7sad1kfXVzaKfVRDvvyH7l5A2e7XUh9EfyWnsOX4n desktop-ce4h6gt-toey-2026-05-12' >> ~/.ssh/authorized_keys
   ```
5. Verify:
   ```bash
   tail -3 ~/.ssh/authorized_keys
   ```
   Should show the DESKTOP key as the last line.
6. Log out of aree-home.

## Steps for Toey (back at DESKTOP-CE4H6GT — work machine, next visit)

1. `git pull` (to see this handoff resolved)
2. Test:
   ```powershell
   ssh aree
   ```
3. Should drop directly into tmux session `aree` on aree-home. Confirm `hostname` returns `aree-home` and we're in the right tmux session.

## On success, also update

- `ψ/active/machines.md` DESKTOP-CE4H6GT section: add Tailscale + SSH details to current state table; History entry for 2026-05-12 setup completion.
- Delete this inbox file (no longer pending).

## Why not pushed to GitHub instead

Alternative would be `gh ssh-key add` then `ssh-import-id gh:superdunk27` on aree-home. Skipped because:
- `gh` on DESKTOP currently lacks `admin:public_key` scope (would need `gh auth refresh` + browser at work — unnecessary if direct paste works)
- Manual append is shorter (1 line vs 2 steps + browser auth)

Either path lands the key in authorized_keys; we chose the simpler one.

## If the steps don't work

- "Permission denied (publickey)" after paste → check the key didn't get word-wrapped or have extra newlines in authorized_keys
- "Connection refused" → check Tailscale on aree-home is up: `tailscale status` on aree-home should show all peers
- "Host key verification failed" on first ssh from DESKTOP → answer "yes" to trust prompt (ssh-keyscan from DESKTOP couldn't fetch host key earlier because Windows OpenSSH client doesn't support aree-home's post-quantum KEX — interactive trust still works)
