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
- id, character, meaning (English fallback), on_reading, kun_reading, jlpt_level

**`kanji_translations`**
- kanji_id FK, locale, meaning
- Primary key: (kanji_id, locale)

**`kanas`**
- id, character, romaji, type (`hiragana`/`katakana`), row, slot, kana_group

**`vocabulary_entries`**
- id, word, reading, meaning (English fallback), jlpt_level, part_of_speech, kanji_id FK (nullable)

**`vocab_translations`**
- vocab_id FK, locale, meaning
- Primary key: (vocab_id, locale)

**`sentences`**
- id, japanese, target_word, vocab_id FK, furigana_before, furigana_after, furigana
- No `jlpt_level` column — level is inherited via `vocab_id → vocabulary_entries.jlpt_level`

**`sentence_translations`**
- sentence_id FK, locale, translation
- Primary key: (sentence_id, locale); English is the fallback locale

**`grammar_lessons`**
- id, locale, chapter, title, content_md, order_index, metadata (JSON)

**`exercises`**
- id, locale, type, source (kana/kanji/vocabulary/grammar), source_id, prompt, answer, distractors (JSON), lesson_id FK

### User Progress (written at runtime)

**`progress_entries`**
- id, item_type, item_id, is_known, toggled_at
- Unique key: (item_type, item_id)
- Simple known/unknown toggle, locale-agnostic

**`srs_cards`**
- item_type (`hiragana`/`katakana`/`kanji`/`vocabulary`), item_id, due, first_seen_at, card_json
- Primary key: (item_type, item_id)
- `card_json` stores the full FSRS `Card` object serialized via `card.toMap()`
- `first_seen_at` is set once on insert and never overwritten

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

## Grammar Asset Format

Grammar lessons are stored as Markdown files under `manabi_do/assets/grammar/`:

```
assets/grammar/
  basics.md
  N5.md
```

These files are loaded and parsed into the `grammar_lessons` and `exercises` tables in `manabi_do_content.db` at build time by the preprocessing tool (`tool/gen_translations.dart`).

---

## Localization

Supported locales: `en`, `fr`, `de`. Locale is user-selectable in Settings and persisted via `SharedPreferences`.

ARB files under `lib/l10n/`. Code-generated accessors via `AppLocalizations`. Content translations (kanji meanings, vocab meanings, sentence translations) are stored in the database and looked up per locale at query time, with English as the fallback.

---

## External Data Sources

| Source | Content | License |
|---|---|---|
| Kanjidic2 | Readings, meanings, JLPT level | CC BY-SA 4.0 |
| KanjiVG | Stroke order SVG | CC BY-SA 3.0 |
| JMdict | Vocabulary | CC BY-SA 4.0 |
| Tatoeba | Example sentences | CC BY 2.0 |
| Kana | Hardcoded (46+46+variants) | — |
| Grammar | Created manually | — |
