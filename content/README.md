# Content

Source files for all app content. Run from the **repo root** in all cases.

## Content model

```
Online sources (Bluskyo, JMdict, KANJIDIC2, KanjiVG)
        ↓  download & cache  →  data/  (gitignored)
content/  ← versioned JSON snapshot, committed to git
        ↓  scripts/content_pipeline/generate.py
manabi_do/assets/manabi_do_content.db  ← compiled output, committed to git
```

`content/` JSON files are committed as a versioned snapshot. They can diverge from upstream as manual edits accumulate — that divergence is intentional as the app's content matures.

---

## Directory layout

```
content/
  characters/   kanji_n1-n5.json, kana.json
                kanji_svg/  SVG stroke order files (KanjiVG), committed
  vocabulary/   vocabulary_n1-n5.json
  grammar/      levels.json + recursive lesson tree (index.json + lesson files)

data/  (gitignored — raw downloads, re-fetchable)
  tatoeba/         Sentence corpus, downloaded by scripts/content_pipeline/build_content_db.py on first run
  bluskyo_vocabulary.json  JLPT vocabulary list (Bluskyo)
  jmdict.json         JMdict-simplified (meanings in all languages)
  kanjidic2.xml       KANJIDIC2 (readings, meanings, JLPT levels)
  kanji_data.json     davidluzgouveia/kanji-data (JLPT level assignment)
```

---

## Full rebuild from scratch

To completely re-seed `content/characters/` and `content/vocabulary/` from online sources and rebuild the DB:

```bash
python3 scripts/content_pipeline/generate.py --sync [--no-sentences]
```

This runs `scripts/content_pipeline/sync_content.py` (download + regenerate JSON), then builds the DB.

Use `--force` to re-download source files even if already cached:

```bash
python3 scripts/content_pipeline/generate.py --sync --force --no-sentences
```

**Known limitation — N2/N3 split:** KANJIDIC2 uses the old 4-level JLPT system where old level 2 covers both N2 and N3 (~734 kanji). After a sync, N3 will have ~734 entries and N2 will be empty. The committed JSON files preserve the manually curated 367/367 split — use them as reference if you need to redistribute entries.

**Note:** `content/characters/kana.json` is static (kana never changes) and is not touched by `sync_content.py`.

---

## Rebuild the database only

When `content/` JSON is already correct and you only need to recompile the DB:

```bash
python3 scripts/content_pipeline/generate.py                 # full rebuild (downloads Tatoeba on first run)
python3 scripts/content_pipeline/generate.py --no-sentences  # skip Tatoeba — faster, good for grammar/kanji edits
```

---

## Refresh multilingual meanings

`scripts/content_pipeline/gen_translations.py` enriches **existing** entries in `content/characters/kanji_n*.json` and `content/vocabulary/vocabulary_n*.json` with multilingual meanings from JMdict and KANJIDIC2. It does not create or remove entries.

```bash
python3 scripts/content_pipeline/generate.py --translations [--no-sentences]
```

This requires `data/jmdict.json` and `data/kanjidic2.xml` — they are downloaded automatically when running `--sync`. If you want to run translations without a full sync, place them manually:

| File                 | Source                                                                                                                                      |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `data/jmdict.json`   | [jmdict-simplified releases](https://github.com/scriptin/jmdict-simplified/releases) — download `jmdict-all-*.json.zip`, extract and rename |
| `data/kanjidic2.xml` | [EDRDG](https://www.edrdg.org/kanjidic/kanjidic2.xml.gz) — decompress the `.gz`                                                             |

---

## Refresh kanji SVGs

Downloads missing SVGs from KanjiVG into `content/characters/kanji_svg/`. Already-present files are skipped. `scripts/content_pipeline/generate.py` calls this automatically before building the DB.

```bash
python3 scripts/content_pipeline/download_kanjivg.py
```

SVGs are embedded into the DB — they are not bundled as individual asset files.
