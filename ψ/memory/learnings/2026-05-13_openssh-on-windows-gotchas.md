---
date: 2026-05-13
repo: aree
topic: Five Windows OpenSSH gotchas that turn a 30-second setup into a 30-minute one
type: operational checklist / reusable diagnostic ladder
---

# Lesson — Five Windows OpenSSH gotchas worth memorizing before attempting reverse SSH again

Setting up `aree-home → ssh toey0@rdlt` tonight should have taken ~30 seconds (the underlying components are all stock Windows + one pubkey). It took ~30 minutes because of five Windows-specific behaviors that each looked superficially Linux-like but weren't. This file is the checklist for next time.

## Gotcha 1 — The Windows username is whatever `Get-LocalUser` says it is, NOT what the Linux side's `/home/` directory suggests

I assumed `toey` because aree-home's user is `toey`. Then I tried `Toey` because `C:\Users\Toey\Desktop\Aree.lnk` exists. Both produced `sshd: Invalid user` in the event log. The actual Windows username on RDLT is `toey0` — apparently the Windows installer's display-name-vs-account-name disambiguation produced a numeric suffix at first-boot. The `C:\Users\Toey\` directory and the `toey0` account coexist because Windows treats display name and account name as distinct.

**Fix reflex**: before any `ssh user@windows`, run `Get-LocalUser` on the Windows side (or have Toey run it) and use the `Name` column exactly. Capitalization doesn't matter for sshd matching, but the literal string (including any digit suffix) does.

## Gotcha 2 — Admin accounts use `administrators_authorized_keys`, not `~/.ssh/authorized_keys`

The Windows OpenSSH default `sshd_config` ends with:

```
Match Group administrators
       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys
```

If the connecting user is in `BUILTIN\Administrators` (which is true for the default Windows user out of the box — first account created is admin), sshd ignores the user-level `C:\Users\<user>\.ssh\authorized_keys` and looks at the system-level `C:\ProgramData\ssh\administrators_authorized_keys` instead. Putting the key in the user-level file silently does nothing.

**Fix reflex**: Always install the key to `C:\ProgramData\ssh\administrators_authorized_keys` for admin Windows accounts. Verify with `whoami /groups | findstr -i admin` to confirm admin membership before deciding which file. `Add-Content -Path C:\ProgramData\ssh\administrators_authorized_keys -Value $pubkey` will auto-create the file if missing.

## Gotcha 3 — Strict ACL is mandatory; the system-default ACL will silently fail auth

Windows OpenSSH refuses to use an `authorized_keys` file that has inherited ACLs or grants to non-privileged principals. The default ACL on a newly-created file in `C:\ProgramData\ssh\` inherits from the parent and includes `Users` — sshd reads that, decides the file is world-readable, and refuses.

**Fix reflex**: After writing the key, run:

```powershell
icacls C:\ProgramData\ssh\administrators_authorized_keys /inheritance:r /grant Administrators:F /grant SYSTEM:F
```

That removes inheritance and grants Full Control to exactly `Administrators` and `SYSTEM`, which is what sshd's `StrictModes` check expects. Verify with `icacls C:\ProgramData\ssh\administrators_authorized_keys` — output should show **only** `NT AUTHORITY\SYSTEM:(F)` and `BUILTIN\Administrators:(F)`, nothing else.

## Gotcha 4 — `OpenSSH/Operational` event log is the diagnostic, not ssh's client output

When the auth fails, the client sees `Permission denied (publickey,password,keyboard-interactive)` — that's a generic message that covers many different server-side errors. The actionable detail is on the Windows side, in the event log:

```powershell
Get-WinEvent -LogName "OpenSSH/Operational" -MaxEvents 5 | Format-List TimeCreated, Message
```

This tells you specifically whether the failure was `sshd: Invalid user <name>` (Gotcha 1 — wrong username) vs `sshd: Authentication failed for user <name>` (the user exists but the key didn't match or the ACL was bad).

**Fix reflex**: as soon as auth fails twice, jump to the event log. Don't keep trying usernames blind.

## Gotcha 5 — Tailscale's "Run Tailscale SSH server" checkbox on Windows is not currently a working feature

Toey toggled the option in Tailscale's tray Preferences. `tailscale ssh toey@rdlt` then returned:

```
Dial("rdlt.tail9e69b1.ts.net.", 22): unexpected HTTP response: 502 Bad Gateway,
dial failure: dial tcp 100.111.92.57:22: i/o timeout
```

The Tailscale daemon believes it should be proxying to port 22 on RDLT but nothing is listening there — the Windows version of Tailscale doesn't ship a working SSH server, despite the UI offering the checkbox. Tailscale SSH is Linux-first; on Windows the canonical answer is OpenSSH Server through normal `ssh user@host` (Tailscale handles the routing as a network layer, not the SSH layer).

**Fix reflex**: For Windows targets, default to installing OpenSSH Server (`Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0`) and use regular `ssh` over Tailscale's IP/MagicDNS. Skip the Tailscale SSH path entirely for Windows.

## Diagnostic ladder for next time

Top-to-bottom checklist when "can't ssh into a Windows machine":

1. **Reachability** — `tailscale ping <host>` returns `pong` within 100ms? If not, Tailscale issue, not SSH.
2. **Port 22 open** — `bash -c "</dev/tcp/<ip>/22 && echo OK"` returns OK? If not, OpenSSH not installed or firewall blocking. Install + firewall rule.
3. **User is valid** — `OpenSSH/Operational` event log shows `Invalid user`? Use `Get-LocalUser` for the canonical name.
4. **User is admin?** — `whoami /groups` shows `BUILTIN\Administrators`? If yes, key goes to `C:\ProgramData\ssh\administrators_authorized_keys`. If no, goes to `C:\Users\<user>\.ssh\authorized_keys`.
5. **Key present** — `Get-Content <authfile>` shows the expected pubkey?
6. **ACL strict** — `icacls <authfile>` shows ONLY `SYSTEM:(F)` + `Administrators:(F)`?
7. **Service running** — `Get-Service sshd` → Running, StartType Automatic?
8. **Config matches** — `Get-Content C:\ProgramData\ssh\sshd_config | Select-String "Match Group|AuthorizedKeysFile"` shows the admin block intact?

If all eight pass, auth will succeed. Today three of eight tripped before we got a clean connection.

## Pointers

- The actual setup that worked: `ψ/active/machines.md` → RDLT section → Current state row "OpenSSH Server" and History entries 2026-05-13 ~20:05 through ~20:25
- Same-day session retrospective: `ψ/memory/retrospectives/2026-05/13/20.36_rdlt-reverse-ssh-defender-scan.md`
- Related: the post-update Defender scan finding from the same diagnostic run — surfaced in the same retro, not a separate lesson
- aree-home pubkey installed today: `ssh-ed25519 …FkoSwkd7iXIxiw4EQt1wCwtr+6+ou+78kw8zNx8uMF2 toey@aree-home` fingerprint `SHA256:gj5EGNMYJFIFFWTOTbKWPvXqDmeZbwAYxiZETfC3Z/4`
