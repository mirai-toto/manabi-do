#!/usr/bin/env python3
"""
Re-seed content/characters/kanji_n*.json and content/vocabulary/vocab_n*.json
from online sources, downloading and caching raw data to data/.

Sources:
  - Kanji levels:    davidluzgouveia/kanji-data (GitHub) — modern N1–N5 assignment
                     (based on Jonathan Waller's JLPT lists, jlpt_new field)
  - Kanji readings/meanings: KANJIDIC2 (EDRDG)
  - Vocab:  Bluskyo/JLPT_Vocabulary (JLPT level + reading)
            + JMdict-simplified (meanings in all languages, POS)

Run from the repo root:
    python3 tools/sync_content.py [--force]

Flags:
    --force   Re-download source files even if already cached in data/

Note:
    content/characters/kana.json is static (kana never changes) and is not
    touched by this script.

After running, rebuild the DB:
    python3 tools/generate.py --no-sentences
"""

import argparse
import gzip
import io
import json
import os
import re
import urllib.request
import xml.etree.ElementTree as ET
import zipfile

DATA_DIR   = "data"
CHARS_DIR  = "content/characters"
VOCAB_DIR  = "content/vocabulary"

BLUSKYO_PATH    = os.path.join(DATA_DIR, "bluskyo_vocab.json")
JMDICT_PATH     = os.path.join(DATA_DIR, "jmdict.json")
KANJIDIC2_PATH  = os.path.join(DATA_DIR, "kanjidic2.xml")
KANJI_DATA_PATH = os.path.join(DATA_DIR, "kanji_data.json")

BLUSKYO_URL    = "https://raw.githubusercontent.com/Bluskyo/JLPT_Vocabulary/main/data/vocab/results/JLPT_vocab_ALL.json"
JMDICT_API_URL = "https://api.github.com/repos/scriptin/jmdict-simplified/releases/latest"
KANJIDIC2_URL  = "https://www.edrdg.org/kanjidic/kanjidic2.xml.gz"
KANJI_DATA_URL = "https://raw.githubusercontent.com/davidluzgouveia/kanji-data/master/kanji.json"

# davidluzgouveia/kanji-data jlpt_new: 5=N5, 4=N4, 3=N3, 2=N2, 1=N1
JLPT_NEW_TO_STR: dict[int, str] = {5: "N5", 4: "N4", 3: "N3", 2: "N2", 1: "N1"}

# JMdict ISO 639-2/3 → BCP-47
LANG_MAP: dict[str, str] = {
    "eng": "en",
    "fre": "fr",
    "ger": "de",
    "spa": "es",
    "rus": "ru",
    "nld": "nl",
    "hun": "hu",
    "slv": "sl",
    "swe": "sv",
    "por": "pt",
}


_POS_MAP: dict[str, str] = {
    "n":       "noun",
    "adj-i":   "i-adjective",
    "adj-na":  "na-adjective",
    "adj-no":  "no-adjective",
    "adv":     "adverb",
    "adv-to":  "adverb",
    "conj":    "conjunction",
    "int":     "interjection",
    "prt":     "particle",
    "pn":      "pronoun",
    "exp":     "expression",
    "num":     "numeral",
    "aux":     "auxiliary",
    "aux-v":   "auxiliary verb",
    "aux-adj": "auxiliary adjective",
    "suf":     "suffix",
    "pref":    "prefix",
    "ctr":     "counter",
}
_VERB_RE = re.compile(r"^v\d|^vi$|^vt$|^vs$|^vk$|^vz$|^vr$|^vn$")


def _normalise_pos(codes: list[str]) -> str:
    for code in codes:
        if code in _POS_MAP:
            return _POS_MAP[code]
        if _VERB_RE.match(code):
            return "verb"
    return codes[0] if codes else ""


# ── Download helpers ──────────────────────────────────────────────────────────

def _get_bytes(url: str, desc: str) -> bytes:
    print(f"  ↓ {desc}")
    req = urllib.request.Request(url, headers={"User-Agent": "manabi-do/sync-content"})
    with urllib.request.urlopen(req, timeout=180) as r:
        total = int(r.headers.get("Content-Length", 0))
        buf = io.BytesIO()
        done = 0
        while chunk := r.read(1 << 16):
            buf.write(chunk)
            done += len(chunk)
            if total:
                print(f"\r    {done * 100 // total:3d}%  {done // 1024} KB ", end="", flush=True)
        print()
    return buf.getvalue()


def _ensure(path: str, force: bool, fetch_fn) -> None:
    if os.path.exists(path) and not force:
        print(f"  ✓ {os.path.basename(path)} (cached)")
        return
    fetch_fn(path)


