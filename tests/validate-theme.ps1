$ErrorActionPreference = "Stop"

$RootDir = Split-Path -Parent $PSScriptRoot
$ExpectedColorCount = 22
$ExpectedFont = "JetBrainsMonoNFM 24"

function Fail($Message) {
  throw $Message
}

function Assert-Eq($Expected, $Actual, $Context) {
  if ("$Expected" -ne "$Actual") {
    Fail "${Context}: expected ${Expected}, got ${Actual}"
  }
}

function Assert-Contains($File, $Pattern, $Context) {
  $text = Get-Content -LiteralPath $File -Raw
  if (-not $text.Contains($Pattern)) {
    Fail "${File}: missing ${Context}: ${Pattern}"
  }
}

function Component-ToByte($Value) {
  return [int][Math]::Floor(([double]$Value * 255) + 0.5)
}

function Color-ToHex($Color) {
  return "#{0:X2}{1:X2}{2:X2}" -f `
    (Component-ToByte $Color."Red Component"), `
    (Component-ToByte $Color."Green Component"), `
    (Component-ToByte $Color."Blue Component")
}

function Convert-PlistDict($DictNode) {
  $elements = @($DictNode.ChildNodes | Where-Object { $_.NodeType -eq [System.Xml.XmlNodeType]::Element })
  $result = @{}
  for ($i = 0; $i -lt $elements.Count; $i += 2) {
    $keyNode = $elements[$i]
    $valueNode = $elements[$i + 1]
    if ($keyNode.Name -ne "key") {
      Fail "plist parse error: expected key, got $($keyNode.Name)"
    }

    if ($valueNode.Name -eq "dict") {
      $result[$keyNode.InnerText] = Convert-PlistDict $valueNode
    } else {
      $result[$keyNode.InnerText] = $valueNode.InnerText
    }
  }
  return $result
}

function Read-Plist($File) {
  [xml]$xml = Get-Content -LiteralPath $File -Raw
  return Convert-PlistDict $xml.plist.dict
}

function Read-KvFile($File) {
  $values = @{}
  foreach ($line in Get-Content -LiteralPath $File) {
    $trimmed = $line.Trim()
    if (-not $trimmed -or $trimmed.StartsWith("#")) {
      continue
    }

    $parts = $line -split "=", 2
    if ($parts.Count -ne 2) {
      Fail "${File}: invalid setting line: ${line}"
    }

    $key = $parts[0].Trim()
    $value = $parts[1].Trim()
    if (-not $values.ContainsKey($key)) {
      $values[$key] = @()
    }
    $values[$key] += $value
  }
  return $values
}

function Get-SingleValue($Values, $Key, $File) {
  if (-not $Values.ContainsKey($Key)) {
    Fail "${File}: missing ${Key}"
  }
  if ($Values[$Key].Count -ne 1) {
    Fail "${File}: duplicate ${Key}"
  }
  return $Values[$Key][0]
}

function Validate-ItermVariant($Variant, $ProfileName, $ProfileGuid, $ExpectedColors) {
  $plistFile = Join-Path $RootDir "home/.config/iterm2/colors/nothing-${Variant}.itermcolors"
  $profileFile = Join-Path $RootDir "home/.config/iterm2/DynamicProfiles/nothing-${Variant}.json"

  $plist = Read-Plist $plistFile
  $profileJson = Get-Content -LiteralPath $profileFile -Raw | ConvertFrom-Json
  Assert-Eq 1 $profileJson.Profiles.Count "nothing-${Variant}.json profile count"
  $profile = $profileJson.Profiles[0]

  $plistColorCount = @($plist.Keys | Where-Object { $_ -like "* Color" }).Count
  Assert-Eq $ExpectedColorCount $plistColorCount "nothing-${Variant}.itermcolors color count"
  Assert-Eq $ProfileName $profile.Name "nothing-${Variant}.json profile name"
  Assert-Eq $ProfileGuid $profile.Guid "nothing-${Variant}.json profile guid"
  Assert-Eq $ExpectedFont $profile."Normal Font" "nothing-${Variant}.json normal font"
  Assert-Eq $ExpectedFont $profile."Non Ascii Font" "nothing-${Variant}.json non-ascii font"

  $profileColorCount = @($profile.PSObject.Properties.Name | Where-Object { $_ -like "* Color" }).Count
  Assert-Eq $ExpectedColorCount $profileColorCount "nothing-${Variant}.json color count"

  foreach ($entry in $ExpectedColors.GetEnumerator()) {
    $plistHex = Color-ToHex $plist[$entry.Key]
    $profileHex = Color-ToHex $profile.PSObject.Properties[$entry.Key].Value
    Assert-Eq $entry.Value $plistHex "nothing-${Variant}.itermcolors $($entry.Key)"
    Assert-Eq $entry.Value $profileHex "nothing-${Variant}.json $($entry.Key)"
    Assert-Eq $plistHex $profileHex "nothing-${Variant} preset/profile $($entry.Key)"
  }
}

function Validate-GhosttyVariant($Variant, $ExpectedPalette, $ExpectedColors) {
  $file = Join-Path $RootDir "home/.config/ghostty/themes/nothing-${Variant}"
  $values = Read-KvFile $file
  $expectedKeys = @("background", "cursor-color", "cursor-text", "font-family", "font-size", "foreground", "palette", "selection-background", "selection-foreground") | Sort-Object
  $actualKeys = @($values.Keys) | Sort-Object
  Assert-Eq ($expectedKeys -join " ") ($actualKeys -join " ") "${file} key set"

  foreach ($entry in $ExpectedColors.GetEnumerator()) {
    Assert-Eq $entry.Value (Get-SingleValue $values $entry.Key $file) "nothing-${Variant} $($entry.Key)"
  }

  $palette = @{}
  foreach ($line in $values["palette"]) {
    $parts = $line -split "=", 2
    $palette[$parts[0].Trim()] = $parts[1].Trim()
  }
  foreach ($entry in $ExpectedPalette.GetEnumerator()) {
    Assert-Eq $entry.Value $palette[$entry.Key] "nothing-${Variant} palette $($entry.Key)"
  }
}

function Validate-Tmux {
  $allowed = "^(#090807|#E5DDD0|#FF4719|#181614|#5A5248|#E8A030|#FFFFFF|#D71921|#3A3632|#111111|#E8E4DF|#6B6560|#7A4A00|#C0000A)$"
  foreach ($variant in @("light", "dark")) {
    $file = Join-Path $RootDir "home/.config/tmux/themes/nothing-${variant}.conf"
    if (-not (Test-Path -LiteralPath $file)) { Fail "missing tmux theme ${file}" }
    foreach ($option in @("status-style", "status-left-style", "status-right-style", "window-status-style", "window-status-current-style", "pane-border-style", "pane-active-border-style", "message-style", "mode-style", "popup-style", "popup-border-style")) {
      $count = @(Select-String -LiteralPath $file -Pattern "^\s*set -g ${option}\s").Count
      Assert-Eq 1 $count "${file} ${option}"
    }
    $colors = [regex]::Matches((Get-Content -LiteralPath $file -Raw), "#[0-9A-Fa-f]{6}") | ForEach-Object { $_.Value } | Sort-Object -Unique
    foreach ($color in $colors) {
      if ($color -notmatch $allowed) { Fail "${file}: unexpected color ${color}" }
    }
  }
  Assert-Contains (Join-Path $RootDir "home/.config/tmux/themes/nothing-light.conf") 'status-style "fg=#111111,bg=#FFFFFF"' "light status background"
  Assert-Contains (Join-Path $RootDir "home/.config/tmux/themes/nothing-dark.conf") 'status-style "fg=#E5DDD0,bg=#090807"' "dark status background"
  Assert-Contains (Join-Path $RootDir "home/.config/tmux/themes/nothing-dark.conf") 'popup-style "fg=#E5DDD0,bg=#090807"' "dark popup background"
}

function Validate-Nvim {
  foreach ($variant in @("light", "dark")) {
    $file = Join-Path $RootDir "home/.config/nvim/colors/nothing-${variant}.lua"
    if (-not (Test-Path -LiteralPath $file)) { Fail "missing Neovim colorscheme ${file}" }
    Assert-Contains $file "vim.g.colors_name = `"nothing-${variant}`"" "colorscheme name"
    Assert-Contains $file "vim.o.background = `"${variant}`"" "background setting"
    Assert-Contains $file 'local terminal = {' "terminal palette table"
    Assert-Contains $file 'vim.g["terminal_color_" .. (i - 1)] = color' "terminal color assignment"
    foreach ($group in @("Normal", "Comment", "String", "Number", "Boolean", "Constant", "Keyword", "Function", "Type", "Identifier", "Operator", "Delimiter", "Error", "CursorLine", "Visual", "LineNr", "StatusLine", "Pmenu", "FloatBorder", "DiagnosticError", "DiffAdd", "DiffDelete", "DiffChange")) {
      Assert-Contains $file "hl(`"${group}`"" "highlight group ${group}"
    }
  }
  Assert-Contains (Join-Path $RootDir "home/.config/nvim/colors/nothing-light.lua") 'hl("Normal", { fg = c.fg, bg = c.bg })' "light Normal background"
  Assert-Contains (Join-Path $RootDir "home/.config/nvim/colors/nothing-dark.lua") 'bg = "#090807"' "dark palette background"
}

