#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

assert_config() {
  local file="$1"
  local key="$2"
  local expected="$3"
  local actual

  actual="$(git config -f "$file" --get "$key")"
  if [[ "$actual" != "$expected" ]]; then
    echo "${file}: expected ${key}=${expected}, got ${actual}" >&2
    exit 1
  fi
}

for variant in light dark; do
  file="${ROOT_DIR}/home/.config/delta/themes/nothing-${variant}.gitconfig"

  [[ -f "$file" ]] || { echo "missing delta theme ${file}" >&2; exit 1; }
  git config -f "$file" --get-regexp "^delta\\.nothing-${variant}\\." >/dev/null

  for key in \
    navigate \
    line-numbers \
    syntax-theme \
    plus-style \
    minus-style \
    zero-style \
    file-style \
    hunk-header-style; do
    git config -f "$file" --get "delta.nothing-${variant}.${key}" >/dev/null
  done
done

assert_config "${ROOT_DIR}/home/.config/delta/themes/nothing-light.gitconfig" "delta.nothing-light.light" "true"
assert_config "${ROOT_DIR}/home/.config/delta/themes/nothing-dark.gitconfig" "delta.nothing-dark.dark" "true"
assert_config "${ROOT_DIR}/home/.config/delta/themes/nothing-dark.gitconfig" "delta.nothing-dark.zero-style" 'syntax #000000 #E8E8E8'

echo "delta theme validation passed"
