#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

component_to_byte() {
  awk -v value="$1" 'BEGIN { printf "%02X", int((value * 255) + 0.5) }'
}

iterm2_background_hex() {
  local file="$1"
  local red green blue

  red="$(plutil -extract 'Background Color.Red Component' raw -o - "$file")"
  green="$(plutil -extract 'Background Color.Green Component' raw -o - "$file")"
  blue="$(plutil -extract 'Background Color.Blue Component' raw -o - "$file")"

  printf "#%s%s%s" "$(component_to_byte "$red")" "$(component_to_byte "$green")" "$(component_to_byte "$blue")"
}

ghostty_background_hex() {
  local file="$1"

  awk -F '=' '
    $1 ~ /^[[:space:]]*#/ || $0 ~ /^[[:space:]]*$/ { next }
    {
      key = $1
      value = $2
      sub(/^[[:space:]]+/, "", key)
      sub(/[[:space:]]+$/, "", key)
      sub(/^[[:space:]]+/, "", value)
      sub(/[[:space:]]+$/, "", value)
      if (key == "background") {
        print value
      }
    }
  ' "$file"
}

tmux_style_background_hex() {
  local file="$1"
  local option="$2"

  awk -v option="$option" '
    $0 ~ "^[[:space:]]*set -g " option "[[:space:]]" {
      if (match($0, /bg=#[0-9A-Fa-f]{6}/)) {
        print substr($0, RSTART + 3, 7)
      }
    }
  ' "$file"
}

nvim_palette_background_hex() {
  local file="$1"

  awk '
    $0 ~ /^[[:space:]]*bg = "#[0-9A-Fa-f]{6}",?$/ {
      gsub(/[",]/, "", $3)
      print $3
      exit
    }
  ' "$file"
}

iterm2_profile_background_hex() {
  local file="$1"
  local red green blue

  red="$(jq -r '.Profiles[0]["Background Color"]["Red Component"]' "$file")"
  green="$(jq -r '.Profiles[0]["Background Color"]["Green Component"]' "$file")"
  blue="$(jq -r '.Profiles[0]["Background Color"]["Blue Component"]' "$file")"

  printf "#%s%s%s" "$(component_to_byte "$red")" "$(component_to_byte "$green")" "$(component_to_byte "$blue")"
}

assert_black_background() {
  local actual="$1"
  local context="$2"

  if [[ "$actual" != "#000000" ]]; then
    echo "${context}: dark terminal background must be #000000, got ${actual}" >&2
    exit 1
  fi
}

assert_black_background \
  "$(iterm2_background_hex "${ROOT_DIR}/home/.config/iterm2/colors/nothing-dark.itermcolors")" \
  "nothing-dark.itermcolors"

assert_black_background \
  "$(iterm2_profile_background_hex "${ROOT_DIR}/home/.config/iterm2/DynamicProfiles/nothing-dark.json")" \
  "nothing-dark.json"

assert_black_background \
  "$(ghostty_background_hex "${ROOT_DIR}/home/.config/ghostty/themes/nothing-dark")" \
  "ghostty nothing-dark"

assert_black_background \
  "$(tmux_style_background_hex "${ROOT_DIR}/home/.config/tmux/themes/nothing-dark.conf" "status-style")" \
  "tmux nothing-dark status-style"

assert_black_background \
  "$(tmux_style_background_hex "${ROOT_DIR}/home/.config/tmux/themes/nothing-dark.conf" "popup-style")" \
  "tmux nothing-dark popup-style"

assert_black_background \
  "$(nvim_palette_background_hex "${ROOT_DIR}/home/.config/nvim/colors/nothing-dark.lua")" \
  "nvim nothing-dark Normal"

echo "Dark terminal background validation passed"
