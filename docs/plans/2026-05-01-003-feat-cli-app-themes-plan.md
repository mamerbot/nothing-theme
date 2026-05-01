---
title: "feat: Add CLI app Nothing themes"
type: feat
status: completed
date: 2026-05-01
---

# feat: Add CLI app Nothing themes

## Overview

Add dark and light Nothing theme implementations for tmux, Neovim, eza, delta, and lazygit. Each app should get both `nothing-light` and `nothing-dark` variants, validated against `AGENTS.md`, and wired into the existing `Makefile` install/deploy flow without silently changing user preferences beyond copying managed theme files.

---

## Problem Frame

The repository now has validated terminal themes for iTerm2 and Ghostty, but several common CLI/editor surfaces still lack checked-in Nothing theme artifacts. These apps each use different configuration formats and different activation mechanics, so the implementation needs consistent palette fidelity while respecting each tool's native contract.

---

## Requirements Trace

- R1. Create both light and dark variants for tmux, Neovim, eza, delta, and lazygit.
- R2. Map shared palette roles from `AGENTS.md` consistently: terminal dark backgrounds must be black, invariant red/green/yellow must stay unchanged, and each variant's blue/magenta/cyan must match the spec.
- R3. Preserve app-native activation models instead of forcing one shared format.
- R4. Add validation that parses every generated file and catches missing keys, malformed config, or palette drift.
- R5. Extend `Makefile` with app-specific install/deploy targets plus aggregate validation/install coverage.
- R6. Document app paths, activation snippets, and variant switching guidance in `AGENTS.md`.

**Required app/variant outputs:**

| App | Light | Dark |
|-----|-------|------|
| tmux | `home/.config/tmux/themes/nothing-light.conf` | `home/.config/tmux/themes/nothing-dark.conf` |
| Neovim | `home/.config/nvim/colors/nothing-light.lua` | `home/.config/nvim/colors/nothing-dark.lua` |
| eza | `home/.config/eza/themes/nothing-light.yml` | `home/.config/eza/themes/nothing-dark.yml` |
| delta | `home/.config/delta/themes/nothing-light.gitconfig` | `home/.config/delta/themes/nothing-dark.gitconfig` |
| lazygit | `home/.config/lazygit/themes/nothing-light.yml` | `home/.config/lazygit/themes/nothing-dark.yml` |

---

## Scope Boundaries

- Do not change palette values in `AGENTS.md`.
- Do not replace or rewrite user-owned app configs such as `~/.tmux.conf`, `~/.config/nvim/init.lua`, `~/.gitconfig`, or `~/.config/lazygit/config.yml`.
- Do not add plugin-manager integration for Neovim or tmux.
- Do not implement non-requested apps such as bat, Starship, FZF, or tmux-powerline in this plan.
- Do not make dark variants use `#111111` or `surface` as terminal/editor background unless a specific app surface is not a terminal/editor background; dark base backgrounds must remain `#000000`.

---

## Context & Research

### Relevant Code and Patterns

- `AGENTS.md` is the source of truth for palette roles, ANSI slots, terminal special colors, and syntax highlighting roles.
- `home/.config/iterm2/` and `home/.config/ghostty/` establish the repo pattern: checked-in app artifacts, variant-specific files, and install targets that copy files to expected config locations.
- `tests/validate-iterm2-theme.sh`, `tests/validate-ghostty-theme.sh`, and `tests/validate-dark-backgrounds.sh` establish the validation style: small shell scripts with exact palette assertions.
- `Makefile` already has `validate`, app-specific install targets, and aggregate `install` / `deploy` targets.
- No `docs/solutions/` institutional learnings were present.

### Institutional Learnings

- None found.

### External References

- tmux manual: `https://man7.org/linux/man-pages/man1/tmux.1.html`
- Neovim syntax/color docs: `https://neovim.io/doc/user/syntax/`
- Neovim terminal color docs: `https://neovim.io/doc/user/terminal/`
- eza theme docs: `https://github.com/eza-community/eza-themes`
- delta configuration docs: `https://dandavison.github.io/delta/configuration.html`
- lazygit config docs: `https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md`

---

## Key Technical Decisions

