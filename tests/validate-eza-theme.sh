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

for variant in light dark; do
  file="${ROOT_DIR}/home/.config/eza/themes/nothing-${variant}.yml"

  [[ -f "$file" ]] || { echo "missing eza theme ${file}" >&2; exit 1; }
  ruby -ryaml -e 'YAML.load_file(ARGV.fetch(0))' "$file"

  for key in colourful filekinds perms size users links git; do
    assert_contains "$file" "${key}:" "top-level key ${key}"
  done

  for role in directory executable broken_symlink; do
    assert_contains "$file" "  ${role}:" "filekind ${role}"
  done

  for git_role in new modified deleted renamed ignored conflicted; do
    assert_contains "$file" "  ${git_role}:" "git role ${git_role}"
  done
done

assert_contains "${ROOT_DIR}/home/.config/eza/themes/nothing-light.yml" '"#1050A0"' "light blue"
assert_contains "${ROOT_DIR}/home/.config/eza/themes/nothing-dark.yml" '"#4A8FD9"' "dark blue"
assert_contains "${ROOT_DIR}/home/.config/eza/themes/nothing-dark.yml" '"#26C6C6"' "dark cyan"

echo "eza theme validation passed"
