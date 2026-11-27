# Polish Backlog — Manabi Do

Ergonomic improvements found while listing the app's features in [09_functional_features.md](09_functional_features.md). Ranked by priority; the ranking is a draft to adjust.

Done items are removed; git history and [09_functional_features.md](09_functional_features.md) keep them. Content tooling and data fixes (the content back office, misread furigana, missing sentences) live in manabi-content's `docs/03_backlog.md`.

---

## Next

- **Kanji the app does not teach** (e.g. 誰, 俺) aren't listed in sentence detail, since the app has no data for them; a sentence made only of those shows no kanji at all
- **Words in this sentence** (planned): a list like the kanji one, each word opening its word detail. Words are worked out ahead of time in the content pipeline (`manabi-content`), not in the app:
  - Source: Tatoeba's `jpn_indices` (curated, already linked to JMdict senses) where a sentence has them; Janome (or SudachiPy) as a fallback for the rest, matching its dictionary forms and readings to the app's vocabulary
  - Words outside the app's vocabulary are skipped, like untaught kanji
  - App side: a sentence → words table (schema change and migration), one query, and the list on the sentence detail reusing the word rows
  - Rejected: matching words in the app (misses conjugations, noisy on particles) and shipping a tokenizer in the app (tens of MB, native code)
  - Since content schema 30 every sentence carries its `tatoeba_id`, the key `jpn_indices` uses, so the indices can be joined directly

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
