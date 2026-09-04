# Manabi Do

<img src="manabi_do/assets/icons/app_icon.png" width="100px" alt="Manabi Do icon">

## Overview

Offline Japanese learning app: kana, kanji, vocabulary, and grammar, with spaced-repetition practice (FSRS).

### Features

- **Kana & kanji**: hiragana and katakana tables, N5–N1 kanji with readings, example words, stroke order, and audio
- **Vocabulary & grammar**: N5–N1 vocabulary with example sentences, beginner and N5 grammar lessons
- **Interface**: English 🇬🇧 · French 🇫🇷 · German 🇩🇪
- **Fully offline**: no account, everything stays on the device ([privacy policy](https://mirai-toto.github.io/manabi-do/privacy/))

---

## Install

| Platform                                                                        | Link                                                                                         |
| ------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| <img src=".github/assets/android.svg" width="16" alt=""> Android                | [Google Play](https://play.google.com/store/apps/details?id=com.github.mirai_toto.manabi_do) |
| <img src=".github/assets/apple.svg" width="16" alt=""> iOS                      | _(coming soon: App Store)_                                                                   |
| <img src=".github/assets/linux.svg" width="16" alt=""> Linux                    | _(coming soon)_                                                                              |

---

## Development

### Git hooks

Run once after cloning to activate the local hooks (mirrors CI checks):

```bash
git config core.hooksPath .githooks
```

This enables:

- **pre-commit**: `flutter analyze` + `dart format` check
- **commit-msg**: conventional commit linting via `commitlint`

### Linux

No local Flutter installation needed, everything runs inside Docker.

```bash
# Build and run
./run-linux.sh
```

The `Dockerfile` and `docker-compose.yml` at the repo root define the build environment.

### Windows

Requires [Flutter SDK](https://docs.flutter.dev/get-started/install/windows) and Visual Studio 2022 with the C++ workload.

```powershell
cd manabi_do
flutter run -d windows
```

Release build:

```powershell
flutter build windows --release
```

Output: `build\windows\x64\runner\Release\manabi_do.exe`

---

## Credits

### Data sources

| Source                                      | Author                                              | Used for                    | License                                                         |
| ------------------------------------------- | --------------------------------------------------- | --------------------------- | --------------------------------------------------------------- |
| [JMdict / KANJIDIC2](https://www.edrdg.org) | Electronic Dictionary Research and Development Group | Kanji readings, vocabulary  | [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) |
| [KanjiVG](https://kanjivg.tagaini.net)      | Ulrich Apel                                         | Kanji stroke order diagrams | [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/) |
| [Tatoeba](https://tatoeba.org)              | Community corpus                                    | Example sentences           | [CC BY 2.0](https://creativecommons.org/licenses/by/2.0/)       |

### Algorithm

Spaced repetition uses the [FSRS algorithm](https://github.com/open-spaced-repetition/fsrs4anki) by Jarrett Ye, via the [`fsrs` Dart package](https://pub.dev/packages/fsrs).

---

## Support

Open an issue on [GitHub Issues](https://github.com/mirai-toto/manabi-do/issues) with as much detail as possible.
