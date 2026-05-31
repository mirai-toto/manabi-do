import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isKnown = false;
  bool _chip1 = true;
  bool _chip2 = false;
  bool _chip3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainer,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainer,
        elevation: 0,
        title: Text('Widget Gallery', style: AppTextStyles.title),
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
          const AppProgressBar(progress: 0.25, color: Color(0xFF1976D2)),
          const SizedBox(height: 10),
          const AppProgressBar(progress: 0.15, color: Color(0xFF388E3C)),
          const SizedBox(height: 32),

          _SectionLabel('Section Cards'),
          const SizedBox(height: 12),
          SectionCard(
            section: AppSection.grammar,
            subtitle: '17 chapters · N5/N4',
            statLabel: '3 / 17 chapters completed',
            progress: 0.18,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          SectionCard(
            section: AppSection.characters,
            subtitle: 'Kana · Kanji N5/N4',
            statLabel: '46 / 184 known',
            progress: 0.25,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          SectionCard(
            section: AppSection.vocabulary,
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
        color: AppColors.onSurfaceVariant,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
