"""
Generates manabi_do/assets/manabi_do_content.db from the JSON source files.

Run from the repo root:
    python3 tools/build_content_db.py

Commit the output file. The app copies it on first install — no runtime
parsing or seeding loop.

To add multilingual translations, run tools/gen_translations.dart first,
then re-run this script.

Sentence exercises use Tatoeba (CC BY 2.0, tatoeba.org). The script
downloads and caches the required dump files in tools/tatoeba_cache/ on first
run (~60 MB total). Pass --no-sentences to skip the sentence step.
"""

import json
import sqlite3
import os
import sys
import tarfile
import urllib.request
from collections import defaultdict

import pykakasi

SCHEMA_VERSION = 11

_kks = pykakasi.kakasi()


def _is_kana(ch: str) -> bool:
    return ("぀" <= ch <= "ゟ") or ("゠" <= ch <= "ヿ")


def _katakana_to_hiragana(ch: str) -> str:
    return chr(ord(ch) - 0x60) if "゠" <= ch <= "ヿ" else ch


def _annotate_mixed(orig: str, hira: str) -> str:
    """
    Annotate a mixed kanji+kana morpheme by aligning kana characters in orig
    as anchors against the hiragana reading.

    Examples:
      "彼ら" / "かれら"     → "{彼|かれ}ら"
      "追いつい" / "おいつい" → "{追|お}いつい"
      "飛び込む" / "とびこむ" → "{飛|と}び{込|こ}む"

    Falls back to plain orig if alignment fails (e.g. katakana mismatch).
    This is safe because _splitAnnotation handles plain chars individually,
    so there is no risk of annotation straddling a word boundary.
    """
    result = ""
    hira_pos = 0
    kanji_buf = ""
    i = 0

    while i < len(orig):
        ch = orig[i]
        if _is_kana(ch):
            if kanji_buf:
                ch_h = _katakana_to_hiragana(ch)
                # Search from hira_pos+1 so the pending kanji group gets at
                # least one reading character. Without this, a word like 客引き
                # (reading きゃくひき) would find き at index 0 → empty reading.
                anchor = hira.find(ch_h, hira_pos + 1)
                if anchor == -1:
                    anchor = hira.find(ch_h, hira_pos)
                if anchor == -1:
                    return orig  # alignment failed — fall back
                kanji_reading = hira[hira_pos:anchor]
                result += "{" + kanji_buf + "|" + kanji_reading + "}"
                hira_pos = anchor
                kanji_buf = ""
            # Consume consecutive kana from orig, advancing hira in parallel.
            while i < len(orig) and _is_kana(orig[i]):
                ch_o = orig[i]
                ch_h = _katakana_to_hiragana(ch_o)
                if hira_pos >= len(hira) or hira[hira_pos] != ch_h:
                    return orig  # alignment failed
                result += ch_o
                hira_pos += 1
                i += 1
        else:
            kanji_buf += ch
            i += 1

    # Trailing kanji group (morpheme ends with kanji, e.g. "話し合う" → "は")
    if kanji_buf:
        kanji_reading = hira[hira_pos:]
        if kanji_reading:
            result += "{" + kanji_buf + "|" + kanji_reading + "}"
        else:
            result += kanji_buf

    return result


def _annotate(text: str) -> str:
    """Return text with kanji groups annotated as {kanji|reading}."""
    if not text:
        return ""
    out = ""
    for item in _kks.convert(text):
        orig: str = item["orig"]
        hira: str = item["hira"]
        has_kanji = any("一" <= c <= "鿿" for c in orig)
        if not has_kanji or not hira or hira == orig:
            out += orig
            continue
        has_kana = any(_is_kana(c) for c in orig)
        if has_kana:
            # Mixed kanji+kana morpheme: split at kana anchor points so each
            # kanji group gets its own {kanji|reading} annotation. This avoids
            # the old {whole-compound|reading} form that straddled word
            # boundaries in the fill-in-the-blank split.
            out += _annotate_mixed(orig, hira)
        else:
            out += "{" + orig + "|" + hira + "}"
    return out

