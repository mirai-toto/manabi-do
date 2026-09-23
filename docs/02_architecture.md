# Architecture — Manabi Do

## Tech Stack

| Component        | Choice                           | Reason                                                        |
| ---------------- | -------------------------------- | ------------------------------------------------------------- |
| Framework        | Flutter                          | One codebase, 5 platforms, smooth animations for stroke order |
| Language         | Dart                             | Bundled with Flutter                                          |
| Database         | SQLite via `drift`               | Offline first, typed queries, managed migrations              |
| State management | Riverpod                         | Modern Flutter standard                                       |
| SRS              | `package:fsrs`                   | FSRS algorithm for spaced repetition                          |
| UI               | Material 3                       | Adaptive navigation components, markdown support              |
| i18n             | `flutter_localizations` + `intl` | ARB-based, code-generated accessors                           |

---

## Application Architecture

Two meaningful layers: **Data** and **Presentation**. There is no use-case layer — providers in the presentation layer call `AppDatabase` methods directly.

```
Presentation (screens, providers)
      ↓
AppDatabase (drift, all queries)
      ↓
SQLite (manabi_do_content.db)
```

**Domain** (`lib/domain/`) contains entity definitions and static data (kana hardcoded data). It has no runtime logic and no external dependencies.

---

## Entry Point

`main.dart` → `ManabiDoApp` → `ShellScreen`. No landing screen or login flow. The app opens directly on the Home tab.

---

## Navigation

`ShellScreen` manages five tabs via `IndexedStack`, each with its own nested `Navigator`:

1. Home
2. Characters
3. Vocabulary
4. Grammar
5. Settings

Navigation component:

- Mobile (< 600px): `AppNavBar` (bottom navigation bar)
- Wide (≥ 600px): `AppNavRail` (left navigation rail)

Both are hidden during active practice sessions. Hardware Escape key maps to back navigation on desktop/Linux.

Drill-down state (selected level, selected group) is lifted into Riverpod providers so tab re-taps and Escape can reset it without `Navigator.pop`.

---

## Data Model

A single SQLite file — `manabi_do_content.db` — is bundled as an asset and copied to a platform-specific directory on first run:

- **Linux debug** — repo root (located via `.git` detection), so the DB sits next to the source and is easy to inspect
- **Linux release** — `~/.local/share/<app>/` (XDG application support directory)
- **All other platforms** — `getApplicationDocumentsDirectory()`

If the bundled DB version marker changes, the existing DB is replaced and SRS progress is migrated across automatically.

`manabi_do_content.db` tables: `kanjis`, `kanji_translations`, `kanas`, `vocabulary_entries`, `vocabulary_translations`, `sentences`, `sentence_translations`, `grammar_lessons`, `exercises`.

User progress tables (written at runtime): `progress_entries`, `srs_cards`.

See `docs/03_database.md` for full column-level schema.

---

## Content Pipeline

All app content is authored outside the Flutter project and compiled into `manabi_do_content.db`:

```
Online sources (Bluskyo, JMdict, KANJIDIC2, KanjiVG)
        ↓  download & cache  →  data/  (gitignored)
content/  ← versioned JSON snapshot, committed to git
        ↓  scripts/content_pipeline/generate.py
manabi_do/assets/manabi_do_content.db  ← compiled output, committed to git
```

`content/` JSON files are committed to git as a versioned snapshot and can diverge from upstream as manual edits accumulate. `scripts/content_pipeline/sync_content.py` re-seeds `content/characters/` and `content/vocabulary/` from online sources; `scripts/content_pipeline/generate.py --sync` is the end-to-end rebuild entry point. See `content/README.md` for the full rebuild workflow.

---

## Design Reference

The design system is defined in code and inspected through two generated artefacts. Neither is committed: both are rebuilt on demand into `design-reference/` (gitignored).

```
lib/core/theme/*.dart          ← the design system itself
lib/widgetbook/*_use_cases.dart ← one use case per widget state
        ↓  scripts/design/build_design_reference.sh
design-reference/
  index.html    ← tokens, contrast, dimensions, type, and live widget previews
  widgetbook/   ← the widgetbook web build the previews embed
```

