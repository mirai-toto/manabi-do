# Database

## Local files

| File                                    | Purpose                                                     |
| --------------------------------------- | ----------------------------------------------------------- |
| `manabi_do/assets/manabi_do_content.db` | Main content DB — kanji, vocab, sentences, all translations |

The content DB is bundled as a Flutter asset. On first launch it is copied to the app's documents directory and used as the live SQLite database. Edits to the asset file only affect fresh installs/reinstalls; existing installs carry their own on-device copy.

## Schema

### `manabi_do_content.db` — All content

**`kanjis`**

| Column      | Type       | Notes             |
| ----------- | ---------- | ----------------- |
| id          | INTEGER PK | Unicode codepoint |
| character   | TEXT       |                   |
| meaning     | TEXT       | English fallback  |
| on_reading  | TEXT       |                   |
| kun_reading | TEXT       |                   |
| jlpt_level  | TEXT       | `N5`–`N1`         |
| svg         | TEXT       | KanjiVG SVG, nullable |

**`kanji_translations`**

| Column   | Type       | Notes               |
| -------- | ---------- | ------------------- |
| kanji_id | INTEGER FK | → `kanjis.id`       |
| locale   | TEXT       | `en`, `fr`, `de`, … |
| meaning  | TEXT       |                     |

Primary key: (kanji_id, locale)

**`kanas`**

| Column     | Type       | Notes                         |
| ---------- | ---------- | ----------------------------- |
| id         | INTEGER PK |                               |
| character  | TEXT       |                               |
| romaji     | TEXT       |                               |
| type       | TEXT       | `hiragana` \| `katakana`      |
| row        | TEXT       | Row label, e.g. `Vowels`, `K` |
| kana_group | TEXT       | `gojuuon` \| `dakuten`        |
| slot       | INTEGER    | Column position 0–4           |

**`vocabulary_entries`**

| Column         | Type       | Notes                   |
| -------------- | ---------- | ----------------------- |
| id             | INTEGER PK |                         |
| word           | TEXT       |                         |
| reading        | TEXT       |                         |
| meaning        | TEXT       | English fallback        |
| jlpt_level     | TEXT       | `N5`–`N1`               |
| part_of_speech | TEXT       |                         |
| kanji_id       | INTEGER FK | → `kanjis.id`, nullable |

**`vocab_translations`**

| Column   | Type       | Notes                     |
| -------- | ---------- | ------------------------- |
| vocab_id | INTEGER FK | → `vocabulary_entries.id` |
| locale   | TEXT       | `en`, `fr`, `de`, …       |
| meaning  | TEXT       |                           |

Primary key: (vocab_id, locale)

**`sentences`**

| Column          | Type       | Notes                                |
| --------------- | ---------- | ------------------------------------ |
| id              | INTEGER PK |                                      |
| japanese        | TEXT       |                                      |
| target_word     | TEXT       | Vocab word the sentence demonstrates |
| vocab_id        | INTEGER FK | → `vocabulary_entries.id`            |
| furigana_before | TEXT       | nullable                             |
| furigana_after  | TEXT       | nullable                             |
| furigana        | TEXT       | Full annotated string, nullable      |

No `jlpt_level` column — level is inherited via `vocab_id → vocabulary_entries.jlpt_level`.

**`sentence_translations`**

| Column      | Type       | Notes                  |
| ----------- | ---------- | ---------------------- |
| sentence_id | INTEGER FK | → `sentences.id`       |
| locale      | TEXT       | `eng`, `fra`, `deu`, … |
| translation | TEXT       |                        |

Primary key: (sentence_id, locale). English (`eng`) is the fallback locale.

**`grammar_lessons`**

| Column      | Type       | Notes                               |
| ----------- | ---------- | ----------------------------------- |
| id          | INTEGER PK |                                     |
| level       | TEXT       | `basics`, `N5`, …                   |
| path        | TEXT       | Relative to `content/grammar/`      |
| chapter     | TEXT       | Chapter title                       |
| title       | TEXT       | Lesson title                        |
| blocks_json | TEXT       | JSON array of `{type, data}` blocks |
| order_index | INTEGER    | Position within chapter             |

Compiled from `content/grammar/` by `tools/build_content_db.py`. Read at runtime by `grammarChaptersProvider` via `AppDatabase.getGrammarLessonsForLevel`.

**`exercises`**

