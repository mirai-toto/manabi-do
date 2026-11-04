# Database

## Local files

| File                                    | Purpose                                                     |
| --------------------------------------- | ----------------------------------------------------------- |
| `manabi_do/assets/manabi_do_content.db` | Main content DB — kanji, vocabulary, sentences, all translations |

The content DB is bundled as a Flutter asset. On first launch it is copied to a platform-specific directory and used as the live SQLite database:

- **Linux debug** — repo root (located via `.git` detection)
- **Linux release** — `~/.local/share/<app>/` (XDG application support directory)
- **All other platforms** — `getApplicationDocumentsDirectory()`

Edits to the asset file only affect fresh installs/reinstalls; existing installs carry their own on-device copy. If the bundled version marker changes, SRS progress is migrated automatically before the old DB is replaced.

## Schema

The schema has a single source of truth: **`manabi_do/lib/data/database/schema.drift`**.

Two very different consumers read that one file:

- **drift** generates the Dart table classes and row types from it
- **`pipeline/build_content_db.py`** in [mirai-toto/manabi-content](https://github.com/mirai-toto/manabi-content) executes the same statements when building the shipped content DB

Keep it to plain `CREATE TABLE`. Only two drift-isms are tolerated, and both are translated for the Python side: a trailing `) AS RowName` naming the generated row class, and `DATETIME` / `BOOLEAN`, which drift stores as `INTEGER`.

The two consumers live in different repositories, so nothing here catches them diverging. The content repo vendors a copy of this file under `schema/` and `pipeline/check_schema.py` compares the two, but that check runs there, not in this repo. After a schema change: bump `schemaVersion`, copy this file over the content repo's `schema/content.drift`, update its `schema/version.txt`, and cut a release whose tag carries the new schema number.

### Changing the schema

1. Edit `schema.drift`
2. Bump `schemaVersion` in `app_database.dart`
3. `dart run drift_dev schema dump lib/data/database/app_database.dart drift_schemas/`
4. `dart run drift_dev schema steps drift_schemas/ lib/data/database/schema_versions.dart`
5. Fill in the generated `fromNToN+1` case

`drift_schemas/` holds the frozen snapshot per version and feeds step 4, so it stays under version control.

You do **not** need to rebuild the asset for a schema change — `stepByStep` migrates it forward on open.

### Two mechanisms, deliberately separate

| change | mechanism |
|---|---|
| **schema** — a column, a table | a `stepByStep` case in `schema_versions.dart`. No asset rebuild. |
| **content** — new lessons, new sentences | cut a content release, repin `manabi_do/content.lock`. `user_data_preservation.dart` carries progress across the swap. |

Upgrades are generated rather than hand-written. Each step receives the schema **frozen at that version**, so editing `schema.drift` later cannot change what an old step means. That is what the previous `if (from < N)` chain could not do — it referenced current definitions, so old steps silently changed meaning and needed `try/catch` to survive.

v22 is the baseline. The steps since are in `app_database.dart`: 24 dropped the
JLPT columns for measured ones, 26 renamed the coverage band to the vocabulary
level, 27 added `vocabulary_senses`, and 28 dropped `vocabulary_translations`.


---

## What is in the content database

Not documented here. The tables are built by
[mirai-toto/manabi-content](https://github.com/mirai-toto/manabi-content) from
`schema/content.drift`, a copy of the `schema.drift` above, and that repo's
README describes what each one holds and how the figures are arrived at.

This file used to carry a copy: the table shapes, a data-source table, word and
sentence counts per JLPT level, and translation coverage percentages. All of it
was transcribed by hand from a build, and all of it was wrong within a few
releases — it still named a vocabulary source retired at schema 24, and counted
sentences by a JLPT level the vocabulary no longer has. A hand-copied figure
has no way to stay true.

| Looking for | Read |
|---|---|
| What a source is, its licence, the credit it is owed | `ATTRIBUTION.md` in the content repo — generated from a registry, and CI fails when it is stale |
| Which tables exist and what they hold | `schema/content.drift` in the content repo |
| Word counts, level sizes, coverage, translation reach | that repo's `README.md`, which the build's own output backs |

## User progress (written at runtime)

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

## Content storage and recoverability

None of the content lives in this repository any more. The compiled database is
a release asset, and everything it was built from lives in
[mirai-toto/manabi-content](https://github.com/mirai-toto/manabi-content).

| Content | In the DB | Recovery |
|---|---|---|
| Kanji characters, readings, meanings | `kanjis` | fetch the release, or rebuild from the content repo's committed JSON |
| Kanji stroke order SVGs | `kanjis.svg` | same; the 2,211 SVGs are committed there |
| Kana | `kanas` | same; static |
| Vocabulary words, readings, POS | `vocabulary_entries` | same |
| Vocabulary meanings, per sense | `vocabulary_senses` | same |
| Example sentences | `sentences` | re-download Tatoeba and rebuild |
| Sentence translations | `sentence_translations` | same |
| Grammar lessons | `grammar_lessons` | same; hand-authored and committed there |

**Two things worth knowing.** Losing the local asset costs nothing — run
`scripts/content/fetch_content.sh`. The asset is gitignored, so `git clean -fdX`
removes it.

Sentences are the one content type with no committed fallback anywhere: they
exist only in a built database and in the Tatoeba download, which is itself
re-fetched live on every build. So two builds of the same commit can differ.
Every other type is reproducible from committed files in the content repo.