Run from the repo root:

```bash
bash scripts/design/build_design_reference.sh --serve   # build, then serve on 8800
bash scripts/design/build_design_reference.sh --debug   # readable exceptions while iterating
```

`--serve` starts the server and prints the URL. Without it the build just tells you how to serve it yourself.

It has to go over HTTP. Opened from disk, `file://` renders each preview iframe as a directory listing rather than serving the folder's `index.html`, and Flutter will not boot from `file://` regardless.

The release bundle is ~90 MB on disk: 22 MB of content DB that the widgetbook never queries, 20 MB of bundled fonts, and 37 MB of CanvasKit variants of which a browser fetches exactly one. Transfer size per visitor is closer to 15 MB. If that ever matters for a deploy, the content DB is the obvious thing to drop first.

**`scripts/design/gen_design_reference.dart`** parses `app_tokens.dart`, `app_dimens.dart`, `app_text_styles.dart`, `jlpt_level.dart`, `srs_level.dart` and `widgetbook.directories.g.dart`, so the page cannot drift from the code. It fails loudly rather than emitting an empty page. Beyond listing the tokens it computes three things the source does not state:

- **Contrast ratios** for every foreground/background pair the app actually uses, graded against WCAG AA, in both themes.
- **Dimensions grouped by value**, so two names holding the same number are flagged as a likely collision.
- **Usage counts** for every colour, dimension and text style, cross-referenced against `lib/`. Zero means dead.

Widget previews are `<iframe>`s into the widgetbook in preview mode (`widgetbook/#/?path=<folder>/<component>/<use-case>&preview`), so a tile shows the real widget rather than a copy of it. They boot lazily on scroll because each one starts a Flutter engine.

If you only want to browse widgets interactively, skip the reference and run the widgetbook directly:

```bash
flutter run -t lib/widgetbook.dart
```

Adding a widget means adding a `@widgetbook.UseCase` in `lib/widgetbook/<area>_use_cases.dart` and re-running `dart run build_runner build` to regenerate `widgetbook.directories.g.dart`. See `docs/07_widget_catalogue.md` for what each widget is for.

---

## SRS Logic

`AppDatabase` exposes session-building methods that return `List<(T, Card?)>` pairs:

- `getAllDueKanaSrsSession` — due hiragana + katakana with a shared new-card budget
- `getAllDueKanjiSrsSession` — due kanji from all levels; new cards from the lowest JLPT level with unseen items
- `getAllDueVocabularySrsSession` / `getVocabularySrsSession` — due vocabulary globally or per level
- `getKanaSrsSession` / `getKanjiSrsSession` — per-type sessions for Characters tab

New card rate is enforced by `_countSeenToday(itemType)` — cards whose `first_seen_at` falls on the current calendar day count against the daily limit.

Streak is computed from `srs_cards.card_json` → `lastReview` dates: count consecutive calendar days ending today that have at least one review.

---

## Kanji SVG Assets

Stroke order SVGs are stored in the `kanjis.svg` column of `manabi_do_content.db`. They are loaded at runtime by `KanjiStrokesProvider` via a DB query and rendered as animated paths. Source SVG files live in `content/characters/kanji_svg/` (committed) and are embedded into the DB by `scripts/content_pipeline/build_content_db.py`.

---

## Grammar Content

Grammar lessons are authored as JSON files in `content/grammar/` using a recursive chapter/lesson structure. `scripts/content_pipeline/build_content_db.py` walks the tree and writes all lessons into the `grammar_lessons` table. The block format is defined in `docs/04_grammar_lesson_widgets.md`.

---

## Localization

Supported locales: `en`, `fr`, `de`. Locale is user-selectable in Settings and persisted via `SharedPreferences`.

ARB files under `lib/l10n/`. Code-generated accessors via `AppLocalizations`. Content translations (kanji meanings, vocabulary meanings, sentence translations) are stored in the database and looked up per locale at query time, with English as the fallback.

---

## External Data Sources

See `docs/03_database.md` for data sources, coverage, and known gaps.