| Column      | Type       | Notes                                    |
| ----------- | ---------- | ---------------------------------------- |
| id          | INTEGER PK |                                          |
| locale      | TEXT       |                                          |
| type        | TEXT       | `mcq`, `flashcard`, `drawing`, …         |
| source      | TEXT       | `kana`, `kanji`, `vocabulary`, `grammar` |
| source_id   | INTEGER    | Row ID in the source table               |
| prompt      | TEXT       |                                          |
| answer      | TEXT       |                                          |
| distractors | TEXT       | JSON array of wrong answers              |
| lesson_id   | INTEGER FK | → `grammar_lessons.id`, nullable         |

### User progress (written at runtime)

**`progress_entries`**

| Column     | Type       | Notes                      |
| ---------- | ---------- | -------------------------- |
| id         | INTEGER PK |                            |
| item_type  | TEXT       | `ItemType` enum name       |
| item_id    | INTEGER    | Row ID in the source table |
| is_known   | BOOLEAN    |                            |
| toggled_at | DATETIME   |                            |

Unique key: (item_type, item_id). Simple known/unknown toggle, locale-agnostic.

**`srs_cards`**

| Column        | Type     | Notes                                          |
| ------------- | -------- | ---------------------------------------------- |
| item_type     | TEXT     | `hiragana`, `katakana`, `kanji`, `vocabulary`  |
| item_id       | INTEGER  | Row ID in the source table                     |
| due           | DATETIME | Next review date                               |
| first_seen_at | DATETIME | Set once on insert, never overwritten          |
| card_json     | TEXT     | Full FSRS `Card` serialized via `card.toMap()` |

Primary key: (item_type, item_id).

---

## Data sources

