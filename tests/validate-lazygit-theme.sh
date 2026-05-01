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
  file="${ROOT_DIR}/home/.config/lazygit/themes/nothing-${variant}.yml"

  [[ -f "$file" ]] || { echo "missing lazygit theme ${file}" >&2; exit 1; }
  ruby -ryaml -e 'YAML.load_file(ARGV.fetch(0))' "$file"

  for key in \
    activeBorderColor \
    inactiveBorderColor \
    searchingActiveBorderColor \
    optionsTextColor \
    selectedLineBgColor \
    cherryPickedCommitBgColor \
    cherryPickedCommitFgColor \
    unstagedChangesColor \
    defaultFgColor; do
    assert_contains "$file" "    ${key}:" "theme key ${key}"
  done
done

assert_contains "${ROOT_DIR}/home/.config/lazygit/themes/nothing-light.yml" '"#FF4719"' "light active border"
assert_contains "${ROOT_DIR}/home/.config/lazygit/themes/nothing-dark.yml" '"#181614"' "dark selected line color"
assert_contains "${ROOT_DIR}/home/.config/lazygit/themes/nothing-dark.yml" '"#FF4719"' "dark active border"

echo "lazygit theme validation passed"
