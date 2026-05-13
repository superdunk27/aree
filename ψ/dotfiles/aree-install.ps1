# Aree Windows quick-launch installer
# Installs Windows Terminal "Aree (aree-home)" profile + Desktop\Aree.lnk shortcut.
# Idempotent: re-running is safe.

# --- 1.2: Windows Terminal profile ---

Write-Host "=== Step 1.2: Windows Terminal profile ===" -ForegroundColor Cyan

$candidates = @(
  "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
  "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json",
  "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
)
$settingsPath = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $settingsPath) {
  Write-Host "ERROR: Windows Terminal settings.json not found." -ForegroundColor Red
  Write-Host "Is Windows Terminal installed? Tried these paths:" -ForegroundColor Red
  $candidates | ForEach-Object { Write-Host "  $_" }
  return
}

Write-Host "Settings file: $settingsPath"

$backup = "$settingsPath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Copy-Item $settingsPath $backup
Write-Host "Backup created: $backup"

$settings = Get-Content $settingsPath -Raw -Encoding UTF8 | ConvertFrom-Json

$existing = $settings.profiles.list | Where-Object { $_.name -eq "Aree (aree-home)" }
if ($existing) {
  Write-Host "Profile 'Aree (aree-home)' already exists. Skipping add." -ForegroundColor Yellow
  Write-Host "  GUID: $($existing.guid)"
} else {
  $newGuid = "{$([guid]::NewGuid().Guid)}"
  $newProfile = [PSCustomObject]@{
    guid        = $newGuid
    name        = "Aree (aree-home)"
    commandline = "ssh aree"
    tabTitle    = "Aree"
    hidden      = $false
  }
  $settings.profiles.list = @($settings.profiles.list) + $newProfile
  $settings | ConvertTo-Json -Depth 100 | Set-Content $settingsPath -Encoding UTF8
  Write-Host "SUCCESS: Added profile 'Aree (aree-home)'" -ForegroundColor Green
  Write-Host "  GUID: $newGuid"
}

# --- 1.3: Desktop shortcut ---

Write-Host ""
Write-Host "=== Step 1.3: Desktop shortcut ===" -ForegroundColor Cyan

$desktopCandidates = @(
  "$env:USERPROFILE\Desktop",
  "$env:OneDrive\Desktop"
)
$desktopPath = $desktopCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $desktopPath) {
  Write-Host "ERROR: No Desktop folder found at:" -ForegroundColor Red
  $desktopCandidates | ForEach-Object { Write-Host "  $_" }
  return
}

Write-Host "Desktop folder: $desktopPath"

$shortcutPath = Join-Path $desktopPath "Aree.lnk"

if (Test-Path $shortcutPath) {
  Write-Host "Shortcut already exists. Skipping create." -ForegroundColor Yellow
  Write-Host "  Path: $shortcutPath"
} else {
  $WshShell = New-Object -ComObject WScript.Shell
  $shortcut = $WshShell.CreateShortcut($shortcutPath)
  $shortcut.TargetPath = "wt.exe"
  $shortcut.Arguments = '-p "Aree (aree-home)"'
  $shortcut.IconLocation = "wt.exe,0"
  $shortcut.Description = "Aree home server SSH session"
  $shortcut.Save()
  Write-Host "SUCCESS: Shortcut created" -ForegroundColor Green
  Write-Host "  Path: $shortcutPath"
}

Write-Host ""
Write-Host "=== Installation complete ===" -ForegroundColor Cyan
Write-Host "Test 1 (Windows Terminal):"
Write-Host "  Open Windows Terminal, click the v dropdown next to + tab,"
Write-Host "  choose 'Aree (aree-home)'. You should land in tmux on aree-home."
Write-Host ""
Write-Host "Test 2 (Desktop shortcut):"
Write-Host "  Close this window, look at your Desktop, double-click 'Aree' icon."
Write-Host "  Windows Terminal opens directly into the Aree session."