- Keep each app in native config format: tmux `.conf`, Neovim Lua colorschemes, eza YAML, delta gitconfig snippets, and lazygit YAML.
- Install theme files without mutating user activation config: deployment should copy theme artifacts, while `AGENTS.md` documents how to source/select/include them.
- Use separate light/dark files for every app: this makes validation and user selection explicit, and avoids hidden runtime branching in formats that do not natively auto-switch.
- Add app-specific validators plus shared palette guards: per-app validators prove syntax and expected keys; shared checks enforce dark backgrounds and invariant semantic colors across apps.
- Prefer direct checked-in files over a generator for this batch: current scope is five apps and fixed palettes; generation can be introduced later if duplication becomes a maintenance problem.
- Preserve existing aggregate `make` semantics: bare `make` remains validation-only, while `make install` / `make deploy` install all managed themes.

---

## Open Questions

### Resolved During Planning

- Should eza install to a single `theme.yml`? No. eza only auto-loads `theme.yml`, but this repo should install both variants as named files and document how to symlink or copy the desired variant. The install target should not choose a preference.
- Should delta themes be merged into the user's global gitconfig? No. Store snippets under `~/.config/delta/themes/` and document `[include] path = ...` or one-off `git -c include.path=...` usage.
- Should lazygit update the user's active config? No. Store variant snippets under `~/.config/lazygit/themes/`; document how to merge/include per lazygit's config loading behavior or copy into the active config.
- Should Neovim have one `nothing.lua` that switches on `vim.o.background`? No for v1. Create explicit `nothing-light.lua` and `nothing-dark.lua`; a compatibility alias can be considered later if users want `:colorscheme nothing`.

### Deferred to Implementation

- Whether each CLI is installed locally and can run native validation commands. Prefer optional native checks when available, but static validation must not depend on all five tools being installed.
- Exact lazygit config merge/activation ergonomics for the user's local setup. Document a conservative copy/merge snippet rather than mutating live config.

---

## Output Structure

    home/
      .config/
        tmux/
          themes/
            nothing-light.conf
            nothing-dark.conf
        nvim/
          colors/
            nothing-light.lua
            nothing-dark.lua
        eza/
          themes/
            nothing-light.yml
            nothing-dark.yml
        delta/
          themes/
            nothing-light.gitconfig
            nothing-dark.gitconfig
        lazygit/
          themes/
            nothing-light.yml
            nothing-dark.yml
    tests/
      validate-tmux-theme.sh
      validate-nvim-theme.sh
      validate-eza-theme.sh
      validate-delta-theme.sh
      validate-lazygit-theme.sh

---

## Implementation Units

- U1. **Add tmux Themes**

**Goal:** Create tmux light and dark theme files for status line, pane borders, messages, copy-mode, and menu/popup surfaces.

**Requirements:** R1, R2, R3

**Dependencies:** None

**Files:**
- Create: `home/.config/tmux/themes/nothing-light.conf`
- Create: `home/.config/tmux/themes/nothing-dark.conf`
- Test: `tests/validate-tmux-theme.sh`

**Approach:**
- Use tmux commands such as `set -g status-style`, `window-status-style`, `window-status-current-style`, `pane-border-style`, `pane-active-border-style`, `message-style`, `mode-style`, `popup-style`, and `popup-border-style`.
- Map light backgrounds to `#FFFFFF` and dark backgrounds to `#000000`.
- Use muted/border colors for inactive borders, blue for active/focused surfaces, yellow for warnings/activity, red for alerts, and green for success-like indicators where applicable.
- Keep files sourceable via `source-file ~/.config/tmux/themes/nothing-dark.conf`.

**Patterns to follow:**
- tmux manual style option syntax.
- Existing terminal dark-background invariant enforced by `tests/validate-dark-backgrounds.sh`.

**Test scenarios:**
- Happy path: Parse both files and confirm each required tmux option appears exactly once.
- Happy path: Confirm dark `status-style`, `popup-style`, and message surfaces use `bg=#000000` where they set a base background.
- Edge case: Confirm all colors are `#RRGGBB` values from `AGENTS.md`, not named colors or untracked variants.
- Optional native check: If `tmux` is installed, run tmux with an isolated server/config and source each file without errors.

**Verification:**
- Static validator passes and optional tmux source check passes when tmux is available.

---

- U2. **Add Neovim Colorschemes**

**Goal:** Create explicit Lua colorschemes for `nothing-light` and `nothing-dark`.

**Requirements:** R1, R2, R3

**Dependencies:** None

**Files:**
- Create: `home/.config/nvim/colors/nothing-light.lua`
- Create: `home/.config/nvim/colors/nothing-dark.lua`
- Test: `tests/validate-nvim-theme.sh`

