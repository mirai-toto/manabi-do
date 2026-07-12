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

## Rebuild the database

This is the only step needed for day-to-day content changes (editing grammar lessons, etc.).

```bash
python3 tools/build_content_db.py
```

Reads all files under `content/` and writes `manabi_do/assets/manabi_do_content.db`.

Requires kanji SVGs to be present in `data/kanji_svg/` (see below). On first run, downloads ~60 MB of Tatoeba sentence data into `data/tatoeba/` (cached for subsequent runs). Skip sentences for a fast rebuild:

```bash
python3 tools/build_content_db.py --no-sentences
```

---

## Refresh kanji/vocabulary translations

Only needed when updating kanji meanings or vocabulary translations from JMdict/KANJIDIC2. Requires two files placed in `data/` first:

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

Both scripts update `content/characters/kanji_n*.json` and `content/vocabulary/vocab_n*.json` in place. Rebuild the database afterwards.

---

## Refresh kanji SVGs

Required before the first DB rebuild on a fresh clone, and whenever kanji are added to `content/characters/`. Downloads missing SVGs from KanjiVG into `data/kanji_svg/`; already-present files are skipped.

```bash
python3 tools/download_kanjivg.py
```

SVGs are embedded into the DB by `build_content_db.py` — they are not bundled as individual asset files.
