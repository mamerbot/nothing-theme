# Nothing Theme

Custom terminal/editor colorscheme based on the [Nothing design system](https://github.com/dominikmartn/nothing-design-skill).
Two variants: `nothing-light` (default) and `nothing-dark`.

---

## Design principles

- OLED-first monochrome: 8-step grayscale ladder as the structural backbone
- Four invariant semantic colors: red, green, yellow, blue
- Magenta and cyan are synthesized (the Nothing system has no official values) — desaturated hybrids that honor the monochrome spirit
- Blue shifts between variants: `#007AFF` (iOS-style, light) / `#5B9BF6` (softened for dark OLED)
- Red and green are identical across both variants (invariant)
- Yellow/amber is identical across both variants (invariant)

---

## Nothing Light

### Grayscale ladder

| Role       | Hex       | Swatch | RGB             | Usage                                      |
|------------|-----------|--------|-----------------|---------------------------------------------|
| `bg`       | `#FFFFFF` | ![#FFFFFF](https://img.shields.io/badge/%23FFFFFF-FFFFFF?style=flat-square) | 255, 255, 255   | Terminal background, editor background      |
| `surface`  | `#FFFFFF` | ![#FFFFFF](https://img.shields.io/badge/%23FFFFFF-FFFFFF?style=flat-square) | 255, 255, 255   | Same as bg (light has no surface lift)      |
| `raised`   | `#F0F0F0` | ![#F0F0F0](https://img.shields.io/badge/%23F0F0F0-F0F0F0?style=flat-square) | 240, 240, 240   | Float/popup backgrounds, cursor line        |
| `border`   | `#E8E8E8` | ![#E8E8E8](https://img.shields.io/badge/%23E8E8E8-E8E8E8?style=flat-square) | 232, 232, 232   | Subtle borders, invisibles                  |
| `split`    | `#CCCCCC` | ![#CCCCCC](https://img.shields.io/badge/%23CCCCCC-CCCCCC?style=flat-square) | 204, 204, 204   | Selection background, split lines           |
| `disabled` | `#999999` | ![#999999](https://img.shields.io/badge/%23999999-999999?style=flat-square) | 153, 153, 153   | Comments (italic), disabled UI elements     |
| `muted`    | `#666666` | ![#666666](https://img.shields.io/badge/%23666666-666666?style=flat-square) | 102, 102, 102   | Operators, punctuation, line numbers        |
| `fg`       | `#1A1A1A` | ![#1A1A1A](https://img.shields.io/badge/%231A1A1A-1A1A1A?style=flat-square) | 26, 26, 26      | Primary text, variables                     |
| `bright`   | `#000000` | ![#000000](https://img.shields.io/badge/%23000000-000000?style=flat-square) | 0, 0, 0         | Bold text, headings, maximum contrast       |

### Semantic colors

| Role      | Hex       | Swatch | RGB             | Usage                                        |
|-----------|-----------|--------|-----------------|-----------------------------------------------|
| `red`     | `#D71921` | ![#D71921](https://img.shields.io/badge/%23D71921-D71921?style=flat-square) | 215, 25, 33     | Keywords, errors, deletions, boolean/null     |
| `green`   | `#4A9E5C` | ![#4A9E5C](https://img.shields.io/badge/%234A9E5C-4A9E5C?style=flat-square) | 74, 158, 92     | Strings, additions, success                   |
| `yellow`  | `#D4A843` | ![#D4A843](https://img.shields.io/badge/%23D4A843-D4A843?style=flat-square) | 212, 168, 67    | Numbers, warnings, modified, dates            |
| `blue`    | `#007AFF` | ![#007AFF](https://img.shields.io/badge/%23007AFF-007AFF?style=flat-square) | 0, 122, 255     | Functions, properties, links, directories     |
| `magenta` | `#7A4FA8` | ![#7A4FA8](https://img.shields.io/badge/%237A4FA8-7A4FA8?style=flat-square) | 122, 79, 168    | Types, classes, constants, decorators         |
| `cyan`    | `#2A8FAF` | ![#2A8FAF](https://img.shields.io/badge/%232A8FAF-2A8FAF?style=flat-square) | 42, 143, 175    | Imports, namespaces, string escapes           |

### ANSI terminal palette

| Slot | Name           | Hex       | Swatch | RGB             |
|------|----------------|-----------|--------|-----------------|
| 0    | Black          | `#1A1A1A` | ![#1A1A1A](https://img.shields.io/badge/%231A1A1A-1A1A1A?style=flat-square) | 26, 26, 26      |
| 1    | Red            | `#D71921` | ![#D71921](https://img.shields.io/badge/%23D71921-D71921?style=flat-square) | 215, 25, 33     |
| 2    | Green          | `#4A9E5C` | ![#4A9E5C](https://img.shields.io/badge/%234A9E5C-4A9E5C?style=flat-square) | 74, 158, 92     |
| 3    | Yellow         | `#D4A843` | ![#D4A843](https://img.shields.io/badge/%23D4A843-D4A843?style=flat-square) | 212, 168, 67    |
| 4    | Blue           | `#007AFF` | ![#007AFF](https://img.shields.io/badge/%23007AFF-007AFF?style=flat-square) | 0, 122, 255     |
| 5    | Magenta        | `#7A4FA8` | ![#7A4FA8](https://img.shields.io/badge/%237A4FA8-7A4FA8?style=flat-square) | 122, 79, 168    |
| 6    | Cyan           | `#2A8FAF` | ![#2A8FAF](https://img.shields.io/badge/%232A8FAF-2A8FAF?style=flat-square) | 42, 143, 175    |
| 7    | White          | `#CCCCCC` | ![#CCCCCC](https://img.shields.io/badge/%23CCCCCC-CCCCCC?style=flat-square) | 204, 204, 204   |
| 8    | Bright Black   | `#666666` | ![#666666](https://img.shields.io/badge/%23666666-666666?style=flat-square) | 102, 102, 102   |
| 9    | Bright Red     | `#D71921` | ![#D71921](https://img.shields.io/badge/%23D71921-D71921?style=flat-square) | 215, 25, 33     |
| 10   | Bright Green   | `#4A9E5C` | ![#4A9E5C](https://img.shields.io/badge/%234A9E5C-4A9E5C?style=flat-square) | 74, 158, 92     |
| 11   | Bright Yellow  | `#D4A843` | ![#D4A843](https://img.shields.io/badge/%23D4A843-D4A843?style=flat-square) | 212, 168, 67    |
| 12   | Bright Blue    | `#007AFF` | ![#007AFF](https://img.shields.io/badge/%23007AFF-007AFF?style=flat-square) | 0, 122, 255     |
| 13   | Bright Magenta | `#7A4FA8` | ![#7A4FA8](https://img.shields.io/badge/%237A4FA8-7A4FA8?style=flat-square) | 122, 79, 168    |
| 14   | Bright Cyan    | `#2A8FAF` | ![#2A8FAF](https://img.shields.io/badge/%232A8FAF-2A8FAF?style=flat-square) | 42, 143, 175    |
| 15   | Bright White   | `#000000` | ![#000000](https://img.shields.io/badge/%23000000-000000?style=flat-square) | 0, 0, 0         |

### Terminal special colors

| Key                  | Hex       | Swatch |
|----------------------|-----------|--------|
| Background           | `#FFFFFF` | ![#FFFFFF](https://img.shields.io/badge/%23FFFFFF-FFFFFF?style=flat-square) |
| Foreground           | `#1A1A1A` | ![#1A1A1A](https://img.shields.io/badge/%231A1A1A-1A1A1A?style=flat-square) |
| Cursor               | `#000000` | ![#000000](https://img.shields.io/badge/%23000000-000000?style=flat-square) |
| Cursor text          | `#FFFFFF` | ![#FFFFFF](https://img.shields.io/badge/%23FFFFFF-FFFFFF?style=flat-square) |
| Selection background | `#CCCCCC` | ![#CCCCCC](https://img.shields.io/badge/%23CCCCCC-CCCCCC?style=flat-square) |
| Selection text       | `#1A1A1A` | ![#1A1A1A](https://img.shields.io/badge/%231A1A1A-1A1A1A?style=flat-square) |

---

## Nothing Dark

### Grayscale ladder

| Role       | Hex       | Swatch | RGB             | Usage                                      |
|------------|-----------|--------|-----------------|---------------------------------------------|
| `bg`       | `#000000` | ![#000000](https://img.shields.io/badge/%23000000-000000?style=flat-square) | 0, 0, 0         | OLED terminal background, editor background |
| `surface`  | `#111111` | ![#111111](https://img.shields.io/badge/%23111111-111111?style=flat-square) | 17, 17, 17      | Editor surface (Normal bg)                  |
| `raised`   | `#1A1A1A` | ![#1A1A1A](https://img.shields.io/badge/%231A1A1A-1A1A1A?style=flat-square) | 26, 26, 26      | Float/popup backgrounds, cursor line        |
| `border`   | `#222222` | ![#222222](https://img.shields.io/badge/%23222222-222222?style=flat-square) | 34, 34, 34      | Subtle borders, invisibles                  |
| `split`    | `#333333` | ![#333333](https://img.shields.io/badge/%23333333-333333?style=flat-square) | 51, 51, 51      | Selection background, split lines           |
| `disabled` | `#666666` | ![#666666](https://img.shields.io/badge/%23666666-666666?style=flat-square) | 102, 102, 102   | Comments (italic), disabled UI elements     |
| `muted`    | `#999999` | ![#999999](https://img.shields.io/badge/%23999999-999999?style=flat-square) | 153, 153, 153   | Operators, punctuation, line numbers        |
| `fg`       | `#E8E8E8` | ![#E8E8E8](https://img.shields.io/badge/%23E8E8E8-E8E8E8?style=flat-square) | 232, 232, 232   | Primary text, variables                     |
| `bright`   | `#FFFFFF` | ![#FFFFFF](https://img.shields.io/badge/%23FFFFFF-FFFFFF?style=flat-square) | 255, 255, 255   | Bold text, headings, maximum contrast       |

### Semantic colors

| Role      | Hex       | Swatch | RGB             | Usage                                        |
|-----------|-----------|--------|-----------------|-----------------------------------------------|
| `red`     | `#D71921` | ![#D71921](https://img.shields.io/badge/%23D71921-D71921?style=flat-square) | 215, 25, 33     | Keywords, errors, deletions, boolean/null     |
| `green`   | `#4A9E5C` | ![#4A9E5C](https://img.shields.io/badge/%234A9E5C-4A9E5C?style=flat-square) | 74, 158, 92     | Strings, additions, success                   |
| `yellow`  | `#D4A843` | ![#D4A843](https://img.shields.io/badge/%23D4A843-D4A843?style=flat-square) | 212, 168, 67    | Numbers, warnings, modified, dates            |
| `blue`    | `#5B9BF6` | ![#5B9BF6](https://img.shields.io/badge/%235B9BF6-5B9BF6?style=flat-square) | 91, 155, 246    | Functions, properties, links, directories     |
| `magenta` | `#9B6FBF` | ![#9B6FBF](https://img.shields.io/badge/%239B6FBF-9B6FBF?style=flat-square) | 155, 111, 191   | Types, classes, constants, decorators         |
| `cyan`    | `#4A9EC4` | ![#4A9EC4](https://img.shields.io/badge/%234A9EC4-4A9EC4?style=flat-square) | 74, 158, 196    | Imports, namespaces, string escapes           |

### ANSI terminal palette

| Slot | Name           | Hex       | Swatch | RGB             |
|------|----------------|-----------|--------|-----------------|
| 0    | Black          | `#000000` | ![#000000](https://img.shields.io/badge/%23000000-000000?style=flat-square) | 0, 0, 0         |
| 1    | Red            | `#D71921` | ![#D71921](https://img.shields.io/badge/%23D71921-D71921?style=flat-square) | 215, 25, 33     |
| 2    | Green          | `#4A9E5C` | ![#4A9E5C](https://img.shields.io/badge/%234A9E5C-4A9E5C?style=flat-square) | 74, 158, 92     |
| 3    | Yellow         | `#D4A843` | ![#D4A843](https://img.shields.io/badge/%23D4A843-D4A843?style=flat-square) | 212, 168, 67    |
| 4    | Blue           | `#5B9BF6` | ![#5B9BF6](https://img.shields.io/badge/%235B9BF6-5B9BF6?style=flat-square) | 91, 155, 246    |
| 5    | Magenta        | `#9B6FBF` | ![#9B6FBF](https://img.shields.io/badge/%239B6FBF-9B6FBF?style=flat-square) | 155, 111, 191   |
| 6    | Cyan           | `#4A9EC4` | ![#4A9EC4](https://img.shields.io/badge/%234A9EC4-4A9EC4?style=flat-square) | 74, 158, 196    |
| 7    | White          | `#999999` | ![#999999](https://img.shields.io/badge/%23999999-999999?style=flat-square) | 153, 153, 153   |
| 8    | Bright Black   | `#333333` | ![#333333](https://img.shields.io/badge/%23333333-333333?style=flat-square) | 51, 51, 51      |
| 9    | Bright Red     | `#D71921` | ![#D71921](https://img.shields.io/badge/%23D71921-D71921?style=flat-square) | 215, 25, 33     |
| 10   | Bright Green   | `#4A9E5C` | ![#4A9E5C](https://img.shields.io/badge/%234A9E5C-4A9E5C?style=flat-square) | 74, 158, 92     |
| 11   | Bright Yellow  | `#D4A843` | ![#D4A843](https://img.shields.io/badge/%23D4A843-D4A843?style=flat-square) | 212, 168, 67    |
| 12   | Bright Blue    | `#5B9BF6` | ![#5B9BF6](https://img.shields.io/badge/%235B9BF6-5B9BF6?style=flat-square) | 91, 155, 246    |
| 13   | Bright Magenta | `#9B6FBF` | ![#9B6FBF](https://img.shields.io/badge/%239B6FBF-9B6FBF?style=flat-square) | 155, 111, 191   |
| 14   | Bright Cyan    | `#4A9EC4` | ![#4A9EC4](https://img.shields.io/badge/%234A9EC4-4A9EC4?style=flat-square) | 74, 158, 196    |
| 15   | Bright White   | `#FFFFFF` | ![#FFFFFF](https://img.shields.io/badge/%23FFFFFF-FFFFFF?style=flat-square) | 255, 255, 255   |

### Terminal special colors

| Key                  | Hex       | Swatch |
|----------------------|-----------|--------|
| Background           | `#000000` | ![#000000](https://img.shields.io/badge/%23000000-000000?style=flat-square) |
| Foreground           | `#E8E8E8` | ![#E8E8E8](https://img.shields.io/badge/%23E8E8E8-E8E8E8?style=flat-square) |
| Cursor               | `#FFFFFF` | ![#FFFFFF](https://img.shields.io/badge/%23FFFFFF-FFFFFF?style=flat-square) |
| Cursor text          | `#000000` | ![#000000](https://img.shields.io/badge/%23000000-000000?style=flat-square) |
| Selection background | `#333333` | ![#333333](https://img.shields.io/badge/%23333333-333333?style=flat-square) |
| Selection text       | `#E8E8E8` | ![#E8E8E8](https://img.shields.io/badge/%23E8E8E8-E8E8E8?style=flat-square) |

---

## Syntax highlighting mapping

These rules apply to both variants (swap colors for light vs dark per the tables above).

| Syntax role              | Color role  | Notes                              |
|--------------------------|-------------|------------------------------------|
| Comment                  | `disabled`  | Italic                             |
| String                   | `green`     |                                    |
| String escape / interp   | `cyan`      |                                    |
| Number / Float           | `yellow`    |                                    |
| Boolean / Null           | `red`       |                                    |
| Constant                 | `magenta`   |                                    |
| Keyword / Control        | `red`       |                                    |
| Function name / call     | `blue`      |                                    |
| Type / Class             | `magenta`   |                                    |
| Variable / Identifier    | `fg`        |                                    |
| Property / Member        | `blue`      |                                    |
| Operator                 | `muted`     |                                    |
| Punctuation / Delimiter  | `muted`     |                                    |
| Tag name (HTML/JSX)      | `red`       |                                    |
| Tag attribute            | `magenta`   |                                    |
| Import / Namespace       | `cyan`      |                                    |
| Decorator                | `magenta`   |                                    |
| Regex                    | `red`       |                                    |
| Diff added               | `green`     |                                    |
| Diff removed             | `red`       |                                    |
| Diff changed             | `yellow`    |                                    |
| Error / Invalid          | `red`       | Bold                               |

---

## iTerm2

Both Nothing variants are available for iTerm2:

| Variant | Color preset | Dynamic Profile |
|---------|--------------|-----------------|
| `nothing-light` | `home/.config/iterm2/colors/nothing-light.itermcolors` | `home/.config/iterm2/DynamicProfiles/nothing-light.json` |
| `nothing-dark` | `home/.config/iterm2/colors/nothing-dark.itermcolors` | `home/.config/iterm2/DynamicProfiles/nothing-dark.json` |

Import the `.itermcolors` files as iTerm2 color presets, or install the Dynamic Profile JSON files to `~/Library/Application Support/iTerm2/DynamicProfiles/` to load the named `Nothing Light` and `Nothing Dark` profiles.

Run `make install-iterm2` to install both Dynamic Profiles into iTerm2's watched directory and copy the color preset files into `~/.config/iterm2/colors/` for manual import. Use `PREFIX=/path/to/home` to install into another home-style directory.

---

## Ghostty

Both Nothing variants are available for Ghostty:

| Variant | Theme file |
|---------|------------|
| `nothing-light` | `home/.config/ghostty/themes/nothing-light` |
| `nothing-dark` | `home/.config/ghostty/themes/nothing-dark` |

Run `make install-ghostty` to install both themes into `~/.config/ghostty/themes/`. Use `PREFIX=/path/to/home` to install into another home-style directory. Both themes set `font-family = "JetBrainsMono Nerd Font Mono"` and `font-size = 16`.

Use a single variant:

```text
theme = nothing-light
```

```text
theme = nothing-dark
```

Or switch with the system appearance:

```text
theme = light:nothing-light,dark:nothing-dark
```

---

## CLI app themes

Bare `make` runs validation only. Run `make install` or `make deploy` to copy all managed iTerm2, Ghostty, tmux, Neovim, eza, delta, and lazygit theme artifacts. App-specific targets are also available:

| App | Install target | Light file | Dark file |
|-----|----------------|------------|-----------|
| tmux | `make install-tmux` | `home/.config/tmux/themes/nothing-light.conf` | `home/.config/tmux/themes/nothing-dark.conf` |
| Neovim | `make install-nvim` | `home/.config/nvim/colors/nothing-light.lua` | `home/.config/nvim/colors/nothing-dark.lua` |
| eza | `make install-eza` | `home/.config/eza/themes/nothing-light.yml` | `home/.config/eza/themes/nothing-dark.yml` |
| delta | `make install-delta` | `home/.config/delta/themes/nothing-light.gitconfig` | `home/.config/delta/themes/nothing-dark.gitconfig` |
| lazygit | `make install-lazygit` | `home/.config/lazygit/themes/nothing-light.yml` | `home/.config/lazygit/themes/nothing-dark.yml` |

### tmux

Install both variants into `~/.config/tmux/themes/`, then source the preferred variant from `~/.tmux.conf`:

```tmux
source-file ~/.config/tmux/themes/nothing-light.conf
```

```tmux
source-file ~/.config/tmux/themes/nothing-dark.conf
```

### Neovim

Install both colorschemes into `~/.config/nvim/colors/`, then select one explicitly:

```vim
colorscheme nothing-light
```

```vim
colorscheme nothing-dark
```

### eza

Install both YAML themes into `~/.config/eza/themes/`. eza loads `~/.config/eza/theme.yml`, so activate a variant by copying or symlinking the preferred file:

```sh
ln -sf ~/.config/eza/themes/nothing-light.yml ~/.config/eza/theme.yml
```

```sh
ln -sf ~/.config/eza/themes/nothing-dark.yml ~/.config/eza/theme.yml
```

### delta

Install both snippets into `~/.config/delta/themes/`, then include the preferred snippet from Git config and select its feature:

```gitconfig
[include]
    path = ~/.config/delta/themes/nothing-light.gitconfig
[delta]
    features = nothing-light
```

```gitconfig
[include]
    path = ~/.config/delta/themes/nothing-dark.gitconfig
[delta]
    features = nothing-dark
```

### lazygit

Install both snippets into `~/.config/lazygit/themes/`. Lazygit does not have a dedicated theme search path, so merge the preferred snippet into `~/.config/lazygit/config.yml` or copy its `gui.theme` block into the active config.