def _fetch_bluskyo(dest: str) -> None:
    data = _get_bytes(BLUSKYO_URL, "Bluskyo JLPT vocabulary")
    with open(dest, "wb") as f:
        f.write(data)


def _fetch_jmdict(dest: str) -> None:
    api = json.loads(_get_bytes(JMDICT_API_URL, "jmdict-simplified release info"))
    url = next(
        (a["browser_download_url"] for a in api.get("assets", [])
         if a.get("name", "").startswith("jmdict-all") and a["name"].endswith(".json.zip")),
        None,
    )
    if url is None:
        raise RuntimeError("Could not find jmdict-all .json.zip in latest release assets")
    zip_bytes = _get_bytes(url, "jmdict-all.json.zip")
    print("  Extracting…", end="", flush=True)
    with zipfile.ZipFile(io.BytesIO(zip_bytes)) as zf:
        json_name = next(n for n in zf.namelist() if n.endswith(".json"))
        raw = zf.read(json_name)
    with open(dest, "wb") as f:
        f.write(raw)
    print(f" {len(raw) // 1024} KB")


def _fetch_kanjidic2(dest: str) -> None:
    gz = _get_bytes(KANJIDIC2_URL, "kanjidic2.xml.gz")
    print("  Decompressing…", end="", flush=True)
    xml_bytes = gzip.decompress(gz)
    with open(dest, "wb") as f:
        f.write(xml_bytes)
    print(f" {len(xml_bytes) // 1024} KB")


def _fetch_kanji_data(dest: str) -> None:
    data = _get_bytes(KANJI_DATA_URL, "davidluzgouveia/kanji-data")
    with open(dest, "wb") as f:
        f.write(data)


# ── Kanji ─────────────────────────────────────────────────────────────────────

def generate_kanji(force: bool) -> set[int]:
    print("\n── Kanji ────────────────────────────────────────────────────")
    _ensure(KANJI_DATA_PATH, force, _fetch_kanji_data)
    _ensure(KANJIDIC2_PATH, force, _fetch_kanjidic2)

    print("  Loading kanji level list…", end="", flush=True)
    with open(KANJI_DATA_PATH, encoding="utf-8") as f:
        kanji_data: dict[str, dict] = json.load(f)
    # character → level string; skip entries with no modern JLPT level
    char_to_level: dict[str, str] = {}
    for char, info in kanji_data.items():
        lvl = JLPT_NEW_TO_STR.get(info.get("jlpt_new"))
        if lvl:
            char_to_level[char] = lvl
    print(f" {len(char_to_level)} kanji with JLPT level")

    print("  Parsing KANJIDIC2…", end="", flush=True)
    root = ET.parse(KANJIDIC2_PATH).getroot()
    kanjidic2_index: dict[str, ET.Element] = {
        ch.findtext("literal") or "": ch for ch in root.findall("character")
    }
    print(f" {len(kanjidic2_index)} entries")

    by_level: dict[str, list[dict]] = {l: [] for l in ["N5", "N4", "N3", "N2", "N1"]}
    kanji_ids: set[int] = set()

    for char, level in char_to_level.items():
        kanji_id = ord(char)
        kanji_ids.add(kanji_id)

        on_readings: list[str] = []
        kun_readings: list[str] = []
        meanings: dict[str, list[str]] = {}

        character = kanjidic2_index.get(char)
        if character is not None:
            for rmgroup in character.findall("reading_meaning/rmgroup"):
                for reading in rmgroup.findall("reading"):
                    r_type = reading.get("r_type", "")
                    text = reading.text or ""
                    if r_type == "ja_on":
                        on_readings.append(text)
                    elif r_type == "ja_kun":
                        kun_readings.append(text)
                for meaning in rmgroup.findall("meaning"):
                    lang_attr = meaning.get("m_lang", "")
                    lang = "en" if lang_attr == "" else LANG_MAP.get(lang_attr, lang_attr)
                    meanings.setdefault(lang, []).append(meaning.text or "")

        by_level[level].append({
            "id": kanji_id,
            "character": char,
            "jlpt": level,
            "on": on_readings,
            "kun": kun_readings,
            "meanings": {lang: ", ".join(texts) for lang, texts in meanings.items()},
        })

    os.makedirs(CHARS_DIR, exist_ok=True)
    for level in ["N5", "N4", "N3", "N2", "N1"]:
        path = os.path.join(CHARS_DIR, f"kanji_{level.lower()}.json")
        entries = sorted(by_level[level], key=lambda e: e["id"])
        with open(path, "w", encoding="utf-8") as f:
            json.dump(entries, f, ensure_ascii=False, indent=2)
        print(f"  kanji_{level.lower()}.json: {len(entries)} entries")

    return kanji_ids


