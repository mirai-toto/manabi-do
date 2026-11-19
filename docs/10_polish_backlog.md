# Polish Backlog — Manabi Do

Ergonomic improvements found while listing the app's features in [09_functional_features.md](09_functional_features.md). Ranked by priority; the ranking is a draft to adjust.

---

## Now

### 1. Back navigation ✅

Done:

- Back no longer leaves the app from a group or level: the tab navigators' "can't pop" reports used to reach Android's predictive back and close the app before the shell's back handler ran
- No duplicates: tapping a kanji or word already open in the current chain of detail screens goes back to it instead of stacking a copy (`screens/detail_navigation.dart`); the search stops at the first non-detail screen, so a practice session is never closed without its "Leave session?" check

Still open:

- A close button in the detail app bar for deep chains (tapping the current tab already returns to the tab root)

### 2. Settings scope ✅

Done, in a simpler form than the planned split into Daily reviews / Free practice / Exercises pages:

- Auto-advance is one switch per exercise type, used in graded sessions and free practice alike; the separate session-wide switch is gone
- "Session length" is now "Free practice length", and graded sessions no longer show it in the in-session sheet
- The misleading note pointing to a non-existent "switch under Study" is removed

### 3. Sentence detail ✅

Done: tapping an example sentence in word detail opens a sentence detail with audio, "Copy Japanese" / "Copy translation" buttons (the copy popup on the word detail rows is gone), and the kanji in the sentence, each opening its kanji detail.

Still open:

- Kanji outside the app's 2,211 (e.g. 誰, 俺) aren't listed, since the app has no data for them; a sentence made only of those shows no kanji at all
- Breakdown: list the words in the sentence by matching dictionary entries against the text (conjugated forms would be missed; needs its own look)
- Sentence detail is only reachable from word detail; the sentence exercise should link to it too (see 4)

### 4. Details from every answer choice

After answering with auto-advance off, let every choice open its detail, not just the item asked:

- Multiple choice: tap any of the kana, kanji, or words offered to open its detail
- Sentence: tap the sentence to open the sentence detail (see 3)

---

## Next

- **Vocabulary search**: searching by reading in romaji doesn't work; ranking doesn't work perfectly yet
- **Example sentence audio**: playable from the sentence detail now; the sentence list in word detail and the sentence exercise still have no play button
- **"Show example" setting**: only affects grammar flashcards; for kana, kanji and vocabulary it does nothing. Either say so in the setting, or give those flashcards examples too
- **Kana free practice pool**: uses the same items as the graded queue (due and new today), so when nothing is due there's little or nothing to practise, unlike kanji and vocabulary which pick from the whole level or group
- **Practice buttons never record**: "Practice" inside a section never counts toward reviews, which may surprise a learner who expects it to

---

## Later

- **Tablet UI** (not urgent): larger screens only get a wider centred column today. Ideas:
  - List and detail side by side (e.g. kanji group on the left, kanji detail on the right)
  - Wider grids that use the extra space instead of leaving empty margins

---

## Grammar (last)

Grammar changes come after everything above.

- Sooner:
  - Far too few exercises; author many more
  - Richer lessons: support images and videos in lesson content
- Later:
  - Bring grammar into the SRS so read lessons get reviewed
- Much later:
  - Author N4 to N1 content
