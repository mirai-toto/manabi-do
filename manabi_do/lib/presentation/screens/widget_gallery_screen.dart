import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/jlpt_level.dart';
import '../../domain/entities/lesson_status.dart';
import '../../l10n/l10n.dart';
import '../widgets/widgets.dart';

// ── Main screen ───────────────────────────────────────────────────────────────

class WidgetGalleryScreen extends ConsumerStatefulWidget {
  const WidgetGalleryScreen({super.key});

  @override
  ConsumerState<WidgetGalleryScreen> createState() => _WidgetGalleryScreenState();
}

class _WidgetGalleryScreenState extends ConsumerState<WidgetGalleryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  static const _tabLabels = ['Common', 'Study', 'Characters', 'Exercise', 'Nav'];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _tabLabels.length, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Scaffold(
      backgroundColor: t.surfaceContainer,
      appBar: AppBar(
        backgroundColor: t.surfaceContainer,
        elevation: 0,
        title: Text('Widget Gallery', style: AppTextStyles.title),
        actions: [
          IconButton(
            icon: Text(
              ref.watch(localeProvider).languageCode == 'en' ? '🇫🇷' : '🇬🇧',
              style: const TextStyle(fontSize: 20),
            ),
            onPressed: () => ref.read(localeProvider.notifier).toggle(),
          ),
          IconButton(
            icon: Icon(
              ref.watch(themeModeProvider) == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [for (final label in _tabLabels) Tab(text: label)],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _CommonTab(),
          _StudyTab(),
          _CharactersTab(),
          _ExerciseTab(),
          _NavTab(),
        ],
      ),
    );
  }
}

// ── Shared gallery primitives ─────────────────────────────────────────────────

class _GallerySection extends StatelessWidget {
  final String label;
  final Widget child;
  final bool interactive;
  const _GallerySection({required this.label, required this.child, this.interactive = false});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8,
          children: [
            Text(
              label.toUpperCase(),
              style: AppTextStyles.labelSmall.copyWith(
                color: t.onSurfaceVariant,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (interactive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: t.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'LIVE',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: t.success,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceSm),
        child,
      ],
    );
  }
}

const _gap  = SizedBox(height: AppDimens.spaceLg);
const _hpad = EdgeInsets.symmetric(horizontal: AppDimens.spaceMd, vertical: AppDimens.spaceMd);

// ── Common tab ────────────────────────────────────────────────────────────────

class _CommonTab extends StatelessWidget {
  const _CommonTab();

  @override
  Widget build(BuildContext context) => ListView(padding: _hpad, children: const [
    _GallerySection(label: 'AppButton',      child: _DemoAppButtons()),
    _gap,
    _GallerySection(label: 'AppFilterChip',  interactive: true, child: _LiveFilterChips()),
    _gap,
    _GallerySection(label: 'AppFilterChip (disabled)', child: _DemoFilterChipsDisabled()),
    _gap,
    _GallerySection(label: 'AppTextField',   interactive: true, child: _LiveTextField()),
    _gap,
    _GallerySection(label: 'KnownToggle',    interactive: true, child: _LiveKnownToggle()),
    _gap,
    _GallerySection(label: 'ProgressBar & ProgressRow', child: _DemoProgress()),
    _gap,
    _GallerySection(label: 'PracticeButton', interactive: true, child: _DemoPracticeButtons()),
    _gap,
    _GallerySection(label: 'SectionLabel',   child: _DemoSectionLabels()),
    _gap,
    _GallerySection(label: 'AppEmoji',       child: _DemoAppEmoji()),
    _gap,
  ]);
}

