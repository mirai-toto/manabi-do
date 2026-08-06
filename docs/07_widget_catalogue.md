# Widget Catalogue — Manabi Do

All widgets live under `lib/presentation/widgets/`. Each widget is a pure presentational unit — it renders what it is given. Decisions about visibility, settings, and state belong to the caller (screen or body widget), not to the widget itself.

The one explicit exception is `SpeakButton`, which reads `ttsProvider` to trigger a TTS action — a service action, not a display setting.

---

## common/

### AuthButton

Full-width landing/onboarding button. Elevation 0, `radiusLg` corners, vertical padding `spaceMd`, bold `body` text. Accepts `backgroundColor`, `foregroundColor`, and an optional `BorderSide` for outlined variants.

```dart
AuthButton(
  backgroundColor: t.cardBackground,
  foregroundColor: t.onSurface,
  side: BorderSide(color: t.outlineVariant, width: 1.5),
  onPressed: () {},
  child: Row(children: [SvgPicture.asset('…'), Text(l.signInWithGoogle)]),
)
```

---

### AppButton

Themed filled/outlined button with consistent padding and style.

```dart
AppButton(label: 'Start practice', onPressed: () {})

AppButton(label: 'Learn more', variant: AppButtonVariant.tonal, onPressed: () {})

AppButton(
  label: 'Reset progress',
  variant: AppButtonVariant.danger,
  fullWidth: true,
  onPressed: () {},
)
```

---

### AppEmoji

Renders an emoji with a fixed font so it displays consistently across platforms.

```dart
const AppEmoji('👋', size: 22)
```

---

### AppFilterChip

Selectable filter chip used in lists and search screens.

```dart
AppFilterChip(label: 'N5', isActive: true, onTap: () {})
```

---

### AppTextField

Themed text input with label, hint, and error state.

```dart
AppTextField(label: 'Search', hint: 'Type a kanji…', onChanged: (v) {})
```

---

### AppProgressBar

Thin horizontal progress bar (0–1). Accepts an optional `color` and `height`.

```dart
AppProgressBar(progress: 0.6)

AppProgressBar(progress: 0.4, color: Colors.green, height: 8)
```

---

### CardContainer

Rounded card shell (`cardBackground` fill, `outlineVariant` border). Wraps any child.

```dart
CardContainer(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Text('Content'),
  ),
)
```

---

### CollapsibleSection

Tappable section header with an animated chevron and a tinted background. Used to group collapsible lists (e.g. grammar chapters inside a theme). The caller owns the collapsed state and provides `onToggle`.

Optional `badge` renders a pill label between the title and the icon — visible even when collapsed or locked. The caller is responsible for formatting the string (e.g. `l.nLessons(count)`).

Optional `isLocked` swaps the chevron for a lock icon and dims the row to 55% opacity. The caller is still responsible for what `onToggle` does in the locked case (e.g. show an unlock dialog).

```dart
CollapsibleSection(
  title: 'て-form',
  isCollapsed: _collapsed.contains(0),
  accentColor: levelColor('N5'),
  onToggle: () => setState(() => _collapsed.toggle(0)),
)

// With badge (caller formats the string)
CollapsibleSection(
  title: 'て-form',
  badge: l.nLessons(4),
  isCollapsed: _collapsed.contains(0),
  accentColor: levelColor('N5'),
  onToggle: () => setState(() => _collapsed.toggle(0)),
)

// Locked — shows lock icon, caller handles the tap
CollapsibleSection(
  title: 'Advanced verbs',
  badge: l.nLessons(6),
  isCollapsed: true,
  isLocked: true,
  accentColor: levelColor('N4'),
  onToggle: _showUnlockDialog,
)
```

---

### ConfirmDialog

Standard two-button confirmation dialog (cancel / confirm). Exposed as a top-level async function, not a widget class.

```dart
final confirmed = await showConfirmDialog(
  context,
  title: 'Reset progress?',
  body: 'This cannot be undone.',
  confirmLabel: 'Reset',
  isDestructive: true,
);
```

---

### DifficultyDots

Row of filled/empty dots indicating difficulty level.

```dart
DifficultyDots(
  total: 5,
  filled: 3,
  color: Theme.of(context).colorScheme.primary,
)
```

---

### JapaneseSentence

Renders a Japanese sentence with optional furigana and a highlighted target word. Pass `hideHighlight: true` to mask the target as a blank pill before reveal.

