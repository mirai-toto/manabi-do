# Content Pipeline Refactor

## Goal

Consolidate all source content and tooling at the monorepo root, outside the Flutter project. The Flutter app (`manabi_do/`) becomes purely app code + compiled artifacts. This also lays the foundation for the grammar content pipeline and future user-generated lessons.

---

## Current State

```
manabi-do/
  tools/                        # some tools (download_kanjivg.py, generate_vocab_seed.py)
  manabi_do/
    tool/                       # other tools (build_content_db.py, gen_translations.*)
    content/                    # source JSON (kanji, vocab)
    assets/grammar/             # grammar lesson JSON (loaded directly by the app)
    assets/manabi_do_content.db # compiled output
```

Problems:

- Tools split across two locations (`tools/` and `manabi_do/tool/`)
- Source content (`content/`) lives inside the Flutter project
- Grammar lessons bypass the build pipeline entirely (loaded raw from assets)
- No path for user-generated content

---

## Target State

```
manabi-do/
  content/                      # ALL source content
    kanji/                      # (moved from manabi_do/content/)
    vocab/                      # (moved from manabi_do/content/)
    grammar/
      levels.json
      basics/
        index.json
        three-scripts.json
        sov-word-order.json
        ...
      N5/
        index.json
        verbs/
          index.json
          verb-groups.json
          masu-form.json
          ...
  tools/                        # ALL tools (merged)
    build_content_db.py         # (moved from manabi_do/tool/, extended for grammar)
    generate_vocab_seed.py      # (moved from manabi_do/tool/ or tools/)
    download_kanjivg.py         # (already here)
    gen_translations.py         # (moved from manabi_do/tool/)
    gen_translations.dart       # (moved from manabi_do/tool/)
  manabi_do/
    assets/                     # compiled output only
      manabi_do_content.db      # includes grammar_lessons table
      kanji_svg/
      ...
    lib/                        # Flutter app code only
```

---

## Grammar Content Format

### `content/grammar/levels.json`

Top-level registry. Loaded by the app to display the level selector screen.

```json
[
  {
    "id": "basics",
    "name": "Japanese Basics",
    "color": "#795548",
    "difficulty": { "value": 1, "total": 5 },
    "path": "basics/index.json"
  },
  {
    "id": "N5",
    "name": "N5",
    "color": "#4CAF50",
    "difficulty": { "value": 3, "total": 5 },
    "path": "N5/index.json"
  }
]
```

`difficulty.total` is conventionally 5 but not enforced — content authors can override.

### `index.json` — chapter or lesson list (recursive)

A chapter index lists either sub-chapters or lessons. Can nest to any depth.

```json
{
  "type": "chapters",
  "items": [
    { "title": "Verbs", "path": "N5/verbs/index.json" },
    { "title": "Adjectives", "path": "N5/adjectives/index.json" }
  ]
}
```

```json
{
  "type": "lessons",
  "items": [
    { "title": "Verb Groups", "path": "N5/verbs/verb-groups.json" },
    { "title": "Masu Form", "path": "N5/verbs/masu-form.json" }
  ]
}
```

All `path` values are relative to `content/grammar/`.

### Lesson file — standalone

```json
{
  "id": "verb-groups",
  "title": "Verb Groups",
  "blocks": [
    {
      "type": "text",
      "content": "Every Japanese verb belongs to one of three groups..."
    },
    {
      "type": "vocab_table",
      "columns": ["japanese", "romaji", "english", "group"],
      "rows": []
    }
  ]
}
```

No knowledge of its position in the hierarchy. `title` is kept for the lesson screen header.

---

## Build Pipeline

`build_content_db.py` gets a grammar step:

1. Read `content/grammar/levels.json`
2. Walk the index tree for each level (recursively follow `index.json` files)
3. Load each lesson file
4. Write rows into the `grammar_lessons` table in `manabi_do_content.db`

The `grammar_lessons` table schema needs updating — replace `content_md` with `blocks_json` (the blocks array serialized as JSON) and add `level`, `path` columns for navigation.

---

## App-Side Changes

Once grammar content comes from the database:

- Remove `grammarJsonChaptersProvider` and `grammarChaptersProvider` from `grammar_provider.dart`
- New Drift queries on `grammar_lessons` replacing the asset-based providers
- `levels.json` can either be compiled into the DB (a `grammar_levels` table) or kept as a single bundled asset — TBD
- `GrammarChapter`, `GrammarLesson`, `GrammarBlock` models stay; `GrammarSection` added for recursive navigation

---

## Phases

1. **Reorganize** — move `manabi_do/content/` → `content/`, merge `manabi_do/tool/` into `tools/`. Update `build_content_db.py` paths. No app changes.
2. **Grammar pipeline** — add grammar step to `build_content_db.py`, update `grammar_lessons` schema, migrate existing `basics/` and `N5/` content to the new source format.
3. **App reads from DB** — replace asset-based grammar providers with Drift queries, add recursive navigation support.
4. **User-generated content** — TBD (user lessons stored in `manabi.db`, same reader code path).
