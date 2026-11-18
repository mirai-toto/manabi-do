# AGENTS.md — Manabi Do

Offline Japanese learning app (kana, kanji, vocabulary, grammar) with FSRS spaced repetition. Flutter, Riverpod, drift (SQLite). No backend: all data and progress stay on the device.

## Layout

- `manabi_do/`: the Flutter app (run Flutter commands from here)
  - `lib/core/`: models, providers, theme (`AppTokens`, `AppDimens`, `AppTextStyles`)
  - `lib/presentation/`: screens, widgets, services, providers
  - `lib/l10n/`: ARB files (`app_en.arb` is the source) and generated localizations
- `scripts/`: every runnable script, one directory per job (see `scripts/README.md`)
- `docs/`: product, architecture, database, grammar, refactoring and feature docs
- Content (kanji, vocabulary, grammar) ships as a prebuilt database from [mirai-toto/manabi-content](https://github.com/mirai-toto/manabi-content); `scripts/content/fetch_content.sh` downloads the version pinned in `manabi_do/content.lock`

## Docs to read first

- `docs/01_product_requirements.md`: scope and v1 status
- `docs/02_architecture.md`: structure and data flow
- `docs/09_functional_features.md`: what the app does, screen by screen
- `docs/10_polish_backlog.md`: ranked improvement backlog
- `docs/06_refactoring_goals.md`: ongoing refactors (e.g. the single `AppButton` engine)

## Commands

```bash
git config core.hooksPath .githooks   # once per clone

cd manabi_do
flutter analyze
dart format .
flutter gen-l10n                      # after editing app_en.arb
flutter build apk --debug
flutter run -d linux                  # Escape triggers the same back handler as Android back
```

The pre-commit hook runs `flutter analyze` and `dart format --set-exit-if-changed`; both must pass.

## Tools

All under `scripts/` (details in `scripts/README.md`):

- `content/fetch_content.sh`: downloads the content database pinned in `content.lock` into the app
- `content/build_content.sh`: builds the content database from source instead, when working on the content pipeline
- `run/`: launch the app for a human: Linux via Docker, Windows, web (local server), and widgetbook
- `design/build_design_reference.sh`: builds and serves the design reference (colour tokens with contrast grades, dimension and type scales, every widget live)
- `design/widget_inventory.py`: groups widgets by purpose; flags overlaps, dead code and widgets bypassing the design system
- `design/theme_palettes.py`: builds the colour themes, checks their contrast, writes the Dart theme file
- `design/store_screenshots.py`: frames raw emulator screenshots into Play Store images
- `android/theme_tour.sh`: screenshots Home in every colour theme, light and dark, on the running emulator
- `android/widget_stale_repro.sh`: checks the Android home-screen widgets redraw after a reinstall
- `android/make_notification_icon.sh`: rebuilds the notification icon from the launcher icon
- `screenshot/`: headless web screenshots of every tab (web builds have no database content, see below)
- `sonar/sonar.sh`: runs a local SonarQube code quality scan
- `setup/setup-android-signing.sh`: one-time release signing setup, maintainer only

The `android/` scripts read the `ADB` variable for the Windows `adb.exe` path (see the emulator section below).

## Code rules

- **Theming**: colours from `context.tokens`, spacing and radii from `AppDimens`, text from `AppTextStyles`. No `Color(0xFF…)` or spacing literals in widgets. Use `.withValues(alpha:)`, not `.withOpacity()`.
- **AppDimens scope**: app-wide design decisions only (spacing scale, radii, border weights). A one-off inside a single widget stays local as a file-level `const _kFoo`.
- **i18n**: every visible string comes from `context.l10n`. Add new strings to `app_en.arb` (and `app_fr.arb`, `app_de.arb`), then run `flutter gen-l10n`. Japanese glyphs used as icons and brand names are not UI strings.
- **Widgets render, callers decide**: widgets don't read providers to decide whether to show themselves or how to behave; the screen or body reads settings and passes them as parameters. A widget without `ref` is a `StatelessWidget`.
- **Widget files**: grouped by feature under `lib/presentation/widgets/`, one widget per file, re-exported from the `widgets.dart` barrel that screens import.
- **Buttons**: `AppButton` is the only button engine; extend it instead of adding a new button widget.
- **In-tab back navigation**: drill-down state inside a tab (level → group) lives in a `NotifierProvider`, and `ShellScreen._onBack()` clears it step by step. Don't use `PopScope` + `maybePop()` for it.
- **No placeholders**: no feature flags, locked overlays or "coming soon" entries for unfinished work. Ship it or remove its entry points.
- Docs are written in English.

## Git and releases

- Commit messages are one line and must use one of these types, or commitlint rejects them: `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, `test`. The rejection is buried under `flutter pub get` output, so check `git log --oneline -1` after committing.
- `main` is protected: changes land through pull requests only.
- Git tags are the version source. `manabi_do/pubspec.yaml` stays at `0.0.0` on purpose; CI stamps the real version at build time. Don't rename `.github/workflows/build-android.yml`: its run number is the Android versionCode.

## Testing notes

- Web builds show no database content (drift can't seed the bundled DB on web), so DB-backed screens can't be checked on web.
- Android back bugs (predictive back) may not reproduce with Escape on Linux; check them on an Android emulator.

### Android Studio emulator from WSL

The emulator runs on the Windows host. WSL's own `adb` doesn't see it, so use the Windows `adb.exe` from the Android SDK, and install from a Windows path.

```bash
ADB="/mnt/c/Users/<windows-user>/AppData/Local/Android/Sdk/platform-tools/adb.exe"
WINTMP="/mnt/c/Users/<windows-user>/AppData/Local/Temp"

# 1. Find the emulator. A recreated device can leave a dead entry behind:
#    keep the one that answers.
"$ADB" devices
timeout 15 "$ADB" -s emulator-5554 shell getprop sys.boot_completed   # prints 1 when ready

# 2. Build in WSL, copy to Windows, install, launch
cd manabi_do && flutter build apk --debug
cp build/app/outputs/flutter-apk/app-debug.apk "$WINTMP/manabi-debug.apk"
"$ADB" -s emulator-5554 install -r 'C:\Users\<windows-user>\AppData\Local\Temp\manabi-debug.apk'
"$ADB" -s emulator-5554 shell monkey -p com.github.mirai_toto.manabi_do -c android.intent.category.LAUNCHER 1

# 3. Drive and inspect the UI
"$ADB" -s emulator-5554 exec-out uiautomator dump /dev/tty   # screen as XML; Flutter labels are in content-desc, with bounds
"$ADB" -s emulator-5554 shell input tap 672 1080             # tap the centre of a node's bounds
"$ADB" -s emulator-5554 shell input keyevent 4               # Android back
"$ADB" -s emulator-5554 exec-out screencap -p > "$WINTMP/screen.png"
"$ADB" -s emulator-5554 shell dumpsys activity activities | grep -m1 topResumedActivity   # is the app still in front?
```

- App data survives `install -r`; a new virtual device starts on onboarding.
- Wrap `adb.exe` calls in `timeout`: a dead emulator entry makes them hang instead of failing.
- Re-read the screen (`uiautomator dump`) before each tap; coordinates change between screens and after a relaunch.
