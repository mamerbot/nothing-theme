#!/usr/bin/env python3
"""Render simulated terminal screenshots for the Nothing theme README."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = ROOT / "assets"


def rgb(value: str) -> tuple[int, int, int]:
    value = value.removeprefix("#")
    return int(value[0:2], 16), int(value[2:4], 16), int(value[4:6], 16)


def font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont:
    candidates = [
        Path("C:/Windows/Fonts/consolab.ttf" if bold else "C:/Windows/Fonts/consola.ttf"),
        Path("C:/Windows/Fonts/Consolas.ttf"),
    ]

    for candidate in candidates:
        if candidate.is_file():
            return ImageFont.truetype(str(candidate), size=size)
    return ImageFont.load_default(size=size)


THEMES = {
    "nothing-light-terminal": {
        "name": "Nothing Light",
        "caption": "Pure white canvas / molten cursor",
        "bg": "#FFFFFF",
        "frame": "#E8E4DF",
        "shadow": "#D7D2CC",
        "title": "#FFFFFF",
        "title_border": "#D8D2CC",
        "fg": "#111111",
        "muted": "#6B6560",
        "dim": "#8A837C",
        "accent": "#FF4719",
        "red": "#C0000A",
        "green": "#1E6B3C",
        "yellow": "#7A4A00",
        "blue": "#1050A0",
        "magenta": "#5A2D9A",
        "cyan": "#006E6E",
        "bright": "#000000",
        "surface": "#F7F5F2",
        "selection": "#E8E4DF",
    },
    "nothing-dark-terminal": {
        "name": "Nothing Dark",
        "caption": "OLED black / warm parchment",
        "bg": "#090807",
        "frame": "#181614",
        "shadow": "#050403",
        "title": "#181614",
        "title_border": "#3A3632",
        "fg": "#E5DDD0",
        "muted": "#5A5248",
        "dim": "#7A7066",
        "accent": "#FF4719",
        "red": "#D71921",
        "green": "#5AB87A",
        "yellow": "#E8A030",
        "blue": "#4A8FD9",
        "magenta": "#9575CD",
        "cyan": "#26C6C6",
        "bright": "#FFFFFF",
        "surface": "#181614",
        "selection": "#1D1A17",
    },
}


def draw_segments(
    draw: ImageDraw.ImageDraw,
    x: int,
    y: int,
    segments: list[tuple[str, str]],
    face: ImageFont.FreeTypeFont,
    palette: dict[str, str],
) -> None:
    for text, color_name in segments:
        draw.text((x, y), text, fill=rgb(palette[color_name]), font=face)
        x += int(draw.textlength(text, font=face))


def terminal_preview(slug: str, palette: dict[str, str]) -> Image.Image:
    width, height = 1600, 1100
    img = Image.new("RGB", (width, height), rgb(palette["frame"]))
    draw = ImageDraw.Draw(img)

    mono = font(29)
    mono_sm = font(20)
    mono_bold = font(30, bold=True)

    margin = 72
    x0, y0 = margin + 18, margin
    x1, y1 = width - margin + 18, height - margin
    radius = 24

    draw.rounded_rectangle((x0 - 18, y0 + 20, x1 + 18, y1 + 28), radius=radius + 8, fill=rgb(palette["shadow"]))
    draw.rounded_rectangle((x0, y0, x1, y1), radius=radius, fill=rgb(palette["bg"]), outline=rgb(palette["title_border"]), width=2)

    title_h = 68
    draw.rounded_rectangle((x0 + 2, y0 + 2, x1 - 2, y0 + title_h), radius=radius - 2, fill=rgb(palette["title"]))
    draw.rectangle((x0 + 2, y0 + title_h - 16, x1 - 2, y0 + title_h), fill=rgb(palette["title"]))
    draw.line((x0, y0 + title_h, x1, y0 + title_h), fill=rgb(palette["title_border"]), width=2)

    dot_y = y0 + title_h // 2
    for idx, color in enumerate(("accent", "yellow", "green")):
        cx = x0 + 32 + idx * 28
        draw.ellipse((cx - 8, dot_y - 8, cx + 8, dot_y + 8), fill=rgb(palette[color]))

    draw.text((x0 + 132, y0 + 21), palette["name"], font=mono_sm, fill=rgb(palette["fg"]))
    caption = palette["caption"]
    caption_w = int(draw.textlength(caption, font=mono_sm))
    draw.text((x1 - caption_w - 32, y0 + 21), caption, font=mono_sm, fill=rgb(palette["muted"]))

    body_x = x0 + 46
    body_y = y0 + title_h + 42
    line_h = 43

    def line(segments: list[tuple[str, str]]) -> None:
        nonlocal body_y
        draw_segments(draw, body_x, body_y, segments, mono, palette)
        body_y += line_h

    def gap(amount: int = 22) -> None:
        nonlocal body_y
        body_y += amount

    line([("mark@workstation", "green"), (" ", "fg"), ("~/Code/GH/mamerbot/nothing-theme", "blue")])
    line([("$ ", "accent"), ("make validate", "fg")])
    line([("iTerm2 light validation passed", "green")])
    line([("Ghostty theme validation passed", "green")])
    line([("tmux theme validation passed", "green")])
    line([("Neovim theme validation passed", "green")])
    line([("Dark terminal background validation passed", "green")])
    gap(20)

    bar_x, bar_y = body_x, body_y
    draw.rounded_rectangle((bar_x, bar_y, x1 - 46, bar_y + 58), radius=10, fill=rgb(palette["surface"]), outline=rgb(palette["title_border"]), width=1)
    draw.text((bar_x + 22, bar_y + 15), "palette", font=mono_sm, fill=rgb(palette["muted"]))
    swatch_x = bar_x + 150
    for color in ("red", "green", "yellow", "blue", "magenta", "cyan", "accent"):
        draw.rounded_rectangle((swatch_x, bar_y + 16, swatch_x + 72, bar_y + 42), radius=5, fill=rgb(palette[color]))
        swatch_x += 88
    body_y += 92

    line([("git status --short", "fg")])
    line([(" M ", "yellow"), ("README.md", "fg")])
    line([(" M ", "yellow"), ("scripts/deploy-windows-light.ps1", "fg")])
    line([("?? ", "cyan"), ("wallpapers/voltron-industrial/", "fg")])
    gap(18)

    code_x, code_y = body_x, body_y
    code_w, code_h = x1 - body_x - 46, 188
    draw.rounded_rectangle((code_x, code_y, code_x + code_w, code_y + code_h), radius=12, fill=rgb(palette["surface"]), outline=rgb(palette["title_border"]), width=1)
    y = code_y + 25
    code_lines = [
        [("local", "red"), (" c ", "fg"), ("= ", "muted"), ("require", "blue"), ("(", "muted"), ("'nothing.palette'", "green"), (")", "muted")],
        [("vim", "cyan"), (".g.colors_name ", "fg"), ("= ", "muted"), ("'nothing-light'", "green")],
        [("hl", "blue"), ("(", "muted"), ("'Cursor'", "green"), (", ", "muted"), ("{ fg = c.bg, bg = c.accent }", "fg"), (")", "muted")],
        [("-- accent appears only when it matters", "muted")],
    ]
    for segments in code_lines:
        draw_segments(draw, code_x + 26, y, segments, mono, palette)
        y += 37

    cursor_w = int(draw.textlength("$ ", font=mono_bold))
    prompt_y = y1 - 78
    draw.text((body_x, prompt_y), "$ ", font=mono_bold, fill=rgb(palette["accent"]))
    draw.rounded_rectangle((body_x + cursor_w + 2, prompt_y + 4, body_x + cursor_w + 21, prompt_y + 36), radius=3, fill=rgb(palette["accent"]))

    return img


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    for slug, palette in THEMES.items():
        image = terminal_preview(slug, palette)
        out = OUT_DIR / f"{slug}.png"
        image.save(out, optimize=True)
        print(f"wrote {out.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
