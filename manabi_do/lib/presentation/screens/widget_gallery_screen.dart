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
  const _GallerySection({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelSmall.copyWith(
            color: context.tokens.onSurfaceVariant,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        child,
      ],
    );
  }
}

const _gap = SizedBox(height: AppDimens.spaceLg);
const _hpad = EdgeInsets.symmetric(horizontal: AppDimens.spaceMd, vertical: AppDimens.spaceMd);

// ── Common tab ────────────────────────────────────────────────────────────────

class _CommonTab extends StatefulWidget {
  const _CommonTab();

  @override
  State<_CommonTab> createState() => _CommonTabState();
}

class _CommonTabState extends State<_CommonTab> {
  bool _isKnown = false;
  bool _chip1 = true;
  bool _chip2 = false;
  bool _chip3 = true;
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: _hpad,
      children: [
        _GallerySection(
          label: 'AppButton',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(spacing: 8, runSpacing: 8, children: [
                AppButton(label: 'Start Lesson'),
                AppButton(label: 'Practice', variant: AppButtonVariant.tonal),
                AppButton(label: 'View All', variant: AppButtonVariant.outlined),
                AppButton(label: 'Skip', variant: AppButtonVariant.text),
                AppButton(label: 'Reset', variant: AppButtonVariant.danger),
              ]),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                AppButton(label: 'Small', size: AppButtonSize.small),
                AppButton(label: 'N5', variant: AppButtonVariant.tonal, size: AppButtonSize.small),
                AppButton(
                  label: 'With icon',
                  icon: const Icon(Icons.play_arrow, size: 16),
                ),
              ]),
            ],
          ),
        ),
        _gap,

        _GallerySection(
          label: 'AppFilterChip',
          child: Wrap(spacing: 8, runSpacing: 8, children: [
            AppFilterChip(label: 'All',        isActive: _chip1, onTap: () => setState(() => _chip1 = !_chip1)),
            AppFilterChip(label: 'N5',         isActive: _chip2, onTap: () => setState(() => _chip2 = !_chip2)),
            AppFilterChip(label: 'Verbs',      isActive: _chip3, onTap: () => setState(() => _chip3 = !_chip3)),
            const AppFilterChip(label: 'Adjectives'),
            const AppFilterChip(label: 'Particles'),
          ]),
        ),
        _gap,

        _GallerySection(
          label: 'AppTextField',
          child: Column(children: [
            AppTextField(
              label: 'Search',
              controller: _textController,
              hint: 'e.g. 食べる',
              prefixIcon: const Icon(Icons.search),
            ),
            const SizedBox(height: 8),
            const AppTextField(
              label: 'Disabled',
              hint: 'Cannot edit',
              enabled: false,
            ),
          ]),
        ),
        _gap,

        _GallerySection(
          label: 'KnownToggle',
          child: Row(spacing: 12, children: [
            KnownToggle(isKnown: _isKnown, onTap: () => setState(() => _isKnown = !_isKnown)),
            KnownToggle(isKnown: true,  onTap: () {}),
            KnownToggle(isKnown: false, onTap: () {}),
          ]),
        ),
        _gap,

        _GallerySection(
          label: 'ProgressBar & ProgressRow',
          child: Column(children: [
            const AppProgressBar(progress: 0.65),
            const SizedBox(height: 8),
            AppProgressBar(progress: 0.3, color: context.tokens.characters),
            const SizedBox(height: 12),
            const ProgressRow(known: 32, total: 80),
            const SizedBox(height: 4),
            ProgressRow(known: 46, total: 184, color: context.tokens.characters),
          ]),
        ),
        _gap,

        _GallerySection(
          label: 'PracticeButton',
          child: Column(children: [
            for (final level in ['N5', 'N4', 'N3', 'N2', 'N1']) ...[
              PracticeButton(color: levelColor(level)),
              const SizedBox(height: 4),
            ],
          ]),
        ),
        _gap,

        _GallerySection(
          label: 'SectionLabel',
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionLabel('Readings'),
            const SizedBox(height: 8),
            const SectionLabel('Stroke Order'),
            const SizedBox(height: 8),
            const SectionLabel('Example Words'),
          ]),
        ),
        _gap,

        _GallerySection(
          label: 'AppEmoji',
          child: Wrap(spacing: 12, children: const [
            AppEmoji('🔥', size: 32),
            AppEmoji('⭐', size: 32),
            AppEmoji('✅', size: 32),
            AppEmoji('🎌', size: 32),
          ]),
        ),
        _gap,
      ],
    );
  }
}