```dart
JapaneseSentence(
  sentence: '水を{飲|の}みます。',   // {kanji|furigana} annotation
  highlight: '飲',
  highlightColor: Colors.blue,
  translation: 'I drink water.',
)

// Before card is revealed — masks the highlighted word
JapaneseSentence(
  sentence: '音楽を{聴|き}きながら{勉強|べんきょう}する',
  highlight: 'ながら',
  hideHighlight: true,
  highlightColor: t.primary,
)
```

---

### JapaneseText

Low-level furigana renderer. Parses `{漢字|かんじ}` annotation syntax into ruby text spans.

```dart
JapaneseText(
  word: '日本語',
  reading: 'にほんご',
  style: const TextStyle(fontSize: 28),
)
```

---

### LandingHeroPanel

Full-bleed hero at the top of the landing screen. 3-stop vertical gradient (`heroDeep → heroMid → primaryLight`), app glyph `'学び'` with glow shadow, app name in letter-spaced label, and tagline. Reads `context.tokens` and `context.l10n` internally — no parameters.

```dart
const LandingHeroPanel()
```

---

### LockedFeatureCard

Centred overlay card shown when a feature is locked. Large `Icons.lock_outline_rounded`, title in `titleLarge`, subtitle in `body onSurfaceVariant`. Decoration: `cardBackground`, `radiusMd`, prominent drop shadow. Title and subtitle are pre-formatted by the caller.

```dart
LockedFeatureCard(
  title: l.grammarLockedTitle,
  subtitle: l.grammarLockedSubtitle,
)
```

---

### JlptLevelCard

Compact badge showing a JLPT level (N1–N5) in brand colours.

```dart
JlptLevelCard(code: 'N5', subtitle: '100 kanji', onTap: () {})
```

---

### PillBadge

Rounded pill label. Accepts `label`, `color`, and `background` — no default colours.

```dart
PillBadge(
  label: 'N5',
  color: t.primary,
  background: t.primaryContainer,
)
```

---

### PracticeButton

"Free Practice" action button shown at the bottom of lesson and chapter views.

```dart
PracticeButton(color: Colors.indigo, onTap: () {})
```

---

### ProgressRow

`known / total` label alongside an `AppProgressBar`.

```dart
ProgressRow(known: 42, total: 100, color: Colors.teal)
```

---

### ReviewProgressInfo

SRS state pill + stability progress bar for a single `Card?`. Shows level label and due date.

```dart
ReviewProgressInfo(srsCard: null)    // new card — shows "New" state

ReviewProgressInfo(srsCard: card)    // card from fsrs package
```

---

### SectionHeader

Bold section title with optional subtitle, glyph accent, and color.

```dart
SectionHeader(
  title: 'Kanji',
  subtitle: 'N5–N1 characters with stroke order',
  glyph: '漢',
  color: t.primary,
)
```

---

### SegmentSelector

Horizontal row of equally-sized labelled segments. Selected segment: `primary` fill + white label. Others: `cardBackground` + `outlineVariant` border + `onSurface` label. Animates transitions in 150ms. All option labels are pre-formatted by the caller.

```dart
SegmentSelector(
  options: [l.always, l.onTap, l.never],
  selected: _furiganaMode,
  onSelect: (i) => setState(() => _furiganaMode = i),
)
```

---

### SectionLabel

Small all-caps label used above content groups.

---

### SheetDragHandle

The 36×4 pill shown at the top of every bottom sheet. Centred, `outlineVariant` colour, with a bottom margin (`spaceMd`) to separate it from sheet content. Always `const`.

```dart
const SheetDragHandle()
```

```dart
const SectionLabel('Stroke order')
```

---

### SegmentedTabBar

Pill-style segmented control backed by a `TabController`.

```dart
SegmentedTabBar(
  controller: _tabController,
  labels: const ['Hiragana', 'Katakana', 'Kanji'],
)
```

---

### SpeakButton

Icon button that triggers Japanese TTS for a given text string. Reads `ttsProvider` internally — the only widget allowed to do so because TTS is a service action, not a display setting.

```dart
SpeakButton(text: '日本語', color: t.primary)
```

---

### TappableSurface

Low-level tappable shell: `ClipRRect → Material → InkWell → Ink(decoration)`. Use this instead of `GestureDetector` when an ink ripple is desired.

```dart
TappableSurface(
  decoration: BoxDecoration(
    color: t.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: t.outlineVariant),
  ),
  onTap: () {},
  child: const Padding(padding: EdgeInsets.all(16), child: Text('Tap me')),
)
```

---

## exercise/

### DrawingExercise

Kanji stroke-order exercise. Manages canvas strokes, DTW comparison, and SRS rating. The caller reads `drawingSettingsProvider` and passes the result as `settings`.