TATOEBA_CACHE = "tools/tatoeba_cache"
TATOEBA_SENTENCES_URL = "https://downloads.tatoeba.org/exports/sentences.tar.bz2"
TATOEBA_LINKS_URL = "https://downloads.tatoeba.org/exports/links.tar.bz2"
MAX_SENTENCES_PER_WORD = 3
MAX_SENTENCE_LEN = 40
TARGET_LANGS = {"eng", "fra", "deu", "spa", "ita", "por", "rus"}
OUT_PATH = "manabi_do/assets/manabi_do_content.db"
LEVELS = [("n5", "N5"), ("n4", "N4"), ("n3", "N3"), ("n2", "N2"), ("n1", "N1")]


def create_tables(db: sqlite3.Connection) -> None:
    db.executescript("""
        CREATE TABLE kanjis (
            id          INTEGER PRIMARY KEY,
            character   TEXT NOT NULL,
            meaning     TEXT NOT NULL,
            on_reading  TEXT NOT NULL,
            kun_reading TEXT NOT NULL,
            jlpt_level  TEXT NOT NULL
        );

        CREATE TABLE vocabulary_entries (
            id             INTEGER PRIMARY KEY AUTOINCREMENT,
            word           TEXT NOT NULL,
            reading        TEXT NOT NULL,
            meaning        TEXT NOT NULL,
            jlpt_level     TEXT NOT NULL,
            part_of_speech TEXT NOT NULL,
            kanji_id       INTEGER REFERENCES kanjis(id)
        );

        CREATE TABLE kanji_translations (
            kanji_id INTEGER NOT NULL REFERENCES kanjis(id),
            locale   TEXT NOT NULL,
            meaning  TEXT NOT NULL,
            PRIMARY KEY (kanji_id, locale)
        );

        CREATE TABLE vocab_translations (
            vocab_id INTEGER NOT NULL REFERENCES vocabulary_entries(id),
            locale   TEXT NOT NULL,
            meaning  TEXT NOT NULL,
            PRIMARY KEY (vocab_id, locale)
        );

        CREATE TABLE kanas (
            id         INTEGER PRIMARY KEY AUTOINCREMENT,
            character  TEXT NOT NULL,
            romaji     TEXT NOT NULL,
            type       TEXT NOT NULL,
            row        TEXT NOT NULL,
            kana_group TEXT NOT NULL,
            slot       INTEGER NOT NULL
        );

        CREATE TABLE grammar_lessons (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            locale      TEXT NOT NULL,
            chapter     TEXT NOT NULL,
            title       TEXT NOT NULL,
            content_md  TEXT NOT NULL,
            order_index INTEGER NOT NULL,
            metadata    TEXT NOT NULL DEFAULT '{}'
        );

        CREATE TABLE exercises (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            locale      TEXT NOT NULL,
            type        TEXT NOT NULL,
            source      TEXT NOT NULL,
            source_id   INTEGER NOT NULL,
            prompt      TEXT NOT NULL,
            answer      TEXT NOT NULL,
            distractors TEXT NOT NULL DEFAULT '[]',
            lesson_id   INTEGER REFERENCES grammar_lessons(id)
        );

        CREATE TABLE progress_entries (
            id         INTEGER PRIMARY KEY AUTOINCREMENT,
            item_type  TEXT NOT NULL,
            item_id    INTEGER NOT NULL,
            is_known   INTEGER NOT NULL,
            toggled_at INTEGER NOT NULL,
            UNIQUE (item_type, item_id)
        );

        CREATE TABLE sentences (
            id               INTEGER PRIMARY KEY AUTOINCREMENT,
            japanese         TEXT NOT NULL,
            target_word      TEXT NOT NULL,
            vocab_id         INTEGER NOT NULL REFERENCES vocabulary_entries(id),
            furigana_before  TEXT,
            furigana_after   TEXT,
            furigana         TEXT
        );

        CREATE TABLE sentence_translations (
            sentence_id INTEGER NOT NULL REFERENCES sentences(id),
            locale      TEXT NOT NULL,
            translation TEXT NOT NULL,
            PRIMARY KEY (sentence_id, locale)
        );
    """)