// ── Study tab ─────────────────────────────────────────────────────────────────

class _StudyTab extends StatelessWidget {
  const _StudyTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: _hpad,
      children: [
        _GallerySection(
          label: 'SectionCard',
          child: Column(children: [
            SectionCard(
              title: context.l10n.sectionGrammar,
              icon: '文',
              gradientColors: [context.tokens.primary, context.tokens.primaryLight],
              progressColor: context.tokens.primary,
              subtitle: '17 chapters · N5/N4',
              statLabel: '3 / 17 chapters completed',
              progress: 0.18,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            SectionCard(
              title: context.l10n.sectionCharacters,
              icon: '字',
              gradientColors: [context.tokens.charactersDark, context.tokens.characters],
              progressColor: context.tokens.characters,
              subtitle: 'Kana · Kanji N5–N1',
              statLabel: '46 / 184 known',
              progress: 0.25,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            SectionCard(
              title: context.l10n.sectionVocabulary,
              icon: '語',
              gradientColors: [context.tokens.vocabularyDark, context.tokens.vocabulary],
              progressColor: context.tokens.vocabulary,
              subtitle: '800+ words · N5/N4',
              statLabel: '120 / 800 known',
              progress: 0.15,
              onTap: () {},
            ),
          ]),
        ),
        _gap,

        const _GallerySection(
          label: 'StreakCard',
          child: StreakCard(days: 7),
        ),
        _gap,

        _GallerySection(
          label: 'ChapterCard',
          child: Column(children: [
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
          ]),
        ),
        _gap,

        const _GallerySection(
          label: 'LessonRow',
          child: Column(children: [
            LessonRow(title: 'Verb Groups',       difficulty: 2, status: LessonStatus.done),
            SizedBox(height: 8),
            LessonRow(title: 'Polite Form (ます)', difficulty: 1, status: LessonStatus.done),
            SizedBox(height: 8),
            LessonRow(title: 'て-form',           difficulty: 3, status: LessonStatus.notStarted),
          ]),
        ),
        _gap,
      ],
    );
  }
}

// ── Characters tab ────────────────────────────────────────────────────────────

class _CharactersTab extends StatefulWidget {
  const _CharactersTab();

  @override
  State<_CharactersTab> createState() => _CharactersTabState();
}

class _CharactersTabState extends State<_CharactersTab> {
  // Unicode codepoint of 食 — a common kanji with a clear stroke order
  static const _demoKanjiId = 39135;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: _hpad,
      children: [
        _GallerySection(
          label: 'KanaCell',
          child: Wrap(spacing: 8, runSpacing: 8, children: const [
            KanaCell(kana: 'あ', romaji: 'a', isKnown: true),
            KanaCell(kana: 'い', romaji: 'i', isKnown: true),
            KanaCell(kana: 'う', romaji: 'u', isKnown: true),
            KanaCell(kana: 'え', romaji: 'e'),
            KanaCell(kana: 'お', romaji: 'o'),
            KanaCell(kana: 'か', romaji: 'ka'),
            KanaCell(kana: 'き', romaji: 'ki'),
          ]),
        ),
        _gap,

        _GallerySection(
          label: 'KanjiCell',
          child: Wrap(spacing: 8, runSpacing: 8, children: const [
            KanjiCell(character: '食', isKnown: true),
            KanjiCell(character: '水', isKnown: true),
            KanjiCell(character: '火', isKnown: false),
            KanjiCell(character: '山', isKnown: false),
            KanjiCell(character: '川', isKnown: false),
          ]),
        ),
        _gap,

        const _GallerySection(
          label: 'StrokeOrderAnimator',
          child: StrokeOrderAnimator(kanjiId: _demoKanjiId),
        ),
        _gap,

        const _GallerySection(
          label: 'StrokeStepRow',
          child: StrokeStepRow(kanjiId: _demoKanjiId),
        ),
        _gap,
      ],
    );
  }
}

