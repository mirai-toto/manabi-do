---
description: Launch this Flutter app (or its widgetbook) as a web build and screenshot it with headless Chromium, for visual inspection. Two environments covered: Claude web container (no Flutter SDK, restricted proxy) and local WSL2 (Flutter pre-installed, no restrictions). Use whenever asked to "see", "look at", or "screenshot" the UI, or to visually verify a change.
---

## IMPORTANT: never take screenshots proactively

Do **not** run `rebuild_and_screenshot.sh` or any screenshot script on your own initiative. Screenshots take ~2 minutes to build and are only useful when the user explicitly asks to see them. Wait for the user to say "screenshot", "show me", "what does it look like", etc.

# Running manabi_do (or its widgetbook) headless and screenshotting it

---

## WSL2 / Local Linux path

Flutter SDK is pre-installed. No proxy restrictions.

### 1. Build

```bash
cd /home/wsluser/manabi-do/manabi_do
flutter build web -t lib/main.dart --no-web-resources-cdn --debug
```

Swap `-t lib/main.dart` for `-t lib/widgetbook.dart` for the widgetbook.

### 2. Serve

```bash
pkill -f "http.server 8767" 2>/dev/null || true
setsid nohup python3 -m http.server 8767 --bind 0.0.0.0 \
  --directory build/web > /tmp/webserver.log 2>&1 < /dev/null & disown
curl -sf http://localhost:8767 | head -2
```

### 3. Screenshot with Playwright

Playwright lives in `/tmp/pw-test/` (first time: `cd /tmp/pw-test && npm install playwright && npx playwright install chromium`).

A reusable base script lives at `scripts/screenshot.js` in the repo root. Run it with:

```bash
NODE_PATH=/tmp/pw-test/node_modules node scripts/screenshot.js [port] [output_path]
# e.g.
NODE_PATH=/tmp/pw-test/node_modules node scripts/screenshot.js 8768 /tmp/home.png
```

For multi-step navigation (click through screens), write a new script in `scripts/` that requires the same playwright setup:
- Font: `/usr/share/fonts/truetype/dejavu/DejaVuSans-BoldOblique.ttf` (liberation fonts not installed)
- `waitUntil: 'load'` — do NOT use `'networkidle'`, Flutter web never reaches it
- 5 s initial wait after load for the canvas to fully render
- Navigate by pixel coords from a prior screenshot — Flutter canvas has no DOM selectors
- Always pass `colorScheme: 'dark'` to `browser.newPage()` — Flutter reads `MediaQuery.platformBrightness` from the browser, which defaults to light in headless Chromium

### 4. Notes specific to WSL2

- `kDebugMode` is always `false` on web builds. To bypass the `_grammarEnabled = false` gate in `grammar_screen.dart`, flip it to `true` temporarily. **Revert before committing.**
- **Hiragana/Katakana appear as tofu boxes** in all screenshots (headless and WSLg-headed). Root cause: CanvasKit + SwiftShader software GL cannot rasterize kana glyph outlines. CJK ideographs render fine. Not fixable without a real GPU or the HTML renderer (removed in Flutter 3.22+). Screenshots are still useful for layout/navigation review — just not for reading Japanese kana content.
- Read screenshots with the Read tool — Claude can view PNG images directly.

---

## Claude web container path

This container has no Flutter SDK, no GPU, `kill`/`pkill` are blocked by the
sandbox, and outbound network only reaches a fixed allowlist through a proxy
(GitHub is allowed, `gstatic.com` is not). Flutter web's default behavior
assumes none of that. Below is the path that actually works, in order —
follow it, don't rediscover it.

This container has no Flutter SDK, no GPU, `kill`/`pkill` are blocked by the
sandbox, and outbound network only reaches a fixed allowlist through a proxy
(GitHub is allowed, `gstatic.com` is not). Flutter web's default behavior
assumes none of that. Below is the path that actually works, in order —
follow it, don't rediscover it.

## 1. Install Flutter (not preinstalled)

```bash
git clone https://github.com/flutter/flutter.git /opt/flutter --branch stable --depth 1
export PATH="/opt/flutter/bin:$PATH"   # add to every subsequent shell call
flutter config --enable-web
flutter precache --web
```

Ignore the "Woah! You appear to be trying to run flutter as root" banner —
harmless in this container.

## 2. Fetch deps and generate code

```bash
cd manabi_do
flutter pub get
flutter gen-l10n                                   # reads l10n.yaml
dart run build_runner build                         # NOT --delete-conflicting-outputs — that flag is removed/ignored and just prints a warning
```

## 3. Build a static web bundle — do NOT use `flutter run -d web-server`

`flutter run -d web-server` waits on a debug-service/Dart-Debug-Extension
handshake that headless Chromium never completes — the page loads scripts
but `main()` never visibly starts and the canvas stays blank forever no
matter how long you wait. Skip it entirely. Build instead:

```bash
flutter build web -t lib/widgetbook.dart --no-web-resources-cdn --debug
```

