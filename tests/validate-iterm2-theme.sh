#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXPECTED_COLOR_COUNT=22
EXPECTED_FONT="JetBrainsMonoNFM-Regular 16"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

component_to_byte() {
  awk -v value="$1" 'BEGIN { printf "%02X", int((value * 255) + 0.5) }'
}

plist_hex() {
  local file="$1"
  local key="$2"
  local red green blue

  red="$(plutil -extract "${key}.Red Component" raw -o - "$file")"
  green="$(plutil -extract "${key}.Green Component" raw -o - "$file")"
  blue="$(plutil -extract "${key}.Blue Component" raw -o - "$file")"

  printf "#%s%s%s" "$(component_to_byte "$red")" "$(component_to_byte "$green")" "$(component_to_byte "$blue")"
}

profile_hex() {
  local file="$1"
  local key="$2"
  local red green blue

  red="$(jq -r --arg key "$key" '.Profiles[0][$key]["Red Component"]' "$file")"
  green="$(jq -r --arg key "$key" '.Profiles[0][$key]["Green Component"]' "$file")"
  blue="$(jq -r --arg key "$key" '.Profiles[0][$key]["Blue Component"]' "$file")"

  printf "#%s%s%s" "$(component_to_byte "$red")" "$(component_to_byte "$green")" "$(component_to_byte "$blue")"
}

assert_eq() {
  local expected="$1"
  local actual="$2"
  local context="$3"

  if [[ "$expected" != "$actual" ]]; then
    echo "${context}: expected ${expected}, got ${actual}" >&2
    exit 1
  fi
}

validate_variant() {
  local variant="$1"
  local profile_name="$2"
  local profile_guid="$3"
  local plist_file="${ROOT_DIR}/home/.config/iterm2/colors/nothing-${variant}.itermcolors"
  local profile_file="${ROOT_DIR}/home/.config/iterm2/DynamicProfiles/nothing-${variant}.json"
  local actual_count actual_profile_count actual_profile_name actual_profile_guid key expected_hex

  plutil -lint "$plist_file" >/dev/null
  plutil -convert xml1 -o /dev/null "$profile_file"
  jq empty "$profile_file"

  actual_count="$(plutil -convert json -o - "$plist_file" | jq 'length')"
  assert_eq "$EXPECTED_COLOR_COUNT" "$actual_count" "nothing-${variant}.itermcolors color count"

  actual_profile_count="$(jq '.Profiles | length' "$profile_file")"
  assert_eq "1" "$actual_profile_count" "nothing-${variant}.json profile count"

  actual_profile_name="$(jq -r '.Profiles[0].Name' "$profile_file")"
  assert_eq "$profile_name" "$actual_profile_name" "nothing-${variant}.json profile name"
  actual_profile_guid="$(jq -r '.Profiles[0].Guid' "$profile_file")"
  assert_eq "$profile_guid" "$actual_profile_guid" "nothing-${variant}.json profile guid"
  assert_eq "$EXPECTED_FONT" "$(jq -r '.Profiles[0]["Normal Font"]' "$profile_file")" "nothing-${variant}.json normal font"
  assert_eq "$EXPECTED_FONT" "$(jq -r '.Profiles[0]["Non Ascii Font"]' "$profile_file")" "nothing-${variant}.json non-ascii font"

  actual_profile_count="$(jq '[.Profiles[0] | keys[] | select(test(" Color$"))] | length' "$profile_file")"
  assert_eq "$EXPECTED_COLOR_COUNT" "$actual_profile_count" "nothing-${variant}.json color count"

  while IFS='|' read -r key expected_hex; do
    [[ -z "$key" ]] && continue
    assert_eq "$expected_hex" "$(plist_hex "$plist_file" "$key")" "nothing-${variant}.itermcolors ${key}"
    assert_eq "$expected_hex" "$(profile_hex "$profile_file" "$key")" "nothing-${variant}.json ${key}"
    assert_eq "$(plist_hex "$plist_file" "$key")" "$(profile_hex "$profile_file" "$key")" "nothing-${variant} preset/profile ${key}"
  done
}

require_command plutil
require_command jq
require_command awk

validate_variant light "Nothing Light" "DE7935C0-F723-4730-8EB2-4583C861CDCA" <<'COLORS'
Ansi 0 Color|#1A1A1A
Ansi 1 Color|#D71921
Ansi 2 Color|#4A9E5C
Ansi 3 Color|#D4A843
Ansi 4 Color|#007AFF
Ansi 5 Color|#7A4FA8
Ansi 6 Color|#2A8FAF
Ansi 7 Color|#CCCCCC
Ansi 8 Color|#666666
Ansi 9 Color|#D71921
Ansi 10 Color|#4A9E5C
Ansi 11 Color|#D4A843
Ansi 12 Color|#007AFF
Ansi 13 Color|#7A4FA8
Ansi 14 Color|#2A8FAF
Ansi 15 Color|#000000
Background Color|#FFFFFF
Foreground Color|#1A1A1A
Cursor Color|#000000
Cursor Text Color|#FFFFFF
Selection Color|#CCCCCC
Selected Text Color|#1A1A1A
COLORS

validate_variant dark "Nothing Dark" "9E60CD40-829B-4DC6-8FB8-051E95498C2C" <<'COLORS'
Ansi 0 Color|#000000
Ansi 1 Color|#D71921
Ansi 2 Color|#4A9E5C
Ansi 3 Color|#D4A843
Ansi 4 Color|#5B9BF6
Ansi 5 Color|#9B6FBF
Ansi 6 Color|#4A9EC4
Ansi 7 Color|#999999
Ansi 8 Color|#333333
Ansi 9 Color|#D71921
Ansi 10 Color|#4A9E5C
Ansi 11 Color|#D4A843
Ansi 12 Color|#5B9BF6
Ansi 13 Color|#9B6FBF
Ansi 14 Color|#4A9EC4
Ansi 15 Color|#FFFFFF
Background Color|#000000
Foreground Color|#E8E8E8
Cursor Color|#FFFFFF
Cursor Text Color|#000000
Selection Color|#333333
Selected Text Color|#E8E8E8
COLORS

echo "iTerm2 theme validation passed"
