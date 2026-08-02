# Widget Catalogue — Manabi Do

All widgets live under `lib/presentation/widgets/`. Each widget is a pure presentational unit — it renders what it is given. Decisions about visibility, settings, and state belong to the caller (screen or body widget), not to the widget itself.

The one explicit exception is `SpeakButton`, which reads `ttsProvider` to trigger a TTS action — a service action, not a display setting.

---

## common/

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

### ChapterListView

Scrollable list of chapter items with a title and dividers.

```dart
ChapterListView(
  title: 'N5 Grammar',
  sectionLabel: 'Chapters',
  items: const ['Greetings', 'Numbers', 'Time'],
  accentColor: Colors.blue,
  onBack: () {},
  onItemTap: (index) {},
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

### JlptLevelCard

Compact badge showing a JLPT level (N1–N5) in brand colours.

```dart
JlptLevelCard(code: 'N5', subtitle: '100 kanji', onTap: () {})
```

---

### NumberBadge

Small circular badge with a number, used for due/new counts.

```dart
NumberBadge(number: 3, color: Colors.blue)
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

### SectionLabel

Small all-caps label used above content groups.

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

## characters/

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

## study/

### ChapterCard

Card showing chapter number, title, description, lesson count, and completion progress.

```dart
ChapterCard(
  chapterNumber: 2,
  title: 'Numbers & Time',
  description: 'Count, tell the time, and talk about dates.',
  totalLessons: 10,
  completedLessons: 6,
  onTap: () {},
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

List row for a single lesson with title, difficulty dots, status pill, and tap handler.

```dart
LessonRow(
  title: 'Hiragana basics',
  difficulty: 1,               // 1–3
  status: LessonStatus.done,
  lessonNumber: 1,
  onTap: () {},
)
```

---

### StreakCard

Gradient card displaying the user's current study streak in days.

```dart
StreakCard(days: 14, label: 'day streak', subtitle: 'Keep it up!')
```
