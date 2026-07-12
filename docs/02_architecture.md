# Architecture — Manabi Do

## Tech Stack

| Component | Choice | Reason |
|---|---|---|
| Framework | Flutter | One codebase, 5 platforms, smooth animations for stroke order |
| Language | Dart | Bundled with Flutter |
| Database | SQLite via `drift` | Offline first, typed queries, managed migrations |
| State management | Riverpod | Modern Flutter standard |
| SRS | `package:fsrs` | FSRS algorithm for spaced repetition |
| UI | Material 3 | Adaptive navigation components, markdown support |
| i18n | `flutter_localizations` + `intl` | ARB-based, code-generated accessors |

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

Two SQLite files are bundled as assets and copied to the app's documents directory on first run. `manabi.db` is an empty placeholder; all content lives in `manabi_do_content.db`.

### `manabi_do_content.db` — All content

**`kanjis`**

| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | Unicode codepoint |
| character | TEXT | |
| meaning | TEXT | English fallback |
| on_reading | TEXT | |
| kun_reading | TEXT | |
| jlpt_level | TEXT | `N5`–`N1` |

**`kanji_translations`**

| Column | Type | Notes |
|---|---|---|
| kanji_id | INTEGER FK | → `kanjis.id` |
| locale | TEXT | `en`, `fr`, `de`, … |
| meaning | TEXT | |

Primary key: (kanji_id, locale)

**`kanas`**

| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | |
| character | TEXT | |
| romaji | TEXT | |
| type | TEXT | `hiragana` \| `katakana` |
| row | TEXT | Row label, e.g. `Vowels`, `K` |
| kana_group | TEXT | `gojuuon` \| `dakuten` |
| slot | INTEGER | Column position 0–4 |

**`vocabulary_entries`**

| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | |
| word | TEXT | |
| reading | TEXT | |
| meaning | TEXT | English fallback |
| jlpt_level | TEXT | `N5`–`N1` |
| part_of_speech | TEXT | |
| kanji_id | INTEGER FK | → `kanjis.id`, nullable |

**`vocab_translations`**

| Column | Type | Notes |
|---|---|---|
| vocab_id | INTEGER FK | → `vocabulary_entries.id` |
| locale | TEXT | `en`, `fr`, `de`, … |
| meaning | TEXT | |

Primary key: (vocab_id, locale)

**`sentences`**

| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | |
| japanese | TEXT | |
| target_word | TEXT | Vocab word the sentence demonstrates |
| vocab_id | INTEGER FK | → `vocabulary_entries.id` |
| furigana_before | TEXT | nullable |
| furigana_after | TEXT | nullable |
| furigana | TEXT | Full annotated string, nullable |

No `jlpt_level` column — level is inherited via `vocab_id → vocabulary_entries.jlpt_level`.

**`sentence_translations`**

| Column | Type | Notes |
|---|---|---|
| sentence_id | INTEGER FK | → `sentences.id` |
| locale | TEXT | `eng`, `fra`, `deu`, … |
| translation | TEXT | |

Primary key: (sentence_id, locale). English (`eng`) is the fallback locale.

**`grammar_lessons`**

| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | |
| level | TEXT | `basics`, `N5`, … |
| path | TEXT | Relative to `content/grammar/` |
| chapter | TEXT | Chapter title |
| title | TEXT | Lesson title |
| blocks_json | TEXT | JSON array of `{type, data}` blocks |
| order_index | INTEGER | Position within chapter |

Compiled from `content/grammar/` by `tools/build_content_db.py`. App-side integration pending (Phase 3) — grammar is currently still loaded from bundled JSON assets.

**`exercises`**

| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | |
| locale | TEXT | |
| type | TEXT | `mcq`, `flashcard`, `drawing`, … |
| source | TEXT | `kana`, `kanji`, `vocabulary`, `grammar` |
| source_id | INTEGER | Row ID in the source table |
| prompt | TEXT | |
| answer | TEXT | |
| distractors | TEXT | JSON array of wrong answers |
| lesson_id | INTEGER FK | → `grammar_lessons.id`, nullable |

### User progress (written at runtime)

**`progress_entries`**

| Column | Type | Notes |
|---|---|---|
| id | INTEGER PK | |
| item_type | TEXT | `ItemType` enum name |
| item_id | INTEGER | Row ID in the source table |
| is_known | BOOLEAN | |
| toggled_at | DATETIME | |

Unique key: (item_type, item_id). Simple known/unknown toggle, locale-agnostic.

**`srs_cards`**

| Column | Type | Notes |
|---|---|---|
| item_type | TEXT | `hiragana`, `katakana`, `kanji`, `vocabulary` |
| item_id | INTEGER | Row ID in the source table |
| due | DATETIME | Next review date |
| first_seen_at | DATETIME | Set once on insert, never overwritten |
| card_json | TEXT | Full FSRS `Card` serialized via `card.toMap()` |

Primary key: (item_type, item_id).

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

Stroke order SVGs are bundled as individual files under `assets/kanji_svg/`. They are loaded at runtime by `KanjiStrokesProvider` and rendered as animated paths. The `kanjis` table does not store SVG data — it only stores text fields.

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
