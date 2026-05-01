#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXPECTED_THEME_KEYS=(
  background
  cursor-color
  cursor-text
  font-family
  font-size
  foreground
  palette
  selection-background
  selection-foreground
)

assert_eq() {
  local expected="$1"
  local actual="$2"
  local context="$3"

  if [[ "$expected" != "$actual" ]]; then
    echo "${context}: expected ${expected}, got ${actual}" >&2
    exit 1
  fi
}

theme_value() {
  local file="$1"
  local key="$2"
  local value

  value="$(awk -F '=' -v key="$key" '
    $1 ~ /^[[:space:]]*#/ || $0 ~ /^[[:space:]]*$/ { next }
    {
      left = $1
      sub(/^[[:space:]]+/, "", left)
      sub(/[[:space:]]+$/, "", left)
      if (left == key) {
        right = $2
        sub(/^[[:space:]]+/, "", right)
        sub(/[[:space:]]+$/, "", right)
        print right
      }
    }
  ' "$file")"

  if [[ -z "$value" ]]; then
    echo "${file}: missing ${key}" >&2
    exit 1
  fi

  if [[ "$(printf '%s\n' "$value" | wc -l | tr -d ' ')" != "1" ]]; then
    echo "${file}: duplicate ${key}" >&2
    exit 1
  fi

  printf '%s' "$value"
}

palette_value() {
  local file="$1"
  local slot="$2"
  local value

  value="$(awk -F '=' -v slot="$slot" '
    $1 ~ /^[[:space:]]*#/ || $0 ~ /^[[:space:]]*$/ { next }
    {
      left = $1
      right = substr($0, index($0, "=") + 1)
      sub(/^[[:space:]]+/, "", left)
      sub(/[[:space:]]+$/, "", left)
      sub(/^[[:space:]]+/, "", right)
      sub(/[[:space:]]+$/, "", right)
      if (left == "palette") {
        split(right, parts, "=")
        index_key = parts[1]
        color = parts[2]
        sub(/^[[:space:]]+/, "", index_key)
        sub(/[[:space:]]+$/, "", index_key)
        sub(/^[[:space:]]+/, "", color)
        sub(/[[:space:]]+$/, "", color)
        if (index_key == slot) {
          print color
        }
      }
    }
  ' "$file")"

  if [[ -z "$value" ]]; then
    echo "${file}: missing palette ${slot}" >&2
    exit 1
  fi

  if [[ "$(printf '%s\n' "$value" | wc -l | tr -d ' ')" != "1" ]]; then
    echo "${file}: duplicate palette ${slot}" >&2
    exit 1
  fi

  printf '%s' "$value"
}

validate_key_set() {
  local file="$1"
  local actual expected

  actual="$(awk -F '=' '
    $1 ~ /^[[:space:]]*#/ || $0 ~ /^[[:space:]]*$/ { next }
    {
      left = $1
      sub(/^[[:space:]]+/, "", left)
      sub(/[[:space:]]+$/, "", left)
      print left
    }
  ' "$file" | sort -u | tr '\n' ' ')"

  expected="$(printf '%s\n' "${EXPECTED_THEME_KEYS[@]}" | sort -u | tr '\n' ' ')"
  assert_eq "$expected" "$actual" "${file} key set"
}

validate_variant() {
  local variant="$1"
  local file="${ROOT_DIR}/home/.config/ghostty/themes/nothing-${variant}"
  local slot expected_hex key

  validate_key_set "$file"
}

validate_palette() {
  local variant="$1"
  local file="${ROOT_DIR}/home/.config/ghostty/themes/nothing-${variant}"
  local slot expected_hex

  while IFS='|' read -r slot expected_hex; do
    [[ -z "$slot" ]] && continue
    assert_eq "$expected_hex" "$(palette_value "$file" "$slot")" "nothing-${variant} palette ${slot}"
  done
}

validate_special_colors() {
  local variant="$1"
  local file="${ROOT_DIR}/home/.config/ghostty/themes/nothing-${variant}"
  local key expected_hex

  while IFS='|' read -r key expected_hex; do
    [[ -z "$key" ]] && continue
    assert_eq "$expected_hex" "$(theme_value "$file" "$key")" "nothing-${variant} ${key}"
  done
}

validate_variant light
validate_palette light <<'PALETTE'
0|#1A1A1A
1|#D71921
2|#4A9E5C
3|#D4A843
4|#007AFF
5|#7A4FA8
6|#2A8FAF
7|#CCCCCC
8|#666666
9|#D71921
10|#4A9E5C
11|#D4A843
12|#007AFF
13|#7A4FA8
14|#2A8FAF
15|#000000
PALETTE
validate_special_colors light <<'COLORS'
background|#FFFFFF
font-family|"JetBrainsMono Nerd Font Mono"
font-size|16
foreground|#1A1A1A
cursor-color|#000000
cursor-text|#FFFFFF
selection-background|#CCCCCC
selection-foreground|#1A1A1A
COLORS

validate_variant dark
validate_palette dark <<'PALETTE'
0|#000000
1|#D71921
2|#4A9E5C
3|#D4A843
4|#5B9BF6
5|#9B6FBF
6|#4A9EC4
7|#999999
8|#333333
9|#D71921
10|#4A9E5C
11|#D4A843
12|#5B9BF6
13|#9B6FBF
14|#4A9EC4
15|#FFFFFF
PALETTE
validate_special_colors dark <<'COLORS'
background|#000000
font-family|"JetBrainsMono Nerd Font Mono"
font-size|16
foreground|#E8E8E8
cursor-color|#FFFFFF
cursor-text|#000000
selection-background|#333333
selection-foreground|#E8E8E8
COLORS

echo "Ghostty theme validation passed"