// ── Exercise tab ──────────────────────────────────────────────────────────────

class _ExerciseTab extends StatefulWidget {
  const _ExerciseTab();

  @override
  State<_ExerciseTab> createState() => _ExerciseTabState();
}

class _ExerciseTabState extends State<_ExerciseTab> {
  int _mcqSelected = -1;
  bool _flashRevealed = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: _hpad,
      children: [
        _GallerySection(
          label: 'FlashCard',
          child: Column(children: [
            FlashCard(
              japanese: '食べる',
              isRevealed: _flashRevealed,
              answer: 'to eat',
              onTap: () => setState(() => _flashRevealed = !_flashRevealed),
            ),
            const SizedBox(height: 8),
            FlashCardActions(
              notYetLabel: context.l10n.flashcardNotYet,
              gotItLabel: context.l10n.flashcardGotIt,
              onNotYet: () => setState(() => _flashRevealed = false),
              onGotIt:  () => setState(() => _flashRevealed = false),
            ),
          ]),
        ),
        _gap,

        _GallerySection(
          label: 'McqCard',
          child: McqCard(
            question: 'What is the て-form of 書く?',
            japanesePrompt: '書く → ？',
            options: [
              McqOption(letter: 'A', text: '書きて', useJpFont: true),
              McqOption(letter: 'B', text: '書いて ✓', useJpFont: true,
                  state: _mcqSelected == 1 ? McqOptionState.correct : McqOptionState.idle),
              McqOption(letter: 'C', text: '書って ✗', useJpFont: true,
                  state: _mcqSelected == 2 ? McqOptionState.wrong : McqOptionState.idle),
              McqOption(letter: 'D', text: '書んで', useJpFont: true),
            ],
            onOptionTap: (i) => setState(() => _mcqSelected = i),
          ),
        ),
        _gap,

        _GallerySection(
          label: 'SummaryCard',
          child: SummaryCard(
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
          ),
        ),
        _gap,

        _GallerySection(
          label: 'LessonReaderCard',
          child: LessonReaderCard(
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
          ),
        ),
        _gap,
      ],
    );
  }
}

// ── Navigation tab ────────────────────────────────────────────────────────────

class _NavTab extends StatefulWidget {
  const _NavTab();

  @override
  State<_NavTab> createState() => _NavTabState();
}

class _NavTabState extends State<_NavTab> {
  int _navIndex = 0;

  List<NavDestination> _destinations(BuildContext context) {
    final l = context.l10n;
    return [
      NavDestination(label: l.sectionCharacters, icon: '字'),
      NavDestination(label: l.sectionVocabulary, icon: '語'),
      NavDestination(label: l.sectionGrammar,    icon: '文'),
      NavDestination(label: l.navMore,           icon: '☰'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: _hpad,
      children: [
        _GallerySection(
          label: 'AppNavBar',
          child: AppNavBar(
            destinations: _destinations(context),
            selectedIndex: _navIndex,
            onDestinationSelected: (i) => setState(() => _navIndex = i),
          ),
        ),
        _gap,

        _GallerySection(
          label: 'AppNavRail',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppNavRail(
                destinations: _destinations(context),
                selectedIndex: _navIndex,
                onDestinationSelected: (i) => setState(() => _navIndex = i),
              ),
            ],
          ),
        ),
        _gap,

        _GallerySection(
          label: 'SegmentedTabBar',
          child: SegmentedTabBar(
            tabs: const ['Tab A', 'Tab B', 'Tab C'],
            selectedIndex: _navIndex % 3,
            onTabSelected: (i) => setState(() => _navIndex = i),
          ),
        ),
        _gap,
      ],
    );
  }
}
