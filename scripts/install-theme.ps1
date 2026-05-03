param(
  [string]$Prefix = "",
  [string[]]$Targets = @("iterm2", "ghostty", "tmux", "nvim", "eza", "delta", "lazygit")
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($Prefix)) {
  $Prefix = if ($env:HOME) { $env:HOME } else { $env:USERPROFILE }
}

$TargetSet = New-Object "System.Collections.Generic.HashSet[string]" ([StringComparer]::OrdinalIgnoreCase)
foreach ($target in $Targets) {
  foreach ($part in ($target -split ",")) {
    $trimmed = $part.Trim()
    if ($trimmed) {
      [void]$TargetSet.Add($trimmed)
    }
  }
}

function Copy-ThemeFiles {
  param(
    [string]$Name,
    [string]$Destination,
    [string[]]$Sources
  )

  New-Item -ItemType Directory -Force -Path $Destination | Out-Null
  foreach ($source in $Sources) {
    Copy-Item -LiteralPath (Join-Path $RepoRoot $source) -Destination $Destination -Force
  }
  Write-Host "Installed $Name to $Destination"
}

if ($TargetSet.Contains("iterm2")) {
  $configDir = Join-Path $Prefix ".config/iterm2"
  Copy-ThemeFiles "iTerm2 color presets" (Join-Path $configDir "colors") @(
    "home/.config/iterm2/colors/nothing-light.itermcolors",
    "home/.config/iterm2/colors/nothing-dark.itermcolors"
  )
  Copy-ThemeFiles "iTerm2 Dynamic Profiles" (Join-Path $Prefix "Library/Application Support/iTerm2/DynamicProfiles") @(
    "home/.config/iterm2/DynamicProfiles/nothing-light.json",
    "home/.config/iterm2/DynamicProfiles/nothing-dark.json"
  )
}

if ($TargetSet.Contains("ghostty")) {
  Copy-ThemeFiles "Ghostty themes" (Join-Path $Prefix ".config/ghostty/themes") @(
    "home/.config/ghostty/themes/nothing-light",
    "home/.config/ghostty/themes/nothing-dark"
  )
}

if ($TargetSet.Contains("tmux")) {
  Copy-ThemeFiles "tmux themes" (Join-Path $Prefix ".config/tmux/themes") @(
    "home/.config/tmux/themes/nothing-light.conf",
    "home/.config/tmux/themes/nothing-dark.conf"
  )
}

if ($TargetSet.Contains("nvim")) {
  Copy-ThemeFiles "Neovim colorschemes" (Join-Path $Prefix ".config/nvim/colors") @(
    "home/.config/nvim/colors/nothing-light.lua",
    "home/.config/nvim/colors/nothing-dark.lua"
  )
}

if ($TargetSet.Contains("eza")) {
  Copy-ThemeFiles "eza themes" (Join-Path $Prefix ".config/eza/themes") @(
    "home/.config/eza/themes/nothing-light.yml",
    "home/.config/eza/themes/nothing-dark.yml"
  )
}

if ($TargetSet.Contains("delta")) {
  Copy-ThemeFiles "delta themes" (Join-Path $Prefix ".config/delta/themes") @(
    "home/.config/delta/themes/nothing-light.gitconfig",
    "home/.config/delta/themes/nothing-dark.gitconfig"
  )
}

if ($TargetSet.Contains("lazygit")) {
  Copy-ThemeFiles "lazygit themes" (Join-Path $Prefix ".config/lazygit/themes") @(
    "home/.config/lazygit/themes/nothing-light.yml",
    "home/.config/lazygit/themes/nothing-dark.yml"
  )
}
