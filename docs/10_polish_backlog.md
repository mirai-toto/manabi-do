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
- **Words in this sentence** (planned): a list like the kanji one, each word opening its word detail. Words are worked out ahead of time in the content pipeline (`manabi-content`), not in the app:
  - Source: Tatoeba's `jpn_indices` (curated, already linked to JMdict senses) where a sentence has them; Janome (or SudachiPy) as a fallback for the rest, matching its dictionary forms and readings to the app's vocabulary
  - Words outside the app's vocabulary are skipped, like untaught kanji
  - App side: a sentence → words table (schema change and migration), one query, and the list on the sentence detail reusing the word rows
  - Rejected: matching words in the app (misses conjugations, noisy on particles) and shipping a tokenizer in the app (tens of MB, native code)
  - First step: check how the content pipeline imports sentences and whether the indices are already used

### 4. Details from every answer choice ✅

Done: after answering with auto-advance off, every option in kanji and vocabulary multiple choice and in the sentence exercise shows an info icon and opens its kanji or word detail; the sentence exercise also has "View sentence". Kana options (romaji) and grammar options are left out on purpose.

### 5. Home screen setting ✅

Done: the Home screen sheet's switches now move when tapped (they were saved, but the sheet never redrew, so they looked broken), and a line under the title says hidden sections also leave today's reviews and can still be studied from their tab.

---

## Next

- **Vocabulary search**: searching by reading in romaji doesn't work; ranking doesn't work perfectly yet
- ✅ **Example sentence audio**: playable from the sentence list in word detail, the sentence detail and the sentence exercise
- ✅ **"Show example" setting**: vocabulary flashcards now show one of the word's sentences (word masked until revealed); kanji and kana have no sentences, so it stays vocabulary and grammar only
- ✅ **Kana free practice pool**: picks random kana from the whole table, up to the free practice length
- **CI performance**: run the release notes check first, as a preflight, so a missing or broken release note fails fast instead of after all the heavy checks
- ✅ **Practice buttons never record**: the kanji and vocabulary practice pickers open with a banner (練 tile) saying practice isn't recorded, with a link to today's reviews

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
