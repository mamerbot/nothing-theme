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

| Role       | Hex       | RGB             | Usage                                      |
|------------|-----------|-----------------|---------------------------------------------|
| `bg`       | `#FFFFFF` | 255, 255, 255   | Terminal background, editor background      |
| `surface`  | `#FFFFFF` | 255, 255, 255   | Same as bg (light has no surface lift)      |
| `raised`   | `#F0F0F0` | 240, 240, 240   | Float/popup backgrounds, cursor line        |
| `border`   | `#E8E8E8` | 232, 232, 232   | Subtle borders, invisibles                  |
| `split`    | `#CCCCCC` | 204, 204, 204   | Selection background, split lines           |
| `disabled` | `#999999` | 153, 153, 153   | Comments (italic), disabled UI elements     |
| `muted`    | `#666666` | 102, 102, 102   | Operators, punctuation, line numbers        |
| `fg`       | `#1A1A1A` | 26, 26, 26      | Primary text, variables                     |
| `bright`   | `#000000` | 0, 0, 0         | Bold text, headings, maximum contrast       |

### Semantic colors

| Role      | Hex       | RGB             | Usage                                        |
|-----------|-----------|-----------------|-----------------------------------------------|
| `red`     | `#D71921` | 215, 25, 33     | Keywords, errors, deletions, boolean/null     |
| `green`   | `#4A9E5C` | 74, 158, 92     | Strings, additions, success                   |
| `yellow`  | `#D4A843` | 212, 168, 67    | Numbers, warnings, modified, dates            |
| `blue`    | `#007AFF` | 0, 122, 255     | Functions, properties, links, directories     |
| `magenta` | `#7A4FA8` | 122, 79, 168    | Types, classes, constants, decorators         |
| `cyan`    | `#2A8FAF` | 42, 143, 175    | Imports, namespaces, string escapes           |

### ANSI terminal palette

| Slot | Name           | Hex       | RGB             |
|------|----------------|-----------|-----------------|
| 0    | Black          | `#1A1A1A` | 26, 26, 26      |
| 1    | Red            | `#D71921` | 215, 25, 33     |
| 2    | Green          | `#4A9E5C` | 74, 158, 92     |
| 3    | Yellow         | `#D4A843` | 212, 168, 67    |
| 4    | Blue           | `#007AFF` | 0, 122, 255     |
| 5    | Magenta        | `#7A4FA8` | 122, 79, 168    |
| 6    | Cyan           | `#2A8FAF` | 42, 143, 175    |
| 7    | White          | `#CCCCCC` | 204, 204, 204   |
| 8    | Bright Black   | `#666666` | 102, 102, 102   |
| 9    | Bright Red     | `#D71921` | 215, 25, 33     |
| 10   | Bright Green   | `#4A9E5C` | 74, 158, 92     |
| 11   | Bright Yellow  | `#D4A843` | 212, 168, 67    |
| 12   | Bright Blue    | `#007AFF` | 0, 122, 255     |
| 13   | Bright Magenta | `#7A4FA8` | 122, 79, 168    |
| 14   | Bright Cyan    | `#2A8FAF` | 42, 143, 175    |
| 15   | Bright White   | `#000000` | 0, 0, 0         |

### Terminal special colors

| Key                  | Hex       |
|----------------------|-----------|
| Background           | `#FFFFFF` |
| Foreground           | `#1A1A1A` |
| Cursor               | `#000000` |
| Cursor text          | `#FFFFFF` |
| Selection background | `#CCCCCC` |
| Selection text       | `#1A1A1A` |

---

## Nothing Dark

### Grayscale ladder

