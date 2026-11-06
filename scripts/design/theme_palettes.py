#!/usr/bin/env python3
"""Build the colour themes, check their contrast, and write the Dart file.

Each theme hand-picks its primary family, light and dark: those are the colours
people notice, and a formula gets them wrong (the same HSL lightness is dark for
violet and bright for green). Everything else is derived from Fuji, the
original violet theme, so the themes stay one design:

- surfaces and outlines keep Fuji's lightness and take the theme's hue, with
  a little less colour where the theme asks for it (Sumi is nearly grey);
- the vocabulary level ramp runs dark to light around the theme's primary;
- semantic colours (error, success, warning, readings) are shared, since they
  mean the same thing in every theme.

Fuji's own values are kept exactly as they were validated.

Run from the repo root:

    python3 scripts/design/theme_palettes.py           # check and print a report
    python3 scripts/design/theme_palettes.py --write   # also regenerate the Dart

Exits 1 when a theme fails a contrast rule.
"""

from __future__ import annotations

import argparse
import colorsys
import subprocess
import sys
from pathlib import Path

OUT = Path(__file__).resolve().parents[2] / "manabi_do/lib/core/theme/app_palettes.dart"

# Fuji, as it shipped. Neutrals are re-hued for the other themes; the semantic
# block is shared by all of them.
FUJI_NEUTRAL = {
    "light": {
        "surface": "FEF7FF",
        "surfaceVariant": "E7E0EC",
        "surfaceContainer": "F3EDF7",
        "surfaceContainerHigh": "ECE6F0",
        "cardBackground": "FFFFFF",
        "onSurface": "1C1B1F",
        "onSurfaceVariant": "49454F",
        "outline": "79747E",
        "outlineVariant": "CAC4D0",
    },
    "dark": {
        "surface": "141218",
        "surfaceVariant": "49454F",
        "surfaceContainer": "211F26",
        "surfaceContainerHigh": "2B2930",
        "cardBackground": "1E1B24",
        "onSurface": "E6E1E5",
        "onSurfaceVariant": "CAC4D0",
        "outline": "938F99",
        "outlineVariant": "49454F",
    },
}

SEMANTIC = {
    "light": {
        "error": "B3261E",
        "errorContainer": "FCE8E6",
        "success": "146B3A",
        "successContainer": "C8F5DA",
        "warning": "7A5200",
        "warningContainer": "FFDDB3",
        "hintStroke": "FF8F00",
        "onyomi": "1565C0",
        "kunyomi": "C62828",
    },
    "dark": {
        "error": "F2B8B5",
        "errorContainer": "8C1D18",
        "success": "6CDFAB",
        "successContainer": "0A3D22",
        "warning": "FFBA60",
        "warningContainer": "3E2900",
        "hintStroke": "FFB74D",
        "onyomi": "90CAF9",
        "kunyomi": "EF9A9A",
    },
}

# Fuji's level ramps, validated when they were introduced (vocabulary_level.dart).
FUJI_RAMP = {
    "light": ["2E1A8C", "4B2FD1", "6B4EFF", "9B7FFF", "B9A4FF"],
    "dark": ["CFBCFF", "B39DFF", "9179EB", "6E58BC", "514293"],
}

# name: (label, neutral colour factor, hero deep, hero mid, light, dark)
# light/dark: primary, primaryLight, primaryContainer, onPrimary, onPrimaryContainer
THEMES = {
    "fuji": ("Fuji 藤", 1.0, "0D0630", "3D1FCC",
             ("6B4EFF", "9B7FFF", "E8E0FF", "FFFFFF", "1E0085"),
             ("CFBCFF", "B39DFF", "4F378B", "381E72", "EADDFF")),
    "ai": ("Ai 藍", 1.0, "05112E", "1F46B8",
           ("2F5BD3", "6E8FE8", "DCE4FF", "FFFFFF", "00164F"),
           ("B3C5FF", "8EA8F5", "2B4597", "0A2A73", "DBE1FF")),
    "sakura": ("Sakura 桜", 1.0, "2A0716", "9C2F5E",
               ("B83C6F", "E07AA3", "FFD9E4", "FFFFFF", "3E0021"),
               ("FFB0CB", "F28DB2", "7D2A4E", "5E1133", "FFD9E4")),
    "matcha": ("Matcha 抹茶", 0.8, "111A03", "46610F",
               ("55701C", "8CAD4E", "DCEDB8", "FFFFFF", "1A2600"),
               ("B7D47E", "9DBB62", "3F5A06", "263500", "D3EEA0")),
    "sumi": ("Sumi 墨", 0.3, "0E1116", "3A4452",
             ("3F4A5A", "77818F", "DDE3EC", "FFFFFF", "121C28"),
             ("C4CBD6", "A3ABB8", "3B4552", "1F2833", "DFE6F0")),
}

PRIMARY_KEYS = ["primary", "primaryLight", "primaryContainer", "onPrimary", "onPrimaryContainer"]
FUJI_HUE = colorsys.rgb_to_hls(*[c / 255 for c in bytes.fromhex("6B4EFF")])[0]


def rgb(hex_: str) -> tuple[float, float, float]:
    return tuple(c / 255 for c in bytes.fromhex(hex_))  # type: ignore[return-value]


