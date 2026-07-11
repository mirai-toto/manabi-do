# Grammar Lesson Style Guide

This document defines the voice, structure, and quality bar for all grammar lesson content in Manabi Do. Content is authored in Markdown (`.md` files as drafts) and then expressed as JSON block files (`.json`) for the app. See `docs/04_grammar_lesson_widgets.md` for the block spec.

---

## Who the Lessons Are For

Learners with a basic Japanese foundation — they know all kana, have some kanji exposure, and have basic vocabulary. The app does not target absolute beginners. Lessons should not over-explain phonetics or script basics (except in the dedicated Basics section), but they also should not assume the learner already knows the grammar point being introduced.

---

## Teaching Voice

**Pattern + depth.** Lessons should be scannable like a reference — structured, predictable — but with enough prose to explain *why* a form exists, not just *how* it works.

The tone is that of a knowledgeable, direct teacher: no hand-holding or cheerful filler, but also not a dry list of facts. Every section should feel like it's teaching, not just documenting.

**What this means in practice:**

- Open each section with 2–3 sentences of prose that frame the grammar point: why it exists, what it signals, what it helps the learner do
- Explain the *why* behind a form when it's meaningful (e.g. "ので sounds softer because it presents the reason as objective, not personal assertion")
- Call out common mistakes explicitly — learners make predictable errors; name them
- Add register notes (polite / casual / formal) where relevant so learners know when each form is appropriate
- Keep cultural context light — register and real-usage notes yes, cultural detours no

---

## Lesson Granularity

One grammar point per section. Do not pack multiple grammar points into one section just because they're thematically related.

**Structure hierarchy:**

```
## Chapter  (thematic grouping, e.g. "Verbs", "Adjectives")
└── ### Section  (one grammar point each)
```

Each `###` section is the unit that will become a standalone lesson in the JSON block format.

---

## Section Structure

Every `###` section should follow this order. Steps are not all always required — a simple pattern with no common mistakes needs no mistake callout — but the sequence should not be broken.

### 1. Opening prose

2–3 sentences that answer: *What is this form for? Why does it exist? What does it signal?*

Do not start with "This pattern is used to…" — that's circular. Start from the learner's perspective or the function of the form.

**Bad:**
> ～ます is used to conjugate verbs politely.

**Good:**
> The ます form is how you speak politely in Japanese. It's the default for conversations with people you don't know well, in formal situations, and in service environments. It covers both present habit and future intention — Japanese does not separate these with different tenses.

### 2. Pattern block

A fenced code block for the formation rule. Clean, monospaced, left-aligned. Show every meaningful variant (affirmative, negative, past, etc.) where they fit on a single code block.

```
[Verb stem] + ます       (affirmative)
[Verb stem] + ません     (negative)
```

For irregular forms or exceptions, show the exception inside the block with a parenthetical comment.

### 3. Example table

A markdown table with columns: Japanese | Romaji | English.

- Minimum **4 examples**, aim for **5–6** for common patterns
- Vary contexts — do not repeat the same setting (school/food/travel) four times in a row
- Use natural, memorable sentences over textbook staples (食べます / 飲みます / 行きます every time is not a standard, it's a crutch)
- Japanese column should include kanji where appropriate for the level

### 4. Notes

Use `>` blockquotes for notes. A section can have multiple notes.

Each note should cover one of:
- **Register** — when to use this form, what situations call for it, how it reads to a native speaker
- **Common mistake** — what learners typically get wrong with this form; be specific, give a counter-example
- **Contrast** — how this form differs from a related one that learners might confuse it with

Label notes clearly when the type matters:

```
> **Note:** …
> **Common mistake:** …
> **Register:** …
```

---

## What "Good" Looks Like

### Before (old style)

> **Group 1 — Godan (五段):** ends in any う-row sound. The stem changes across conjugations.
>
> | Japanese | Romaji | English | Group |
> |---|---|---|---|
> | 書く | kaku | to write | 1 |
> | 食べる | taberu | to eat | 2 |
>
> > **Note:** Some る-ending verbs are Group 1. When in doubt, check a dictionary.

This is a memo. It states facts without teaching.

### After (target style)

> Every Japanese verb belongs to one of three groups. The group determines *every* conjugation rule that applies to it — get the group right and the rest is predictable.
>
> **Group 1 (Godan)** ends in any う-column sound — く, ぐ, す, つ, ぬ, ぶ, む, う, or る*. The stem shifts shape across different forms, which feels inconsistent at first but follows consistent phonetic patterns.
>
> **Group 2 (Ichidan)** always ends in る with an い or え vowel sound immediately before it. The stem never changes — you only ever remove the る. Nothing else.
>
> **Group 3** is just する and くる. Both are fully irregular and must be memorised.
>
> | Japanese | Romaji | English | Group |
> |---|---|---|---|
> | 書く | kaku | to write | 1 |
> | 話す | hanasu | to speak | 1 |
> | 帰る | kaeru | to return home | 1 *(looks like Group 2)* |
> | 食べる | taberu | to eat | 2 |
> | 見る | miru | to see | 2 |
> | する | suru | to do | 3 |
>
> > **Common mistake:** る-ending Group 1 verbs look identical to Group 2 in dictionary form — 帰る, 走る, 知る, 切る are all Group 1. There is no reliable visual test. When in doubt, check a dictionary entry — it will label the group.

The difference: the second version teaches. It explains what the groups mean for the learner, frames the tricky case up front, and gives concrete examples of the exact trap that causes mistakes.

---

## Things to Avoid

| Avoid | Why |
|---|---|
| Opening with "This pattern is used to…" | Circular and uninformative |
| Repeating 食べます / 飲みます / 書きます as the default examples for everything | Lazy; learners see the same three verbs in every table |
| Burying the common mistake at the end of a note | Lead with it — it's the most useful part |
| Packing multiple grammar points into one `###` section | Makes future JSON conversion harder and lessons harder to navigate |
| Over-explaining script or phonetics in grammar sections | Covered in Basics; don't repeat it |
| Using ですます in the plain-form explanation box | Pattern blocks always show plain form first |

---

## Adding a New Level (N4–N1)

When writing content for a new JLPT level:

1. Each `##` chapter is a thematic grouping (e.g. "Conditionals", "Passive Voice")
2. Each `###` section is one grammar point — what will become one lesson
3. Follow the section structure above for every `###` section
4. Cross-reference earlier levels where a new form builds on or contrasts with something already learned (e.g. "This is similar to ～てから from N5, but...")
5. N4+ content can assume the learner knows all N5 grammar — no need to re-explain particles or て-form

---

## Markdown to JSON Mapping

`basics` and `N5` are already migrated. When writing content for a new level, author it in Markdown first, then convert to JSON blocks. Each `###` section maps to one `lesson` object, and the internal content maps to blocks as follows:

| Markdown element | JSON block type |
|---|---|
| Opening prose paragraph | `text` |
| `###` sub-heading within a section | `section_title` |
| Fenced code block | `pattern` |
| `> Note:` / `> Common mistake:` | `note` |
| Markdown table (examples) | `example_table` |
| Markdown table (vocab/kanji list) | `vocab_table` |
| Conjugation paradigm table | `conjugation_table` |
| Two-column contrast | `comparison` |
| Bullet / numbered list | `list` |
| `---` horizontal rule | `divider` |
