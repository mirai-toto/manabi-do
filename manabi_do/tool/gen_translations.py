"""
Enriches content/kanji_n[1-5].json and content/vocab_n[1-5].json
with multilingual meanings from JMdict-simplified and KANJIDIC2.

Prerequisites — download these files and place them in tool/data/:
  JMdict-simplified (all languages JSON):
    https://github.com/scriptin/jmdict-simplified/releases
    → jmdict-all-<version>.json  (rename to tool/data/jmdict.json)
  KANJIDIC2 XML:
    https://www.edrdg.org/kanjidic/kanjidic2.xml.gz
    → uncompress to tool/data/kanjidic2.xml

Run from the project root:
    python3 tool/gen_translations.py

After running, re-run tool/build_content_db.py and commit the updated DB.
"""

import json
import xml.etree.ElementTree as ET
import os
import sys

LEVELS = ["n5", "n4", "n3", "n2", "n1"]

# JMdict ISO 639-2 → BCP-47
LANG_MAP = {
    "eng": "en",
    "fre": "fr",
    "ger": "de",
    "spa": "es",
    "rus": "ru",
    "nld": "nl",
    "hun": "hu",
    "slv": "sl",
    "swe": "sv",
}


def build_vocab_lookup(jmdict_path: str) -> dict[tuple[str, str], dict[str, str]]:
    print("Loading JMdict…", flush=True)
    with open(jmdict_path, encoding="utf-8") as f:
        jmdict = json.load(f)

    lookup: dict[tuple[str, str], dict[str, str]] = {}
    for word in jmdict["words"]:
        kanji_forms  = [k["text"] for k in word.get("kanji", [])]
        reading_forms = [r["text"] for r in word.get("kana", [])]

        translations: dict[str, list[str]] = {}
        for sense in word.get("sense", []):
            for gloss in sense.get("gloss", []):
                lang = LANG_MAP.get(gloss.get("lang", "eng"))
                if lang is None:
                    continue
                translations.setdefault(lang, []).append(gloss["text"])

        merged = {lang: "; ".join(texts) for lang, texts in translations.items()}
        if not merged:
            continue

        for k in (kanji_forms if kanji_forms else [""]):
            for r in reading_forms:
                key = (k, r)
                if key not in lookup:
                    lookup[key] = {}
                lookup[key].update(merged)

    print(f"  {len(lookup):,} vocab entries indexed", flush=True)
    return lookup


def build_kanji_lookup(kanjidic2_path: str) -> dict[int, dict[str, str]]:
    print("Loading KANJIDIC2…", flush=True)
    tree = ET.parse(kanjidic2_path)
    root = tree.getroot()

    lookup: dict[int, dict[str, str]] = {}
    for character in root.findall("character"):
        literal = character.findtext("literal", "")
        if not literal:
            continue
        kanji_id = ord(literal)

        meanings: dict[str, list[str]] = {}
        for rmgroup in character.findall("reading_meaning/rmgroup"):
            for m in rmgroup.findall("meaning"):
                lang_attr = m.get("m_lang", "")
                if lang_attr == "":
                    lang = "en"
                else:
                    lang = LANG_MAP.get(lang_attr, lang_attr)
                meanings.setdefault(lang, []).append(m.text or "")

        lookup[kanji_id] = {lang: ", ".join(texts) for lang, texts in meanings.items()}

    print(f"  {len(lookup):,} kanji entries indexed", flush=True)
    return lookup


def enrich_kanji(kanji_lookup: dict[int, dict[str, str]]) -> None:
    for level in LEVELS:
        path = f"content/kanji_{level}.json"
        with open(path, encoding="utf-8") as f:
            entries = json.load(f)

        hits = 0
        for entry in entries:
            tr = kanji_lookup.get(entry["id"])
            if tr:
                entry["meanings"].update(tr)
                hits += 1

        with open(path, "w", encoding="utf-8") as f:
            json.dump(entries, f, ensure_ascii=False, indent=2)

        print(f"kanji_{level}.json: enriched {hits}/{len(entries)} entries")


def enrich_vocab(vocab_lookup: dict[tuple[str, str], dict[str, str]]) -> None:
    for level in LEVELS:
        path = f"content/vocab_{level}.json"
        with open(path, encoding="utf-8") as f:
            entries = json.load(f)

        hits = 0
        for entry in entries:
            word    = entry["word"]
            reading = entry["reading"]
            tr = vocab_lookup.get((word, reading)) or vocab_lookup.get(("", reading))
            if tr:
                entry["meanings"].update(tr)
                hits += 1

        with open(path, "w", encoding="utf-8") as f:
            json.dump(entries, f, ensure_ascii=False, indent=2)

        print(f"vocab_{level}.json: enriched {hits}/{len(entries)} entries")


def main() -> None:
    jmdict_path   = "tool/data/jmdict.json"
    kanjidic2_path = "tool/data/kanjidic2.xml"

    if not os.path.exists(jmdict_path) or not os.path.exists(kanjidic2_path):
        print("Missing input files. See instructions at the top of this script.", file=sys.stderr)
        sys.exit(1)

    vocab_lookup = build_vocab_lookup(jmdict_path)
    kanji_lookup = build_kanji_lookup(kanjidic2_path)

    print("\nEnriching kanji…")
    enrich_kanji(kanji_lookup)

    print("\nEnriching vocab…")
    enrich_vocab(vocab_lookup)

    print("\nDone. Re-run tool/build_content_db.py to rebuild the DB.")


if __name__ == "__main__":
    main()