def to_hex(r: float, g: float, b: float) -> str:
    return "".join(f"{round(max(0.0, min(1.0, c)) * 255):02X}" for c in (r, g, b))


def mix(a: str, b: str, t: float) -> str:
    return to_hex(*[x + (y - x) * t for x, y in zip(rgb(a), rgb(b))])


def rehue(hex_: str, hue: float, chroma: float) -> str:
    """[hex_] with its HLS hue moved to [hue] and its saturation scaled."""
    h, l, s = colorsys.rgb_to_hls(*rgb(hex_))
    if s == 0:
        return hex_
    return to_hex(*colorsys.hls_to_rgb(hue, l, s * chroma))


def luminance(hex_: str) -> float:
    def lin(c: float) -> float:
        return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4

    r, g, b = (lin(c) for c in rgb(hex_))
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def contrast(a: str, b: str) -> float:
    la, lb = sorted((luminance(a), luminance(b)), reverse=True)
    return (la + 0.05) / (lb + 0.05)


def build(name: str) -> dict[str, dict[str, object]]:
    _, chroma, hero_deep, hero_mid, light, dark = THEMES[name]
    hue = colorsys.rgb_to_hls(*rgb(light[0]))[0]
    out: dict[str, dict[str, object]] = {}
    for mode, primaries in (("light", light), ("dark", dark)):
        tokens: dict[str, object] = {}
        for key, value in FUJI_NEUTRAL[mode].items():
            tokens[key] = value if name == "fuji" else rehue(value, hue, chroma)
        tokens.update(zip(PRIMARY_KEYS, primaries))
        tokens.update(SEMANTIC[mode])
        p, pl = primaries[0], primaries[1]
        if name == "fuji":
            ramp = FUJI_RAMP[mode]
        elif mode == "light":
            ramp = [mix(p, "000000", 0.4), mix(p, "000000", 0.2), p, pl, mix(pl, "FFFFFF", 0.3)]
        else:
            ramp = [p, pl, mix(pl, "000000", 0.2), mix(pl, "000000", 0.38), mix(pl, "000000", 0.52)]
        tokens["levelRamp"] = ramp
        # The landing hero sits on its own dark panel, so both modes share it.
        tokens["heroDeep"] = hero_deep
        tokens["heroMid"] = hero_mid
        out[mode] = tokens
    return out


# (foreground, background, minimum): text needs 4.5, large text and UI parts 3.
RULES = [
    ("onPrimary", "primary", 4.5),
    ("onPrimaryContainer", "primaryContainer", 4.5),
    ("primary", "surface", 4.5),
    ("primary", "cardBackground", 4.5),
    ("primary", "primaryContainer", 3.0),
    ("onSurfaceVariant", "surface", 4.5),
    ("onSurface", "surfaceContainerHigh", 4.5),
]


def check(name: str, tokens: dict[str, dict[str, object]]) -> list[str]:
    failures = []
    for mode in ("light", "dark"):
        t = tokens[mode]
        for fg, bg, minimum in RULES:
            ratio = contrast(str(t[fg]), str(t[bg]))
            if ratio < minimum:
                failures.append(f"{name}/{mode}: {fg} on {bg} is {ratio:.2f}, needs {minimum}")
        ramp = [str(c) for c in t["levelRamp"]]  # type: ignore[union-attr]
        lums = [luminance(c) for c in ramp]
        if lums != sorted(lums) and lums != sorted(lums, reverse=True):
            failures.append(f"{name}/{mode}: level ramp lightness is not monotone")
    return failures


def dart_color(hex_: object) -> str:
    return f"Color(0xFF{hex_})"


def dart_tokens(t: dict[str, object]) -> str:
    lines = []
    for key, value in t.items():
        if key == "levelRamp":
            ramp = ", ".join(dart_color(c) for c in value)  # type: ignore[union-attr]
            lines.append(f"    levelRamp: [{ramp}],")
        else:
            lines.append(f"    {key}: {dart_color(value)},")
    return "\n".join(lines)


def render() -> str:
    parts = [
        "// Generated by scripts/design/theme_palettes.py. Edit the script and run it",
        "// with --write rather than changing this file by hand.",
        "",
        "part of 'app_palette.dart';",
        "",
    ]
    for name in THEMES:
        tokens = build(name)
        for mode in ("light", "dark"):
            parts += [f"const AppTokens _{name}{mode.capitalize()} = AppTokens(", dart_tokens(tokens[mode]), ");", ""]
    return "\n".join(parts)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--write", action="store_true", help="regenerate app_palettes.dart")
    args = parser.parse_args()

    failures = []
    for name, spec in THEMES.items():
        tokens = build(name)
        failures += check(name, tokens)
        light, dark = tokens["light"], tokens["dark"]
        print(
            f"{spec[0]:<12} light primary {light['primary']} on surface {contrast(str(light['primary']), str(light['surface'])):.1f}:1"
            f" · dark primary {dark['primary']} on surface {contrast(str(dark['primary']), str(dark['surface'])):.1f}:1"
        )
    for failure in failures:
        print(f"FAIL {failure}")
    if args.write and not failures:
        OUT.write_text(render(), encoding="utf-8")
        subprocess.run(["dart", "format", str(OUT)], check=True, capture_output=True)
        print(f"Wrote {OUT}")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
