# Manabi Do

A Japanese learning app covering kana, kanji (N5/N4), and grammar. Built with Flutter for Linux, Windows, macOS, iOS, and Android. Full offline — no backend.

## Dependencies

| Tool | Purpose |
|---|---|
| Flutter (stable) | App framework |
| Docker | Linux builds (no local Flutter required) |
| Visual Studio 2022 + C++ workload | Windows builds |

## Building

### Linux (via Docker)

```bash
docker compose run build
```

Output: `manabi_do/build/linux/x64/release/bundle/manabi_do`

### Windows (local)

Requires Flutter and Visual Studio installed on the Windows host.

```powershell
cd manabi_do
flutter build windows --release
```

Output: `build\windows\x64\runner\Release\manabi_do.exe`

### Run locally (development)

Requires Flutter installed locally.

```bash
cd manabi_do
flutter run -d linux   # or -d windows on Windows
```

## Project structure

```
docs/          # Architecture and product requirements
manabi_do/     # Flutter application
  lib/
    domain/    # Entities and repository interfaces (no external deps)
    data/      # SQLite via drift, repository implementations
    presentation/ # Flutter widgets, Riverpod providers
    l10n/      # Localization (ARB files)
```
