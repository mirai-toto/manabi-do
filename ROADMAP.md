# Roadmap

## Completed ✓

- **App icon** — custom icon (学 kanji, indigo gradient) at all required sizes
- **Home screen** — real dashboard: per-domain due-today cards (Characters + Vocabulary), progress overview; cards hidden when nothing is due
- **Text-to-speech** — speak button on flashcards, MCQ Japanese prompt, kana detail, kanji detail character box
- **Characters practice** — flashcard, MCQ, drawing exercise; shared `PracticeSessionScreen` for kana / kanji / vocab
- **View detail in practice** — "View detail" link on all kanji exercise types (flashcard, MCQ, drawing) that opens `KanjiDetailScreen`
- **Vocabulary screen** — level selector, word list with furigana, known toggle, SRS practice session
- **Kanji detail** — readings (onyomi / kunyomi), stroke order animation, SRS progress panel
- **Grammar screen** — Japanese Basics (5 foundational chapters) + N5 grammar points; themed markdown renderer
- **App name & bundle ID** — `com.github.mirai_toto.manabi_do`; display name "Manabi Do" on Android and iOS

---

## v1 — Must Ship

- [ ] **Data sync** — sign in with Google / Apple, sync SRS progress so it survives reinstalls
- [ ] **Privacy policy** — required by App Store and Play Store

---

## Nice to Have Before v1

- [ ] **Onboarding** — first-launch flow: pick JLPT target level and UI language
- [ ] **Kanji detail — TTS on example words** — speak button next to each example word once the example words UI is built
- [ ] **Vocab practice — kanji breakdown on flashcard** — during auto-evaluation (after the answer is revealed), list the individual kanji that make up the word, each linking to its `KanjiDetailScreen`

---

## Post-v1

- Onboarding refinement — level quiz instead of manual pick
- Grammar screen — deeper content beyond N5
- Streak / gamification
- Notifications — daily review reminders