```dart
DrawingExercise(
  referenceStrokes: refStrokes,   // List<ui.Path> from kanjiStrokesProvider
  kanjiId: 0x6c34,                // Unicode code point (水)
  label: '水',
  color: t.primary,
  settings: ref.watch(drawingSettingsProvider),
  onReading: 'すい',
  kunReading: 'みず',
  card: srsCard,                  // null in free mode
  isFreeMode: false,
  onRate: (rating) {},
)
```

---

### ExampleCard

Displays a grammar example sentence with an "Example" pill badge. Pass `showTranslation: false` to hide translation and mask the highlighted word. Visibility is controlled by the caller.

```dart
ExampleCard(
  example: GrammarExample(
    sentence: '音楽を{聴|き}きながら{勉強|べんきょう}する',
    highlight: 'ながら',
    translation: {'en': 'I study while listening to music.'},
  ),
  locale: 'en',
  showTranslation: _revealed,   // hides translation + masks highlight when false
)
```

---

### FlashCard

Large gradient card showing a prompt and, when revealed, an answer. Includes a `SpeakButton` and a tap-to-reveal/hide label.

```dart
FlashCard(
  prompt: '水',
  promptSub: 'みず',
  reveal: 'Water',
  speakText: '水',
  isRevealed: _revealed,
  onTap: _onTap,
)
```

---

### FlashCardActions

Rating button row shown after a flashcard is revealed. Shows FSRS interval previews in SRS mode; shows "Got it / Not yet" in free mode.

```dart
FlashCardActions(
  card: srsCard,                        // null = free mode buttons
  isFreeMode: false,
  question: l.selfAssessQuestion,       // optional label above buttons
  onRate: (Rating rating) {},
)
```

---

### LessonReaderCard

Card shell for grammar lesson content. Shows chapter label, title, body widgets, and an optional "Practice" button.

```dart
LessonReaderCard(
  chapterLabel: 'Chapter 1',
  title: 'Greetings in Japanese',
  body: const [
    ReaderBodyText('Japanese greetings vary by formality.'),
    ReaderSectionTitle('Morning greeting'),
    ReaderJpExample(
      japanese: 'おはようございます',
      translation: 'Good morning (formal)',
    ),
  ],
  onPractice: () {},
)
```

---

### McqCard

Multiple-choice question card. Renders a question prompt and a list of `McqOption` tiles with idle/correct/wrong states. The caller reads `mcqSettingsProvider` and passes `showFurigana`.

```dart
McqCard(
  question: 'What does this sentence mean?',
  japanesePrompt: '水を飲みます。',
  options: const [
    McqOption(letter: 'A', text: 'I drink water.'),
    McqOption(letter: 'B', text: 'I eat water.'),
  ],
  showFurigana: ref.watch(mcqSettingsProvider.select((s) => s.showPromptFurigana)),
  onOptionTap: (index) {},
)
```

---

### PracticeProgressRow

Thin progress bar + `"N / total"` counter shown at the top of every exercise screen. The bar fills proportionally to `index / total` using the session's accent colour; the text label counts from 1. Handles `total == 0` without dividing by zero.

```dart
PracticeProgressRow(
  index: widget.index,   // 0-based current position
  total: widget.total,
  color: widget.color,
)
```

---

### SummaryCard

End-of-session results card. Shows score, correct/missed counts, time spent, and retry/next actions.

```dart
SummaryCard(
  score: 8,
  total: 10,
  title: 'Session complete!',
  subtitle: 'N5 Kanji · 10 cards',
  correct: 8,
  missed: 2,
  timeSpent: '4m 32s',
  onRetry: () {},
  onNext: () {},
)
```

---

### FeedbackPanel

Full-width result banner shown after an exercise answer. Background is `successContainer` or `errorContainer`; text is `success` or `error`.

```dart
FeedbackPanel(text: l.correct, isCorrect: true)
FeedbackPanel(text: explanation, isCorrect: false)
```

---

### PracticeFlashcardBody

Flashcard exercise body. Shows a `FlashCard` (front/back flip), then SRS rating buttons. Handles the flip animation and rating UI internally.

```dart
PracticeFlashcardBody(
  japanese: '水',
  label: 'みず',
  answer: 'water',
  isReversed: false,
  card: srsCard,
  isFreeMode: false,
  index: 0,
  total: 10,
  color: levelColor('N5'),
  onAnswer: (rating) {},
  onDetailTap: () => Navigator.push(context, ...),
)
```

---

### PracticeMcqBody

Multiple-choice exercise body. Renders `McqCard` options and advances on selection.

