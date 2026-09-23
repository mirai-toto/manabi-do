# Scripts

Everything runnable lives here — shell, Python and Dart alike. Each directory is
one responsibility.

```
scripts/
  common/                          # sourced by other scripts, never run directly
    env.sh                         # REPO / APP / SCRIPTS paths
    flutter_web.sh                 # flutter_web_build <target> [mode]
    serve.sh                       # serve_dir <dir> [port] [bind]
  run/                             # launch the app for a human
    run-linux.sh                   # Build (Docker) + launch on Linux
    run-windows.ps1                # Build (Docker) + launch on Windows
    run-web.sh                     # Flutter web build + local HTTP server
    run-widgetbook-linux.sh        # Launch widgetbook on Linux
    run-widgetbook-windows.ps1     # Launch widgetbook on Windows
  content_pipeline/                # compile content/ into the shipped DB
    generate.py                    # orchestrator — the entry point
    sync_content.py                # re-seed content/ from online sources
    gen_translations.py            # multilingual meanings from JMdict/KANJIDIC2
    download_kanjivg.py            # fetch missing stroke-order SVGs
    build_content_db.py            # content/ → manabi_do_content.db
  design/                          # the design system reference
    build_design_reference.sh      # widgetbook build + page generation
    gen_design_reference.dart      # reads the theme source, writes the page
  screenshot/                      # capture app screenshots headlessly
    rebuild_and_screenshot.sh      # full pipeline: build + every screenshot
    screenshot.js                  # single screenshot
    screenshot_tab.js              # every bottom-nav tab
    screenshot_grammar.js          # the full grammar flow
    screenshot_grammar_n5.js       # N5 grammar lessons
    pw/                            # Playwright install (gitignored)
    output/                        # screenshot output (gitignored)
  setup/                           # one-time machine setup
    setup-android-signing.sh
    app.build.gradle.kts.template
  sonar/                           # code quality scan
    sonar.sh
    docker-compose.yml
    sonar-project.properties
    plugins/                       # plugin jars (gitignored)
    .sonar_token                   # cached token (gitignored)
  README.md
```

`content_pipeline/` rather than `content/`, because the repo root already has a
`content/` holding the JSON data and two directories with that name would be
worse than the split this replaced.

---

## common/

Source these; do not execute them. A helper earns a place here when **two or
more** scripts need it — matching numbers is not enough on its own.

```bash
source "$(dirname "$0")/../common/env.sh"
source "$SCRIPTS/common/flutter_web.sh"
source "$SCRIPTS/common/serve.sh"

flutter_web_build lib/main.dart --debug
serve_dir "$APP/build/web" 8767
```

| Helper | Provides | Used by |
| --- | --- | --- |
| `env.sh` | `REPO`, `APP`, `SCRIPTS` | everything |
| `flutter_web.sh` | `flutter_web_build <target> [mode]` | `run/run-web.sh`, `design/build_design_reference.sh` |
| `serve.sh` | `serve_dir <dir> [port] [bind]` | `run/run-web.sh`, `design/build_design_reference.sh` |

Three things `common/` fixes that the inline copies got wrong:

- Paths resolve from the helper's own location, so a script can move directories
  without its `cd ../..` quietly pointing somewhere else.
- `--no-web-resources-cdn` is always passed. Without it Flutter fetches CanvasKit
  from `gstatic.com`, which fails behind a restricted proxy and leaves a blank
  canvas with no error.
- `serve_dir` polls with `curl` until the server answers instead of sleeping for
  a second and hoping, and reports failure rather than returning success.

Playwright bootstrap is deliberately **not** here: only
`screenshot/rebuild_and_screenshot.sh` installs it. One caller is not shared.

---

## Design reference

```bash
bash scripts/design/build_design_reference.sh --serve
# open http://localhost:8800/design-reference/
```

Builds the widgetbook for web, stages it into `design-reference/widgetbook/`,
then generates `design-reference/index.html` from the theme source: colour tokens
with WCAG contrast grades, the dimension and type scales, and a live preview of
every widgetbook use case.

| Flag | Effect |
| --- | --- |
| `--serve` | serve the repo root on 8800 when the build finishes |
| `--debug` | debug build — release paints crashed widgets as silent grey boxes |

It has to be served over HTTP. Opened from disk, `file://` renders each preview
iframe as a directory listing and Flutter cannot boot from it. The page detects
this and says so.

Previews boot one at a time as you scroll, because each is a whole Flutter engine
(~44 MB, ~3 s). Append `?tiles=3` to the URL to cap them when you only came for
the tokens. Output is gitignored — rebuild rather than commit.

---

## Content pipeline

Run through Docker so the Python dependencies stay out of your machine:

```bash
docker compose run --rm content
```

That runs `generate.py`, which orchestrates the rest. See `content/README.md` for
the full rebuild workflow and `docs/03_database.md` for the schema.

`generate.py` resolves its siblings from its own location, so it works from any
working directory.

---

## Screenshots

```bash
bash scripts/screenshot/rebuild_and_screenshot.sh
```

Enables grammar, builds, serves, runs every screenshot script, then reverts the
grammar flag. Installs Playwright on first run into `scripts/screenshot/pw/`.

```bash
export NODE_PATH=scripts/screenshot/pw/node_modules

node scripts/screenshot/screenshot.js [port] [output_path]
node scripts/screenshot/screenshot_tab.js [port] [outputDir]
node scripts/screenshot/screenshot_grammar.js [port]
```

| Variable | Default | Purpose |
| --- | --- | --- |
| `SCREENSHOT_FONT` | `/usr/share/fonts/truetype/dejavu/DejaVuSans-BoldOblique.ttf` | Fallback font for the gstatic intercept. Override off WSL2. |
| `CHROMIUM_PATH` | Playwright default | Path to the Chromium binary. |

Known limitations:

- Kana can render as tofu boxes in app screenshots — CanvasKit on software GL
  cannot always rasterize the glyph outlines. CJK ideographs render fine. Note
  this does *not* affect the design reference, where kana renders correctly.
- No live database on web builds, so data-dependent UI shows fallback states.

---

## Build & run

```bash
bash scripts/run/run-linux.sh              # Docker build + launch
bash scripts/run/run-widgetbook-linux.sh   # widgetbook
bash scripts/run/run-web.sh [port]         # web build + serve, defaults to 8767
```

---

## SonarQube

```bash
bash scripts/sonar/sonar.sh
```

Downloads the [sonar-flutter community plugin](https://github.com/insideapp-fr/sonar-flutter)
on first run, generates a Dart analysis report and coverage via the Flutter Docker
service, starts SonarQube, and runs the scanner. The auth token is cached in
`scripts/sonar/.sonar_token`.

| | |
| --- | --- |
| URL | http://localhost:9000 |
| Username | `admin` |
| Password | `Sonar_local_1` (changed from the default on first run) |
