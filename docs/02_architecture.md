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
SQLite (two bundled .db files)
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

A single SQLite file — `manabi_do_content.db` — is bundled as an asset and copied to the app's documents directory on first run.

`manabi_do_content.db` tables: `kanjis`, `kanji_translations`, `kanas`, `vocabulary_entries`, `vocab_translations`, `sentences`, `sentence_translations`, `grammar_lessons`, `exercises`.

User progress tables (written at runtime): `progress_entries`, `srs_cards`.

See `docs/03_database.md` for full column-level schema.

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

Stroke order SVGs are stored in the `kanjis.svg` column of `manabi_do_content.db`. They are loaded at runtime by `KanjiStrokesProvider` via a DB query and rendered as animated paths. Source SVG files live in `data/kanji_svg/` (gitignored) and are embedded into the DB by `tools/build_content_db.py`.

---

## Grammar Content Pipeline

Grammar source lives in `content/grammar/` at the repo root (outside the Flutter project):

```
content/grammar/
  levels.json               — level registry (id, name, color, difficulty)
  basics/
    index.json              — chapter list
    {chapter}/
      index.json            — lesson list
      {lesson-id}.json      — standalone lesson (id, title, blocks[])
  N5/
    ...
```

`tools/build_content_db.py` walks this tree recursively and writes all lessons into the `grammar_lessons` table in `manabi_do_content.db`. The block format is defined in `docs/04_grammar_lesson_widgets.md`.

The bundled `assets/grammar/basics.json` and `N5.json` are a temporary fallback while the app-side DB integration (Phase 3) is pending.

---

## Localization

Supported locales: `en`, `fr`, `de`. Locale is user-selectable in Settings and persisted via `SharedPreferences`.

ARB files under `lib/l10n/`. Code-generated accessors via `AppLocalizations`. Content translations (kanji meanings, vocab meanings, sentence translations) are stored in the database and looked up per locale at query time, with English as the fallback.

---

## External Data Sources

See `docs/03_database.md` for data sources, coverage, and known gaps.
