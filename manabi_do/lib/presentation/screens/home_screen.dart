import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/lesson_status.dart';
import '../../l10n/l10n.dart';
import '../widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isKnown = false;
  bool _chip1 = true;
  bool _chip2 = false;
  bool _chip3 = true;
  int _navIndex = 0;
  int _mcqSelected = -1;
  bool _flashRevealed = false;
  final _textController = TextEditingController();

  List<NavDestination> _navDestinations(BuildContext context) {
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
    return Scaffold(
      backgroundColor: context.tokens.surfaceContainer,
      appBar: AppBar(
        backgroundColor: context.tokens.surfaceContainer,
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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          _SectionLabel('Buttons'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppButton(label: 'Start Lesson'),
              AppButton(label: 'Practice', variant: AppButtonVariant.tonal),
              AppButton(label: 'View All', variant: AppButtonVariant.outlined),
              AppButton(label: 'Skip', variant: AppButtonVariant.text),
              AppButton(label: 'Reset', variant: AppButtonVariant.danger),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppButton(label: 'Continue', size: AppButtonSize.small),
              AppButton(label: 'N5', variant: AppButtonVariant.tonal, size: AppButtonSize.small),
              AppButton(label: 'N4', variant: AppButtonVariant.tonal, size: AppButtonSize.small),
              AppButton(
                label: 'With icon',
                icon: const Icon(Icons.play_arrow, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 32),

          _SectionLabel('Filter Chips'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppFilterChip(label: 'All', isActive: _chip1, onTap: () => setState(() => _chip1 = !_chip1)),
              AppFilterChip(label: 'N5', isActive: _chip2, onTap: () => setState(() => _chip2 = !_chip2)),
              AppFilterChip(label: 'Verbs', isActive: _chip3, onTap: () => setState(() => _chip3 = !_chip3)),
              const AppFilterChip(label: 'Adjectives'),
              const AppFilterChip(label: 'Particles'),
            ],
          ),
          const SizedBox(height: 32),

          _SectionLabel('Known Toggle'),
          const SizedBox(height: 12),
          KnownToggle(
            isKnown: _isKnown,
            onTap: () => setState(() => _isKnown = !_isKnown),
          ),
          const SizedBox(height: 32),

          _SectionLabel('Progress Bar'),
          const SizedBox(height: 12),
          const AppProgressBar(progress: 0.6),
          const SizedBox(height: 10),
          AppProgressBar(progress: 0.25, color: context.tokens.characters),
          const SizedBox(height: 10),
          AppProgressBar(progress: 0.15, color: context.tokens.vocabulary),
          const SizedBox(height: 32),

          _SectionLabel('Section Cards'),
          const SizedBox(height: 12),
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
          const SizedBox(height: 12),
          SectionCard(
            title: context.l10n.sectionCharacters,
            icon: '字',
            gradientColors: [context.tokens.charactersDark, context.tokens.characters],
            progressColor: context.tokens.characters,
            subtitle: 'Kana · Kanji N5/N4',
            statLabel: '46 / 184 known',
            progress: 0.25,
            onTap: () {},
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 32),

          _SectionLabel('Chapter Cards'),
          const SizedBox(height: 12),
          ChapterCard(
            chapterNumber: 1,
            title: 'Verbs',
            description: 'Verb groups, base forms, polite conjugations and て-form.',
            totalLessons: 5,
            completedLessons: 3,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          ChapterCard(
            chapterNumber: 2,
            title: 'Directions & Places',
            description: 'Spatial particles, location nouns, and directional expressions.',
            totalLessons: 3,
            completedLessons: 0,
            onTap: () {},
          ),
          const SizedBox(height: 32),

          _SectionLabel('Lesson Rows'),
          const SizedBox(height: 12),
          const LessonRow(
            title: 'Verb Groups',
            difficulty: 2,
            status: LessonStatus.done,
          ),
          const SizedBox(height: 10),
          const LessonRow(
            title: 'Polite Form (ます)',
            difficulty: 1,
            status: LessonStatus.done,
          ),
          const SizedBox(height: 10),
          LessonRow(
            title: 'て-form Conjugation',
            difficulty: 3,
            status: LessonStatus.notStarted,
            lessonNumber: 3,
            onTap: () {},
          ),
          const SizedBox(height: 32),

          _SectionLabel('Kana Grid'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              KanaCell(kana: 'あ', romaji: 'a', isKnown: true),
              KanaCell(kana: 'い', romaji: 'i', isKnown: true),
              KanaCell(kana: 'う', romaji: 'u', isKnown: true),
              KanaCell(kana: 'え', romaji: 'e', isKnown: true),
              KanaCell(kana: 'お', romaji: 'o', isKnown: true),
              KanaCell(kana: 'か', romaji: 'ka'),
              KanaCell(kana: 'き', romaji: 'ki'),
              KanaCell(kana: 'く', romaji: 'ku'),
              KanaCell(kana: 'け', romaji: 'ke'),
              KanaCell(kana: 'こ', romaji: 'ko'),
            ],
          ),
          const SizedBox(height: 32),

          _SectionLabel('Nav Bar'),
          const SizedBox(height: 12),
          AppNavBar(
            destinations: _navDestinations(context),
            selectedIndex: _navIndex,
            onDestinationSelected: (i) => setState(() => _navIndex = i),
          ),
          const SizedBox(height: 32),

          _SectionLabel('Nav Rail'),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppNavRail(
                destinations: _navDestinations(context),
                selectedIndex: _navIndex,
                onDestinationSelected: (i) => setState(() => _navIndex = i),
              ),
            ],
          ),
          const SizedBox(height: 32),

          _SectionLabel('Text Fields'),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Search',
            controller: _textController,
            hint: 'e.g. 食べる',
            prefixIcon: const Icon(Icons.search),
          ),
          const SizedBox(height: 12),
          const AppTextField(
            label: 'Disabled field',
            hint: 'Cannot edit',
            enabled: false,
          ),
          const SizedBox(height: 32),

          _SectionLabel('Lesson Reader'),
          const SizedBox(height: 12),
          LessonReaderCard(
            chapterLabel: 'Chapter 01 · Verbs',
            title: 'て-form Conjugation',
            body: const [
              ReaderBodyText('The て-form is one of the most important verb forms in Japanese.'),
              ReaderSectionTitle('Group 1 verbs (godan)'),
              ReaderJpExample(japanese: '書く → 書いて', translation: 'kaku → kaite (to write)'),
              ReaderJpExample(japanese: '飲む → 飲んで', translation: 'nomu → nonde (to drink)'),
              ReaderSectionTitle('Group 2 verbs (ichidan)'),
              ReaderJpExample(japanese: '食べる → 食べて', translation: 'taberu → tabete (to eat)'),
            ],
            onPractice: () {},
          ),
          const SizedBox(height: 32),

          _SectionLabel('Exercise — MCQ'),
          const SizedBox(height: 12),
          McqCard(
            question: 'What is the て-form of 書く (kaku)?',
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
          const SizedBox(height: 32),

          _SectionLabel('Exercise — Flashcard'),
          const SizedBox(height: 12),
          FlashCard(
            japanese: '食べる',
            isRevealed: _flashRevealed,
            answer: 'to eat',
            onTap: () => setState(() => _flashRevealed = !_flashRevealed),
          ),
          const SizedBox(height: 12),
          FlashCardActions(
            notYetLabel: context.l10n.flashcardNotYet,
            gotItLabel: context.l10n.flashcardGotIt,
            onNotYet: () => setState(() => _flashRevealed = false),
            onGotIt: () => setState(() => _flashRevealed = false),
          ),
          const SizedBox(height: 32),

          _SectionLabel('Exercise Summary'),
          const SizedBox(height: 12),
          SummaryCard(
            score: 8,
            total: 10,
            title: 'Lesson Complete!',
            subtitle: 'て-form Conjugation · Chapter 01',
            correct: 8,
            missed: 2,
            markedKnown: 5,
            timeSpent: '2m',
            onRetry: () {},
            onNext: () {},
          ),
          const SizedBox(height: 32),

          _SectionLabel('Kanji Detail Card'),
          const SizedBox(height: 12),
          KanjiDetailCard(
            kanji: '食',
            meaning: 'Eat, food',
            jlptLevel: 'N5',
            readings: const ['た(べる)', 'しょく', 'く(う)'],
            examples: const [
              KanjiExample(kanji: '食べる', reading: 'たべる', meaning: 'to eat'),
              KanjiExample(kanji: '食事', reading: 'しょくじ', meaning: 'meal'),
              KanjiExample(kanji: '食堂', reading: 'しょくどう', meaning: 'cafeteria'),
            ],
            isKnown: _isKnown,
            onKnownToggle: () => setState(() => _isKnown = !_isKnown),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.label.copyWith(
        color: context.tokens.onSurfaceVariant,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
