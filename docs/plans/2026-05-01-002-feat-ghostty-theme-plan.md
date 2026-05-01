---
title: "feat: Add Ghostty Nothing themes"
type: feat
status: completed
date: 2026-05-01
---

# feat: Add Ghostty Nothing themes

## Overview

Add Ghostty theme files for both required Nothing variants: `nothing-light` and `nothing-dark`. Each theme should be loadable by name from Ghostty's custom theme lookup directory and should map the palette values in `AGENTS.md` to Ghostty's documented theme keys.

---

## Problem Frame

`AGENTS.md` defines a complete light and dark terminal palette and originally listed Ghostty as an intended implementation target, but the repository currently has no Ghostty theme files. Ghostty users need checked-in theme files plus validation and install/deploy targets equivalent to the iTerm2 workflow.

---

## Requirements Trace

- R1. Create Ghostty theme files for both `nothing-light` and `nothing-dark`.
- R2. Encode ANSI palette slots 0-15 exactly from the `AGENTS.md` terminal palette tables.
- R3. Encode terminal special colors exactly from `AGENTS.md`: background, foreground, cursor color, cursor text, selection background, and selection foreground.
- R4. Store themes in Ghostty's name-discoverable repo layout: `home/.config/ghostty/themes/`.
- R5. Add validation so malformed theme files, missing keys, or palette drift can be caught locally.
- R6. Add install/deploy support so themes can be copied to `~/.config/ghostty/themes/` and selected by name.
- R7. Document how to use one variant directly or configure Ghostty's light/dark auto-switching.

**Required variants:**

| Variant | Theme file | Palette source |
|---------|------------|----------------|
| Light | `home/.config/ghostty/themes/nothing-light` | `AGENTS.md` / `Nothing Light` |
| Dark | `home/.config/ghostty/themes/nothing-dark` | `AGENTS.md` / `Nothing Dark` |

---

## Scope Boundaries

- Do not change the palette values, semantic color roles, or design principles in `AGENTS.md`.
- Do not mutate a user's Ghostty `config.ghostty` automatically; installation should deploy theme files only.
- Do not add Ghostty font, window, keybinding, shell integration, or app behavior settings to the theme files.
- Do not implement other applications listed in `AGENTS.md`; this plan is Ghostty-only.

---

## Context & Research

### Relevant Code and Patterns

- `AGENTS.md` is the source of truth for light/dark ANSI slots and terminal special colors.
- `home/.config/iterm2/` shows the current pattern for checked-in terminal theme artifacts.
- `tests/validate-iterm2-theme.sh` and `Makefile` show the existing validation/install pattern to mirror for Ghostty.
- No `home/.config/ghostty/` tree exists yet.
- No `docs/solutions/` institutional learnings were found.

### Institutional Learnings

- None found.

### External References

- Ghostty Color Theme docs: `https://ghostty.org/docs/features/theme`
- Ghostty Configuration docs: `https://ghostty.org/docs/config`
- Ghostty Configuration Reference for `theme` and `palette`: `https://ghostty.org/docs/config/reference`

---

## Key Technical Decisions

- Use extensionless theme file names `nothing-light` and `nothing-dark`: Ghostty looks up custom themes by file name under `$XDG_CONFIG_HOME/ghostty/themes` or `~/.config/ghostty/themes`, so the file names should match the desired `theme = nothing-light` and `theme = nothing-dark` values.
- Keep Ghostty theme files color-only: Upstream warns themes can set any configuration option; these files should only set palette and special color keys.
- Use Ghostty's documented key syntax directly: `palette = N=#RRGGBB`, `background`, `foreground`, `cursor-color`, `cursor-text`, `selection-background`, and `selection-foreground`.
- Add Ghostty-specific validation rather than generalizing too early: The current repo only has iTerm2 plus planned Ghostty, so a focused shell validator keeps scope low while still catching drift.
- Extend `Makefile` with Ghostty targets: Mirror `install-iterm2` with `install-ghostty` and `deploy-ghostty`, plus include Ghostty validation under `make validate`.

