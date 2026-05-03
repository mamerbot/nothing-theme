param(
  [string]$Prefix = "",
  [switch]$InstallOnly
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($Prefix)) {
  $Prefix = if ($env:USERPROFILE) { $env:USERPROFILE } else { $env:HOME }
}

$wallpaperSource = Join-Path $RepoRoot "wallpapers/voltron-industrial/aperture/light.png"
if (-not (Test-Path -LiteralPath $wallpaperSource)) {
  throw "Missing light wallpaper: $wallpaperSource"
}

$picturesDir = [Environment]::GetFolderPath("MyPictures")
if ([string]::IsNullOrWhiteSpace($picturesDir)) {
  $picturesDir = Join-Path $Prefix "Pictures"
}

$wallpaperDir = Join-Path $picturesDir "Nothing Theme"
$wallpaperPath = Join-Path $wallpaperDir "nothing-voltron-industrial-aperture-light.png"

New-Item -ItemType Directory -Force -Path $wallpaperDir | Out-Null
Copy-Item -LiteralPath $wallpaperSource -Destination $wallpaperPath -Force
Write-Host "Installed light wallpaper to $wallpaperPath"

$ezaTheme = Join-Path $Prefix ".config/eza/themes/nothing-light.yml"
$ezaActiveTheme = Join-Path $Prefix ".config/eza/theme.yml"
if (Test-Path -LiteralPath $ezaTheme) {
  Copy-Item -LiteralPath $ezaTheme -Destination $ezaActiveTheme -Force
  Write-Host "Activated eza nothing-light theme"
}

$lazygitTheme = Join-Path $Prefix ".config/lazygit/themes/nothing-light.yml"
$lazygitConfigDir = Join-Path $Prefix ".config/lazygit"
$lazygitConfig = Join-Path $lazygitConfigDir "config.yml"
if ((Test-Path -LiteralPath $lazygitTheme) -and -not (Test-Path -LiteralPath $lazygitConfig)) {
  New-Item -ItemType Directory -Force -Path $lazygitConfigDir | Out-Null
  Copy-Item -LiteralPath $lazygitTheme -Destination $lazygitConfig -Force
  Write-Host "Activated lazygit nothing-light theme"
}

$deltaTheme = Join-Path $Prefix ".config/delta/themes/nothing-light.gitconfig"
if ((Test-Path -LiteralPath $deltaTheme) -and (Get-Command git -ErrorAction SilentlyContinue)) {
  & git config --global --unset-all include.path ([regex]::Escape($deltaTheme)) 2>$null
  $themeEntries = @(& git config -f $deltaTheme --get-regexp "^delta\.nothing-light\.")
  if ($LASTEXITCODE -ne 0 -or $themeEntries.Count -eq 0) {
    throw "Failed to read delta nothing-light theme settings"
  }
  foreach ($entry in $themeEntries) {
    $parts = $entry -split "\s+", 2
    if ($parts.Count -ne 2) {
      throw "Invalid delta theme entry: $entry"
    }
    & git config --global $parts[0] $parts[1]
    if ($LASTEXITCODE -ne 0) { throw "Failed to write $($parts[0]) to global Git config" }
  }
  & git config --global delta.features nothing-light
  if ($LASTEXITCODE -ne 0) { throw "Failed to activate delta nothing-light feature in global Git config" }
  Write-Host "Activated delta nothing-light theme"
}

$ghosttyConfigCandidates = @(
  (Join-Path $env:APPDATA "ghostty/config"),
  (Join-Path $Prefix ".config/ghostty/config")
) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

foreach ($ghosttyConfig in $ghosttyConfigCandidates) {
  if (Test-Path -LiteralPath $ghosttyConfig) {
    $lines = Get-Content -LiteralPath $ghosttyConfig
    $replaced = $false
    $updated = foreach ($line in $lines) {
      if ($line -match '^\s*theme\s*=') {
        $replaced = $true
        "theme = nothing-light"
      } else {
        $line
      }
    }
    if (-not $replaced) {
      $updated += "theme = nothing-light"
    }
    Set-Content -LiteralPath $ghosttyConfig -Value $updated
    Write-Host "Activated Ghostty nothing-light theme in $ghosttyConfig"
    break
  }
}

if ($InstallOnly) {
  return
}

$personalizeKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
New-Item -Path $personalizeKey -Force | Out-Null
New-ItemProperty -Path $personalizeKey -Name AppsUseLightTheme -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty -Path $personalizeKey -Name SystemUsesLightTheme -PropertyType DWord -Value 1 -Force | Out-Null

$desktopKey = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $desktopKey -Name Wallpaper -Value $wallpaperPath
Set-ItemProperty -Path $desktopKey -Name WallpaperStyle -Value "10"
Set-ItemProperty -Path $desktopKey -Name TileWallpaper -Value "0"

Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class Wallpaper {
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
  public static extern bool SystemParametersInfo(int action, int param, string value, int flags);
}
"@

$SPI_SETDESKWALLPAPER = 20
$SPIF_UPDATEINIFILE = 0x01
$SPIF_SENDCHANGE = 0x02

$ok = [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $wallpaperPath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)
if (-not $ok) {
  $errorCode = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
  throw "Failed to set desktop wallpaper. Win32 error: $errorCode"
}

Start-Process -FilePath "RUNDLL32.EXE" -ArgumentList "USER32.DLL,UpdatePerUserSystemParameters" -WindowStyle Hidden -Wait

Write-Host "Applied Windows light mode"
Write-Host "Applied desktop wallpaper"
