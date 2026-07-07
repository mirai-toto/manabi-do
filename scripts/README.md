# Scripts

## Structure

```
scripts/
  build/
    build_web.sh            # Flutter web build + local HTTP server
  run/
    linux.sh                # Launch app on Linux
    widgetbook-linux.sh     # Launch widgetbook on Linux
    windows.ps1             # Launch app on Windows
    widgetbook-windows.ps1  # Launch widgetbook on Windows
  screenshot/
    screenshot.js           # Single screenshot of the home screen
    screenshot_tab.js       # Screenshots every bottom-nav tab
    screenshot_grammar.js   # Screenshots the full grammar flow
    screenshot_grammar_n5.js  # Screenshots N5 grammar lessons
  setup/
    setup.sh                # One-time Playwright install (auto-called by rebuild_and_screenshot.sh)
    setup-android-signing.sh  # Android signing key setup
  pw/                       # Playwright install dir (gitignored)
  rebuild_and_screenshot.sh # Full pipeline: build + all screenshots
  README.md
```

Screenshots are saved to `screenshots/` (gitignored) at the repo root.

---

## Screenshot scripts

### One command (recommended)

```bash
bash scripts/rebuild_and_screenshot.sh
```

Enables grammar, builds, serves, runs all screenshot scripts, then reverts the grammar flag.
Installs Playwright automatically on first run.

### Individual scripts

```bash
export NODE_PATH=scripts/pw/node_modules

# Single home screenshot
node scripts/screenshot/screenshot.js [port] [output_path]

# All bottom-nav tabs
node scripts/screenshot/screenshot_tab.js [port] [outputDir]

# Full grammar flow (requires app built with _grammarEnabled = true)
node scripts/screenshot/screenshot_grammar.js [port]
```

### Environment variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `SCREENSHOT_FONT` | `/usr/share/fonts/truetype/dejavu/DejaVuSans-BoldOblique.ttf` | Fallback font for gstatic intercept. Override on non-WSL2 environments. |
| `CHROMIUM_PATH` | Playwright default | Path to Chromium binary. |

### Known limitations

- Hiragana and Katakana appear as tofu boxes in screenshots. Root cause: CanvasKit + SwiftShader software GL cannot rasterize kana glyph outlines. CJK ideographs render fine.
- No live database on web builds — data-dependent UI (counts, progress) shows empty/fallback states.

---

## Build & run scripts

```bash
# Build Flutter web and serve locally
bash scripts/build/build_web.sh [port]   # defaults to 8767

# Launch the app (Linux)
bash scripts/run/linux.sh
bash scripts/run/widgetbook-linux.sh
```
