# Product Requirements — Japanese Learning App

## Target Platforms

Flutter — iOS, Android, macOS, Windows, Linux
Full offline — no backend for now (multi-device sync considered for later)

---

## Localization (i18n)

- UI strings are localized via ARB files (`lib/l10n/app_<locale>.arb`)
- Lesson and exercise content is authored per locale under `content/<locale>/chapters/`
- Assets (images) are shared across locales
- Progress is locale-agnostic — knowing an item in one language carries over to all
- Initial supported locale: `en`. Structure supports adding further locales without rework.

---

## App Sections

### 1. Characters

#### Kana
- Full hiragana + katakana list with romaji
- Hardcoded data (46 + 46 characters)
- No stroke order

#### Kanji
- N5 and N4 groups
- Animated stroke order (SVG)
- On/kun readings
- Associated word examples
- Data from Kanjidic2 + KanjiVG + JMdict

---

### 2. Grammar

- 17 chapters covering N5/N4 Japanese concepts
- Each chapter contains one or more lessons
- Each lesson contains a course + associated exercises
- Content created manually by the developer

---

## Exercise System

The exercise system is generic and applies to both sections.
Exercises are hardcoded, not dynamically generated.

### Exercise Types

| Type | Description |
|---|---|
| MCQ | One question, N choices, one correct answer. Single or multi (chained quiz) |
| Flashcard | A card is shown, the user self-assesses (known / not known) |
| True/False | Simple assertion to validate or invalidate |
| Free writing | The user types their answer, compared against the correct answer |
| Matching | Connect pairs (drag & drop or tap-tap) |
| Ordering | Put elements back in the correct order |

The system is designed to be extensible — other types can be added without a full rewrite.

---

## Progress

- Each exercise has a simple toggle: known / not known
- No SRS (spaced repetition) for now
- Progress is stored locally in SQLite

---

## Lesson Content

- Source format: Markdown with YAML frontmatter for metadata
- Images embedded as local assets
- Folder structure carries the chapter / lesson hierarchy
- Loaded into SQLite at build time via a preprocessing script

### Folder Structure

```
content/
  en/
    chapters/
      01_verbs/
        meta.json
        01_groups.md
        02_polite_form.md
      02_directions_places/
        meta.json
        01_particles.md
  fr/
    chapters/
      01_verbs/
        meta.json
        01_groups.md
  assets/
    godan_conjugation.png
```

### Lesson Frontmatter

```markdown
---
title: い adjectives
prerequisites: [01_verbs/03_conjugations]
tags: [adjectives, conjugation]
difficulty: 1
---
```
