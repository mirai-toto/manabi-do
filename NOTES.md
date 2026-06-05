# Notes & Ideas

## Current Goal

Polish the vocabulary word list tile and bring the kanji character detail up to parity with kana.

## Immediate Improvements

- **Kanji detail screen — SRS progress**: `KanjiDetailScreen` opens on tap but shows no SRS info. Add the progress panel that kana already has:
  - SRS state badge + stability bar + due date (reuse `_ProgressInfo` from `kana_detail_sheet.dart`)
  - Skip/unskip toggle (DB method `setKanjiKnown` already exists)
  - Reset progress button (needs `resetKanjiCard` in DB, mirrors `resetKanaCard`)

- **VocabWordTile — furigana rendering**: the reading is currently plain text next to the word. Improve to render proper ruby/furigana annotation — small kana above each kanji segment rather than a separate text field beside the word. Requires parsing the word+reading pair to align furigana spans over the correct characters.

## Completed

- ~~**Kanji detail — readings**: label as "onyomi" / "kunyomi"; grey out okurigana after the dot~~ ✓
- ~~**Kanji detail — stroke order**: animated stroke order display (KanjiVG + CustomPainter)~~ ✓
- ~~**Characters — practice sessions**: flashcard, MCQ, drawing exercise; shared `PracticeSessionScreen` for kana / kanji / vocab~~ ✓
- ~~**Vocabulary screen**: level selector, word list with known toggle + expandable meanings, SRS practice session~~ ✓
- ~~**Kanji detail — example words**: show words using the kanji, grouped by JLPT level~~ (not started — moved to backlog)

## Backlog / Later

- Kanji detail — example words (grouped by level, fetched from DB)
- Grammar screen (stub)
- Onboarding / level selection on first launch