function Validate-Eza {
  foreach ($variant in @("light", "dark")) {
    $file = Join-Path $RootDir "home/.config/eza/themes/nothing-${variant}.yml"
    if (-not (Test-Path -LiteralPath $file)) { Fail "missing eza theme ${file}" }
    foreach ($key in @("colourful", "filekinds", "perms", "size", "users", "links", "git")) {
      Assert-Contains $file "${key}:" "top-level key ${key}"
    }
    foreach ($role in @("directory", "executable", "broken_symlink")) {
      Assert-Contains $file "  ${role}:" "filekind ${role}"
    }
    foreach ($role in @("new", "modified", "deleted", "renamed", "ignored", "conflicted")) {
      Assert-Contains $file "  ${role}:" "git role ${role}"
    }
  }
  Assert-Contains (Join-Path $RootDir "home/.config/eza/themes/nothing-light.yml") '"#1050A0"' "light blue"
  Assert-Contains (Join-Path $RootDir "home/.config/eza/themes/nothing-dark.yml") '"#4A8FD9"' "dark blue"
  Assert-Contains (Join-Path $RootDir "home/.config/eza/themes/nothing-dark.yml") '"#26C6C6"' "dark cyan"
}

function Validate-Delta {
  foreach ($variant in @("light", "dark")) {
    $file = Join-Path $RootDir "home/.config/delta/themes/nothing-${variant}.gitconfig"
    if (-not (Test-Path -LiteralPath $file)) { Fail "missing delta theme ${file}" }
    foreach ($key in @("navigate", "line-numbers", "syntax-theme", "plus-style", "minus-style", "zero-style", "file-style", "hunk-header-style")) {
      $value = & git config -f $file --get "delta.nothing-${variant}.${key}"
      if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($value)) {
        Fail "${file}: missing delta.nothing-${variant}.${key}"
      }
    }
  }
  Assert-Eq "true" (& git config -f (Join-Path $RootDir "home/.config/delta/themes/nothing-light.gitconfig") --get "delta.nothing-light.light") "delta light mode"
  Assert-Eq "true" (& git config -f (Join-Path $RootDir "home/.config/delta/themes/nothing-dark.gitconfig") --get "delta.nothing-dark.dark") "delta dark mode"
  Assert-Eq "syntax #090807 #E5DDD0" (& git config -f (Join-Path $RootDir "home/.config/delta/themes/nothing-dark.gitconfig") --get "delta.nothing-dark.zero-style") "delta dark zero-style"
}

