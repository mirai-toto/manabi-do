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

`manabi_do_content.db` tables: `kanjis`, `kanji_translations`, `kanas`, `vocabulary_entries`, `vocab_translations`, `sentences`, `sentence_translations`, `grammar_lessons`, `exercises`.

User progress tables (written at runtime): `progress_entries`, `srs_cards`.

See `docs/03_database.md` for full column-level schema.

---

## Content Pipeline

All app content is authored outside the Flutter project and compiled into `manabi_do_content.db`:

```
Online sources (Bluskyo, JMdict, KANJIDIC2, KanjiVG)
        ↓  download & cache  →  data/  (gitignored)
content/  ← versioned JSON snapshot, committed to git
        ↓  tools/generate.py
manabi_do/assets/manabi_do_content.db  ← compiled output, committed to git
```

`content/` JSON files are committed to git as a versioned snapshot and can diverge from upstream as manual edits accumulate. `tools/sync_content.py` re-seeds `content/characters/` and `content/vocabulary/` from online sources; `tools/generate.py --sync` is the end-to-end rebuild entry point. See `content/README.md` for the full rebuild workflow.

---

## SRS Logic

`AppDatabase` exposes session-building methods that return `List<(T, Card?)>` pairs:

- `getAllDueKanaSrsSession` — due hiragana + katakana with a shared new-card budget
- `getAllDueKanjiSrsSession` — due kanji from all levels; new cards from the lowest JLPT level with unseen items
- `getAllDueVocabSrsSession` / `getVocabSrsSession` — due vocab globally or per level
- `getKanaSrsSession` / `getKanjiSrsSession` — per-type sessions for Characters tab

New card rate is enforced by `_countSeenToday(itemType)` — cards whose `first_seen_at` falls on the current calendar day count against the daily limit.

Streak is computed from `srs_cards.card_json` → `lastReview` dates: count consecutive calendar days ending today that have at least one review.

---

## Kanji SVG Assets

Stroke order SVGs are stored in the `kanjis.svg` column of `manabi_do_content.db`. They are loaded at runtime by `KanjiStrokesProvider` via a DB query and rendered as animated paths. Source SVG files live in `content/characters/kanji_svg/` (committed) and are embedded into the DB by `tools/build_content_db.py`.

---

## Grammar Content

Grammar lessons are authored as JSON files in `content/grammar/` using a recursive chapter/lesson structure. `tools/build_content_db.py` walks the tree and writes all lessons into the `grammar_lessons` table. The block format is defined in `docs/04_grammar_lesson_widgets.md`.

---

## Localization

Supported locales: `en`, `fr`, `de`. Locale is user-selectable in Settings and persisted via `SharedPreferences`.

ARB files under `lib/l10n/`. Code-generated accessors via `AppLocalizations`. Content translations (kanji meanings, vocab meanings, sentence translations) are stored in the database and looked up per locale at query time, with English as the fallback.

---

## External Data Sources

See `docs/03_database.md` for data sources, coverage, and known gaps.