| Content                   | Source                                                                                                                                                                         | License      |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------ |
| Kanji JLPT level          | [davidluzgouveia/kanji-data](https://github.com/davidluzgouveia/kanji-data) (based on Jonathan Waller's JLPT lists)                                                            | MIT          |
| Kanji meanings & readings | KANJIDIC2 — Electronic Dictionary Research and Development Group (EDRDG)                                                                                                       | CC BY-SA 4.0 |
| Kanji stroke order SVGs   | [KanjiVG](https://kanjivg.tagaini.net/) by Ulrich Apel                                                                                                                        | CC BY-SA 3.0 |
| Vocabulary                | JMdict (via [jmdict-simplified](https://github.com/scriptin/jmdict-simplified)) + [Bluskyo/JLPT_Vocabulary](https://github.com/Bluskyo/JLPT_Vocabulary) for JLPT level tagging | CC BY-SA 4.0 |
| Example sentences         | [Tatoeba](https://tatoeba.org) community corpus                                                                                                                                | CC BY 2.0    |
| Grammar lessons           | Hand-authored in `content/grammar/`                                                                                                                                            | —            |

These sources feed into `content/` JSON files (committed) via the content pipeline. See `content/README.md` for the full rebuild workflow. `tools/sync_content.py` re-seeds `content/characters/` and `content/vocabulary/` from upstream; run via `tools/generate.py --sync`.

## Content storage and recoverability

Every content type has a different resilience profile. This table maps where each lives and what is needed to recover it if the compiled DB is lost or corrupted.

| Content | `content/` JSON (git) | DB | Raw source in `data/` (gitignored) | Recovery if DB lost |
|---|---|---|---|---|
| Kanji characters, readings, meanings | ✅ `kanji_n*.json` | ✅ `kanjis` | ✅ re-downloadable | Rebuild from `content/` |
| Kanji stroke order SVGs | ❌ | ✅ `kanjis.svg` | ✅ re-downloadable | Re-download KanjiVG → rebuild DB |
| Kana | ✅ `kana.json` | ✅ `kanas` | — (static) | Rebuild from `content/` |
| Vocabulary words, readings, POS | ✅ `vocab_n*.json` | ✅ `vocabulary_entries` | ✅ re-downloadable | Rebuild from `content/` |
| Vocabulary meanings (multilingual) | ✅ inside `vocab_n*.json` | ✅ `vocab_translations` | ✅ re-downloadable (250 MB) | Rebuild from `content/` |
| Example sentences | ❌ | ✅ `sentences` | ✅ re-downloadable | Re-download Tatoeba → rebuild DB |
| Sentence translations | ❌ | ✅ `sentence_translations` | ✅ re-downloadable | Re-download Tatoeba → rebuild DB |
| Grammar lessons | ✅ `content/grammar/` | ✅ `grammar_lessons` | — (hand-authored) | Rebuild from `content/` |

**Key insight:** sentences and SVGs have no committed fallback — they exist only in the DB and their gitignored raw source. All other content survives a DB loss via `content/` JSON. A full rebuild from scratch (including re-downloading all sources) takes a few minutes with `python3 tools/generate.py --sync`.

## Content organisation by JLPT level

All three content types are queryable by JLPT level (N5–N1):

- **Kanji** — `kanjis.jlpt_level` column; queried directly.
- **Vocabulary** — `vocabulary_entries.jlpt_level` column; queried directly.
- **Sentences** — no `jlpt_level` column; level is inherited via `sentences.vocab_id → vocabulary_entries.jlpt_level`. The app filters sentences by level through this join.

Sentence distribution by inherited level:

| Level     | Sentences  |
| --------- | ---------- |
| N5        | 1 765      |
| N4        | 1 623      |
| N3        | 5 128      |
| N2        | 3 981      |
| N1        | 7 661      |
| **Total** | **20 158** |

## Translation coverage

Translations are stored in three tables: `kanji_translations`, `vocab_translations`, `sentence_translations`.
`sentence_translations` uses ISO 639-2 (3-letter) locale codes; the others use ISO 639-1 (2-letter).

### Kanji meanings (2 211 total)

| Level     | Count     | EN       | FR      | ES       | PT      | DE     |
| --------- | --------- | -------- | ------- | -------- | ------- | ------ |
| N5        | 79        | 100%     | 100%    | 100%     | 100%    | —      |
| N4        | 166       | 100%     | 100%    | 100%     | 100%    | —      |
| N3        | 367       | 100%     | 100%    | 100%     | 100%    | —      |
| N2        | 367       | 100%     | 100%    | 100%     | 100%    | —      |
| N1        | 1 232     | 100%     | 82%     | 100%     | 77%     | —      |
| **Total** | **2 211** | **100%** | **90%** | **100%** | **87%** | **0%** |

Gaps: 219 missing FR kanji (all N1), 283 missing PT kanji (all N1), German has no kanji translations at any level.

### Vocabulary meanings (8 018 total)

| Level     | Count     | EN       | FR      | DE      | ES      | RU      |
| --------- | --------- | -------- | ------- | ------- | ------- | ------- |
| N5        | 603       | 100%     | 95%     | 95%     | 96%     | 94%     |
| N4        | 557       | 100%     | 99%     | 98%     | 98%     | 98%     |
| N3        | 1 727     | 100%     | 98%     | 98%     | 98%     | 98%     |
| N2        | 1 681     | 100%     | 98%     | 98%     | 98%     | 95%     |
| N1        | 3 450     | 100%     | 79%     | 96%     | 93%     | 94%     |
| **Total** | **8 018** | **100%** | **90%** | **97%** | **96%** | **95%** |

Gaps: mainly N1 — 735 missing FR vocab, ~233 missing DE vocab. N2–N5 nearly complete across all locales.

### Sentence translations (20 158 EN source sentences)

| Level     | Count      | EN       | FR      | DE      | ES      | RU      |
| --------- | ---------- | -------- | ------- | ------- | ------- | ------- |
| N5        | 1 765      | 100%     | 30%     | 34%     | 28%     | 25%     |
| N4        | 1 623      | 100%     | 24%     | 29%     | 21%     | 17%     |
| N3        | 5 128      | 100%     | 23%     | 26%     | 20%     | 17%     |
| N2        | 3 981      | 100%     | 17%     | 24%     | 14%     | 13%     |
| N1        | 7 661      | 100%     | 18%     | 24%     | 14%     | 12%     |
| **Total** | **20 158** | **100%** | **20%** | **26%** | **17%** | **15%** |

Sentences come from Tatoeba where translations depend on community contributions. Coverage is sparse across all non-English locales — the app falls back to the English sentence when no translation exists for the user's locale (configurable via the "My language only" setting).

## Known gaps to address

- [ ] N1 kanji meanings in FR (219 missing) and PT (283 missing)
- [ ] German kanji meanings: 0% coverage — no translations in DB at any level
- [ ] N1 vocab meanings in FR (~735 missing)
- [ ] Sentence translations: structural gap — Tatoeba does not cover most sentences in FR/DE/ES
