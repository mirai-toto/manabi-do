# Database

## Local files

| File | Purpose |
|------|---------|
| `manabi_do/assets/manabi_do_content.db` | Main content DB — kanji, vocab, sentences, all translations |
| `manabi_do/assets/manabi.db` | Empty placeholder (unused) |

The content DB is bundled as a Flutter asset. On first launch it is copied to the app's documents directory and used as the live SQLite database. Edits to the asset file only affect fresh installs/reinstalls; existing installs carry their own on-device copy.

## Data sources

| Content | Source | License |
|---------|--------|---------|
| Kanji meanings & readings | KANJIDIC2 — Electronic Dictionary Research and Development Group (EDRDG) | CC BY-SA 4.0 |
| Vocabulary | JMdict (via [jmdict-simplified](https://github.com/scriptin/jmdict-simplified)) + [Bluskyo/JLPT_Vocabulary](https://github.com/Bluskyo/JLPT_Vocabulary) for JLPT level tagging | CC BY-SA 4.0 |
| Example sentences | [Tatoeba](https://tatoeba.org) community corpus | CC BY 2.0 |
| Stroke order diagrams | KanjiVG by Ulrich Apel | CC BY-SA 3.0 |

Vocab seed generation script: `tools/generate_vocab_seed.py`

## Content organisation by JLPT level

All three content types are queryable by JLPT level (N5–N1):

- **Kanji** — `kanjis.jlpt_level` column; queried directly.
- **Vocabulary** — `vocabulary_entries.jlpt_level` column; queried directly.
- **Sentences** — no `jlpt_level` column; level is inherited via `sentences.vocab_id → vocabulary_entries.jlpt_level`. The app filters sentences by level through this join.

Sentence distribution by inherited level:

| Level | Sentences |
|-------|-----------|
| N5 | 1 765 |
| N4 | 1 623 |
| N3 | 5 128 |
| N2 | 3 981 |
| N1 | 7 661 |
| **Total** | **20 158** |

## Translation coverage

Translations are stored in three tables: `kanji_translations`, `vocab_translations`, `sentence_translations`.
`sentence_translations` uses ISO 639-2 (3-letter) locale codes; the others use ISO 639-1 (2-letter).

### Kanji meanings (2 211 total)

| Level | Count | EN | FR | ES | PT | DE |
|-------|-------|----|----|----|----|----|
| N5 | 79 | 100% | 100% | 100% | 100% | — |
| N4 | 166 | 100% | 100% | 100% | 100% | — |
| N3 | 367 | 100% | 100% | 100% | 100% | — |
| N2 | 367 | 100% | 100% | 100% | 100% | — |
| N1 | 1 232 | 100% | 82% | 100% | 77% | — |
| **Total** | **2 211** | **100%** | **90%** | **100%** | **87%** | **0%** |

Gaps: 219 missing FR kanji (all N1), 283 missing PT kanji (all N1), German has no kanji translations at any level.

### Vocabulary meanings (8 018 total)

| Level | Count | EN | FR | DE | ES | RU |
|-------|-------|----|----|----|----|----|
| N5 | 603 | 100% | 95% | 95% | 96% | 94% |
| N4 | 557 | 100% | 99% | 98% | 98% | 98% |
| N3 | 1 727 | 100% | 98% | 98% | 98% | 98% |
| N2 | 1 681 | 100% | 98% | 98% | 98% | 95% |
| N1 | 3 450 | 100% | 79% | 96% | 93% | 94% |
| **Total** | **8 018** | **100%** | **90%** | **97%** | **96%** | **95%** |

Gaps: mainly N1 — 735 missing FR vocab, ~233 missing DE vocab. N2–N5 nearly complete across all locales.

### Sentence translations (20 158 EN source sentences)

| Level | Count | FR | DE | ES | RU |
|-------|-------|----|----|----|----|
| N5 | 1 765 | 30% | 34% | 28% | 25% |
| N4 | 1 623 | 24% | 29% | 21% | 17% |
| N3 | 5 128 | 23% | 26% | 20% | 17% |
| N2 | 3 981 | 17% | 24% | 14% | 13% |
| N1 | 7 661 | 18% | 24% | 14% | 12% |
| **Total** | **20 158** | **20%** | **26%** | **17%** | **15%** |

Sentences come from Tatoeba where translations depend on community contributions. Coverage is sparse across all non-English locales — the app falls back to the English sentence when no translation exists for the user's locale (configurable via the "My language only" setting).

## Known gaps to address

- [ ] N1 kanji meanings in FR (219 missing) and PT (283 missing)
- [ ] German kanji meanings: 0% coverage — no translations in DB at any level
- [ ] N1 vocab meanings in FR (~735 missing)
- [ ] Sentence translations: structural gap — Tatoeba does not cover most sentences in FR/DE/ES
