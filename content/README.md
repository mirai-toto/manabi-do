# Content

Source files for all app content. Run from the **repo root** in all cases.

## Content model

```
Online sources (Bluskyo, JMdict, KANJIDIC2, KanjiVG)
        ↓  download & cache  →  data/  (gitignored)
content/  ← versioned JSON snapshot, committed to git
        ↓  tools/generate.py
manabi_do/assets/manabi_do_content.db  ← compiled output, committed to git
```

`content/` JSON files are currently derived from online sources and committed as a versioned snapshot. They can diverge from upstream as manual edits accumulate — that divergence is intentional as the app's content matures.

**Gap:** there is currently no automated tool to re-seed `content/characters/` and `content/vocabulary/` from the online sources. `tools/sync_content.py` is planned to fill this gap. Until then, `tools/gen_translations.py` can only refresh multilingual *meanings* on existing entries — it cannot add, remove, or restructure entries.

---

## Directory layout

```
content/
  characters/   kanji_n1-n5.json, kana.json
  vocabulary/   vocab_n1-n5.json
  grammar/      levels.json + recursive lesson tree (index.json + lesson files)

data/  (gitignored — raw downloads, re-fetchable)
  kanji_svg/    SVG source files (KanjiVG), downloaded by tools/download_kanjivg.py
  tatoeba/      Sentence corpus, downloaded by tools/build_content_db.py on first run
  jmdict.json   JMdict-simplified — manually placed (see below)
  kanjidic2.xml KANJIDIC2 — manually placed (see below)
```

---

## Rebuild the database

`tools/generate.py` is the main entry point. It downloads missing SVGs then builds the DB.

```bash
python3 tools/generate.py                 # full rebuild (downloads Tatoeba on first run)
python3 tools/generate.py --no-sentences  # skip Tatoeba — faster, good for grammar/kanji edits
python3 tools/generate.py --translations  # refresh multilingual meanings first, then rebuild
```

---

## Refresh multilingual meanings

`tools/gen_translations.py` enriches **existing** entries in `content/characters/kanji_n*.json` and `content/vocabulary/vocab_n*.json` with multilingual meanings from JMdict and KANJIDIC2. It does not create or remove entries.

Requires two files placed manually in `data/`:

| File                 | Source                                                                                                                                      |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `data/jmdict.json`   | [jmdict-simplified releases](https://github.com/scriptin/jmdict-simplified/releases) — download `jmdict-all-*.json.zip`, extract and rename |
| `data/kanjidic2.xml` | [EDRDG](https://www.edrdg.org/kanjidic/kanjidic2.xml.gz) — decompress the `.gz`                                                             |

```bash
python3 tools/generate.py --translations  # enrich then rebuild (recommended)
# or standalone:
python3 tools/gen_translations.py
```

---

## Refresh kanji SVGs

Downloads missing SVGs from KanjiVG into `data/kanji_svg/`. Already-present files are skipped. `tools/generate.py` calls this automatically before building the DB.

```bash
python3 tools/download_kanjivg.py
```

SVGs are embedded into the DB — they are not bundled as individual asset files.

---

## Sync content from upstream _(planned)_

`tools/sync_content.py` will re-seed `content/characters/` and `content/vocabulary/` from scratch by downloading fresh data from Bluskyo/JLPT_Vocabulary, JMdict, and KANJIDIC2. When implemented it will replace `tools/gen_translations.py` and `tools/generate_vocab_seed.py`.

Until then, the JSON files in `content/` are the authoritative source and must be edited manually for any structural changes (adding/removing entries).
