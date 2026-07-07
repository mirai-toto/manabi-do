# Refactoring Goals

Priority-ordered list of structural improvements for the codebase. Each goal is independent but they build on each other — fixing separation of concerns first makes theming and i18n easier to apply consistently.

---

## 1. Separation of Concerns

**Rule:** Screens are navigation shells. Logic lives in services. Data access lives in repositories. UI composition lives in widgets.

### Layering model

| Layer | Responsibility | Should NOT contain |
|---|---|---|
| **Screen** | Compose widgets, wire providers, handle navigation | Business logic, direct DB calls, raw data transformation |
| **Notifier / Provider** | State derivation, orchestration, async actions | UI concerns, BuildContext, navigation |
| **Service** | Domain logic, SRS scheduling, session building | DB queries, UI concerns |
| **Repository** | DB/API access, serialization, caching | Business rules, UI concerns |
| **Widget** | Render a specific UI element | Logic beyond display decisions |

### Specific items

#### ✅ Done
- `practice_session_screen.dart` — extracted queue state, index, score counters, retry logic and SRS call into `PracticeSessionNotifier`
- `vocabulary_screen.dart` — `allLoaded`/`sum` loop replaced by `vocabTotalCountProvider`
- `vocab_level_view.dart` — `learnedCount` SRS filter replaced by `vocabGroupLearnedCountProvider`

#### Screens with inline business logic
- ✅ `kanji_detail_screen.dart` (`_KanjiSrsSection`) — converted to `ConsumerWidget` watching `kanjiSrsCardsProvider`; eliminated `initState`, `_load`, and local state

#### Services that mix too many concerns
- ✅ `vocab_session_service.dart` — monolithic `buildQueue` split into `_buildFlashcardItems`, `_buildMcqItems`, `_buildSentenceItems`, `_buildMixedItems`
- ✅ `kanji_session_service.dart` — `buildQueue` dispatch loop split into `_buildFlashcardItem`, `_buildDrawingItem`, `_buildMcqItem`
- ✅ `srs_service.dart` — `applyRating(Card?, Rating) -> Card` extracted as a pure function; `PracticeSessionNotifier` now uses it instead of duplicating the scheduler logic

#### Missing repository layer
- `AppDatabase` (Drift) already exposes domain-level methods (`getVocabByLevel`, `watchKanjiDueCount`, `getVocabSrsSession`, etc.) — it effectively IS the repository. Wrapping it in a second layer would be ~31 mechanical forwarding lines with no behaviour change. Deferred until unit testing is introduced; mock repositories become valuable then.

---

## 2. Theme Compliance

**Rule:** No hardcoded colors or sizes anywhere in widget code. Every value must come from `AppTokens` (colors) or `AppDimens` (sizes/spacing).

### Colors
- All colors via `context.tokens.*` — never `Color(0xFF...)` or `Colors.*` in widgets (exception: `Colors.white` / `Colors.transparent` where semantically correct)
- Level accent colors via `levelColor(level)` — never hardcoded per-level hex values in widget files

### Sizes & spacing
- All padding, margin, gap via `AppDimens.*` constants — never raw `8.0`, `16.0`, etc.
- Font sizes via `AppTextStyles.*` — never `.copyWith(fontSize: 14)` unless overriding for a documented reason
- Border radii via `AppDimens.radius*` — never raw values

### Specific items
- ✅ `Color(0xFF795548)` for "basics" grammar level — added `'basics'` to `levelColor()`, removed inline hardcodes from `grammar_chapter_list.dart` and `grammar_screen.dart`
- ✅ Raw `SizedBox(height: 2/4)` and `EdgeInsets.all(4)` across 8 files — replaced with `AppDimens.spaceXxs` / `AppDimens.spaceXs`
- Remaining one-offs (acceptable): emoji font sizes (`fontSize: 28/22` with `fontFamily: NotoColorEmoji`), `fontSize: 26` for sentence text in `sentence_cloze_card.dart`, `SizedBox` values of 6/10/12 with no matching constant, `Color(0x33ffffff)` white overlay in `kanji_hero.dart`
- Constructor default `Color(0xFF795548)` in `grammar_lesson_screen.dart` — Dart const constraint prevents using `levelColor()` as a default; acceptable since callers always pass explicitly

---

## 3. Internationalization (i18n)

**Rule:** Every user-visible UI string must go through the l10n system (`context.l10n.*`). Grammar lesson content is exempt but must be explicitly flagged.

### Current state
- App UI strings: partially covered via `AppLocalizations`
- Grammar lesson content (JSON blocks): English-only by design for now — prose, examples, notes are hardcoded in JSON files
- Some UI labels and error messages are still hardcoded strings in widget files

### Specific items
- Audit all widget/screen files for hardcoded UI strings not yet in `.arb` files
- Define an explicit policy for grammar content: document that JSON lesson files are content-only and not expected to go through the l10n pipeline (at least for v1)
- Plan a future path for grammar content localization: either per-locale JSON files (`N5_fr.json`) or a translation layer over the block renderer

---

## 4. Code Simplification

**Rule:** Delete complexity that isn't earning its keep. Prefer the obvious path.

### Principles
- If a widget's `build()` is longer than ~60 lines, it probably contains an unnamed sub-widget
- If a provider does data fetching AND state transformation AND side effects, split it
- Dead code (unused widgets, unreachable branches, commented-out blocks) gets deleted
- No wrapper classes that add zero behavior

### Specific items
- `vocab_session_service.dart` and `kanji_session_service.dart` — overlapping structure; consolidate shared logic into a base or a shared utility once they are split in goal #1
- `writing_session_provider.dart` — DB queries + shuffling + locale lookups + transforms in one provider; split by concern
- Some utility functions are defined locally in files when they belong in a shared util module
- Older provider files mix concerns that would be cleaner as separate, focused providers

---

## Approach

Work through these one targeted change at a time — not a big-bang rewrite. Each PR should:
- Be focused on one layer or one screen
- Pass the analyzer and all existing tests
- Not be mixed with feature work

Track progress by checking off items in the lists above as they are completed.
