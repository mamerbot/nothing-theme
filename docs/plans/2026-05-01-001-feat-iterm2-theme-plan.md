---
title: "feat: Add iTerm2 Nothing theme"
type: feat
status: completed
date: 2026-05-01
---

# feat: Add iTerm2 Nothing theme

## Overview

Add a complete iTerm2 implementation of the Nothing theme with both required variants: `nothing-light` and `nothing-dark`. Each variant should provide an importable color preset file and a Dynamic Profile entry that makes the preset usable as a named iTerm2 profile without relying on manual color entry.

---

## Problem Frame

`AGENTS.md` defines the Nothing palette, terminal special colors, ANSI slots, and the intended iTerm2 implementation paths, but the current checkout only contains `AGENTS.md` and no iTerm2 theme files. iTerm2 support should be generated from the documented source of truth so terminal colors match the rest of the theme family.

---

## Requirements Trace

- R1. Create iTerm2 color preset files for both `nothing-light` and `nothing-dark`.
- R2. Encode every ANSI slot 0-15 and terminal special color exactly from the `AGENTS.md` iTerm2 palette.
- R3. Create iTerm2 Dynamic Profile files for both variants, using the corresponding color preset values and clear profile names.
- R4. Keep generated files in the documented repo layout: `home/.config/iterm2/colors/` and `home/.config/iterm2/DynamicProfiles/`.
- R5. Provide lightweight validation so future palette drift or malformed plist/JSON files can be caught without opening iTerm2.

**Required variants:**

| Variant | Color preset | Dynamic Profile | Palette source |
|---------|--------------|-----------------|----------------|
| Light | `home/.config/iterm2/colors/nothing-light.itermcolors` | `home/.config/iterm2/DynamicProfiles/nothing-light.json` | `AGENTS.md` / `Nothing Light` |
| Dark | `home/.config/iterm2/colors/nothing-dark.itermcolors` | `home/.config/iterm2/DynamicProfiles/nothing-dark.json` | `AGENTS.md` / `Nothing Dark` |

---

## Scope Boundaries

- Do not change the palette values, semantic color roles, or design principles in `AGENTS.md`.
- Do not add installers, shell integration, or macOS preference mutation.
- Do not implement other applications listed in `AGENTS.md`; this plan is iTerm2-only.
- Do not make one variant canonical over the other; both iTerm2 profiles should be present.

---

## Context & Research

### Relevant Code and Patterns

- `AGENTS.md` is the source of truth for palette values, ANSI terminal palette slots, terminal special colors, and documented iTerm2 paths.
- The repo currently has no `home/` tree, no existing theme implementation files, and no `docs/solutions/` institutional learnings.
- Existing Git history contains only `AGENTS.md`, so this should be treated as a greenfield app implementation rather than a refactor of previous iTerm2 files.

### Institutional Learnings

- None found; `docs/solutions/` is absent.

### External References

- iTerm2 color preset files conventionally use `.itermcolors`, a plist format with per-channel real values.
- iTerm2 Dynamic Profiles conventionally live as JSON files under a Dynamic Profiles directory and can embed color dictionaries directly.

---

## Key Technical Decisions

- Use `AGENTS.md` values as the authoritative palette input: It already defines exact hex values for every required iTerm2 terminal color.
- Add both `.itermcolors` presets and Dynamic Profile JSON: Presets support manual import and reuse, while Dynamic Profiles make the theme immediately available as profiles when the user points iTerm2 at the repo-backed config directory.
- Store color channels as normalized real values in plist/JSON color dictionaries: This matches iTerm2's common color serialization style and avoids lossy named-color shortcuts.
- Keep validation local and format-focused: The repo has no app runtime, so verification should parse plist/JSON and assert expected color keys and representative values.

---

## Open Questions

### Resolved During Planning

- Should this plan include both variants? Yes. `AGENTS.md` documents both light and dark iTerm2 profiles as active implementation targets.
- Should implementation generate files from a script or hand-author the theme files? Prefer direct checked-in theme files plus validation. A generator can be added later if multiple app themes need automated regeneration from a shared palette.