class _DemoAppButtons extends StatelessWidget {
  const _DemoAppButtons();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(spacing: 8, runSpacing: 8, children: [
        AppButton(label: 'Start Lesson', onPressed: () {}),
        AppButton(label: 'Practice',  variant: AppButtonVariant.tonal,    onPressed: () {}),
        AppButton(label: 'View All',  variant: AppButtonVariant.outlined, onPressed: () {}),
        AppButton(label: 'Skip',      variant: AppButtonVariant.text,     onPressed: () {}),
        AppButton(label: 'Reset',     variant: AppButtonVariant.danger,   onPressed: () {}),
      ]),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: [
        AppButton(label: 'Small',      size: AppButtonSize.small, onPressed: () {}),
        AppButton(label: 'N5',         variant: AppButtonVariant.tonal, size: AppButtonSize.small, onPressed: () {}),
        AppButton(label: 'With icon',  icon: const Icon(Icons.play_arrow, size: 16), onPressed: () {}),
      ]),
      const SizedBox(height: 8),
      const Wrap(spacing: 8, runSpacing: 8, children: [
        AppButton(label: 'Disabled filled'),
        AppButton(label: 'Disabled tonal',    variant: AppButtonVariant.tonal),
        AppButton(label: 'Disabled outlined', variant: AppButtonVariant.outlined),
      ]),
    ],
  );
}

class _LiveFilterChips extends StatefulWidget {
  const _LiveFilterChips();
  @override
  State<_LiveFilterChips> createState() => _LiveFilterChipsState();
}

class _LiveFilterChipsState extends State<_LiveFilterChips> {
  static const _labels = ['All', 'N5', 'Verbs', 'Adjectives', 'Particles'];
  final _active = [true, false, true, false, false];

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8, runSpacing: 8,
    children: [
      for (final (i, label) in _labels.indexed)
        AppFilterChip(
          label: label,
          isActive: _active[i],
          onTap: () => setState(() => _active[i] = !_active[i]),
        ),
    ],
  );
}

class _DemoFilterChipsDisabled extends StatelessWidget {
  const _DemoFilterChipsDisabled();
  @override
  Widget build(BuildContext context) => const Wrap(
    spacing: 8, runSpacing: 8,
    children: [
      AppFilterChip(label: 'All',        isActive: true),
      AppFilterChip(label: 'N5'),
      AppFilterChip(label: 'Verbs'),
      AppFilterChip(label: 'Adjectives', isActive: true),
    ],
  );
}

class _LiveTextField extends StatefulWidget {
  const _LiveTextField();
  @override
  State<_LiveTextField> createState() => _LiveTextFieldState();
}

class _LiveTextFieldState extends State<_LiveTextField> {
  final _controller = TextEditingController();

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Column(children: [
    AppTextField(
      label: 'Search',
      controller: _controller,
      hint: 'e.g. 食べる',
      prefixIcon: const Icon(Icons.search),
    ),
    const SizedBox(height: 8),
    const AppTextField(label: 'Disabled', hint: 'Cannot edit', enabled: false),
  ]);
}

class _LiveKnownToggle extends StatefulWidget {
  const _LiveKnownToggle();
  @override
  State<_LiveKnownToggle> createState() => _LiveKnownToggleState();
}

class _LiveKnownToggleState extends State<_LiveKnownToggle> {
  bool _known = false;

  @override
  Widget build(BuildContext context) => Row(spacing: 12, children: [
    KnownToggle(isKnown: _known, onTap: () => setState(() => _known = !_known)),
    KnownToggle(isKnown: true,  onTap: () {}),
    KnownToggle(isKnown: false, onTap: () {}),
  ]);
}

class _DemoProgress extends StatelessWidget {
  const _DemoProgress();
  @override
  Widget build(BuildContext context) => Column(children: [
    const AppProgressBar(progress: 0.65),
    const SizedBox(height: 8),
    AppProgressBar(progress: 0.3, color: context.tokens.characters),
    const SizedBox(height: 12),
    const ProgressRow(known: 32, total: 80),
    const SizedBox(height: 4),
    ProgressRow(known: 46, total: 184, color: context.tokens.characters),
  ]);
}

class _DemoPracticeButtons extends StatelessWidget {
  const _DemoPracticeButtons();
  @override
  Widget build(BuildContext context) => Column(children: [
    for (final level in ['N5', 'N4', 'N3', 'N2', 'N1']) ...[
      PracticeButton(color: levelColor(level)),
      const SizedBox(height: 4),
    ],
  ]);
}

