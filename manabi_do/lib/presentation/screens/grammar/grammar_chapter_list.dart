import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/grammar_provider.dart';
import '../../services/grammar_session_service.dart';
import '../../widgets/widgets.dart';
import '../practice/practice_session_screen.dart';
import 'grammar_lesson_list_screen.dart';

class GrammarChapterList extends ConsumerWidget {
  final String level;
  final VoidCallback onBack;

  const GrammarChapterList({
    super.key,
    required this.level,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.tokens;
    final themesAsync = ref.watch(grammarThemesProvider(level));
    final title = level == 'basics'
        ? l.japaneseBasics
        : levelLabel(level, context);
    final color = levelColor(level);

    final themes = themesAsync.asData?.value ?? [];
    final allLessonPaths = themes
        .expand((th) => th.chapters.expand((c) => c.lessons.map((l) => l.id)))
        .toList();
    final pathsKey = allLessonPaths.join('\n');
    final hasExercises = ref
        .watch(grammarChapterHasExercisesProvider(pathsKey))
        .when(data: (v) => v, loading: () => false, error: (_, _) => false);
    final readLessons =
        ref.watch(grammarReadLessonsProvider).asData?.value ?? {};

    return Scaffold(
      backgroundColor: t.surface,
      floatingActionButton: hasExercises
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PracticeSessionScreen(
                    title: title,
                    color: color,
                    persistSrs: false,
                    settingsContexts: const {SettingsContext.grammar},
                    hasExamples: true,
                    loadQueue: (ref) => ref
                        .read(grammarSessionServiceProvider)
                        .buildQueueForChapter(
                          lessonPaths: allLessonPaths,
                          ref: ref,
                          color: color,
                        ),
                  ),
                ),
              ),
              icon: const Icon(Icons.school_rounded),
              label: Text(l.grammarPractice),
              backgroundColor: color,
              foregroundColor: Colors.white,
            )
          : null,
      body: themesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const SizedBox.shrink(),
        data: (themes) => ScrollFade(
          builder: (controller) => ListView(
            controller: controller,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.spaceSm,
                  AppDimens.spaceSm,
                  AppDimens.spaceMd,
                  0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: t.onSurface),
                      onPressed: onBack,
                    ),
                    Text(
                      title,
                      style: AppTextStyles.title.copyWith(color: t.onSurface),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.spaceMd,
                  AppDimens.spaceSm,
                  AppDimens.spaceMd,
                  AppDimens.spaceSm,
                ),
                child: SectionLabel(l.grammarChapters),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < themes.length; i++) ...[
                      if (i > 0) const SizedBox(height: AppDimens.spaceSm),
                      _ThemeRow(
                        theme: themes[i],
                        index: i,
                        accentColor: color,
                        readLessons: readLessons,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.fabClearance),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeRow extends StatelessWidget {
  final GrammarTheme theme;
  final int index;
  final Color accentColor;
  final Set<String> readLessons;

  const _ThemeRow({
    required this.theme,
    required this.index,
    required this.accentColor,
    required this.readLessons,
  });

  int get _lessonCount =>
      theme.chapters.fold(0, (sum, c) => sum + c.lessons.length);

  int get _doneCount => theme.chapters.fold(
    0,
    (sum, c) => sum + c.lessons.where((l) => readLessons.contains(l.id)).length,
  );

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    return TappableSurface(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              GrammarLessonListScreen(theme: theme, levelColor: accentColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.chapterN('${index + 1}'.padLeft(2, '0')),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.badgePaddingH,
                    vertical: AppDimens.badgePaddingV,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                  ),
                  child: Text(
                    l.nLessons(_lessonCount),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceSm),
            Text(
              theme.title,
              style: AppTextStyles.title.copyWith(color: t.onSurface),
            ),
            if (theme.description.isNotEmpty) ...[
              const SizedBox(height: AppDimens.spaceXs),
              Text(
                theme.description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: t.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppDimens.spaceMd),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusPill),
              child: LinearProgressIndicator(
                value: _lessonCount == 0 ? 0 : _doneCount / _lessonCount,
                minHeight: 6,
                backgroundColor: t.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            ),
            const SizedBox(height: AppDimens.spaceXs),
            Text(
              l.lessonsProgress(_doneCount, _lessonCount),
              style: AppTextStyles.labelSmall.copyWith(
                color: t.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
