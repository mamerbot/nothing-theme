#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

assert_contains() {
  local file="$1"
  local pattern="$2"
  local context="$3"

  if ! grep -Fq "$pattern" "$file"; then
    echo "${file}: missing ${context}: ${pattern}" >&2
    exit 1
  fi
}

assert_palette_only() {
  local file="$1"
  local allowed_pattern

  allowed_pattern='^(#000000|#FFFFFF|#F0F0F0|#E8E8E8|#CCCCCC|#999999|#666666|#1A1A1A|#111111|#222222|#333333|#D71921|#4A9E5C|#D4A843|#007AFF|#5B9BF6|#7A4FA8|#9B6FBF|#2A8FAF|#4A9EC4)$'

  while IFS= read -r color; do
    if ! [[ "$color" =~ $allowed_pattern ]]; then
      echo "${file}: unexpected color ${color}" >&2
      exit 1
    fi
  done < <(grep -Eo '#[0-9A-Fa-f]{6}' "$file" | sort -u)
}

for variant in light dark; do
  file="${ROOT_DIR}/home/.config/tmux/themes/nothing-${variant}.conf"

  [[ -f "$file" ]] || { echo "missing tmux theme ${file}" >&2; exit 1; }

  for option in \
    "status-style" \
    "status-left-style" \
    "status-right-style" \
    "window-status-style" \
    "window-status-current-style" \
    "pane-border-style" \
    "pane-active-border-style" \
    "message-style" \
    "mode-style" \
    "popup-style" \
    "popup-border-style"; do
    count="$(grep -Ec "^[[:space:]]*set -g ${option}[[:space:]]" "$file")"
    if [[ "$count" != "1" ]]; then
      echo "${file}: expected exactly one ${option}, found ${count}" >&2
      exit 1
    fi
  done

  assert_palette_only "$file"
done

assert_contains "${ROOT_DIR}/home/.config/tmux/themes/nothing-light.conf" 'status-style "fg=#1A1A1A,bg=#FFFFFF"' "light status background"
assert_contains "${ROOT_DIR}/home/.config/tmux/themes/nothing-dark.conf" 'status-style "fg=#E8E8E8,bg=#000000"' "dark status background"
assert_contains "${ROOT_DIR}/home/.config/tmux/themes/nothing-dark.conf" 'popup-style "fg=#E8E8E8,bg=#000000"' "dark popup background"

if command -v tmux >/dev/null 2>&1; then
  tmux_tmpdir="${TMPDIR:-/tmp}/nothing-theme-tmux-$$"
  socket="${tmux_tmpdir}/socket"
  mkdir -p "$tmux_tmpdir"
  if tmux -S "$socket" -f /dev/null new-session -d 2>/dev/null && [[ -S "$socket" ]]; then
    tmux -S "$socket" source-file "${ROOT_DIR}/home/.config/tmux/themes/nothing-light.conf"
    tmux -S "$socket" source-file "${ROOT_DIR}/home/.config/tmux/themes/nothing-dark.conf"
    tmux -S "$socket" kill-server
  else
    echo "Skipping optional tmux source check: this environment cannot create a tmux validation socket" >&2
  fi
  rm -rf "$tmux_tmpdir"
fi

echo "tmux theme validation passed"