function Validate-Lazygit {
  foreach ($variant in @("light", "dark")) {
    $file = Join-Path $RootDir "home/.config/lazygit/themes/nothing-${variant}.yml"
    if (-not (Test-Path -LiteralPath $file)) { Fail "missing lazygit theme ${file}" }
    foreach ($key in @("activeBorderColor", "inactiveBorderColor", "searchingActiveBorderColor", "optionsTextColor", "selectedLineBgColor", "cherryPickedCommitBgColor", "cherryPickedCommitFgColor", "unstagedChangesColor", "defaultFgColor")) {
      Assert-Contains $file "    ${key}:" "theme key ${key}"
    }
  }
  Assert-Contains (Join-Path $RootDir "home/.config/lazygit/themes/nothing-light.yml") '"#FF4719"' "light active border"
  Assert-Contains (Join-Path $RootDir "home/.config/lazygit/themes/nothing-dark.yml") '"#181614"' "dark selected line color"
  Assert-Contains (Join-Path $RootDir "home/.config/lazygit/themes/nothing-dark.yml") '"#FF4719"' "dark active border"
}

function Validate-DarkBackgrounds {
  $expected = "#090807"
  $darkPlist = Read-Plist (Join-Path $RootDir "home/.config/iterm2/colors/nothing-dark.itermcolors")
  Assert-Eq $expected (Color-ToHex $darkPlist["Background Color"]) "nothing-dark.itermcolors"
  $profile = (Get-Content -LiteralPath (Join-Path $RootDir "home/.config/iterm2/DynamicProfiles/nothing-dark.json") -Raw | ConvertFrom-Json).Profiles[0]
  Assert-Eq $expected (Color-ToHex $profile."Background Color") "nothing-dark.json"
  $ghostty = Read-KvFile (Join-Path $RootDir "home/.config/ghostty/themes/nothing-dark")
  Assert-Eq $expected (Get-SingleValue $ghostty "background" "ghostty nothing-dark") "ghostty nothing-dark"
  $tmux = Get-Content -LiteralPath (Join-Path $RootDir "home/.config/tmux/themes/nothing-dark.conf") -Raw
  if ($tmux -notmatch 'status-style "fg=#E5DDD0,bg=#090807"') { Fail "tmux nothing-dark status-style: dark terminal background must be ${expected}" }
  if ($tmux -notmatch 'popup-style "fg=#E5DDD0,bg=#090807"') { Fail "tmux nothing-dark popup-style: dark terminal background must be ${expected}" }
  Assert-Contains (Join-Path $RootDir "home/.config/nvim/colors/nothing-dark.lua") 'bg = "#090807"' "nvim nothing-dark Normal"
}

