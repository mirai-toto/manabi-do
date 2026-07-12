# Refactoring Goals

Priority-ordered list of structural improvements for the codebase. Each goal is independent but they build on each other — fixing separation of concerns first makes theming and i18n easier to apply consistently.

---

## 1. Separation of Concerns ✅

**Rule:** Screens are navigation shells. Logic lives in services. Data access lives in repositories. UI composition lives in widgets.

### Layering model

| Layer                   | Responsibility                                     | Should NOT contain                                       |
| ----------------------- | -------------------------------------------------- | -------------------------------------------------------- |
| **Screen**              | Compose widgets, wire providers, handle navigation | Business logic, direct DB calls, raw data transformation |
| **Notifier / Provider** | State derivation, orchestration, async actions     | UI concerns, BuildContext, navigation                    |
| **Service**             | Domain logic, SRS scheduling, session building     | DB queries, UI concerns                                  |
| **Repository**          | DB/API access, serialization, caching              | Business rules, UI concerns                              |
| **Widget**              | Render a specific UI element                       | Logic beyond display decisions                           |

- ✅ `practice_session_screen.dart` — extracted queue state, index, score counters, retry logic and SRS call into `PracticeSessionNotifier`
- ✅ `vocabulary_screen.dart` — `allLoaded`/`sum` loop replaced by `vocabTotalCountProvider`
- ✅ `vocab_level_view.dart` — `learnedCount` SRS filter replaced by `vocabGroupLearnedCountProvider`
- ✅ `kanji_detail_screen.dart` (`_KanjiSrsSection`) — converted to `ConsumerWidget` watching `kanjiSrsCardsProvider`; eliminated `initState`, `_load`, and local state
- ✅ `vocab_session_service.dart` — monolithic `buildQueue` split into `_buildFlashcardItems`, `_buildMcqItems`, `_buildSentenceItems`, `_buildMixedItems`
- ✅ `kanji_session_service.dart` — `buildQueue` dispatch loop split into `_buildFlashcardItem`, `_buildDrawingItem`, `_buildMcqItem`
- ✅ `srs_service.dart` — `applyRating(Card?, Rating) -> Card` extracted as a pure function; `PracticeSessionNotifier` now uses it instead of duplicating the scheduler logic

**Repository layer:** `AppDatabase` (Drift) already exposes domain-level methods and effectively IS the repository. A wrapper layer adds no behaviour. Deferred until unit testing is introduced.

---

## 2. Theme Compliance ✅

**Rule:** No hardcoded colors or sizes anywhere in widget code. Every value must come from `AppTokens` (colors) or `AppDimens` (sizes/spacing).

- ✅ `Color(0xFF795548)` for "basics" grammar level — added `'basics'` to `levelColor()`, removed inline hardcodes from `grammar_chapter_list.dart` and `grammar_screen.dart`
- ✅ Raw `SizedBox(height: 2/4)` and `EdgeInsets.all(4)` across 8 files — replaced with `AppDimens.spaceXxs` / `AppDimens.spaceXs`

**Accepted one-offs:** emoji font sizes (`fontSize: 28/22`), `fontSize: 26` for sentence text in `sentence_cloze_card.dart`, `SizedBox` values of 6/10/12 with no matching constant, `Color(0x33ffffff)` white overlay in `kanji_hero.dart`, `Color(0xFF795548)` constructor default in `grammar_lesson_screen.dart` (Dart const constraint).

---

## 3. Internationalization (i18n)

**Rule:** Every user-visible UI string must go through the l10n system (`context.l10n.*`). Grammar lesson content is exempt.

- [ ] Audit widget/screen files for hardcoded UI strings not yet in `.arb` files
- [ ] Grammar content localization: JSON lesson files are English-only by design for v1; plan a future path (per-locale JSON files or a translation layer over the block renderer)

---

## 4. Code Simplification

**Rule:** Delete complexity that isn't earning its keep. Prefer the obvious path.

- ✅ `vocab_session_service.dart` / `kanji_session_service.dart` — shared distractor-picking logic extracted into `_pickDistractors<T>` in `session_item_builders.dart`
- [ ] `writing_session_provider.dart` — DB queries + shuffling + locale lookups + transforms in one provider; split by concern

---

## Approach

Work through these one targeted change at a time — not a big-bang rewrite. Each PR should:

- Be focused on one layer or one screen
- Pass the analyzer and all existing tests
- Not be mixed with feature work
