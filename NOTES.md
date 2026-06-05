# Notes & Ideas

## Pre-release Checklist

Must ship before v1:

- **Onboarding** — first-launch flow: pick JLPT target level, pick UI language. Sets the default filter so the app opens to something meaningful, not an empty level selector.
- **App icon** — currently default Flutter icon. Need a custom icon at all required sizes (Android / iOS).
- **Empty practice state** — when no SRS cards are due for a level, `PracticeSessionScreen` falls straight into `SessionSummary(0, 0)` which looks broken. Show a "nothing due" screen with next-review time instead.
- **App name & bundle ID** — set proper display name and bundle IDs for both platforms before first store submission.
- **Privacy policy URL** — required by both App Store and Play Store.
- **Home screen** — currently a mock/placeholder. Needs real content (progress overview, what's due today, quick-access to active levels).
- **Text-to-speech** — read out Japanese words and example sentences using the device TTS engine (`flutter_tts` package). Useful on vocab tiles, kanji detail, and flashcards.
- **Grammar screen** — "coming soon" placeholder. Needs at least N5 grammar points before release so the tab isn't empty.
- **Data sync** — sign in with Google / Apple and sync SRS progress to Drive or a backend so progress survives reinstalls and transfers between devices.

Nice-to-have before v1 (if time allows):
- **Kanji detail — example words** — already in DB, just needs the UI (grouped by JLPT level).

---

## Current Goal

Pre-release: home screen, TTS, grammar, sync.

## Completed

- ~~**Kanji detail — readings**: label as "onyomi" / "kunyomi"; grey out okurigana after the dot~~ ✓
- ~~**Kanji detail — stroke order**: animated stroke order display (KanjiVG + CustomPainter)~~ ✓
- ~~**Characters — practice sessions**: flashcard, MCQ, drawing exercise; shared `PracticeSessionScreen` for kana / kanji / vocab~~ ✓
- ~~**Vocabulary screen**: level selector, word list with furigana, expandable meanings, known toggle, SRS practice session~~ ✓
- ~~**Kanji detail — SRS progress panel**: state badge, stability bar, due date, reset button~~ ✓
- ~~**VocabWordTile — furigana**: ruby text above kanji segments, kana anchored alignment~~ ✓

## Backlog / Post-v1

- Onboarding refinement (level quiz instead of manual pick)
- Kanji detail — example words
- Grammar screen deeper content