---

## Open Questions

### Resolved During Planning

- Should both light and dark variants be included? Yes. The request explicitly asks for Ghostty dark and light themes, and `AGENTS.md` defines both.
- Should the install target edit Ghostty config to select the theme? No. Theme file deployment is safe and reversible; selecting a theme is user preference and should be documented.
- Should themes include `palette-generate`? No. The Nothing spec defines only ANSI 0-15, and Ghostty's default extended palette behavior should not be changed unless the user asks.

### Deferred to Implementation

- Whether Ghostty is installed locally and can run `ghostty +list-themes`: Use it as an optional verification step if available; static validation should not depend on Ghostty being installed.

---

## Output Structure

    home/
      .config/
        ghostty/
          themes/
            nothing-light
            nothing-dark
    tests/
      validate-ghostty-theme.sh
    Makefile

---

## Implementation Units

- U1. **Add Ghostty Theme Files**

**Goal:** Create `nothing-light` and `nothing-dark` Ghostty theme files with exact Nothing palette values.

**Requirements:** R1, R2, R3, R4

**Dependencies:** None

**Files:**
- Create: `home/.config/ghostty/themes/nothing-light`
- Create: `home/.config/ghostty/themes/nothing-dark`

**Approach:**
- For each variant, write 16 `palette = N=#RRGGBB` entries matching ANSI slots 0-15 from `AGENTS.md`.
- Add `background`, `foreground`, `cursor-color`, `cursor-text`, `selection-background`, and `selection-foreground` using the terminal special colors from `AGENTS.md`.
- Keep comments minimal and avoid non-color Ghostty options.

**Patterns to follow:**
- `AGENTS.md` sections `Nothing Light`, `Nothing Dark`, `ANSI terminal palette`, and `Terminal special colors`.
- Ghostty upstream theme example syntax.

**Test scenarios:**
- Happy path: Parse `nothing-light` and confirm palette slots 0, 1, 4, 7, 15 map to `#1A1A1A`, `#D71921`, `#007AFF`, `#CCCCCC`, and `#000000`.
- Happy path: Parse `nothing-dark` and confirm palette slots 0, 1, 4, 7, 15 map to `#000000`, `#D71921`, `#5B9BF6`, `#999999`, and `#FFFFFF`.
- Integration: Confirm each theme includes all special color keys with exact values from `AGENTS.md`.
- Edge case: Confirm each theme has exactly one entry for every palette slot 0-15 and no duplicate special color keys.

**Verification:**
- Both theme files use valid Ghostty `key = value` syntax and round-trip to the documented palette.

---

- U2. **Add Ghostty Validation**

**Goal:** Add local validation for Ghostty theme syntax and palette correctness.

**Requirements:** R2, R3, R5

**Dependencies:** U1

**Files:**
- Create: `tests/validate-ghostty-theme.sh`
- Modify: `Makefile`

**Approach:**
- Add a small shell script that reads the Ghostty theme files and asserts required keys and exact color values.
- Validate that only expected color/theme keys appear so non-color options do not creep in.
- Update `make validate` to run both iTerm2 and Ghostty validation.

**Patterns to follow:**
- `tests/validate-iterm2-theme.sh` structure and failure messaging.
- Current `Makefile` target style.

**Test scenarios:**
- Happy path: Running `tests/validate-ghostty-theme.sh` against the generated files exits successfully.
- Error path: A missing palette slot exits non-zero and names the missing variant/key.
- Error path: A mismatched color exits non-zero and reports expected vs actual values.
- Error path: An unsupported non-theme option in a Ghostty theme file exits non-zero.

**Verification:**
- `make validate` passes and includes Ghostty validation.

---

- U3. **Add Ghostty Install Targets**

**Goal:** Make Ghostty themes deployable to the user-discoverable Ghostty theme directory.

**Requirements:** R4, R6

**Dependencies:** U1, U2

**Files:**
- Modify: `Makefile`