```dart
PracticeMcqBody(
  question: '水',
  japanesePrompt: null,
  japaneseReading: null,
  options: [McqOption(text: 'water'), ...],
  correctIndex: 0,
  card: srsCard,
  isFreeMode: false,
  index: 0,
  total: 10,
  color: levelColor('N5'),
  onAnswer: (rating) {},
)
```

---

### ClozeOption / LetterCircle

`ClozeOption` is a tappable answer chip for fill-in-the-blank exercises. Shows a lettered circle (`LetterCircle`) alongside the option text/furigana. Colours change to success/error after answer.

```dart
ClozeOption(
  option: McqOption(text: '食べます', furigana: 'たべます'),
  showFurigana: true,
  onTap: () => selectOption(i),
)
```

---

### GrammarBuilderBody

Sentence-builder exercise body. Displays a shuffled word bank; the user taps words into order. Advances automatically or on confirmation.

```dart
GrammarBuilderBody(
  parts: ['私は', '水を', '飲みます'],
  translation: 'I drink water.',
  index: 0,
  total: 5,
  color: levelColor('N5'),
  autoAdvance: true,
  onAnswer: (rating) {},
)
```

---

### GrammarClozeBody

Grammar fill-in-the-blank body. Renders the sentence with a gap and a set of `ClozeOption` chips.

```dart
GrammarClozeBody(
  sentence: '私は水___飲みます。',
  options: [McqOption(text: 'を'), ...],
  correctIndex: 0,
  index: 0,
  total: 5,
  color: levelColor('N5'),
  autoAdvance: false,
  onAnswer: (rating) {},
)
```

---

### GrammarErrorDetectionBody

Error-detection exercise body. Shows two sentences side by side (correct vs. wrong); the user picks the grammatically correct one.

```dart
GrammarErrorDetectionBody(
  correct: '私は水を飲みます。',
  wrong: '私は水が飲みます。',
  explanation: 'Use を for the direct object of 飲む.',
  index: 0,
  total: 5,
  color: levelColor('N5'),
  onAnswer: (rating) {},
)
```

---

### SentenceClozeBody

Sentence-level cloze exercise. Fetches per-card SRS state, renders `SentenceClozeCard`, and handles rating.

```dart
SentenceClozeBody(
  sentence: sentence,
  translation: 'I drink water.',
  targetReading: null,
  options: options,
  correctIndex: 0,
  card: srsCard,
  isFreeMode: false,
  index: 0,
  total: 10,
  color: levelColor('N5'),
  onAnswer: (rating) {},
)
```

---

### SentenceClozeCard

Stateless display card for a sentence cloze item. Renders the gapped sentence, optional furigana, translation toggle, and `ClozeOption` chips. No answer-handling logic.

```dart
SentenceClozeCard(
  sentence: sentence,
  translation: 'I drink water.',
  showTranslation: false,
  onToggleTranslation: () {},
  showSentenceFurigana: true,
  showChoiceFurigana: true,
  targetReading: null,
  options: options,
  answered: false,
  color: levelColor('N5'),
  onOptionTap: (i) {},
)
```

---

## characters/

### CharacterHeroBox

Fixed-size square box displaying a single Japanese character on a styled background. When `accentColor` is provided: diagonal gradient (dark-to-accent). When null: translucent white fill. Both variants use `radiusMd` corners and white character text.

```dart
// Kana detail — gradient variant
CharacterHeroBox(character: 'あ', size: 88, accentColor: levelColor('kana'))

// Kanji hero — translucent white variant
CharacterHeroBox(character: '水', size: 96)
```

---

### SrsProgressCard

Full-width `surfaceContainer` card wrapping `ReviewProgressInfo`. Shows a small `CircularProgressIndicator` while loading; shows SRS state once loaded.

```dart
SrsProgressCard(isLoaded: _loaded, srsCard: _srsCard)
```

---

### CharacterCell

Small grid cell for a single kana or kanji character with reading label.

```dart
CharacterCell(
  character: 'あ',
  subLabel: 'a',
  accentColor: Colors.green,   // null = neutral; non-null = known tint
  onTap: () {},
)
```

---

### KanjiDrawingCanvas

Interactive canvas that captures user strokes for kanji writing practice.

```dart
KanjiDrawingCanvas(
  onStrokesChanged: (strokes) {},
  referenceStrokes: refStrokes,       // List<ui.Path>?
  ghostEnabled: true,
  snapToReference: true,
  strokeResults: const [true, false],
)
```

---

### KanjiStrokesProvider