**Approach:**
- Use Lua colorscheme files that set `vim.g.colors_name`, `vim.o.background`, terminal color globals `vim.g.terminal_color_0` through `vim.g.terminal_color_15`, and highlight groups via `vim.api.nvim_set_hl`.
- Cover core groups (`Normal`, `Comment`, `String`, `Number`, `Boolean`, `Constant`, `Keyword`, `Function`, `Type`, `Identifier`, `Operator`, `Delimiter`, `Error`) and UI groups (`CursorLine`, `Visual`, `LineNr`, `StatusLine`, `Pmenu`, `FloatBorder`, `Diagnostic*`, `Diff*`).
- Map syntax roles from `AGENTS.md`; comments italic disabled, strings green, numbers yellow, keywords red, functions/properties blue, types/constants/decorators magenta, imports/escapes cyan.
- Ensure dark `Normal` background is `#000000`, not `#111111`.

**Patterns to follow:**
- Neovim docs for colorscheme lookup under `colors/{name}.lua`.
- Neovim docs for `g:terminal_color_x` variables and RGB values.

**Test scenarios:**
- Happy path: Static parse confirms both files set `vim.g.colors_name`, `vim.o.background`, all 16 terminal colors, and required highlight groups.
- Happy path: Dark colorscheme has `Normal` bg `#000000`; light colorscheme has `Normal` bg `#FFFFFF`.
- Edge case: Confirm no dark editor/terminal base group uses `#111111` as `Normal` bg.
- Optional native check: If `nvim` is installed, run headless `:colorscheme nothing-light` and `:colorscheme nothing-dark` from an isolated runtime path.

**Verification:**
- Static validator passes and optional headless Neovim load passes when `nvim` is available.

---

- U3. **Add eza Themes**

**Goal:** Create eza YAML themes for both variants.

**Requirements:** R1, R2, R3

**Dependencies:** None

**Files:**
- Create: `home/.config/eza/themes/nothing-light.yml`
- Create: `home/.config/eza/themes/nothing-dark.yml`
- Test: `tests/validate-eza-theme.sh`

**Approach:**
- Use eza `theme.yml` YAML structure with `colourful: true`, `filekinds`, `perms`, `size`, `users`, `links`, `git`, `git_repo`, `punctuation`, `date`, `header`, and selected file type/extension mappings.
- Use exact hex values rather than ANSI color names to preserve palette fidelity.
- Map directories and links to blue/cyan, executables to green, warnings/size/date/modified to yellow, errors/deleted to red, muted metadata to muted/disabled, and normal files to `fg`.
- Avoid setting background on file entries unless a specific eza UI element needs it; eza should not paint terminal backgrounds.

**Patterns to follow:**
- eza theme docs and current repo YAML validation style.

**Test scenarios:**
- Happy path: Parse both YAML files and confirm required top-level sections exist.
- Happy path: Confirm representative keys map exactly: directory blue, executable green, git deleted red, git modified yellow, symlink cyan.
- Edge case: Confirm no unquoted invalid YAML hex values and no app-unsupported top-level sections.
- Optional native check: If `eza` is installed, run with `EZA_CONFIG_DIR` pointing at a temp config that symlinks each variant as `theme.yml`.

**Verification:**
- YAML/static validator passes and optional eza smoke check passes when eza is available.

---

- U4. **Add delta Themes**

**Goal:** Create delta gitconfig snippets for light and dark diff rendering.

**Requirements:** R1, R2, R3

**Dependencies:** None

**Files:**
- Create: `home/.config/delta/themes/nothing-light.gitconfig`
- Create: `home/.config/delta/themes/nothing-dark.gitconfig`
- Test: `tests/validate-delta-theme.sh`

**Approach:**
- Use gitconfig format with named `[delta "nothing-light"]` and `[delta "nothing-dark"]` sections, plus documented include guidance rather than modifying global git config.
- Set `dark = true` for dark and `light = true` for light where appropriate.
- Configure minus/plus/zero styles, line number styles, file/commit/hunk decorations, syntax theme behavior, and navigate/decorations choices using delta-supported style values.
- Map deletions red, additions green, changed/hunk metadata yellow, file names/functions blue, neutral context to fg/muted, and dark backgrounds to black.

**Patterns to follow:**
- delta docs that configuration lives in git config format and supports named groups of settings/features.