$lightColors = [ordered]@{
  "Ansi 0 Color" = "#111111"; "Ansi 1 Color" = "#C0000A"; "Ansi 2 Color" = "#1E6B3C"; "Ansi 3 Color" = "#7A4A00";
  "Ansi 4 Color" = "#1050A0"; "Ansi 5 Color" = "#5A2D9A"; "Ansi 6 Color" = "#006E6E"; "Ansi 7 Color" = "#3A3530";
  "Ansi 8 Color" = "#555050"; "Ansi 9 Color" = "#E8001A"; "Ansi 10 Color" = "#2A8A50"; "Ansi 11 Color" = "#9A5E00";
  "Ansi 12 Color" = "#1A6ACC"; "Ansi 13 Color" = "#7A40C0"; "Ansi 14 Color" = "#008A8A"; "Ansi 15 Color" = "#6B6560";
  "Background Color" = "#FFFFFF"; "Foreground Color" = "#111111"; "Cursor Color" = "#FF4719"; "Cursor Text Color" = "#FFFFFF";
  "Selection Color" = "#E8E4DF"; "Selected Text Color" = "#111111"
}
$darkColors = [ordered]@{
  "Ansi 0 Color" = "#181614"; "Ansi 1 Color" = "#D71921"; "Ansi 2 Color" = "#5AB87A"; "Ansi 3 Color" = "#E8A030";
  "Ansi 4 Color" = "#4A8FD9"; "Ansi 5 Color" = "#9575CD"; "Ansi 6 Color" = "#26C6C6"; "Ansi 7 Color" = "#E5DDD0";
  "Ansi 8 Color" = "#3A3632"; "Ansi 9 Color" = "#FF3B3B"; "Ansi 10 Color" = "#7DD89A"; "Ansi 11 Color" = "#FFB84D";
  "Ansi 12 Color" = "#70ADEC"; "Ansi 13 Color" = "#B39DDB"; "Ansi 14 Color" = "#4DD9D9"; "Ansi 15 Color" = "#FFFFFF";
  "Background Color" = "#090807"; "Foreground Color" = "#E5DDD0"; "Cursor Color" = "#FF4719"; "Cursor Text Color" = "#090807";
  "Selection Color" = "#1D1A17"; "Selected Text Color" = "#E5DDD0"
}

