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

  allowed_pattern='^(#090807|#E5DDD0|#FF4719|#181614|#5A5248|#E8A030|#FFFFFF|#D71921|#3A3632|#111111|#E8E4DF|#6B6560|#7A4A00|#C0000A)$'

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

assert_contains "${ROOT_DIR}/home/.config/tmux/themes/nothing-light.conf" 'status-style "fg=#111111,bg=#FFFFFF"' "light status background"
assert_contains "${ROOT_DIR}/home/.config/tmux/themes/nothing-dark.conf" 'status-style "fg=#E5DDD0,bg=#090807"' "dark status background"
assert_contains "${ROOT_DIR}/home/.config/tmux/themes/nothing-dark.conf" 'popup-style "fg=#E5DDD0,bg=#090807"' "dark popup background"

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
