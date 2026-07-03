# Grammar Lesson — Content Blocks & Widget Spec

This document defines every block type that can appear in a grammar lesson JSON file.
Each block is a JSON object with a required `type` field. The app renders each type
with a dedicated Flutter widget. No HTML or markdown is used in lesson content.

---

## File Structure

Lessons are defined in JSON. The top-level structure for a JLPT level is:

```json
{
  "level": "N5",
  "chapters": [
    {
      "id": "verbs",
      "title": "Verbs",
      "lessons": [
        {
          "id": "verb-groups",
          "title": "Verb Groups",
          "blocks": [ ... ]
        },
        {
          "id": "masu-form",
          "title": "Polite Present / Future — ～ます",
          "blocks": [ ... ]
        }
      ]
    }
  ]
}
```

### Hierarchy

```
Level  (e.g. N5)
└── Chapter  (e.g. "Verbs")
    └── Lesson  (e.g. "Polite Present / Future — ～ます")
        └── Block[]  (ordered list of content blocks)
```

A lesson is the smallest navigable unit — the screen the user reads.

---

## Block Types

---

### `text`

Plain explanatory prose. Supports inline **bold** and *italic* via simple markers
(parsed by the app, not a markdown engine). No headings, no nesting.

```json
{
  "type": "text",
  "content": "Japanese verbs conjugate based on their group. Identifying a verb's group determines how every other form is built."
}
```

**Widget:** `TextBlock` — renders as body text with the app's standard font and colour.

---

### `section_title`

A visual sub-heading within a lesson. Used to separate named sub-topics.

```json
{
  "type": "section_title",
  "content": "Verb Groups"
}
```

**Widget:** `SectionTitleBlock` — larger weight text with a left accent bar using the level colour.

---

### `pattern`

Displays a grammar pattern formula — the structural template for a grammar point.
Monospaced or visually distinct from body text. Supports multiple lines.

```json
{
  "type": "pattern",
  "lines": [
    "[Verb stem] + ます       (affirmative)",
    "[Verb stem] + ません     (negative)"
  ]
}
```

**Widget:** `PatternBlock` — pill-shaped card with a subtle background tint (level colour at low
opacity), monospaced font, left-aligned. Each line on its own row.

---

### `note`

A callout for important nuance, exceptions, or tips. Visually distinct from body text
so it stands out without interrupting flow.

```json
{
  "type": "note",
  "content": "～ます covers both present habits and future actions — Japanese does not separate these."
}
```

**Widget:** `NoteBlock` — left border in amber/warning colour, slightly inset background,
italic body text, small info icon leading.

---

### `example_table`

A table of Japanese example sentences with romaji and English translation.
This is the most common block — almost every lesson section has one.

```json
{
  "type": "example_table",
  "columns": ["japanese", "romaji", "english"],
  "rows": [
    {
      "japanese": "毎日勉強します。",
      "romaji": "Mainichi benkyō shimasu.",
      "english": "I study every day."
    },
    {
      "japanese": "肉を食べません。",
      "romaji": "Niku wo tabemasen.",
      "english": "I don't eat meat."
    }
  ]
}
```

`columns` controls which columns appear and their order. Allowed values:
`japanese`, `romaji`, `english`. All three are optional — some tables may omit romaji.

**Widget:** `ExampleTableBlock` — clean table with alternating row backgrounds.
Japanese column uses the Japanese font. Header row uses the level colour at low opacity.

---

### `vocab_table`

A table for vocabulary or kanji listings — typically with more columns than example_table
(e.g. kanji, reading, meaning, group/counter).

```json
{
  "type": "vocab_table",
  "columns": ["japanese", "romaji", "english", "group"],
  "rows": [
    { "japanese": "書く", "romaji": "kaku", "english": "to write", "group": "1" },
    { "japanese": "食べる", "romaji": "taberu", "english": "to eat", "group": "2" }
  ]
}
```

`columns` is an ordered list of column keys. Any string key is valid — the header
displays the key capitalised. This keeps the block flexible for counters, pitch, etc.

**Widget:** `VocabTableBlock` — same visual treatment as `example_table` but column widths
auto-sized. Japanese column uses Japanese font.

---

### `conjugation_table`

A structured table specifically for showing verb/adjective conjugation paradigms.
Rows are conjugation forms; a single target word is shown across all forms.

```json
{
  "type": "conjugation_table",
  "label": "い-Adjectives — 高い",
  "rows": [
    { "form": "Present",          "japanese": "高い",       "romaji": "takai",        "english": "is expensive / tall" },
    { "form": "Negative",         "japanese": "高くない",   "romaji": "takakunai",    "english": "is not expensive" },
    { "form": "Past",             "japanese": "高かった",   "romaji": "takakatta",    "english": "was expensive" },
    { "form": "Past negative",    "japanese": "高くなかった","romaji": "takakunakatta","english": "was not expensive" }
  ]
}
```

**Widget:** `ConjugationTableBlock` — first column (`form`) is bold label; subsequent columns
match `example_table` styling. `label` appears above the table as a sub-caption.

---

### `comparison`

Side-by-side display of two grammar points or sentence patterns to highlight contrast.
Used for "A vs B" explanations (e.g. に vs で, から vs ので).

```json
{
  "type": "comparison",
  "left": {
    "label": "から",
    "description": "Subjective, direct, casual",
    "example_jp": "疲れたから、休みます。",
    "example_en": "I'm resting because I'm tired."
  },
  "right": {
    "label": "ので",
    "description": "Objective, softer, more polite",
    "example_jp": "雨が降っているので、家にいます。",
    "example_en": "I'm staying home because it's raining."
  }
}
```

**Widget:** `ComparisonBlock` — two cards side by side (or stacked on narrow screens).
Each card has a coloured label at top, description text, then the example sentence.

---

### `divider`

A visual separator between major sub-sections within a long lesson.

```json
{
  "type": "divider"
}
```

**Widget:** `DividerBlock` — thin horizontal line, same as a section break. No parameters.

---

## Block Rendering Order

Blocks are rendered top-to-bottom in the order they appear in the `blocks` array.
The lesson screen is a scrollable column of these widgets with consistent vertical spacing.

---

## What Is NOT a Block

The following are **not** block types — they are lesson metadata:

- `level` — the JLPT level (N5–N1), set at file level
- `chapter.title` — the chapter name, shown in the chapter list
- `lesson.title` — the lesson name, shown in the lesson AppBar

Grammar point tags and SRS anchors are out of scope for now.

---

## Adding a New Block Type

1. Add the type name and JSON schema to this document
2. Create the Flutter widget in `lib/presentation/widgets/grammar/blocks/`
3. Register it in the block renderer switch
4. Add at least one example to a lesson file

New block types must be ignored gracefully by older app versions (render nothing,
no crash) — the renderer should have a default no-op case.