class _DemoSectionLabels extends StatelessWidget {
  const _DemoSectionLabels();
  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionLabel('Readings'),
      SizedBox(height: 8),
      SectionLabel('Stroke Order'),
      SizedBox(height: 8),
      SectionLabel('Example Words'),
    ],
  );
}

class _DemoAppEmoji extends StatelessWidget {
  const _DemoAppEmoji();
  @override
  Widget build(BuildContext context) => const Wrap(spacing: 12, children: [
    AppEmoji('🔥', size: 32),
    AppEmoji('⭐', size: 32),
    AppEmoji('✅', size: 32),
    AppEmoji('🎌', size: 32),
  ]);
}

// ── Study tab ─────────────────────────────────────────────────────────────────

class _StudyTab extends StatelessWidget {
  const _StudyTab();

  @override
  Widget build(BuildContext context) => ListView(padding: _hpad, children: const [
    _GallerySection(label: 'SectionCard',  child: _DemoSectionCards()),
    _gap,
    _GallerySection(label: 'StreakCard',   child: StreakCard(days: 7, label: '🔥 Streak', subtitle: 'Keep it up!')),
    _gap,
    _GallerySection(label: 'ChapterCard',  child: _DemoChapterCards()),
    _gap,
    _GallerySection(label: 'LessonRow',    child: _DemoLessonRows()),
    _gap,
  ]);
}

class _DemoSectionCards extends StatelessWidget {
  const _DemoSectionCards();
  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    return Column(children: [
      SectionCard(
        title: l.sectionGrammar,
        icon: '文',
        gradientColors: [t.primary, t.primaryLight],
        progressColor: t.primary,
        subtitle: '17 chapters · N5/N4',
        statLabel: '3 / 17 chapters completed',
        progress: 0.18,
        onTap: () {},
      ),
      const SizedBox(height: 10),
      SectionCard(
        title: l.sectionCharacters,
        icon: '字',
        gradientColors: [t.charactersDark, t.characters],
        progressColor: t.characters,
        subtitle: 'Kana · Kanji N5–N1',
        statLabel: '46 / 184 known',
        progress: 0.25,
        onTap: () {},
      ),
      const SizedBox(height: 10),
      SectionCard(
        title: l.sectionVocabulary,
        icon: '語',
        gradientColors: [t.vocabularyDark, t.vocabulary],
        progressColor: t.vocabulary,
        subtitle: '800+ words · N5/N4',
        statLabel: '120 / 800 known',
        progress: 0.15,
        onTap: () {},
      ),
    ]);
  }
}

class _DemoChapterCards extends StatelessWidget {
  const _DemoChapterCards();
  @override
  Widget build(BuildContext context) => Column(children: [
    ChapterCard(
      chapterNumber: 1,
      title: 'Verbs',
      description: 'Verb groups, base forms, polite conjugations and て-form.',
      totalLessons: 5,
      completedLessons: 3,
      onTap: () {},
    ),
    const SizedBox(height: 10),
    ChapterCard(
      chapterNumber: 2,
      title: 'Directions & Places',
      description: 'Spatial particles, location nouns, and directional expressions.',
      totalLessons: 3,
      completedLessons: 0,
      onTap: () {},
    ),
  ]);
}

class _DemoLessonRows extends StatelessWidget {
  const _DemoLessonRows();
  @override
  Widget build(BuildContext context) => const Column(children: [
    LessonRow(title: 'Verb Groups',       difficulty: 2, status: LessonStatus.done),
    SizedBox(height: 8),
    LessonRow(title: 'Polite Form (ます)', difficulty: 1, status: LessonStatus.done),
    SizedBox(height: 8),
    LessonRow(title: 'て-form',           difficulty: 3, status: LessonStatus.notStarted),
  ]);
}

// ── Characters tab ────────────────────────────────────────────────────────────