Riverpod `FutureProvider.family` that loads SVG stroke paths for a kanji ID. Not a widget — consume it inside a `ConsumerWidget`.

```dart
final strokesAsync = ref.watch(kanjiStrokesProvider(0x6c34));  // 水
final strokes = strokesAsync.asData?.value ?? [];
```

---

### StrokeOrderAnimator / UserStrokeAnimator

`StrokeOrderAnimator` plays back reference strokes sequentially. `UserStrokeAnimator` replays the user's drawn strokes with pass/fail colouring.

```dart
StrokeOrderAnimator(kanjiId: 0x6c34)           // auto-plays; tap to replay
StrokeOrderAnimator(kanjiId: 0x6c34, size: 260)

UserStrokeAnimator(
  strokes: const [
    [Offset(50, 130), Offset(210, 130)],
  ],
  strokeResults: const [true],   // null = all neutral
)
```

---

### StrokeStepRow

Horizontal scrollable row of mini stroke-step previews; tap a step to jump to it.

```dart
StrokeStepRow(kanjiId: 0x6c34)
```

---

### StrokeOrderSection

`SectionLabel` + `CardContainer(StrokeOrderAnimator)` + `StrokeStepRow` composed as a single block. Drop it below the readings card in any kanji detail view.

```dart
StrokeOrderSection(kanji: kanji)
```

---

### KanjiHero

Full-width gradient hero banner for a kanji detail screen. Shows the character, JLPT level badge, meanings, and a back button. Fetches localized meaning via `localizedKanjiMeaningProvider`.

```dart
KanjiHero(
  kanji: kanji,
  color: levelColor(kanji.jlptLevel),
  onBack: () => Navigator.of(context).pop(),
)
```

---

### KanjiReadingsCard

`SectionLabel` + `CardContainer` listing on-yomi and kun-yomi readings as `KanjiReadingChip` pills.

```dart
KanjiReadingsCard(kanji: kanji)
```

---

### KanjiExampleWords

`SectionLabel` + list of example vocabulary words for a kanji. Fetches localized vocab via provider; shows a loading indicator, empty state, or word list with `PillBadge` JLPT tags.

```dart
KanjiExampleWords(kanji: kanji)
```

---

### KanjiGrid

4-column grid of `CharacterCell` tiles for a set of kanji. Tapping a cell navigates to `KanjiDetailScreen`.

```dart
KanjiGrid(kanjis: kanjiList, srsCards: srsCardMap)
```

---

### KanjiLevelHeader

In-page back-navigation row used at the top of kanji group/level views. Shows a back button, JLPT level `PillBadge`, and a subtitle label.

```dart
KanjiLevelHeader(
  level: 'N5',
  label: l.kanjiGroup(1),
  color: levelColor('N5'),
  onBack: () {},
)
```

---

## grammar/

### LessonReadToggle

Full-width animated toggle shown at the bottom of a grammar lesson. Unread state: `surfaceContainer` background, outline check icon, "Mark as read" label. Read state: `successContainer` background, `success` border, filled check icon, "Marked as read" label. Animates in 150ms. Reads `context.l10n` internally — the labels are inseparable from the toggle state.

```dart
LessonReadToggle(
  isRead: isRead,
  onTap: () {
    if (isRead) db.unmarkGrammarLessonRead(lessonId);
    else db.markGrammarLessonRead(lessonId);
  },
)
```

---

## grammar/blocks/

These widgets are used exclusively by `GrammarBlockRenderer` to render grammar lesson content from JSON blocks.

### GrammarBlockRenderer

Dispatches a `GrammarBlock` to the correct block widget by `type`.

```dart
GrammarBlockRenderer(
  blocks: lesson.blocks,     // List<GrammarBlock>
  levelColor: levelColor('N5'),
)
```

---

### TextBlock

Plain paragraph text inside a lesson.

```dart
TextBlock(content: 'Japanese verbs conjugate based on their group.')
```

---

### SectionTitleBlock

Bold in-lesson section heading.

```dart
SectionTitleBlock(content: 'Verb Groups', color: levelColor('N5'))
```

---

### NoteBlock

Highlighted callout box for tips or warnings.

```dart
NoteBlock(content: '～ます covers both present habits and future actions.')
```

---

### PatternBlock

Displays a grammar pattern formula with colour-coded slots.

```dart
PatternBlock(color: levelColor('N5'), lines: const ['[Verb stem] + ます'])
```

---

### ExampleTableBlock

Table of example sentences with translations.

```dart
ExampleTableBlock(
  columns: const ['japanese', 'romaji', 'english'],
  rows: const [
    {
      'japanese': '毎日勉強します。',
      'romaji': 'Mainichi benkyō shimasu.',
      'english': 'I study every day.',
    },
  ],
)
```