### Deferred to Implementation

- Exact Dynamic Profile schema fields beyond name and colors: The implementer should choose the minimal iTerm2-compatible profile fields after inspecting a known-good profile shape or iTerm2 docs.
- Whether to include font/window/session defaults in Dynamic Profiles: Defer unless required for iTerm2 to load the profile cleanly; this plan is color-focused.

---

## Output Structure

    home/
      .config/
        iterm2/
          colors/
            nothing-light.itermcolors
            nothing-dark.itermcolors
          DynamicProfiles/
            nothing-light.json
            nothing-dark.json
    tests/
      validate-iterm2-theme.sh

---

## Implementation Units

- U1. **Add iTerm2 Color Presets**

**Goal:** Create importable `.itermcolors` files for the light and dark Nothing variants.

**Requirements:** R1, R2, R4

**Dependencies:** None

**Files:**
- Create: `home/.config/iterm2/colors/nothing-light.itermcolors`
- Create: `home/.config/iterm2/colors/nothing-dark.itermcolors`

**Approach:**
- Encode all standard ANSI color keys for slots 0-15 using the corresponding light/dark terminal palette values from `AGENTS.md`.
- Encode terminal special colors for background, foreground, cursor, cursor text, selection background, and selection text.
- Use clear plist keys compatible with iTerm2 color presets, with RGB channels normalized from the documented hex values.

**Patterns to follow:**
- `AGENTS.md` sections `Nothing Light`, `Nothing Dark`, `ANSI terminal palette`, and `Terminal special colors`.

**Test scenarios:**
- Happy path: Parse `nothing-light.itermcolors` as plist and confirm ANSI slots 0, 1, 4, 7, 15 map to `#1A1A1A`, `#D71921`, `#007AFF`, `#CCCCCC`, and `#000000`.
- Happy path: Parse `nothing-dark.itermcolors` as plist and confirm ANSI slots 0, 1, 4, 7, 15 map to `#000000`, `#D71921`, `#5B9BF6`, `#999999`, and `#FFFFFF`.
- Integration: Confirm each preset includes background, foreground, cursor, cursor text, selection background, and selection text values matching `AGENTS.md`.
- Edge case: Confirm both presets contain exactly the expected required color entries, with no missing ANSI slot.

**Verification:**
- Both files are valid plist files and their parsed RGB values round-trip to the documented hex palette.

---

- U2. **Add iTerm2 Dynamic Profiles**

**Goal:** Create Dynamic Profile JSON files that expose `Nothing Light` and `Nothing Dark` as usable iTerm2 profiles.

**Requirements:** R2, R3, R4

**Dependencies:** U1

**Files:**
- Create: `home/.config/iterm2/DynamicProfiles/nothing-light.json`
- Create: `home/.config/iterm2/DynamicProfiles/nothing-dark.json`

**Approach:**
- Define one profile per file with stable, human-readable names such as `Nothing Light` and `Nothing Dark`.
- Embed the same color dictionaries used by the `.itermcolors` presets so Dynamic Profiles do not depend on users importing presets first.
- Keep profile settings minimal and color-focused unless iTerm2 requires additional profile metadata.

**Patterns to follow:**
- `AGENTS.md` documented iTerm2 paths and variant names.
- Color values from U1 should be treated as the local reference to avoid divergence between presets and profiles.

**Test scenarios:**
- Happy path: Parse each JSON file and confirm it contains exactly one expected profile entry with the correct display name.
- Integration: Confirm every color value in each Dynamic Profile matches the corresponding `.itermcolors` file for that variant.
- Edge case: Confirm profile files remain valid JSON with no comments or trailing commas.

**Verification:**
- Both Dynamic Profile files parse as JSON and expose the expected profile names and color dictionaries.

---

- U3. **Add Local Validation**

