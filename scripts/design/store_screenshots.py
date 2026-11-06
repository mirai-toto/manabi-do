#!/usr/bin/env python3
"""Frame raw phone screenshots into Play Store images: 1080x1920 (9:16), a
caption on a gradient in the shot's colour theme, the screenshot below it.

The raw screenshots come from the emulator (`adb exec-out screencap -p`), one
per entry in SHOTS, named `<id>.png`. Run from the repo root:

    python3 scripts/design/store_screenshots.py RAW_DIR OUT_DIR

Needs ImageMagick (`convert`). Captions use Inter, the app's own font.
"""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
FONT = ROOT / "manabi_do/assets/fonts/Inter[opsz,wght].ttf"

WIDTH, HEIGHT = 1080, 1920
SHOT_HEIGHT = 1460  # the phone screenshot, scaled to this height
SHOT_TOP = 400
CORNER = 44

# The landing-hero gradient of each colour theme (theme_palettes.py), so the
# frame matches the theme the screenshot was taken in.
HERO = {
    "fuji": ("0D0630", "3D1FCC"),
    "ai": ("05112E", "1F46B8"),
    "sakura": ("2A0716", "9C2F5E"),
    "matcha": ("111A03", "46610F"),
    "kuri": ("1C0E06", "6B4128"),
    "sumi": ("0E1116", "3A4452"),
}

# id: (theme, caption, subtitle)
SHOTS = {
    "1-home": ("fuji", "Learn Japanese, offline", "Kana, kanji, vocabulary and grammar"),
    "2-mcq": ("fuji", "Practice that adapts to you", "Spaced repetition plans every review"),
    "3-draw": ("ai", "Write kanji stroke by stroke", "Checked as you draw"),
    "4-vocab": ("sakura", "The words that matter most", "Ordered by how often they appear"),
    "5-grammar": ("matcha", "Grammar from the basics", "Clear lessons, starting with how Japanese is written"),
    "6-widgets": ("kuri", "Review from your home screen", "Reviews, kanji of the day, grammar, streak"),
    "7-cloze": ("sumi", "Words in real sentences", "Fill the gap, with furigana and translation"),
    "8-builder": ("sakura", "Build sentences, learn grammar", "Arrange the words, check your answer"),
}


def run(*args: str) -> None:
    subprocess.run(["convert", *args], check=True)


def frame(raw: Path, out: Path, theme: str, caption: str, subtitle: str) -> None:
    deep, mid = HERO[theme]
    tmp = out.with_suffix(".shot.png")
    # Screenshot scaled, corners rounded through a rounded-rectangle mask, then
    # given a soft shadow.
    w_raw, h_raw = map(int, subprocess.run(
        ["identify", "-format", "%w %h", str(raw)], check=True, capture_output=True, text=True,
    ).stdout.split())
    w = round(w_raw * SHOT_HEIGHT / h_raw)
    run(
        str(raw), "-resize", f"{w}x{SHOT_HEIGHT}!",
        "(", "-size", f"{w}x{SHOT_HEIGHT}", "xc:none", "-fill", "white",
        "-draw", f"roundrectangle 0,0,{w - 1},{SHOT_HEIGHT - 1},{CORNER},{CORNER}", ")",
        "-alpha", "set", "-compose", "DstIn", "-composite",
        "(", "+clone", "-background", "black", "-shadow", "45x24+0+18", ")",
        "+swap", "-background", "none", "-compose", "Over", "-layers", "merge", "+repage",
        str(tmp),
    )
    run(
        "-size", f"{WIDTH}x{HEIGHT}", f"gradient:#{deep}-#{mid}",
        "-font", str(FONT), "-fill", "white", "-stroke", "white", "-strokewidth", "1.6",
        "-pointsize", "70", "-gravity", "north", "-annotate", "+0+150", caption,
        "-stroke", "none", "-fill", "#FFFFFFCC",
        "-pointsize", "38", "-annotate", "+0+262", subtitle,
        str(tmp), "-gravity", "north", "-geometry", f"+0+{SHOT_TOP - 30}", "-composite",
        str(out),
    )
    tmp.unlink()


def main() -> int:
    if len(sys.argv) != 3:
        print(__doc__)
        return 2
    raw_dir, out_dir = Path(sys.argv[1]), Path(sys.argv[2])
    out_dir.mkdir(parents=True, exist_ok=True)
    for shot, (theme, caption, subtitle) in SHOTS.items():
        frame(raw_dir / f"{shot}.png", out_dir / f"{shot}.png", theme, caption, subtitle)
        print(out_dir / f"{shot}.png")
    return 0


if __name__ == "__main__":
    sys.exit(main())