def insert_kanji(db: sqlite3.Connection, slug: str, jlpt: str) -> int:
    path = f"content/kanji_{slug}.json"
    with open(path, encoding="utf-8") as f:
        entries = json.load(f)

    kanji_rows = []
    tr_rows = []
    for k in entries:
        kanji_id = k["id"]
        meanings = k["meanings"]
        on  = "、".join(k.get("on", []))
        kun = "、".join(k.get("kun", []))
        kanji_rows.append((kanji_id, k["character"], meanings.get("en", ""), on, kun, jlpt))
        for locale, meaning in meanings.items():
            tr_rows.append((kanji_id, locale, meaning))

    db.executemany(
        "INSERT INTO kanjis VALUES (?, ?, ?, ?, ?, ?)",
        kanji_rows,
    )
    db.executemany(
        "INSERT OR REPLACE INTO kanji_translations VALUES (?, ?, ?)",
        tr_rows,
    )
    return len(entries)


def insert_vocab(db: sqlite3.Connection, slug: str, jlpt: str) -> int:
    path = f"content/vocab_{slug}.json"
    with open(path, encoding="utf-8") as f:
        entries = json.load(f)

    for v in entries:
        meanings = v["meanings"]
        cur = db.execute(
            "INSERT INTO vocabulary_entries (word, reading, meaning, jlpt_level, part_of_speech, kanji_id) VALUES (?, ?, ?, ?, ?, ?)",
            (v["word"], v["reading"], meanings.get("en", ""), jlpt, v["pos"], v.get("kanjiId")),
        )
        vocab_id = cur.lastrowid
        db.executemany(
            "INSERT OR REPLACE INTO vocab_translations VALUES (?, ?, ?)",
            [(vocab_id, locale, meaning) for locale, meaning in meanings.items()],
        )

    return len(entries)


def insert_kana(db: sqlite3.Connection) -> int:
    path = "content/kana.json"
    with open(path, encoding="utf-8") as f:
        d = json.load(f)

    rows = []
    for type_ in ("hiragana", "katakana"):
        for kana_row in d[type_]:
            label = kana_row["label"]
            group = kana_row["group"]
            for slot, entry in enumerate(kana_row["entries"]):
                if entry is None:
                    continue
                rows.append((entry["kana"], entry["romaji"], type_, label, group, slot))

    db.executemany(
        "INSERT INTO kanas (character, romaji, type, row, kana_group, slot) VALUES (?, ?, ?, ?, ?, ?)",
        rows,
    )
    return len(rows)


def _download(url: str, dest: str) -> None:
    print(f"  Downloading {os.path.basename(dest)} …", end="", flush=True)
    urllib.request.urlretrieve(url, dest)
    size_mb = os.path.getsize(dest) / 1024 / 1024
    print(f" {size_mb:.0f} MB")


def _ensure_tatoeba() -> None:
    os.makedirs(TATOEBA_CACHE, exist_ok=True)
    sentences_path = os.path.join(TATOEBA_CACHE, "sentences.tar.bz2")
    links_path = os.path.join(TATOEBA_CACHE, "links.tar.bz2")
    if not os.path.exists(sentences_path):
        _download(TATOEBA_SENTENCES_URL, sentences_path)
    if not os.path.exists(links_path):
        _download(TATOEBA_LINKS_URL, links_path)


def _load_sentences() -> tuple[dict[int, str], dict[str, dict[int, str]]]:
    """Returns (jp_id→text, lang→{id→text}) for short JP sentences and all TARGET_LANGS."""
    path = os.path.join(TATOEBA_CACHE, "sentences.tar.bz2")
    jp: dict[int, str] = {}
    langs: dict[str, dict[int, str]] = {lang: {} for lang in TARGET_LANGS}
    with tarfile.open(path, "r:bz2") as tar:
        member = tar.getmember("sentences.csv")
        f = tar.extractfile(member)
        assert f is not None
        for raw in f:
            line = raw.decode("utf-8", errors="replace").rstrip("\n")
            parts = line.split("\t", 2)
            if len(parts) < 3:
                continue
            sid, lang, text = int(parts[0]), parts[1], parts[2]
            if lang == "jpn" and len(text) <= MAX_SENTENCE_LEN:
                jp[sid] = text
            elif lang in TARGET_LANGS:
                langs[lang][sid] = text
    return jp, langs


