# Product Requirements — Japanese Learning App

## Target Platforms

Flutter — iOS, Android, macOS, Windows, Linux
Full offline — no backend, ever. OAuth delegates authentication to third-party providers.

---

## Target Users

**Initial phase:** Learners who already have a basic foundation in Japanese — they know all kana, some kanji, and have basic vocabulary. They are not absolute beginners.

This assumption has direct consequences on build priority:
- Grammar lessons are the core value proposition and the first thing to build
- Characters and vocabulary sections support grammar but are not the entry point
- The app does not need to hand-hold users through kana recognition or stroke order in the initial phase

---

## Authentication

- **No backend, no password storage** — authentication is fully delegated to OAuth providers
- Supported providers: Google, Sign in with Apple (required on iOS/macOS whenever any third-party login is offered)
- **Continue as guest** option — full access, progress stored locally only
- Authenticated users get the same local experience; sync is a future concern
- Mock implementation for now: both login and guest navigate directly to the home screen

---

## UX Flow

```
Landing screen
  ├── Continue as guest  →  Home
  └── Sign in            →  OAuth provider picker (Google, Apple)
                         →  Home

Home
  ├── Characters  →  Kana tab / Kanji tab
  ├── Vocabulary  →  Word list  →  Word detail
  └── Grammar     →  Chapter list  →  Lesson list  →  Lesson reader  →  Exercises
```

### Landing screen
Login/register entry point. Two actions: "Continue as guest" and "Sign in". Clean, minimal — not an onboarding flow.

### Home
Three section cards (Characters, Vocabulary, Grammar). Grammar is visually prominent as the primary section.

### Grammar (priority section)
- **Chapter list** — all chapters as cards with title, lesson count, and progress bar
- **Lesson list** — lessons within a chapter with title, difficulty, and known/unknown indicator
- **Lesson reader** — scrollable Markdown content with inline images. "Practice" button at the bottom leads to exercises
- **Exercise flow** — lessons play through exercises one by one. Summary screen at the end. Known/unknown toggle per exercise independent of correctness

### Characters
- **Kana tab** — grid of all 46+46 characters grouped by row. Tap → character card with romaji and known/unknown toggle
- **Kanji tab** — list filterable by N5/N4. Tap → detail with stroke order animation, on/kun readings, example words, known/unknown toggle

### Vocabulary
- Scrollable list filterable by JLPT level
- Each entry: kanji form, kana reading, meaning
- Tap → detail with part of speech, link to related kanji, known/unknown toggle

### Cross-cutting UX principles
- Japanese characters are always displayed large enough to read clearly
- Known/unknown toggle is the primary persistent interaction — visible everywhere
- No onboarding, no gamification, no streaks in the initial phase
- No score pressure — the toggle is self-assessed, not pass/fail

---

## Responsive Design

Mobile-first. The layout adapts at two breakpoints:

| Width | Layout | Navigation |
|---|---|---|
| < 600px | Single column | Bottom navigation bar |
| 600–1200px | Tablet | Navigation rail (left side) |
| > 1200px | Desktop | Navigation drawer (persistent sidebar) |

No fixed pixel sizes in widgets — layouts use `LayoutBuilder`, `Flexible`, and `Expanded`. Minimum touch target size: 48px.

---

## Design System

**Material 3** — chosen for ecosystem breadth, pre-built adaptive navigation components, and `flutter_markdown` compatibility.

- Seed color: indigo (`#6B4EFF`)
- `useMaterial3: true`
- Default desktop window size: 390×844 (iPhone 14 portrait) to develop and test in mobile proportions

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

### 2. Vocabulary

- N5 and N4 vocabulary lists
- Each word has: kanji form, kana reading, meaning, JLPT level, part of speech
- Words linked to relevant kanji where applicable
- Data from JMdict

### 3. Grammar

- 17 chapters covering N5/N4 Japanese concepts
- Each chapter contains one or more lessons
- Each lesson contains a course + associated exercises
- Content created manually by the developer

---

## Exercise System

The exercise system is generic and applies to all sections.
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

- Each item has a simple toggle: known / not known
- No SRS (spaced repetition) for now
- Progress is stored locally in SQLite
- Progress is locale-agnostic — carries across languages

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
