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
- ✅ `search_service.dart` — result ranking, level tiebreak and the 50-result cap moved out of `kanji_queries`/`vocabulary_queries`, which now only run the `LIKE` filter
- ✅ `grammar_progress_service.dart` — the six direct `databaseProvider` writes in `home_screen`, `grammar_chapter_view`, `grammar_lesson_list_screen` and `grammar_lesson_screen` replaced by service calls; unlock key formats (`$level:$i`, `group:…`, `lesson:…`) now built in one place instead of inline at each read and write
- ✅ `srs_queue_service.dart` — `srs_session_queries.dart` deleted; the queue policy it held (due items, daily new-card budget, N5→N1 progression) split between `core/srs/srs_queue.dart` (pure) and a service that reads rows through `AppDatabase`
- ✅ `core/srs/srs_queue.dart` — the N5→N1 rule and "take the first N unseen items" each had two or three copies between the service and `dashboard_queries`; both now have one implementation that every caller shares
- ✅ `practice_question.dart` — session services no longer build widgets. `PracticeItem.buildBody`, a closure that constructed the exercise body, is replaced by a sealed `PracticeQuestion` describing what to ask; `PracticeQuestionBody` turns that into a widget and is the only place that knows which body answers which kind of question. No service imports `flutter/material`, a screen or a widget any more
- ✅ Every service now holds a `Ref` and is reached through its own provider, instead of taking the screen's `WidgetRef` as a method argument. Queue building no longer depends on anything from the widget layer, and the free-floating `const kanjiSessionService` / `srsService` / `writingSessionService` singletons are gone. `review_queue_service.dart`'s five top-level functions became `ReviewQueueService`
- ✅ `dashboard_service.dart` — `dashboard_queries.dart` deleted. The home counters moved to a service, the rules behind them (what is due, what is known, how much of today's budget is left, the streak walk, the week strip) to `core/srs/dashboard_stats.dart`. `home_provider` no longer reads the database at all, and the week strip is no longer derived inside a provider

**Known gaps:**

- "Kanji unseen per level" is computed twice: `unseenKanjiByLevel()` as its own query for the dashboard, and inline in `SrsQueueService.allDueKanji`, which needs the same pass to find due cards and would otherwise query twice.
- Eleven widgets under `widgets/` fetch their own data through providers (`kanjiListProvider`, `kanjiStrokesProvider`, `ttsProvider` and friends). Deliberate: they are self-contained list and detail widgets, and threading that data through constructors would cost more than it buys. Settings are a different matter and are always passed in.

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

### Grammar content translation ✅
- ✅ `basics` — all 10 lessons translated to French (`.fr.json`); all index titles have `"fr"` keys
- ✅ `N5` — all 40 lessons translated to French (`.fr.json`); all index titles have `"fr"` keys
- ⬜ Higher levels (N4+) — not started
- ⬜ German (`de`) — started but not a priority

### DB multi-locale support ✅
- ✅ `locale TEXT NOT NULL DEFAULT 'en'` column added to `grammar_lessons` (schema v14, migration in place)
- ✅ `build_content_db.py` runs `insert_grammar` once per locale; non-'en' locales only insert rows for lessons that have a `.{locale}.json` file
- ✅ `getGrammarLessonsForLevel(level, locale:)` filters by locale, falls back to `'en'` if no rows found
- ✅ `grammarChaptersProvider` watches `localeProvider` (the app's persisted locale, not the raw platform locale) so content switches immediately when the in-app language is changed
- ✅ DB asset rebuilt: 50 `en` rows + 50 `fr` rows (basics + N5)

---

## 4. Code Simplification ✅

**Rule:** Delete complexity that isn't earning its keep. Prefer the obvious path.

- ✅ `vocab_session_service.dart` / `kanji_session_service.dart` — shared distractor-picking logic extracted into `_pickDistractors<T>` in `session_item_builders.dart`
- ✅ `writing_session_provider.dart` — extracted into `WritingSessionService`; provider is now a thin wrapper

---

## 5. One Button Engine 🔄

**Rule:** `AppButton` styles every button. A second button widget exists only when
the *affordance* differs, never because `AppButton` was missing a knob.

Three button widgets were built because of a missing knob, not a missing concept:
`PracticeButton` (folded in), `AuthButton`, `RatingButton`. Each time, adding a
parameter was the larger-looking change and writing a new widget was the smaller
one, so the inventory grew. That is the mechanism to stop, and it is why the
default answer to "should this be its own button?" is no.

See `docs/08_widget_inventory.md` (generated) for live usage counts.

### The action role, widget by widget

| Widget | Built on | Fold into `AppButton`? |
| --- | --- | --- |
| `AppButton` | `ElevatedButton` | — it is the engine |
| `AuthButton` | `ElevatedButton` | **Yes.** Same base; only radius, padding and text style differ, all of which are already overrides. Needs an icon-gap knob (10px vs 8px). Blocked on the landing-screen decision — it has no other caller |
| `RatingButton` | `InkWell` | ✅ Folded in. `subtitle` + `selected` were the only gaps |
| `SpeakButton` | `IconButton` | **No.** A bare icon: zero padding, no constraints, compact density, a tooltip. Folding it in would mean overriding `minimumSize`, padding, background and elevation — neutralising everything `ElevatedButton` provides. The test is whether `AppButton`'s shape is the right *starting point*, not whether it can be bent into shape |
| `AppFilterChip` | `InkWell` | **No.** A chip toggles — a different affordance. Keep; there are plans for it |
| `LessonReadToggle` | `GestureDetector` | **Yes, but deferred** — see the animation note below. Calling it "a card" was wrong: it is `Row[Icon, Text]` in a padded rounded box with an `onTap`, and nothing is composed inside it |
| `SettingsToggle` | `Switch` | **No** — and it is mis-roled. Belongs in `input` |
| `FlashcardActions` | composes `RatingButton` | **No** — and it is mis-roled. A row of buttons; belongs in `composite` |

### Decided

- `AppButton` gains `subtitle` (a second line under the label), plus `selected`
  and `toggled`, both `bool?` mirroring `SemanticsProperties`. `null` means the
  button has no such state, because `Semantics(selected: false)` on an ordinary
  button announces "not selected".
- **`selected` and `toggled` are semantics-only. Neither touches appearance.**
  An earlier draft had `selected` draw the ring, which left `AppButton` holding
  an opinion in one case and not the other, invisible from the call site. The
  ring is just a border, so the caller passes `side`. `AppButton` keeps no
  opinions of its own.
- Both are kept because they are not two names for one idea: `toggled` is
  announced "on"/"off" and `selected` as one choice among siblings. Collapsing
  them would have the read toggle announce "selected", implying siblings it does
  not have. Not worth a sealed type to forbid setting both — that emits two
  semantic flags, which is degraded, not broken.
- No icon-only support. It was planned for `SpeakButton`, which then turned out
  not to belong here at all.
- `AppButton` accepts `subtitle`, `selected` and `icon` — typed content slots. It
  will **not** accept a generic `child`. A button that can contain anything
  guarantees nothing, and every caller reinvents the layout.
- `AppFilterChip` stays despite reading as unused.

### Watch out: visual density

Material subtracts the platform's density adjustment from a button's padding
(`button_style_button.dart`), so the same padding is 16px shorter on desktop than
on mobile. Widgets built on `Padding` + `InkWell` have no such adjustment, so
every fold-in silently loses height on desktop unless `visualDensity:
VisualDensity.standard` is passed. This already bit the Free Practice button.
Since every fold-in hits it, standard density probably belongs inside
`AppButton` rather than at each call site.

### Raw Material buttons

42 usages outside `widgets/common/`, counted by
`scripts/design/widget_inventory.py`. Fewer actual buttons than that: a styled
button contributes both its constructor and its `styleFrom`. Triaged 2026-09-25.

**Convert to `AppButton`** — labelled buttons where `AppButton`'s shape already
fits. Agreed list:

| Where | Buttons |
| --- | --- |
| Drawing practice | Undo, Clear, Hint, Retry, Next, and one more |
| Writing session | Retry, Next |
| Grammar error detection | the answer button |
| Kanji detail | the action button under the character, plus a text button |
| Kana detail sheet | one text button |
| Grammar lesson list | Unlock anyway |

Drawing practice is the worst single file, and its Retry is styled independently
from the writing session's Retry — the same button written twice, which is the
drift this goal exists to stop. Start there.

Seven are outlined buttons, which is why `AppButtonVariant.outlined` read as
unused: the app does use outlined buttons, just never through `AppButton`.

**Leave alone**, with reasons, so nobody folds them in later out of tidiness:

- **Dialog buttons** (four, including three `Cancel`s). `AlertDialog`'s
  `actions:` owns their layout and spacing; `AppButton` would fight it.
- **Icon taps** (14: five back arrows, close buttons, the settings tune icon,
  stepper + / −). `AppButton` is an `ElevatedButton`, and an icon-only tap needs
  its background, padding, minimum size and border all overridden — nothing of
  the component would be left. The test is whether `AppButton`'s shape is the
  right *starting point*, not whether it can be bent into one.
- **The two grammar FABs.** A floating action button positions and elevates
  itself and `Scaffold` knows about it. Not `AppButton`'s business.

**Rejected: a global button theme.** `AppTheme` sets only colours, so the idea
was to fill in `textButtonTheme` / `iconButtonTheme` / `outlinedButtonTheme` and
let buttons inherit. Dropped because:

- The icon buttons are already coherent — all five back arrows are identical, as
  are the close buttons, and not one uses `styleFrom`. The problem it solved was
  hypothetical.
- A theme is implicit inheritance, against the explicit-at-the-call-site
  preference this codebase has settled on. Nine call sites saying
  `color: t.onSurface` are readable without opening the theme file.
- It would change every Material button in the app at once, including ones
  nobody has looked at, to delete nine lines.

The one real argument for it: Material 3's default `IconButton` colour is
`onSurfaceVariant` (`icon_button.dart:990`), but the app wants `onSurface`, so
those nine sites override a default they do not want and a tenth author might
forget. If drift ever appears, the cheap catch is a check in the inventory
script — flag any `IconButton` whose colour is not `t.onSurface` — rather than a
theme that changes behaviour.

### Chips

Three implementations of the same visual idea, two of which say so in their own
doc comments:

- `AppFilterChip` — the real one, currently unused
- `streak_pill.dart:9` — *"Chip-sized, like `AppFilterChip`, but the two never sit together"*
- `grammar_builder_body.dart:15` — *"Chip-sized, matching `AppFilterChip` by eye. Kept local"*

Nothing to delete. The question is whether chips are a role of their own and
whether the two local copies should reference the real one.

### Open

- **`LessonReadToggle` is deferred until there is a view on animation across the
  whole app.** It is the last fold and the only one blocked on behaviour rather
  than a styling knob.

  What its `AnimatedContainer` animates today is less than it looks: the
  background and border cross-fade over 150ms, while the icon and label colours
  snap, because `AnimatedContainer` animates its own decoration and not its
  child. Folding it in as-is would keep the border fade (`Material` tweens shape
  via `ShapeBorderTween`) and lose the background one, since `material.dart`
  applies its colour without a tween.

  When it happens, the approach is for the **caller** to animate the values it
  passes — a `TweenAnimationBuilder` walking 0→1 and `Color.lerp` for
  background, foreground and border — not for `AppButton` to grow an animation.
  Six lines in one widget, `AppButton` stays opinion-free, and the icon and
  label start gliding too, so the pill ends up smoother than it is now. What to
  avoid is wrapping `AppButton` in an `AnimatedContainer` internally: that means
  a transparent button over a painted box, radius and border specified twice,
  and every button in the app paying for one pill's transition.
- Triage the 36 raw Material buttons: convert all, or only the seven outlined
  ones where the duplication is real?
- The landing screen: keep for future accounts, or delete with `AuthButton` and
  `LandingHeroPanel`? Deferred.
- **Bug:** on the session review, the `selected` ring does not appear in the
  two-grade Correct/Incorrect layout, only in the four-grade one. Auto-marked
  exercises only ever produce `again` or `good` (`drawing_rating.dart`), which
  are exactly the two on offer, so the ring should show. Cause not identified.

---

## Approach

Work through these one targeted change at a time — not a big-bang rewrite. Each PR should:

- Be focused on one layer or one screen
- Pass the analyzer and all existing tests
- Not be mixed with feature work
