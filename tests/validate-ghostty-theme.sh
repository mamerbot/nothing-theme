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
0|#111111
1|#C0000A
2|#1E6B3C
3|#7A4A00
4|#1050A0
5|#5A2D9A
6|#006E6E
7|#3A3530
8|#555050
9|#E8001A
10|#2A8A50
11|#9A5E00
12|#1A6ACC
13|#7A40C0
14|#008A8A
15|#6B6560
PALETTE
validate_special_colors light <<'COLORS'
background|#FFFFFF
font-family|"SpaceMono Nerd Font Mono"
font-size|24
foreground|#111111
cursor-color|#FF4719
cursor-text|#FFFFFF
selection-background|#E8E4DF
selection-foreground|#111111
COLORS

validate_variant dark
validate_palette dark <<'PALETTE'
0|#181614
1|#D71921
2|#5AB87A
3|#E8A030
4|#4A8FD9
5|#9575CD
6|#26C6C6
7|#E5DDD0
8|#3A3632
9|#FF3B3B
10|#7DD89A
11|#FFB84D
12|#70ADEC
13|#B39DDB
14|#4DD9D9
15|#FFFFFF
PALETTE
validate_special_colors dark <<'COLORS'
background|#090807
font-family|"SpaceMono Nerd Font Mono"
font-size|24
foreground|#E5DDD0
cursor-color|#FF4719
cursor-text|#090807
selection-background|#1D1A17
selection-foreground|#E5DDD0
COLORS

echo "Ghostty theme validation passed"