**Goal:** Add a lightweight validation script that checks the iTerm2 files are parseable and palette-accurate.

**Requirements:** R2, R5

**Dependencies:** U1, U2

**Files:**
- Create: `tests/validate-iterm2-theme.sh`

**Approach:**
- Use macOS-friendly command-line tooling available by default where practical, such as `plutil`, to validate plist and JSON syntax.
- Include deterministic checks for the key palette values listed in U1 and U2 rather than only checking parseability.
- Keep the script focused on iTerm2 files so it does not become a general theme validation framework prematurely.

**Patterns to follow:**
- Repo-local shell scripts should be small, direct, and runnable from the repository root.

**Test scenarios:**
- Happy path: Running the script against valid generated files exits successfully.
- Error path: A malformed `.itermcolors` or JSON file causes a non-zero exit with a useful message naming the failing file.
- Error path: A changed representative color value causes a non-zero exit that identifies the mismatched variant/key.

**Verification:**
- The validation script passes against the newly added iTerm2 preset and Dynamic Profile files.

---

- U4. **Document iTerm2 Usage**

**Goal:** Add concise usage notes so users know where the iTerm2 files live and how to load them.

**Requirements:** R1, R3, R4

**Dependencies:** U1, U2

**Files:**
- Modify: `AGENTS.md`

**Approach:**
- Add a short iTerm2 implementation note near the existing implementation table or in a small dedicated subsection.
- Mention that `.itermcolors` files can be imported as color presets and Dynamic Profile JSON files can be used by iTerm2 when its Dynamic Profiles folder points at `home/.config/iterm2/DynamicProfiles/`.
- Avoid expanding the design spec with operational installation steps beyond what is needed to identify and use the files.

**Patterns to follow:**
- Preserve the existing concise, table-driven documentation style in `AGENTS.md`.

**Test scenarios:**
- Test expectation: none -- documentation-only change.

**Verification:**
- The documented paths match the files added in U1 and U2.

---

## System-Wide Impact

- **Interaction graph:** This is a file-based theme addition. The affected surface is iTerm2 import/profile loading; no application runtime callbacks or services are involved.
- **Error propagation:** Validation failures should be local and explicit, pointing to malformed files or palette mismatches.
- **State lifecycle risks:** No persistent app state is changed by the repo itself; users opt into importing presets or configuring Dynamic Profiles.
- **API surface parity:** The iTerm2 palette should remain consistent with the terminal palettes already documented for other applications.
- **Integration coverage:** Static plist/JSON parsing and representative color assertions are sufficient for this repository; manual iTerm2 import remains an optional human smoke test.
- **Unchanged invariants:** The Nothing palette values in `AGENTS.md` remain unchanged.

---

## Risks & Dependencies

| Risk | Mitigation |
|------|------------|
| iTerm2 rejects a minimally-authored Dynamic Profile | Start from a known-compatible Dynamic Profile shape during implementation and keep validation parse-focused; defer optional profile defaults unless required. |
| Presets and profiles drift from each other | Validate representative colors in both surfaces and compare Dynamic Profile colors against the preset values. |
| Palette values are mistyped while converting hex to normalized RGB channels | Use deterministic conversion or double-check by parsing back to hex in validation. |
| `AGENTS.md` currently claims iTerm2 files exist even though they do not | This plan creates the documented paths and updates usage notes only as needed. |

---

## Documentation / Operational Notes

- Add only concise usage guidance; avoid installer behavior or iTerm2 preference mutation.
- A future cross-application palette generator may be useful once more theme implementations exist, but it is outside this iTerm2-focused plan.

---

## Sources & References

- Source spec: `AGENTS.md`
- Planned presets: `home/.config/iterm2/colors/nothing-light.itermcolors`, `home/.config/iterm2/colors/nothing-dark.itermcolors`
- Planned Dynamic Profiles: `home/.config/iterm2/DynamicProfiles/nothing-light.json`, `home/.config/iterm2/DynamicProfiles/nothing-dark.json`
