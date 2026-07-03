# Product Requirements — Manabi Do

## Target Platforms

Flutter — iOS, Android, macOS, Windows, Linux.
Full offline — no backend. All data and progress live on-device in SQLite.

---

## Target Users

Learners with a basic Japanese foundation — they know all kana, some kanji, and have basic vocabulary. The app is not designed for absolute beginners.

---

## UX Flow

```
App launch → Home (ShellScreen)

ShellScreen tabs
  ├── Home       → domain cards + streak + SRS practice sessions
  ├── Characters → Kana tab / Kanji tab
  ├── Vocabulary → level selector → word list → word detail
  ├── Grammar    → chapter list → lesson list → lesson reader → exercises
  └── Settings   → theme, language, SRS settings
```

No landing screen, no login, no onboarding — the app opens directly on the Home tab.

---

## App Sections

### Home

Four domain cards: Kana, Kanji, Vocabulary, Grammar. Each card shows the total item count and the current SRS queue (due + new). Kana, Kanji, and Vocabulary cards have a practice button that launches an SRS session. A streak pill shows the number of consecutive review days.

Grammar is shown as a card that navigates to the Grammar tab. SRS practice for grammar is not yet implemented ("coming soon").

### Characters

Two tabs: Kana and Kanji.

**Kana tab** — grid of hiragana and katakana grouped by row (gojuuon, dakuten). Tap a character to open a detail sheet with romaji, SRS level indicator, and a known/unknown toggle. Practice button opens an SRS flashcard session.

**Kanji tab** — list filterable by JLPT level (N5→N1). Shows each kanji with SRS level color. Tap → detail screen with:
- Animated stroke order (SVG from bundled assets)
- On/kun readings (locale-translated)
- Example vocabulary words with sentences
- TTS playback on example words
- Known/unknown toggle + SRS level indicator

### Vocabulary

Level selector (N5/N4/N3/N2/N1). Word list shows kanji form, kana reading, meaning, SRS level. Tap → detail with part of speech, related kanji link, example sentences with furigana, known/unknown toggle. Practice button opens an SRS flashcard session for that level.

### Grammar

Chapter list → lesson list → lesson reader (scrollable Markdown content). "Practice" button at the bottom leads to exercises. Lessons are stored in SQLite, loaded from bundled Markdown assets at first run.

---

## SRS System

Spaced repetition using the FSRS algorithm (`package:fsrs`). Applies to kana, kanji, and vocabulary.

Six SRS levels, each with a distinct color:

| Level | Description |
|---|---|
| New | Never seen |
| Learning | In early learning phase |
| Apprentice | Short interval (< 7 days stability) |
| Familiar | Medium interval (7–21 days stability) |
| Mastered | Long interval (21–90 days stability) |
| Expert | Very long interval (90+ days stability) |

New cards per day are rate-limited. For kanji, new cards are introduced from the lowest JLPT level that still has unseen items (N5 → N4 → N3 → N2 → N1).

Progress also tracks a simple known/unknown toggle independently of SRS (stored in `progress_entries`).

---

## Streak

A streak counter shows the number of consecutive calendar days on which at least one SRS review was completed. Displayed as a pill on the Home screen.

---

## Exercise System

Exercises are attached to grammar lessons and are generic across content types.

| Type | Description |
|---|---|
| MCQ | One question, N choices, one correct answer |
| Flashcard | Card shown, user self-assesses (known / not known) |
| Drawing | User traces stroke order on a canvas (kana/kanji) |
| Sentence cloze | A Japanese sentence with the target word blanked out; user picks the correct word from multiple choices |
| Lesson reader | Inline reading card within an exercise flow |

The system is designed to be extensible — new types can be added without a full rewrite.

### Difficulty layers

Difficulty is controlled at two independent levels:

**1. Content difficulty — JLPT level (N5 → N1)**
Content (kanji, vocab, sentences) is tagged N5 (beginner) through N1 (advanced). Users browse and practice within a chosen level. In the home SRS session, new kanji cards are always introduced from the lowest level that still has unseen items, ensuring a natural progression.

**2. Exercise type difficulty — cognitive demand**
Within a session, exercise types vary in how much active recall they require:

| Exercise | Demand | Notes |
|----------|--------|-------|
| Flashcard | Low | Passive recognition; user self-assesses |
| MCQ | Medium | Must select correct answer from options |
| Sentence cloze | Medium–High | Contextual; requires understanding word usage in a sentence |
| Drawing | High | Active production; must reproduce correct stroke order |

For kanji and vocab free-practice sessions, users can filter to a single exercise type (flashcard-only, MCQ-only) or use mixed mode. Home SRS sessions use a mixed mode weighted by what each item needs.

---

## Localization

UI language: English, French, German. Selectable in Settings.

Kanji meanings and vocabulary meanings are locale-translated via separate translation tables. Sentences have per-locale translations with English as fallback.

Progress and SRS state are locale-agnostic — they carry across language switches.

---

## Responsive Design

Mobile-first. Two layout breakpoints:

| Width | Navigation |
|---|---|
| < 600px | Bottom navigation bar |
| ≥ 600px | Navigation rail (left side) |

The navigation rail and bottom bar are hidden during active practice sessions. Escape key navigates back on desktop/Linux.

---

## Design System

Material 3 (`useMaterial3: true`). Seed color: indigo (`#6B4EFF`). Light and dark theme, switchable in Settings. Default desktop window size: 390×844 (iPhone 14 portrait).