---

### VocabTableBlock

Two-column table of vocabulary items with readings and meanings.

```dart
VocabTableBlock(
  columns: const ['japanese', 'romaji', 'english', 'group'],
  rows: const [
    {'japanese': '書く', 'romaji': 'kaku', 'english': 'to write', 'group': '1'},
  ],
)
```

---

### ConjugationTableBlock

Table of verb/adjective conjugation forms.

```dart
ConjugationTableBlock(
  label: 'い-Adjectives · 高い',
  rows: const [
    {'form': 'Present',  'japanese': '高い',     'romaji': 'takai',     'english': 'is expensive'},
    {'form': 'Negative', 'japanese': '高くない', 'romaji': 'takakunai', 'english': 'is not expensive'},
  ],
)
```

---

### GrammarTable

Internal shared renderer used by `ExampleTableBlock`, `VocabTableBlock`, and `ConjugationTableBlock`. Not dispatched directly — use the typed wrappers above.

```dart
GrammarTable(
  columns: const ['japanese', 'english'],
  rows: const [{'japanese': '水', 'english': 'water'}],
  boldFirstColumn: false,
  accentColor: Colors.blue,
)
```

---

### ComparisonBlock

Side-by-side comparison of two grammar patterns.

```dart
ComparisonBlock(
  left: const ComparisonSide(
    label: 'から',
    description: 'Subjective, casual',
    exampleJp: '疲れたから、休みます。',
    exampleEn: 'I\'m resting because I\'m tired.',
  ),
  right: const ComparisonSide(
    label: 'ので',
    description: 'Objective, polite',
    exampleJp: '雨が降っているので、家にいます。',
    exampleEn: 'I\'m staying home because it\'s raining.',
  ),
)
```

---

### ListBlock

Bulleted or numbered list of grammar points.

```dart
ListBlock(
  style: ListStyle.bullet,
  items: const ['Ends in a u-sound', 'Exception: Group 2 verbs ending in る'],
  accentColor: Colors.indigo,
)
```

---

### TransformCardsBlock

Horizontal set of before/after cards showing a grammatical transformation.

```dart
TransformCardsBlock(
  accentColor: levelColor('N5'),
  groups: [
    TransformGroup(
      label: 'Group 1 Verbs',
      tag: 'う-verbs',
      rule: 'Drop う → add い-stem',
      rows: const [
        TransformRow(
          base: '書く', old: 'く', newSuffix: 'き', result: '書きます',
          romaji: 'kakimasu', english: 'write',
        ),
      ],
    ),
  ],
)
```

---

## navigation/

### AppNavBar

Bottom navigation bar for phone layouts.

```dart
AppNavBar(
  destinations: const [
    NavDestination(label: 'Home',       icon: '家'),
    NavDestination(label: 'Characters', icon: '字'),
    NavDestination(label: 'Grammar',    icon: '文'),
  ],
  selectedIndex: 0,
  onDestinationSelected: (i) {},
)
```

---

### AppNavRail

Side navigation rail for tablet/desktop layouts.

```dart
AppNavRail(
  destinations: const [
    NavDestination(label: 'Home',       icon: '家'),
    NavDestination(label: 'Characters', icon: '字'),
    NavDestination(label: 'Grammar',    icon: '文'),
  ],
  selectedIndex: 1,
  onDestinationSelected: (i) {},
)
```

---

### NavDestination

Data object describing a single nav entry. Consumed by `AppNavBar` and `AppNavRail`.

```dart
const NavDestination(label: 'Home', icon: '家')
const NavDestination(label: 'Characters', iconAsset: 'assets/icons/kanji.svg')
```

---

### NavItem

Individual nav item with active/inactive state styling. Used internally by `AppNavBar`/`AppNavRail`; rarely constructed directly.

```dart
NavItem(
  destination: const NavDestination(label: 'Home', icon: '家'),
  isActive: true,
  onTap: () {},
)
```

---

## settings/

### SettingsCard

Grouped settings section with a title and slotted child tiles.

```dart
SettingsCard(
  children: [
    SettingsToggle(
      icon: Icons.notifications_outlined,
      label: 'Daily reminders',
      value: true,
      onChanged: (v) {},
    ),
    SettingsTile(
      leading: const Icon(Icons.language),
      label: 'Language',
      onTap: () {},
    ),
  ],
)
```

---

### SettingsTile / SettingsToggle / SettingsInfo / SettingsStepper

