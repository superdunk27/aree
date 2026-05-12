# Multi-line Windows shell paste is fragile — scp + run from file instead

**Date**: 2026-05-12
**Context**: Phase 1.2 + 1.3 of `ψ/plans/access-everywhere.md`. The plan documented two PowerShell installers (Windows Terminal profile + Desktop\Aree.lnk shortcut) as multi-line code blocks for Toey to paste into PowerShell on RDLT.

## What happened

First paste attempt landed in **CMD, not PowerShell**. Every `Write-Host` returned `'Write-Host' is not recognized as an internal or external command, operable program or batch file.` for ~60 lines. The banner — `Microsoft Windows [Version 10.0.26200.8246]` — was distinct from PowerShell's `Windows PowerShell\nCopyright (C) Microsoft Corporation.`, but Toey reasonably didn't notice. The Start-menu match `"powershell"` did not always launch PowerShell, depending on which entry he clicked.

Second paste attempt landed in PowerShell, but:
- PowerShell shows `>>` continuation prompt when an `if`, `foreach`, or `@( ... )` block is open across lines.
- Toey saw `>>` and instinctively pasted the same block again, thinking the first paste hadn't submitted.
- Result: doubled `if` blocks where the second copy lacked the original's open-brace context → `'foreach' is not recognized`, `'else' is not recognized`, `'$variable' is not recognized` for every line in the duplicated paste.

Total time lost: ~30 minutes across two diagnostic rounds. PowerShell paste of >3 lines failed in two completely different ways on consecutive attempts.

## What worked

Pivot to **server-side install script + 2-line client install**:

1. Aree writes `~/aree-install.ps1` on aree-home (the always-on server). The script is idempotent (checks for existing profile/shortcut before adding) and includes all error handling Aree wants to ship.
2. Client runs **exactly 2 commands**:
   ```powershell
   scp -o RemoteCommand=none aree:aree-install.ps1 .
   powershell -ExecutionPolicy Bypass -File .\aree-install.ps1
   ```
3. First command pulls the script via the existing `aree` SSH alias. Second runs it with execution policy bypass so unsigned scripts work.

Phase 1 closed in under 5 minutes on RDLT after the pivot, with full verification (WT dropdown + Desktop double-click) by Toey. The same 2-line pattern is now sitting in `ψ/plans/access-everywhere.md` for DESKTOP-CE4H6GT to use when Toey is at work next.

## Why this matters

**Pasting is the dominant interaction Toey has with Aree across machines.** On Windows, his `Aree` icon launches `wt.exe -p "Aree (aree-home)"` which lands him *inside aree-home's tmux session via SSH* — a remote shell. Anything Aree wants to run *on the local Windows host* (configure WT, create a Start-menu shortcut, edit hosts) requires Toey to leave the SSH session, open a separate local shell, and paste. Each paste-shell-language-context-switch is a failure mode:

- Wrong shell (CMD vs PowerShell vs Bash-on-Windows) — silent until first command fails
- Wrong terminal (Windows Terminal vs legacy console host) — affects paste behavior, clipboard handling
- Wrong execution context (interactive vs script vs heredoc) — `>>` continuation, line endings, quoting
- Wrong user privilege (admin vs not) — hosts file fails, system services fail

The aree-install.ps1 pattern collapses all of this to a single execution context: **a `.ps1` file run with `powershell -ExecutionPolicy Bypass -File`**, which is unambiguous.

## Rule for future fleet work

**Anything more than 3 lines on Windows → write a script on aree-home, have the client scp + run it.** No exceptions. Even if it "looks simple". Even if "Toey is good with PowerShell". Trust the failure mode rate, not the optimism.

When writing the script:
- Make it **idempotent** (re-run safe). Use `if (Test-Path X) { skip } else { create }` patterns.
- Make it **self-documenting**: print what step it's on, what it's doing, what file it touched. Reduces "did anything happen?" anxiety.
- Make it **fail loudly with the next step**: if a precondition is missing (e.g., Windows Terminal not installed), print the actual path it checked and what to do.
- Keep it ASCII-only in printed messages — Thai characters render unreliably across Windows console code pages.

When delivering it to Toey:
- One unique paste block, exactly 2 lines. No conditional "if you're at work do X else Y" instructions in the paste.
- Reference the script by *which Aree-home file it lives in* (`~/aree-install.ps1`), so future-Aree can find/edit it without scanning chat history.
- Include the test-after-install instructions in the README of the relevant plan, not in the paste block. (Toey will scroll back; chat history disappears.)

## Pre-flight check (cheap, prevents wrong-shell)

Before sending ANY multi-line block for Windows: ask Toey to paste **one** line first that fails differently in CMD vs PowerShell. The simplest:

```
1+1
```

- CMD: `'1+1' is not recognized...`
- PowerShell: `2`

5-second check. Stops a 30-minute debugging round.

## Tag

`#windows` `#powershell` `#fleet-pattern` `#paste-fragility` `#idempotent-scripts` `#access-everywhere-plan`
