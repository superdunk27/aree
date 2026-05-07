# Aree setup — Windows (PowerShell)
# Re-runnable; safe to invoke on a fresh clone or to re-sync skills.
#
# What this does:
#   1. Verify Node.js is installed (Bun installer + npx need it).
#   2. Install Bun if missing (Oracle skills CLI runs on Bun).
#   3. Install Oracle skills (standard profile) globally to ~/.claude/skills/.
#
# Pinned versions keep both Toey's machines in lockstep — bump explicitly.

$ErrorActionPreference = 'Stop'

$ORACLE_SKILLS_VERSION = '26.4.18'
$ORACLE_PROFILE        = 'standard'

Write-Host "`nAree setup starting..." -ForegroundColor Cyan

# 1. Node
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Error "Node.js not found. Install from https://nodejs.org (>=18) and re-run."
    exit 1
}
Write-Host "Node:  $(node --version)"

# 2. Bun
if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Bun..." -ForegroundColor Yellow
    Invoke-RestMethod bun.sh/install.ps1 | Invoke-Expression
    $env:PATH = "$env:USERPROFILE\.bun\bin;$env:PATH"
}
Write-Host "Bun:   $(bun --version)"

# 3. Oracle skills (pinned — keeps both machines in lockstep)
Write-Host "Installing Oracle skills v$ORACLE_SKILLS_VERSION ($ORACLE_PROFILE profile)..." -ForegroundColor Yellow
npx --yes "arra-oracle-skills@$ORACLE_SKILLS_VERSION" install -g -y -p $ORACLE_PROFILE --agent claude-code

Write-Host "`nSetup complete." -ForegroundColor Green
Write-Host "Open a new terminal (or restart Claude Code) to ensure PATH and skills are picked up."
