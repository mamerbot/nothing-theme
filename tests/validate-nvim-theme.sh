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
  file="${ROOT_DIR}/home/.config/nvim/colors/nothing-${variant}.lua"

  [[ -f "$file" ]] || { echo "missing Neovim colorscheme ${file}" >&2; exit 1; }
  assert_contains "$file" "vim.g.colors_name = \"nothing-${variant}\"" "colorscheme name"
  assert_contains "$file" "vim.o.background = \"${variant}\"" "background setting"

  assert_contains "$file" 'local terminal = {' "terminal palette table"
  assert_contains "$file" 'vim.g["terminal_color_" .. (i - 1)] = color' "terminal color assignment"

  for group in \
    Normal \
    Comment \
    String \
    Number \
    Boolean \
    Constant \
    Keyword \
    Function \
    Type \
    Identifier \
    Operator \
    Delimiter \
    Error \
    CursorLine \
    Visual \
    LineNr \
    StatusLine \
    Pmenu \
    FloatBorder \
    DiagnosticError \
    DiffAdd \
    DiffDelete \
    DiffChange; do
    assert_contains "$file" "hl(\"${group}\"" "highlight group ${group}"
  done
done

assert_contains "${ROOT_DIR}/home/.config/nvim/colors/nothing-light.lua" 'hl("Normal", { fg = c.fg, bg = c.bg })' "light Normal background"
assert_contains "${ROOT_DIR}/home/.config/nvim/colors/nothing-dark.lua" 'bg = "#090807"' "dark palette background"
assert_contains "${ROOT_DIR}/home/.config/nvim/colors/nothing-dark.lua" 'hl("Normal", { fg = c.fg, bg = c.bg })' "dark Normal background"

if command -v nvim >/dev/null 2>&1; then
  nvim --headless -u NONE --cmd "set shadafile=NONE" --cmd "set runtimepath^=${ROOT_DIR}/home/.config/nvim" +"colorscheme nothing-light" +qa
  nvim --headless -u NONE --cmd "set shadafile=NONE" --cmd "set runtimepath^=${ROOT_DIR}/home/.config/nvim" +"colorscheme nothing-dark" +qa
fi

echo "Neovim theme validation passed"