Single settings row variants. All exported from `settings_tile.dart`.

```dart
// Tappable row with trailing chevron
SettingsTile(leading: const Icon(Icons.language), label: 'Language', onTap: () {})

// Toggle row
SettingsToggle(icon: Icons.volume_up, label: 'Sound effects', value: true, onChanged: (v) {})

// Read-only info row
const SettingsInfo(icon: Icons.info_outline, label: 'Version 1.0.0')

// Stepper row
SettingsStepper(
  icon: Icons.layers_outlined,
  label: 'New cards per day',
  value: 10,
  onDecrement: () {},
  onIncrement: () {},
)
```

---

### SettingsAboutSection / AttributionCard

`SettingsAboutSection` is a `ConsumerWidget` that renders the app version row and a list of `AttributionCard` entries for third-party libraries. `AttributionCard` is a `CardContainer` with a notice text and a tappable URL link.

```dart
// Rendered automatically inside SettingsScreen — no props needed
const SettingsAboutSection()

// Used internally; can also be used standalone:
AttributionCard(
  notice: 'flutter_svg — Apache 2.0',
  link: 'https://github.com/dnfield/flutter_svg',
)
```

---

### SettingsPracticeCard

`ConsumerWidget` that reads SRS settings and renders a `SettingsCard` with steppers for new characters/vocab per day and an MCQ/flashcard toggle. Self-contained — no props.

```dart
const SettingsPracticeCard()
```

---

### LanguagePickerSheet

Bottom sheet for selecting the app language. Renders a list of supported locale codes as tappable tiles; highlights the current selection.

```dart
LanguagePickerSheet(
  title: l.language,
  currentCode: 'en',
  onSelect: (code) => ref.read(localeProvider.notifier).set(code),
)
```

---

## study/

### PracticeModeCard

Tappable card for a single practice mode or feature entry point. Left-side tinted icon box (`color 12% opacity`, `radiusMd`), title, optional subtitle and count label, trailing chevron. Decoration: `cardBackground`, `radiusLg`, accent border at 25% opacity. Shows a `CircularProgressIndicator` when `isCountLoading: true`. All display strings pre-formatted by the caller.

```dart
// With async counts (from FutureBuilder at screen level)
PracticeModeCard(
  title: mode.title,
  icon: mode.icon,
  color: widget.color,
  countLabel: '12 due · 3 new',   // null when no counts loaded yet
  isCountLoading: _isLoading,
  onTap: () async { await mode.onTap(); _refresh(); },
)

// Without counts
PracticeModeCard(
  title: l.japaneseBasics,
  subtitle: l.japaneseBasicsSubtitle,
  icon: Icons.menu_book_rounded,
  color: levelColor('basics'),
  onTap: () => onSelect('basics'),
)
```

---

### ChapterCard

Card showing a chapter label, title, description, lesson count badge, and completion progress bar. All display strings are pre-formatted by the caller — the widget contains no l10n calls.

`isLocked` dims the card to 55% opacity and shows a lock icon instead of the badge pill. The caller handles navigation and any unlock dialog in `onTap`.

```dart
ChapterCard(
  chapterLabel: l.chapterN('02'),        // caller formats
  title: 'Numbers & Time',
  description: 'Count, tell the time, and talk about dates.',
  badge: l.nLessons(10),                 // caller formats
  doneCount: 6,
  totalLessons: 10,
  progressLabel: l.lessonsProgress(6, 10), // caller formats
  accentColor: levelColor('N5'),
  onTap: () {},
)

// Locked chapter
ChapterCard(
  chapterLabel: l.chapterN('03'),
  title: 'Food & Restaurants',
  description: 'Order food and navigate a Japanese restaurant.',
  badge: l.nLessons(7),
  doneCount: 0,
  totalLessons: 7,
  progressLabel: l.lessonsProgress(0, 7),
  accentColor: levelColor('N5'),
  isLocked: true,
  onTap: _showUnlockDialog,
)
```

---

### DomainCard

Large study domain card with gradient, progress bar, due/new counts, and optional practice shortcut.

```dart
DomainCard(
  title: 'Kanji',
  icon: '漢',
  gradientColors: [Colors.indigo, Colors.indigo.withValues(alpha: 0.6)],
  progressColor: Colors.indigo,
  statLabel: '42 / 2136 known',
  progress: 0.02,
  dueCount: 12,
  onTap: () {},
  onPractice: () {},
)
```

---

### LessonRow

List row for a single lesson showing an index number, title, `DifficultyDots`, exercise count chip, and state pill. `state` drives the border colour, chip label/colour, and optional lock icon.