**Approach:**
- Add `install-ghostty` to create `$(PREFIX)/.config/ghostty/themes` and copy both theme files there.
- Add `deploy-ghostty` as an alias for `install-ghostty`, matching the iTerm2 deploy alias pattern.
- Ensure `install-ghostty` depends on validation before copying files.
- Keep `PREFIX` support so installation can be verified safely under `/private/tmp`.

**Patterns to follow:**
- Existing `install-iterm2` and `deploy-iterm2` targets.
- Ghostty docs for theme lookup under `$XDG_CONFIG_HOME/ghostty/themes` or `~/.config/ghostty/themes`.

**Test scenarios:**
- Happy path: `make install-ghostty PREFIX=/private/tmp/nothing-theme-ghostty-install` copies both files to `/private/tmp/nothing-theme-ghostty-install/.config/ghostty/themes/`.
- Edge case: Re-running the install target overwrites the copied theme files without duplicating them.
- Integration: If the `ghostty` CLI is available, `ghostty +list-themes` should include `nothing-light` and `nothing-dark` after installing to the live config path.

**Verification:**
- Dry-run and temp-prefix install show the expected destination paths and files.

---

- U4. **Document Ghostty Usage**

**Goal:** Document the new Ghostty theme files, install target, and configuration snippets.

**Requirements:** R6, R7

**Dependencies:** U1, U3

**Files:**
- Modify: `AGENTS.md`

**Approach:**
- Add a concise Ghostty section near the existing iTerm2 section.
- Include file paths for both variants and `make install-ghostty`.
- Include example user config snippets: `theme = nothing-light`, `theme = nothing-dark`, and `theme = light:nothing-light,dark:nothing-dark`.
- Keep docs focused on theme selection and reloading; avoid broader Ghostty setup instructions.

**Patterns to follow:**
- Existing iTerm2 documentation section in `AGENTS.md`.

**Test scenarios:**
- Test expectation: none -- documentation-only change.

**Verification:**
- Documented paths and target names match the implemented files and `Makefile`.

---

## System-Wide Impact

- **Interaction graph:** This is a file-based theme addition. Ghostty discovers theme files by name from its config theme directory.
- **Error propagation:** Validation failures should be local and explicit before installation.
- **State lifecycle risks:** `make install-ghostty` copies files into a user config directory but does not edit the user's active Ghostty config.
- **API surface parity:** Ghostty values should match iTerm2 and `AGENTS.md` terminal palette values exactly for both variants.
- **Integration coverage:** Static validation plus temp-prefix install checks are sufficient for repository verification; live `ghostty +list-themes` is optional if the CLI is installed.
- **Unchanged invariants:** The Nothing palette values in `AGENTS.md` remain unchanged.

---

## Risks & Dependencies

| Risk | Mitigation |
|------|------------|
| Ghostty does not list the themes after install because it uses a different config home | Default to `$(PREFIX)/.config/ghostty/themes` and document that this follows the default `$XDG_CONFIG_HOME` behavior; allow overrides later if needed. |
| Theme syntax drifts from Ghostty's current contract | Use upstream-documented `key = value` theme syntax and validate the exact key set. |
| Makefile install accidentally edits user preference state | Only copy theme files; document the config snippets rather than writing `config.ghostty`. |
| Palette values are mistyped | Validate every required palette and special color key against the expected hex values. |

---

## Documentation / Operational Notes

- After installing, users can configure Ghostty with `theme = light:nothing-light,dark:nothing-dark` to switch with system appearance.
- Users may need to reload Ghostty configuration after changing the selected theme.

---

## Sources & References

- Source spec: `AGENTS.md`
- Existing plan/style reference: `docs/plans/2026-05-01-001-feat-iterm2-theme-plan.md`
- Ghostty Color Theme docs: `https://ghostty.org/docs/features/theme`
- Ghostty Configuration docs: `https://ghostty.org/docs/config`
- Ghostty Configuration Reference: `https://ghostty.org/docs/config/reference`