Validate-ItermVariant "light" "Nothing Light" "DE7935C0-F723-4730-8EB2-4583C861CDCA" $lightColors
Write-Host "iTerm2 light validation passed"
Validate-ItermVariant "dark" "Nothing Dark" "9E60CD40-829B-4DC6-8FB8-051E95498C2C" $darkColors
Write-Host "iTerm2 dark validation passed"
Validate-GhosttyVariant "light" ([ordered]@{"0"="#111111";"1"="#C0000A";"2"="#1E6B3C";"3"="#7A4A00";"4"="#1050A0";"5"="#5A2D9A";"6"="#006E6E";"7"="#3A3530";"8"="#555050";"9"="#E8001A";"10"="#2A8A50";"11"="#9A5E00";"12"="#1A6ACC";"13"="#7A40C0";"14"="#008A8A";"15"="#6B6560"}) ([ordered]@{"background"="#FFFFFF";"font-family"='"JetBrainsMono Nerd Font Mono"';"font-size"="24";"foreground"="#111111";"cursor-color"="#FF4719";"cursor-text"="#FFFFFF";"selection-background"="#E8E4DF";"selection-foreground"="#111111"})
Validate-GhosttyVariant "dark" ([ordered]@{"0"="#181614";"1"="#D71921";"2"="#5AB87A";"3"="#E8A030";"4"="#4A8FD9";"5"="#9575CD";"6"="#26C6C6";"7"="#E5DDD0";"8"="#3A3632";"9"="#FF3B3B";"10"="#7DD89A";"11"="#FFB84D";"12"="#70ADEC";"13"="#B39DDB";"14"="#4DD9D9";"15"="#FFFFFF"}) ([ordered]@{"background"="#090807";"font-family"='"JetBrainsMono Nerd Font Mono"';"font-size"="24";"foreground"="#E5DDD0";"cursor-color"="#FF4719";"cursor-text"="#090807";"selection-background"="#1D1A17";"selection-foreground"="#E5DDD0"})
Write-Host "Ghostty theme validation passed"
Validate-Tmux
Write-Host "tmux theme validation passed"
Validate-Nvim
Write-Host "Neovim theme validation passed"
Validate-Eza
Write-Host "eza theme validation passed"
Validate-Delta
Write-Host "delta theme validation passed"
Validate-Lazygit
Write-Host "lazygit theme validation passed"
Validate-DarkBackgrounds
Write-Host "Dark terminal background validation passed"
