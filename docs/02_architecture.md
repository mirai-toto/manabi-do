# Architecture — Japanese Learning App

## Tech Stack

| Component | Choice | Reason |
|---|---|---|
| Framework | Flutter | One codebase, 5 platforms, smooth animations for stroke order |
| Language | Dart | Bundled with Flutter, syntax close to Java/Kotlin |
| Database | SQLite via `drift` | Offline first, JPA-like annotations, managed migrations |
| State management | Riverpod | Modern Flutter standard, compatible with Clean Architecture |
| i18n | `flutter_localizations` + `intl` | Flutter standard, ARB-based, code-generated accessors |

---

## Application Architecture — Clean Architecture

Three layers, dependencies always point inward.

```
Presentation  →  Domain  ←  Data
```

### Domain (center)
- Business entities: `Kanji`, `Kana`, `Exercise`, `Progress`, `GrammarLesson`
- Use cases: `GetKanjiList`, `ToggleProgress`, `GetExercisesBySource`...
- No external dependencies — no Flutter, no SQLite

### Data
- SQLite repositories (read/write)
- Parsers: Kanjidic2 (XML), KanjiVG (SVG), JMdict (XML)
- Implements interfaces defined by the Domain

### Presentation
- Flutter widgets (screens, components)
- Riverpod notifiers (state management)
- Unaware of SQLite — communicates only through use cases

---

## Data Model

### Main Entities

**`kanjis`**
- id, character, meaning, on_reading, kun_reading, jlpt_level, stroke_svg

**`vocabulary`**
- id, word, reading, meaning, jlpt_level, part_of_speech, kanji_id FK (nullable)

**`kanas`**
- id, character, romaji, type (hiragana/katakana), row (a, ka, sa...)

**`grammar_lessons`**
- id, locale, chapter, title, content_md, order_index, metadata (JSON)

**`exercises`**
- id, locale, type, source (kana/kanji/vocabulary/grammar), source_id, prompt, answer, distractors (JSON), lesson_id FK

**`progress`**
- id, item_type (kanji/kana/exercise/lesson), item_id, is_known, toggled_at

### Key Principles
`progress` is generic — a single toggle for any content type via `item_type` + `item_id`. It is locale-agnostic: progress on an item carries across languages.
`exercises.distractors` is a JSON array — stores wrong answers for MCQs.
`grammar_lessons` and `exercises` carry a `locale` column — the same logical lesson can exist in multiple rows, one per language.
`vocabulary.kanji_id` is nullable — not every word maps to a single kanji entry.

---

## Data Pipeline

Source data is never bundled raw — it is preprocessed at build time.

```
Kanjidic2 (XML)  ──┐
KanjiVG (SVG)    ──┤──▶  Preprocessing script  ──▶  kanjis.db (SQLite)
JMdict (XML)     ──┘

content/ (MD + assets)  ──▶  Preprocessing script  ──▶  lessons.db (SQLite)
```

The preprocessing script:
- Parses XML/SVG sources
- Walks the `content/<locale>/chapters/` directory tree for each locale
- Reads the YAML frontmatter of each lesson
- Inserts everything into SQLite with the corresponding `locale` value
- Copies image assets into the Flutter bundle (assets are shared across locales)

---

## Lesson Source Format

### Folder Structure

```
content/
  en/
    chapters/
      01_verbs/
        meta.json          ← chapter title and description (in locale)
        01_groups.md
        02_polite_form.md
  fr/
    chapters/
      01_verbs/
        meta.json
        01_groups.md
        02_polite_form.md
  assets/                  ← shared across all locales
    godan_conjugation.png
```

- Top-level locale folder (`en/`, `fr/`...) determines the `locale` value inserted into SQLite
- Chapter and lesson order comes from the numeric prefix (`01_`, `02_`...)
- Folder = chapter, MD file = lesson
- Assets are shared across locales — referenced by the same relative path in all Markdown files

### meta.json

```json
{
  "title": "Verbs",
  "description": "Verb groups, base forms and conjugations",
  "prerequisites": []
}
```

### Lesson Frontmatter (YAML)

```markdown
---
title: い adjectives
prerequisites: [01_verbs/03_conjugations]
tags: [adjectives, conjugation]
difficulty: 1
---

Markdown content...
```

Fields are extensible — the script ignores unknown fields (future-proof).

---

## External Data Sources

| Source | Content | License |
|---|---|---|
| Kanjidic2 | Readings, meanings, JLPT level | CC BY-SA 4.0 |
| KanjiVG | Stroke order in SVG | CC BY-SA 3.0 |
| JMdict | Vocabulary (words, readings, meanings) | CC BY-SA 4.0 |
| Kana | Hardcoded (46+46) | — |
| Grammar | Created manually | — |