- `-t lib/widgetbook.dart` — swap for `lib/main.dart` to build the real app
  instead of the widgetbook.
- `--no-web-resources-cdn` is required: without it, Flutter's CanvasKit
  loader fetches `https://www.gstatic.com/flutter-canvaskit/...`, which this
  environment's egress proxy blocks (403) — the app hangs after "DDC is
  about to load N/N scripts" with no further console output.
- Use `--debug` (not the default release build) while iterating. Release
  builds swallow widget-build exceptions and render the crashed subtree as a
  **plain, silent grey rectangle — no red text, no console error, nothing**.
  If you see a mysterious grey box in a screenshot, your first move is to
  rebuild with `--debug` and read the browser console
  (`page.on('pageerror')` / `page.on('console')`) for the real
  `EXCEPTION CAUGHT BY WIDGETS LIBRARY` message before assuming it's a
  rendering/screenshot problem. (This is how a real bug in
  `parseFurigana`/`JapaneseText` — a `RangeError` on empty `reading` with
  2+ kanji clusters — was found: it looked exactly like a font/GPU artifact
  until the debug build named the exception.)

Serve the output — plain Python is fine:

```bash
cd build/web && python3 -m http.server 8766 --bind 0.0.0.0
```

## 4. `kill`/`pkill` are blocked here — don't use them

Any `kill <pid>` or `pkill -f ...` in this sandbox returns exit code 144
(SIGSTKFLT) instead of doing anything, whether or not a matching process
exists. Don't spend time debugging that — it's not your process's fault.
**Workaround: never kill, just use a new port** for the next server/build
you spin up.

## 5. Backgrounding a process must survive the tool call ending

`nohup cmd &` alone gets reaped when the Bash tool call returns, even with
`disown`. Use `setsid` too, and redirect stdin:

```bash
setsid nohup flutter build ... > build.log 2>&1 < /dev/null &
disown
```

Poll readiness with `curl -sf`, never a blind `sleep`.

## 6. Driving it: no `chromium-cli`, no real DOM — pixel clicks only

- `chromium-cli` is not installed here. Use Node + the `playwright` **npm
  package** (not preinstalled either — `npm install playwright` in a scratch
  dir) driving the browser at
  `executablePath: '/opt/pw-browsers/chromium'` (already present, do not
  `playwright install`).
- Flutter web with the CanvasKit renderer paints everything to one
  `<canvas>`. There is no DOM to `page.locator(...)` against — every widget,
  button, and list item is invisible to CSS selectors. Drive it with
  `page.mouse.click(x, y)` / `page.mouse.wheel(...)` using pixel coordinates
  read off a screenshot (view the screenshot yourself to find coordinates,
  then click).
- For multi-step interaction (expand a tree, scroll, click a leaf, repeat),
  don't relaunch the browser each step — it's slow and re-triggers font/proxy
  setup. Launch once, hold it open behind a tiny local control server (a
  Node script listening on a Unix socket that accepts `{type: "click"/
  "scroll"/"screenshot", ...}` commands over newline-delimited JSON, run via
  `setsid nohup node session.js &`), and fire commands into it with a
  short client script per step.

## 7. Launch flags that matter

```js
chromium.launch({
  executablePath: '/opt/pw-browsers/chromium',
  args: [
    '--no-sandbox',
    '--use-gl=swiftshader',       // software GL — avoids GPU-driver artifacts/stalls in this container
    '--disable-gpu-sandbox',
    '--enable-webgl',
    '--ignore-gpu-blocklist',
  ],
})
```

## 8. Fonts: two separate problems, two separate fixes

- **CanvasKit's built-in Roboto fallback** is fetched from
  `fonts.gstatic.com` regardless of `--no-web-resources-cdn` and regardless
  of whether the app uses `google_fonts` (it doesn't). That host is blocked
  by the proxy (403), and unlike a missing app font this fetch failure
  leaves Latin text **completely invisible** (CanvasKit has no glyphs to
  paint, not even tofu boxes) — you'll see correct layout/borders but blank
  text. Fix: intercept the request in Playwright and fulfill it with any
  local system TTF (format is sniffed from magic bytes, so a substitute
  works fine):

  ```js
  const fallbackFont = fs.readFileSync('/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf');
  await page.route('https://fonts.gstatic.com/**', (route) =>
    route.fulfill({ status: 200, contentType: 'font/ttf', body: fallbackFont }));
  ```

- **The app's own bundled fonts** (`Inter`, `NotoSansJP`, `NotoColorEmoji`
  under `assets/fonts/`) are same-origin assets and load fine on their own —
  no proxy involvement, no interception needed for these.

## 9. Widgetbook layout reference (for faster navigation)

Entry point: `lib/widgetbook.dart`. Grammar block use cases live under
`Grammar > Blocks` in the sidebar tree (alphabetically after `Exercise`),
sourced from `lib/widgetbook/grammar_use_cases.dart` — block names match
the widget class names (`ComparisonBlock`, `ExampleTableBlock`, etc.), each
with one or more named use-case leaves underneath.