const _demoKanjiId = 39135; // 食

class _CharactersTab extends StatelessWidget {
  const _CharactersTab();

  @override
  Widget build(BuildContext context) => ListView(padding: _hpad, children: const [
    _GallerySection(label: 'CharacterCell (kana)',  child: _DemoKanaCells()),
    _gap,
    _GallerySection(label: 'CharacterCell (kanji)', child: _DemoKanjiCells()),
    _gap,
    _GallerySection(label: 'StrokeOrderAnimator', interactive: true, child: StrokeOrderAnimator(kanjiId: _demoKanjiId)),
    _gap,
    _GallerySection(label: 'StrokeStepRow',       interactive: true, child: StrokeStepRow(kanjiId: _demoKanjiId)),
    _gap,
  ]);
}

class _DemoKanaCells extends StatelessWidget {
  const _DemoKanaCells();
  @override
  Widget build(BuildContext context) => const Wrap(spacing: 8, runSpacing: 8, children: [
    CharacterCell(character: 'あ', subLabel: 'a',  isKnown: true),
    CharacterCell(character: 'い', subLabel: 'i',  isKnown: true),
    CharacterCell(character: 'う', subLabel: 'u',  isKnown: true),
    CharacterCell(character: 'え', subLabel: 'e'),
    CharacterCell(character: 'お', subLabel: 'o'),
    CharacterCell(character: 'か', subLabel: 'ka'),
    CharacterCell(character: 'き', subLabel: 'ki'),
  ]);
}

class _DemoKanjiCells extends StatelessWidget {
  const _DemoKanjiCells();
  @override
  Widget build(BuildContext context) => const Wrap(spacing: 8, runSpacing: 8, children: [
    CharacterCell(character: '食', isKnown: true),
    CharacterCell(character: '水', isKnown: true),
    CharacterCell(character: '火'),
    CharacterCell(character: '山'),
    CharacterCell(character: '川'),
  ]);
}

// ── Exercise tab ──────────────────────────────────────────────────────────────

class _ExerciseTab extends StatelessWidget {
  const _ExerciseTab();

  @override
  Widget build(BuildContext context) => ListView(padding: _hpad, children: const [
    _GallerySection(label: 'FlashCard',        interactive: true, child: _LiveFlashCard()),
    _gap,
    _GallerySection(label: 'McqCard',          interactive: true, child: _LiveMcqCard()),
    _gap,
    _GallerySection(label: 'SummaryCard',      child: _DemoSummaryCard()),
    _gap,
    _GallerySection(label: 'LessonReaderCard', child: _DemoLessonReaderCard()),
    _gap,
  ]);
}

class _LiveFlashCard extends StatefulWidget {
  const _LiveFlashCard();
  @override
  State<_LiveFlashCard> createState() => _LiveFlashCardState();
}

class _LiveFlashCardState extends State<_LiveFlashCard> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) => Column(children: [
    FlashCard(
      japanese: '食べる',
      isRevealed: _revealed,
      answer: 'to eat',
      onTap: () => setState(() => _revealed = !_revealed),
    ),
    const SizedBox(height: 8),
    FlashCardActions(
      notYetLabel: context.l10n.flashcardNotYet,
      gotItLabel: context.l10n.flashcardGotIt,
      onNotYet: () => setState(() => _revealed = false),
      onGotIt:  () => setState(() => _revealed = false),
    ),
  ]);
}

class _LiveMcqCard extends StatefulWidget {
  const _LiveMcqCard();
  @override
  State<_LiveMcqCard> createState() => _LiveMcqCardState();
}

class _LiveMcqCardState extends State<_LiveMcqCard> {
  int _selected = -1;