def _load_links(jp_ids: set[int], trans_ids: set[int]) -> dict[int, list[int]]:
    """Returns jp_id → [trans_id, …] for known jp/translation sentence ID pairs."""
    path = os.path.join(TATOEBA_CACHE, "links.tar.bz2")
    result: dict[int, list[int]] = defaultdict(list)
    with tarfile.open(path, "r:bz2") as tar:
        member = tar.getmember("links.csv")
        f = tar.extractfile(member)
        assert f is not None
        for raw in f:
            parts = raw.decode("utf-8", errors="replace").rstrip("\n").split("\t")
            if len(parts) < 2:
                continue
            a, b = int(parts[0]), int(parts[1])
            if a in jp_ids and b in trans_ids:
                result[a].append(b)
    return result


def populate_sentences(db: sqlite3.Connection) -> int:
    _ensure_tatoeba()

    print("  Loading Tatoeba sentences…", flush=True)
    jp_sents, lang_sents = _load_sentences()
    jp_ids = set(jp_sents.keys())
    all_trans_ids: set[int] = set()
    for sents in lang_sents.values():
        all_trans_ids.update(sents.keys())

    # Build reverse lookup: translation sentence ID → language code
    trans_lang: dict[int, str] = {}
    for lang, sents in lang_sents.items():
        for sid in sents:
            trans_lang[sid] = lang

    print("  Loading Tatoeba links…", flush=True)
    links = _load_links(jp_ids, all_trans_ids)

    vocab_rows = db.execute(
        "SELECT id, word FROM vocabulary_entries ORDER BY jlpt_level"
    ).fetchall()

    total = 0
    for vocab_id, word in vocab_rows:
        count = 0
        matched: list[tuple[int, str]] = [
            (sid, text)
            for sid, text in jp_sents.items()
            if word in text
        ]
        matched.sort(key=lambda p: len(p[1]))
        for sid, jp_text in matched:
            if count >= MAX_SENTENCES_PER_WORD:
                break
            linked_ids = links.get(sid, [])
            if not linked_ids:
                continue

            # Collect one translation per language from linked sentence IDs
            translations: dict[str, str] = {}
            for tid in linked_ids:
                lang = trans_lang.get(tid)
                if lang and lang not in translations:
                    text = lang_sents[lang].get(tid)
                    if text:
                        translations[lang] = text

            # Require at least an English translation
            if "eng" not in translations:
                continue

            furigana = _annotate(jp_text)
            cur = db.execute(
                "INSERT INTO sentences (japanese, target_word, vocab_id, furigana) VALUES (?, ?, ?, ?)",
                (jp_text, word, vocab_id, furigana),
            )
            sentence_id = cur.lastrowid
            db.executemany(
                "INSERT INTO sentence_translations (sentence_id, locale, translation) VALUES (?, ?, ?)",
                [(sentence_id, lang, text) for lang, text in translations.items()],
            )
            total += 1
            count += 1

    return total


def main() -> None:
    if os.path.exists(OUT_PATH):
        os.remove(OUT_PATH)

    db = sqlite3.connect(OUT_PATH)
    db.execute("PRAGMA journal_mode=WAL")
    db.execute("PRAGMA foreign_keys=ON")

    create_tables(db)
    db.execute(f"PRAGMA user_version = {SCHEMA_VERSION}")

    for slug, jlpt in LEVELS:
        print(f"Inserting {jlpt} kanji… ", end="", flush=True)
        n = insert_kanji(db, slug, jlpt)
        print(f"{n} entries")

    for slug, jlpt in LEVELS:
        print(f"Inserting {jlpt} vocab… ", end="", flush=True)
        n = insert_vocab(db, slug, jlpt)
        print(f"{n} entries")

    print("Inserting kana… ", end="", flush=True)
    n = insert_kana(db)
    print(f"{n} entries")

    if "--no-sentences" not in sys.argv:
        print("Inserting sentences (Tatoeba)…")
        n = populate_sentences(db)
        print(f"  {n} sentences total")
    else:
        print("Skipping sentences (--no-sentences)")

    db.commit()
    db.close()

    size_kb = os.path.getsize(OUT_PATH) // 1024
    print(f"\nBuilt {OUT_PATH} ({size_kb} KB)")


if __name__ == "__main__":
    main()
