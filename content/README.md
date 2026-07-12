# Content

Source files for all app content. Run from the **repo root** in all cases.

## Directory layout

```
content/
  characters/   kanji_n1-n5.json, kana.json
  vocabulary/   vocab_n1-n5.json
  grammar/      levels.json + recursive lesson tree (index.json + lesson files)
```

---

## Full pipeline (recommended)

`tools/generate.py` orchestrates all steps in order: SVG download → optional translations → DB build.

```bash
python3 tools/generate.py                 # full rebuild
python3 tools/generate.py --no-sentences  # skip Tatoeba (faster, good for grammar/kanji edits)
python3 tools/generate.py --translations  # also regenerate translations from JMdict/KANJIDIC2
```

---

## Individual steps

### Rebuild the database

```bash
python3 tools/build_content_db.py [--no-sentences]
```

Reads all files under `content/` and writes `manabi_do/assets/manabi_do_content.db`. Requires kanji SVGs in `data/kanji_svg/` (see below). On first run downloads ~60 MB of Tatoeba data into `data/tatoeba/` (cached for subsequent runs).

---

### Refresh kanji/vocabulary translations

Only needed when updating meanings from JMdict/KANJIDIC2. Requires two files placed in `data/` first:

| File                 | Source                                                                                                                                      |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `data/jmdict.json`   | [jmdict-simplified releases](https://github.com/scriptin/jmdict-simplified/releases) — download `jmdict-all-*.json.zip`, extract and rename |
| `data/kanjidic2.xml` | [EDRDG](https://www.edrdg.org/kanjidic/kanjidic2.xml.gz) — decompress the `.gz`                                                             |

Then run either:

```bash
python3 tools/gen_translations.py
# or
dart run tools/gen_translations.dart
```

Both update `content/characters/kanji_n*.json` and `content/vocabulary/vocab_n*.json` in place. Rebuild the database afterwards (or use `tools/generate.py --translations`).

---

### Refresh kanji SVGs

Required before the first DB rebuild on a fresh clone, and whenever kanji are added to `content/characters/`. Downloads missing SVGs from KanjiVG into `data/kanji_svg/`; already-present files are skipped.

```bash
python3 tools/download_kanjivg.py
```

SVGs are embedded into the DB by `build_content_db.py` — they are not bundled as individual asset files.
