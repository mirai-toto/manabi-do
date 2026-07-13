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

## 3. Internationalization (i18n) 🔄

**Rule:** Every user-visible UI string must go through the l10n system (`context.l10n.*`). Grammar lesson content follows a per-locale JSON file approach.

### UI strings ✅
- ✅ Audit widget/screen files for hardcoded UI strings — one found (`Hide`/`Translation` in `sentence_cloze_card.dart`), moved to l10n

### Grammar content pipeline ✅
- ✅ Lesson files renamed from `lesson.json` → `lesson.en.json`; future locales add `lesson.fr.json` etc.
- ✅ Index files (`index.json`) keep inline locale maps: `"title": { "en": "...", "fr": "..." }`
- ✅ `levels.json` uses the same locale-map format for `name`
- ✅ `build_content_db.py` updated: `_walk_grammar_index(locale)` resolves `{path}.{locale}.json` with `.en.json` fallback; `insert_grammar(db, locale)` accepts a locale parameter

### Grammar content translation 🔄
- ✅ `basics` — all 10 lessons translated to French (`.fr.json`); all index titles have `"fr"` keys
- ⬜ `N5` — French translations pending (app falls back to English rows in the meantime)
- ⬜ Higher levels — not started

### DB multi-locale support ✅
- ✅ `locale TEXT NOT NULL DEFAULT 'en'` column added to `grammar_lessons` (schema v14, migration in place)
- ✅ `build_content_db.py` runs `insert_grammar` once per locale; non-'en' locales only insert rows for lessons that have a `.{locale}.json` file
- ✅ `getGrammarLessonsForLevel(level, locale:)` filters by locale, falls back to `'en'` if no rows found
- ✅ `grammarChaptersProvider` watches `localeProvider` (the app's persisted locale, not the raw platform locale) so content switches immediately when the in-app language is changed
- ✅ DB asset rebuilt: 50 `en` rows + 10 `fr` rows (basics only; N5 falls back to English until translated)

---

## 4. Code Simplification ✅

**Rule:** Delete complexity that isn't earning its keep. Prefer the obvious path.

- ✅ `vocab_session_service.dart` / `kanji_session_service.dart` — shared distractor-picking logic extracted into `_pickDistractors<T>` in `session_item_builders.dart`
- ✅ `writing_session_provider.dart` — extracted into `WritingSessionService`; provider is now a thin wrapper

---

## Approach

Work through these one targeted change at a time — not a big-bang rewrite. Each PR should:

- Be focused on one layer or one screen
- Pass the analyzer and all existing tests
- Not be mixed with feature work
