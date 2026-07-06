# Scripts

## Screenshot scripts

All scripts require Playwright to be installed once:
```bash
cd /tmp/pw-test && npm install playwright && npx playwright install chromium
```

Screenshots are saved to `screenshots/` (gitignored) at the repo root.

| Script | What it does |
|--------|-------------|
| `screenshot.js` | Single screenshot of the home screen. Args: `[port]` `[output_path]`. |
| `screenshot_tab.js` | Screenshots every bottom-nav tab. Args: `[port]` `[outputDir]`. |
| `screenshot_grammar.js` | Screenshots the full grammar flow — level selector, basics chapter list, every lesson. Args: `[port]`. Requires the app built with `_grammarEnabled = true`. |
| `rebuild_and_screenshot.sh` | **One-command shortcut** — flips `_grammarEnabled`, builds, serves, runs `screenshot_tab` + `screenshot_grammar`, then reverts the flag. |

### Running a single script
```bash
NODE_PATH=/tmp/pw-test/node_modules node scripts/screenshot.js
NODE_PATH=/tmp/pw-test/node_modules node scripts/screenshot_tab.js
NODE_PATH=/tmp/pw-test/node_modules node scripts/screenshot_grammar.js
```

### Running everything at once
```bash
bash scripts/rebuild_and_screenshot.sh
```

### Environment variables
| Variable | Default | Purpose |
|----------|---------|---------|
| `SCREENSHOT_FONT` | `/usr/share/fonts/truetype/dejavu/DejaVuSans-BoldOblique.ttf` | Fallback font for gstatic intercept. Override on non-WSL2 environments. |
| `CHROMIUM_PATH` | Playwright default | Path to Chromium binary. Override when Playwright's bundled version doesn't match the installed browser. |

### Known limitations
- Hiragana and Katakana appear as tofu boxes in all screenshots. Root cause: CanvasKit + SwiftShader software GL cannot rasterize kana glyph outlines. CJK ideographs render fine. Not fixable without a real GPU. Screenshots are still useful for layout and navigation review.
- No live database on web builds — data-dependent UI (counts, progress) shows empty/fallback states.