`LearningState.locked` dims the row to 55% opacity and shows a lock chip; the caller supplies the `onTap` that opens an unlock dialog.

```dart
LessonRow(
  title: 'Hiragana basics',
  index: 0,                              // 0-based position shown as "01"
  difficulty: 1,                         // 1–3 dots
  state: LearningState.notStarted,
  accentColor: levelColor('N5'),
  exerciseCount: 3,                      // 0 = chip not shown
  onTap: () {},
)

// Locked lesson — caller handles unlock dialog
LessonRow(
  title: 'Complex grammar patterns',
  index: 11,
  difficulty: 3,
  state: LearningState.locked,
  accentColor: levelColor('N4'),
  exerciseCount: 0,
  onTap: () => _showUnlockDialog(lesson),
)
```

---

### StudyGroupCard

Tappable card for selecting a study group. Shows a group title, a range/count label, an `AppProgressBar`, and a trailing chevron. Decoration: `cardBackground`, `radiusLg`, accent-coloured border at 20% opacity. All display strings are pre-formatted by the caller.

```dart
StudyGroupCard(
  title: l.groupN(i + 1),                          // caller formats
  rangeLabel: '${start + 1}–$end · $learned / $total', // caller formats
  progress: learned / total,
  color: levelColor('N5'),
  onTap: () => selectGroup(i),
)
```

---

### StreakCard

Gradient card displaying the user's current study streak in days.

```dart
StreakCard(days: 14, label: 'day streak', subtitle: 'Keep it up!')
```

---

### HomeHeader

Greeting banner at the top of the home screen. Displays a pre-formatted greeting and subtitle string.

```dart
HomeHeader(greeting: l.goodMorning(name), subtitle: l.homeSubtitle)
```

---

### HomeDomainCards

Grid of `DomainCard` entries for the home screen (kana, kanji, vocab, grammar). All counts pre-resolved by the caller.

```dart
HomeDomainCards(
  totalKana: 92, totalKanji: 2136, totalVocab: 8000,
  kanaDue: 3, kanaNew: 5,
  kanjiDue: 12, kanjiNew: 8,
  vocabDue: 0, vocabNew: 10,
  onKanaTap: () {}, onKanjiTap: () {}, onVocabTap: () {}, onGrammarTap: () {},
  onKanaPractice: () {}, onKanjiPractice: () {}, onVocabPractice: () {},
)
```

---

### GrammarChapterList

Scrollable list of `ChapterCard` entries for a given JLPT level. Watches `grammarThemesProvider` internally, resolves unlock/progress state, and calls `onBack` when the user presses the back button.

```dart
GrammarChapterList(
  level: 'N5',
  onBack: () => ref.read(grammarSelectedLevelProvider.notifier).clear(),
)
```

---

### VocabWordTile

Expandable vocabulary list row. Shows word, reading, abbreviated meaning. Tap expands to full meaning, part-of-speech chips, and `SpeakButton`. Localized meaning fetched via provider.

```dart
VocabWordTile(entry: vocabEntry)
```

---

### VocabLevelSelector

Full-screen-width list of JLPT level tiles. Tapping a level calls `onSelect`.

```dart
VocabLevelSelector(onSelect: (level) => selectLevel(level))
```

---

### VocabGroupSelector

Shows a `SectionLabel` header and a list of `StudyGroupCard` tiles for pagination within a vocab level. `kVocabGroupSize` groups of 30 words each.

```dart
VocabGroupSelector(
  level: 'N5',
  onBack: () {},
  onSelect: (groupIndex) => selectGroup(groupIndex),
)
```

---

### VocabLevelView

Shows the vocabulary word list for one paginated group within a level. Fetches entries via `vocabByLevelProvider`, renders `VocabWordTile` rows, and shows learned-count progress.

```dart
VocabLevelView(level: 'N5', groupIndex: 0, onBack: () {})
```

---

### KanjiLevelSelector

Full-screen list of JLPT level tiles for the kanji section. Tapping a level calls `onSelect`.

```dart
KanjiLevelSelector(onSelect: (level) => selectLevel(level))
```

---

### KanjiGroupSelector

Shows group cards for one kanji JLPT level with SRS progress. Navigates into `KanjiGroupView` on tap; back button calls `onBack`.

```dart
KanjiGroupSelector(level: 'N5', onBack: () {})
```

---

### KanjiGroupView

Shows `KanjiLevelHeader`, `KanjiGrid`, and practice/writing-session shortcuts for a single kanji group.

```dart
KanjiGroupView(level: 'N5', groupIndex: 0, onBack: () {})
```