  @override
  Widget build(BuildContext context) => McqCard(
    question: 'What is the て-form of 書く?',
    japanesePrompt: '書く → ？',
    options: [
      McqOption(letter: 'A', text: '書きて', useJpFont: true),
      McqOption(letter: 'B', text: '書いて ✓', useJpFont: true,
          state: _selected == 1 ? McqOptionState.correct : McqOptionState.idle),
      McqOption(letter: 'C', text: '書って ✗', useJpFont: true,
          state: _selected == 2 ? McqOptionState.wrong   : McqOptionState.idle),
      McqOption(letter: 'D', text: '書んで', useJpFont: true),
    ],
    onOptionTap: (i) => setState(() => _selected = i),
  );
}

class _DemoSummaryCard extends StatelessWidget {
  const _DemoSummaryCard();
  @override
  Widget build(BuildContext context) => SummaryCard(
    score: 8,
    total: 10,
    title: 'Lesson Complete!',
    subtitle: 'て-form · Chapter 01',
    correct: 8,
    missed: 2,
    markedKnown: 5,
    timeSpent: '2m',
    onRetry: () {},
    onNext: () {},
  );
}

class _DemoLessonReaderCard extends StatelessWidget {
  const _DemoLessonReaderCard();
  @override
  Widget build(BuildContext context) => LessonReaderCard(
    chapterLabel: 'Chapter 01 · Verbs',
    title: 'て-form Conjugation',
    body: const [
      ReaderBodyText('The て-form is one of the most important verb forms in Japanese.'),
      ReaderSectionTitle('Group 1 verbs (godan)'),
      ReaderJpExample(japanese: '書く → 書いて', translation: 'kaku → kaite'),
      ReaderJpExample(japanese: '飲む → 飲んで', translation: 'nomu → nonde'),
      ReaderSectionTitle('Group 2 verbs (ichidan)'),
      ReaderJpExample(japanese: '食べる → 食べて', translation: 'taberu → tabete'),
    ],
    onPractice: () {},
  );
}

// ── Navigation tab ────────────────────────────────────────────────────────────

class _NavTab extends StatelessWidget {
  const _NavTab();

  @override
  Widget build(BuildContext context) => ListView(padding: _hpad, children: const [
    _GallerySection(label: 'AppNavBar',       interactive: true, child: _LiveNavBar()),
    _gap,
    _GallerySection(label: 'AppNavRail',      interactive: true, child: _LiveNavRail()),
    _gap,
    _GallerySection(label: 'SegmentedTabBar', interactive: true, child: _LiveSegmentedTabBar()),
    _gap,
  ]);
}

class _LiveNavBar extends StatefulWidget {
  const _LiveNavBar();
  @override
  State<_LiveNavBar> createState() => _LiveNavBarState();
}

class _LiveNavBarState extends State<_LiveNavBar> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppNavBar(
      destinations: [
        NavDestination(label: l.sectionCharacters, icon: '字'),
        NavDestination(label: l.sectionVocabulary, icon: '語'),
        NavDestination(label: l.sectionGrammar,    icon: '文'),
        NavDestination(label: l.navMore,           icon: '☰'),
      ],
      selectedIndex: _index,
      onDestinationSelected: (i) => setState(() => _index = i),
    );
  }
}

class _LiveNavRail extends StatefulWidget {
  const _LiveNavRail();
  @override
  State<_LiveNavRail> createState() => _LiveNavRailState();
}

class _LiveNavRailState extends State<_LiveNavRail> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppNavRail(
          destinations: [
            NavDestination(label: l.sectionCharacters, icon: '字'),
            NavDestination(label: l.sectionVocabulary, icon: '語'),
            NavDestination(label: l.sectionGrammar,    icon: '文'),
            NavDestination(label: l.navMore,           icon: '☰'),
          ],
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
        ),
      ],
    );
  }
}

class _LiveSegmentedTabBar extends StatefulWidget {
  const _LiveSegmentedTabBar();
  @override
  State<_LiveSegmentedTabBar> createState() => _LiveSegmentedTabBarState();
}

class _LiveSegmentedTabBarState extends State<_LiveSegmentedTabBar>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SegmentedTabBar(
    controller: _controller,
    labels: const ['Tab A', 'Tab B', 'Tab C'],
  );
}