**Test scenarios:**
- Happy path: `git config --file <theme> --get-regexp` parses both snippets.
- Happy path: Confirm each variant contains its named delta section and expected color/style keys.
- Edge case: Confirm style values that contain spaces are quoted where gitconfig requires it.
- Optional native check: If `delta` is installed, run a small sample diff through each config snippet.

**Verification:**
- gitconfig parser validation passes and optional delta smoke check passes when delta is available.

---

- U5. **Add lazygit Themes**

**Goal:** Create lazygit YAML theme snippets for light and dark.

**Requirements:** R1, R2, R3

**Dependencies:** None

**Files:**
- Create: `home/.config/lazygit/themes/nothing-light.yml`
- Create: `home/.config/lazygit/themes/nothing-dark.yml`
- Test: `tests/validate-lazygit-theme.sh`

**Approach:**
- Use lazygit `gui.theme` YAML structure with keys such as `activeBorderColor`, `inactiveBorderColor`, `searchingActiveBorderColor`, `optionsTextColor`, `selectedLineBgColor`, `inactiveViewSelectedLineBgColor`, `cherryPickedCommitBgColor`, `cherryPickedCommitFgColor`, `unstagedChangesColor`, and related diff/stat colors supported by the current config docs.
- Prefer hex color strings when supported; use style attributes like `bold` only where lazygit expects color attribute lists.
- Map active borders/options to blue, inactive borders to muted/border, selected line backgrounds to split, unstaged/removed to red, staged/added to green, modified to yellow, and neutral text to fg.
- Keep snippets theme-only so users can merge them into an existing lazygit config.

**Patterns to follow:**
- lazygit config docs for `gui.theme` keys and color attribute lists.

**Test scenarios:**
- Happy path: Parse both YAML files and confirm `gui.theme` exists with required keys.
- Happy path: Confirm selected line backgrounds use the variant's split color and dark selected line bg is `#333333`.
- Edge case: Confirm no non-theme lazygit settings are introduced.
- Optional native check: If `lazygit` is installed, run config validation or a no-op startup using a temp config file if supported.

**Verification:**
- YAML/static validator passes and optional lazygit smoke check passes when available.

---

- U6. **Extend Validation Suite**

**Goal:** Make `make validate` cover every app theme and shared invariants.

**Requirements:** R2, R4

**Dependencies:** U1, U2, U3, U4, U5

**Files:**
- Create: `tests/validate-tmux-theme.sh`
- Create: `tests/validate-nvim-theme.sh`
- Create: `tests/validate-eza-theme.sh`
- Create: `tests/validate-delta-theme.sh`
- Create: `tests/validate-lazygit-theme.sh`
- Modify: `tests/validate-dark-backgrounds.sh`
- Modify: `Makefile`

**Approach:**
- Add one validator per app so failure messages stay localized.
- Extend dark-background validation to cover tmux, Neovim, and any future terminal/editor dark base surfaces.
- Use built-in tooling where possible: shell/awk/jq/plutil already exist; use `ruby -e` or available YAML tooling only if present and already dependable in the environment.
- Keep optional native app smoke checks non-blocking unless the binary is present.

**Patterns to follow:**
- Existing validation scripts and `Makefile` target style.

**Test scenarios:**
- Happy path: `make validate` runs all app validators and reports every app as passed.
- Error path: Changing a representative palette value in any app causes the relevant validator to fail with the app/key name.
- Error path: A dark base background changed to `#111111` causes `validate-dark-backgrounds.sh` to fail.
- Edge case: Missing optional app binaries do not fail validation; malformed checked-in files still fail.

**Verification:**
- `make validate` passes from a clean checkout with only required shell tooling.

---

- U7. **Add Install/Deploy Targets**

**Goal:** Copy all theme files into app-appropriate config directories without activating variants destructively.

**Requirements:** R3, R5

**Dependencies:** U1, U2, U3, U4, U5, U6

**Files:**
- Modify: `Makefile`

**Approach:**
- Add `install-tmux`, `install-nvim`, `install-eza`, `install-delta`, and `install-lazygit`.
- Add matching `deploy-*` aliases.
- Extend aggregate `install` and `deploy` targets to include the new apps.
- Use `PREFIX` and app-specific override variables like `TMUX_THEME_DIR`, `NVIM_COLOR_DIR`, `EZA_THEME_DIR`, `DELTA_THEME_DIR`, and `LAZYGIT_THEME_DIR`.
- Install named variant files only; do not overwrite active `theme.yml`, `.gitconfig`, `config.yml`, or app root configs.

