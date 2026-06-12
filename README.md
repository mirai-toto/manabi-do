# Manabi Do

<img src="manabi_do/assets/icons/app_icon.png" width="100px" alt="Manabi Do icon">

## Overview

Offline Japanese learning app for Android, iOS, Windows, and Linux. Covers kana, kanji (N5–N1), and vocabulary with spaced-repetition (FSRS) practice sessions.

### Features

- **Kana** — hiragana and katakana tables with stroke order, TTS, and SRS flashcard practice
- **Kanji** — N5–N1 kanji with readings, stroke order animation, example words, and SRS practice (flashcard, MCQ, drawing)
- **Vocabulary** — N5–N1 word list with furigana, part-of-speech tags, and SRS practice
- **Home screen** — daily review cards per domain (characters, vocabulary) with live due counts
- **Localization** — English, French, German UI
- **Fully offline** — no account required, all data on-device

---

## Install

| Platform | Link |
|---|---|
| Android | *(coming soon — Google Play)* |
| iOS | *(coming soon — App Store)* |
| Windows | *(coming soon — Microsoft Store)* |
| Linux | *(coming soon)* |

---

## Development

### Linux

No local Flutter installation needed — everything runs inside Docker.

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

## Project structure

```
grammar/          # Grammar curriculum outlines per JLPT level (N5–N1)
manabi_do/
  lib/
    core/         # Theme tokens, dimensions, SRS helpers
    data/         # Drift database, DAOs, asset seeding
    l10n/         # Localization (ARB files — en, fr, de)
    presentation/
      providers/  # Riverpod providers
      screens/    # App screens (home, characters, vocabulary, grammar, settings)
      widgets/    # Shared UI components
```

---

## Privacy

[Privacy Policy](https://mirai-toto.github.io/manabi-do/privacy/)

---

## License

MIT — see [LICENSE](LICENSE).

---

## Support

Open an issue on [GitHub Issues](https://github.com/mirai-toto/manabi-do/issues) with as much detail as possible.
