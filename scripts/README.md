# Scripts

## Structure

```
scripts/
  run/
    run-linux.sh               # Build (Docker) + launch app on Linux
    run-widgetbook-linux.sh    # Launch widgetbook on Linux
    run-windows.ps1            # Build (Docker) + launch app on Windows
    run-widgetbook-windows.ps1 # Launch widgetbook on Windows
    run-web.sh                 # Flutter web build + local HTTP server
  screenshot/
    rebuild_and_screenshot.sh  # Full pipeline: build + all screenshots
    screenshot.js              # Single screenshot utility
    screenshot_tab.js          # Screenshots every bottom-nav tab
    screenshot_grammar.js      # Screenshots the full grammar flow
    screenshot_grammar_n5.js   # Screenshots N5 grammar lessons
    pw/                        # Playwright install dir (gitignored, auto-installed)
    output/                    # Screenshot output (gitignored)
  setup/
    setup-android-signing.sh   # Android signing key setup
    app.build.gradle.kts.template  # Gradle signing config template
  README.md
```

---

## Screenshot scripts

### One command (recommended)

```bash
bash scripts/screenshot/rebuild_and_screenshot.sh
```

Enables grammar, builds, serves, runs all screenshot scripts, then reverts the grammar flag.
Installs Playwright automatically on first run into `scripts/screenshot/pw/`.

### Individual scripts

```bash
export NODE_PATH=scripts/screenshot/pw/node_modules

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
# Build (Docker) + launch the app
bash scripts/run/run-linux.sh
bash scripts/run/run-widgetbook-linux.sh

# Build Flutter web and serve locally
bash scripts/run/run-web.sh [port]   # defaults to 8767
```