**Patterns to follow:**
- Existing `install-iterm2`, `install-ghostty`, aggregate `install`, and aggregate `deploy` targets.

**Test scenarios:**
- Happy path: `make -n install PREFIX=<temp-home>` shows every app destination.
- Happy path: `make install PREFIX=<temp-home>` copies all variant files into expected directories.
- Edge case: Re-running install overwrites managed theme files without duplicating them or touching user activation configs.

**Verification:**
- Dry-run and temp-prefix install show expected destination files for all seven currently managed apps.

---

- U8. **Document Usage**

**Goal:** Update `AGENTS.md` with paths, install targets, and activation snippets for all five new app themes.

**Requirements:** R3, R5, R6

**Dependencies:** U1, U2, U3, U4, U5, U7

**Files:**
- Modify: `AGENTS.md`

**Approach:**
- Add concise sections for tmux, Neovim, eza, delta, and lazygit near the existing terminal app sections.
- Include exact file paths and `make install-*` target names.
- Include activation snippets:
  - tmux: `source-file ~/.config/tmux/themes/nothing-dark.conf`
  - Neovim: `vim.cmd.colorscheme("nothing-dark")`
  - eza: symlink/copy desired variant to active `theme.yml`
  - delta: gitconfig include/path guidance
  - lazygit: merge/copy `gui.theme` snippet into active config or use supported config-file workflow
- Preserve the note that bare `make` validates and `make install` / `make deploy` install all managed themes.

**Patterns to follow:**
- Existing iTerm2 and Ghostty documentation sections.

**Test scenarios:**
- Test expectation: none -- documentation-only change.

**Verification:**
- Documented paths and target names match `Makefile` and checked-in files.

---

## System-Wide Impact

- **Interaction graph:** File-based theme artifacts are consumed by each app's config loader; `Makefile` copies files but does not edit active user config.
- **Error propagation:** Validators should fail early with app/key context before install targets copy malformed files.
- **State lifecycle risks:** The main user-state risk is accidentally overwriting active app configs; the plan avoids this by installing named theme artifacts only.
- **API surface parity:** All app themes must preserve palette parity with iTerm2 and Ghostty for shared roles.
- **Integration coverage:** Static validation proves checked-in files; temp-prefix install proves copy targets; optional native app checks add confidence when binaries are available.
- **Unchanged invariants:** Dark terminal/editor backgrounds remain `#000000`; red, green, and yellow remain invariant across light and dark variants.

---

## Risks & Dependencies

| Risk | Mitigation |
|------|------------|
| App config formats differ enough that one validator misses semantic drift | Keep validators app-specific and assert representative semantic mappings per app. |
| Install targets accidentally activate a theme or overwrite user config | Install only named variant files and document activation snippets separately. |
| eza and lazygit theme activation is less direct than terminal themes | Store both variants as reusable snippets/files and document the explicit user selection step. |
| Optional binaries are absent locally | Make static validation authoritative and treat native smoke checks as optional. |
| Dark variants accidentally use surface `#111111` for base backgrounds | Extend `tests/validate-dark-backgrounds.sh` to all terminal/editor base surfaces. |
| Plan scope becomes too broad for a single implementation pass | Keep one U-unit per app plus shared validation/install/docs; defer generator abstraction and non-requested apps. |

---

## Documentation / Operational Notes

- Bare `make` should continue to validate only.
- `make install` and `make deploy` should install all managed themes: iTerm2, Ghostty, tmux, Neovim, eza, delta, and lazygit.
- Activation remains explicit per app so the repository does not surprise the user's active terminal/editor workflow.

---

## Sources & References

- Source spec: `AGENTS.md`
- Existing iTerm2 plan: `docs/plans/2026-05-01-001-feat-iterm2-theme-plan.md`
- Existing Ghostty plan: `docs/plans/2026-05-01-002-feat-ghostty-theme-plan.md`
- tmux manual: `https://man7.org/linux/man-pages/man1/tmux.1.html`
- Neovim syntax/color docs: `https://neovim.io/doc/user/syntax/`
- Neovim terminal docs: `https://neovim.io/doc/user/terminal/`
- eza theme docs: `https://github.com/eza-community/eza-themes`
- delta configuration docs: `https://dandavison.github.io/delta/configuration.html`
- lazygit config docs: `https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md`