| Role       | Hex       | RGB             | Usage                                      |
|------------|-----------|-----------------|---------------------------------------------|
| `bg`       | `#000000` | 0, 0, 0         | OLED terminal background, editor background |
| `surface`  | `#111111` | 17, 17, 17      | Editor surface (Normal bg)                  |
| `raised`   | `#1A1A1A` | 26, 26, 26      | Float/popup backgrounds, cursor line        |
| `border`   | `#222222` | 34, 34, 34      | Subtle borders, invisibles                  |
| `split`    | `#333333` | 51, 51, 51      | Selection background, split lines           |
| `disabled` | `#666666` | 102, 102, 102   | Comments (italic), disabled UI elements     |
| `muted`    | `#999999` | 153, 153, 153   | Operators, punctuation, line numbers        |
| `fg`       | `#E8E8E8` | 232, 232, 232   | Primary text, variables                     |
| `bright`   | `#FFFFFF` | 255, 255, 255   | Bold text, headings, maximum contrast       |

### Semantic colors

| Role      | Hex       | RGB             | Usage                                        |
|-----------|-----------|-----------------|-----------------------------------------------|
| `red`     | `#D71921` | 215, 25, 33     | Keywords, errors, deletions, boolean/null     |
| `green`   | `#4A9E5C` | 74, 158, 92     | Strings, additions, success                   |
| `yellow`  | `#D4A843` | 212, 168, 67    | Numbers, warnings, modified, dates            |
| `blue`    | `#5B9BF6` | 91, 155, 246    | Functions, properties, links, directories     |
| `magenta` | `#9B6FBF` | 155, 111, 191   | Types, classes, constants, decorators         |
| `cyan`    | `#4A9EC4` | 74, 158, 196    | Imports, namespaces, string escapes           |

### ANSI terminal palette

| Slot | Name           | Hex       | RGB             |
|------|----------------|-----------|-----------------|
| 0    | Black          | `#000000` | 0, 0, 0         |
| 1    | Red            | `#D71921` | 215, 25, 33     |
| 2    | Green          | `#4A9E5C` | 74, 158, 92     |
| 3    | Yellow         | `#D4A843` | 212, 168, 67    |
| 4    | Blue           | `#5B9BF6` | 91, 155, 246    |
| 5    | Magenta        | `#9B6FBF` | 155, 111, 191   |
| 6    | Cyan           | `#4A9EC4` | 74, 158, 196    |
| 7    | White          | `#999999` | 153, 153, 153   |
| 8    | Bright Black   | `#333333` | 51, 51, 51      |
| 9    | Bright Red     | `#D71921` | 215, 25, 33     |
| 10   | Bright Green   | `#4A9E5C` | 74, 158, 92     |
| 11   | Bright Yellow  | `#D4A843` | 212, 168, 67    |
| 12   | Bright Blue    | `#5B9BF6` | 91, 155, 246    |
| 13   | Bright Magenta | `#9B6FBF` | 155, 111, 191   |
| 14   | Bright Cyan    | `#4A9EC4` | 74, 158, 196    |
| 15   | Bright White   | `#FFFFFF` | 255, 255, 255   |

### Terminal special colors

| Key                  | Hex       |
|----------------------|-----------|
| Background           | `#000000` |
| Foreground           | `#E8E8E8` |
| Cursor               | `#FFFFFF` |
| Cursor text          | `#000000` |
| Selection background | `#333333` |
| Selection text       | `#E8E8E8` |

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

## Implementations in this repo

| App            | File(s)                                                                 | Active variant  |
|----------------|-------------------------------------------------------------------------|-----------------|
| Ghostty        | `home/.config/ghostty/themes/nothing-{dark,light}`                     | `nothing-light` |
| Neovim         | `home/.config/nvim/colors/nothing.lua`                                  | `light`         |
| bat            | `home/.config/bat/themes/nothing-{dark,light}.tmTheme`                  | `nothing-light` |
| eza            | `home/.config/eza/{dark,light}/theme.yml`                               | `light/`        |
| tmux-powerline | `home/.config/tmux-powerline/themes/nothing-{dark,light}.sh`            | `nothing-light` |
| Starship       | `home/.config/starship.toml`                                            | `nothing_light` |
| Lazygit        | `home/.config/lazygit/config.yml`                                       | light           |
| FZF            | `home/.zshrc` (`FZF_DEFAULT_OPTS`)                                      | light           |
| iTerm2         | `home/.config/iterm2/{colors,DynamicProfiles}/nothing-{dark,light}.*`  | both profiles   |
