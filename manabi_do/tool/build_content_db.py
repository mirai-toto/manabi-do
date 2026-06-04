"""
Generates assets/manabi_do_content.db from the JSON source files.

Run from the project root:
    python3 tool/build_content_db.py

Commit the output file. The app copies it on first install — no runtime
parsing or seeding loop.

To add multilingual translations, run tool/gen_translations.dart first,
then re-run this script.
"""

import json
import sqlite3
import os

SCHEMA_VERSION = 7
OUT_PATH = "assets/manabi_do_content.db"
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
    path = "assets/data/kana.json"
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

    db.commit()
    db.close()

    size_kb = os.path.getsize(OUT_PATH) // 1024
    print(f"\nBuilt {OUT_PATH} ({size_kb} KB)")


if __name__ == "__main__":
    main()