# ── Vocab ─────────────────────────────────────────────────────────────────────

def generate_vocab(kanji_ids: set[int], force: bool) -> None:
    print("\n── Vocabulary ───────────────────────────────────────────────")
    _ensure(BLUSKYO_PATH, force, _fetch_bluskyo)
    _ensure(JMDICT_PATH, force, _fetch_jmdict)

    print("  Loading Bluskyo vocab…", end="", flush=True)
    with open(BLUSKYO_PATH, encoding="utf-8") as f:
        bluskyo_raw: dict[str, list[dict]] = json.load(f)
    # Bluskyo level int: 1=N1 … 5=N5
    by_level: dict[str, list[tuple[str, str]]] = {f"N{i}": [] for i in range(1, 6)}
    for word, entries in bluskyo_raw.items():
        for entry in entries:
            lvl = entry.get("level")
            if isinstance(lvl, int) and 1 <= lvl <= 5:
                by_level[f"N{lvl}"].append((word, entry.get("reading", "")))
    print(" done")

    print("  Loading JMdict…", end="", flush=True)
    with open(JMDICT_PATH, encoding="utf-8") as f:
        jmdict = json.load(f)
    print(" done")

    print("  Building JMdict lookup…", end="", flush=True)
    # surface_form → {meanings, pos, reading}
    lookup: dict[str, dict] = {}
    for word in jmdict.get("words", []):
        kanji_forms: list[str] = [k["text"] for k in word.get("kanji", []) if k.get("text")]
        kana_forms:  list[str] = [k["text"] for k in word.get("kana",  []) if k.get("text")]
        primary_kana = kana_forms[0] if kana_forms else ""

        meanings: dict[str, list[str]] = {}
        pos_str = ""
        for sense in word.get("sense", []):
            if not pos_str:
                pos_str = _normalise_pos(sense.get("partOfSpeech", []))
            for gloss in sense.get("gloss", []):
                lang = LANG_MAP.get(gloss.get("lang", "eng"))
                if lang is None:
                    continue
                meanings.setdefault(lang, []).append(gloss["text"])

        merged = {lang: "; ".join(texts) for lang, texts in meanings.items()}
        if not merged:
            continue

        record = {"meanings": merged, "pos": pos_str, "reading": primary_kana}
        for form in (kanji_forms or kana_forms):
            if form not in lookup:
                lookup[form] = record
    print(f" {len(lookup):,} forms indexed")

    os.makedirs(VOCAB_DIR, exist_ok=True)
    for level_int in range(1, 6):
        level = f"N{level_int}"
        path = os.path.join(VOCAB_DIR, f"vocab_{level.lower()}.json")

        entries: list[dict] = []
        missing: list[str] = []
        # Bluskyo lists a word once per reading, and occasionally repeats the
        # same pair. pos and meanings come from `lookup`, which is keyed by the
        # word alone, so (word, reading) is a full identity check here.
        seen: set[tuple[str, str]] = set()
        duplicates: int = 0

        for word, bluskyo_reading in by_level[level]:
            hit = lookup.get(word) or lookup.get(bluskyo_reading)
            if hit is None:
                missing.append(word)
                continue
            reading = bluskyo_reading if bluskyo_reading else hit["reading"]
            key: tuple[str, str] = (word, reading)
            if key in seen:
                duplicates += 1
                continue
            seen.add(key)
            kanji_id: int | None = next(
                (ord(ch) for ch in word if ord(ch) in kanji_ids), None
            )
            entries.append({
                "word": word,
                "reading": reading,
                "pos": hit["pos"],
                "kanjiId": kanji_id,
                "jlpt": level,
                "meanings": hit["meanings"],
            })

        with open(path, "w", encoding="utf-8") as f:
            json.dump(entries, f, ensure_ascii=False, indent=2)
        skipped = f", {len(missing)} not in JMdict" if missing else ""
        deduped = f", {duplicates} duplicates dropped" if duplicates else ""
        print(
            f"  vocab_{level.lower()}.json: {len(entries)} entries{skipped}{deduped}"
        )


# ── Main ──────────────────────────────────────────────────────────────────────

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Re-seed kanji and vocab JSON from online sources.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Re-download source files even if already cached in data/",
    )
    args = parser.parse_args()

    os.makedirs(DATA_DIR, exist_ok=True)

    kanji_ids = generate_kanji(args.force)
    generate_vocab(kanji_ids, args.force)

    print("\nDone. Rebuild the DB:")
    print("  python3 tools/generate.py --no-sentences")


if __name__ == "__main__":
    main()
