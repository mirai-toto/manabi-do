import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/grammar_provider.dart';
import '../../services/grammar_progress_service.dart';
import '../../widgets/widgets.dart';
import 'grammar_navigation.dart';
import 'grammar_lesson_list_screen.dart';

class GrammarChapterView extends ConsumerWidget {
  final String level;
  final VoidCallback onBack;

  const GrammarChapterView({
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
    final allLessonPaths = [
      for (final theme in themes) ...theme.lessons.map((lesson) => lesson.id),
    ];
    final pathsKey = allLessonPaths.join('\n');
    final hasExercises = ref
        .watch(grammarChapterHasExercisesProvider(pathsKey))
        .when(data: (v) => v, loading: () => false, error: (_, _) => false);
    final readLessons =
        ref.watch(grammarReadLessonsProvider).asData?.value ?? {};
    final unlockedChapters =
        ref.watch(grammarUnlockedChaptersProvider).asData?.value ?? {};

    bool isThemeLocked(int index) =>
        index > 0 &&
        isGrammarStepLocked(
          previousLessonIds: themes[index - 1].lessons.map((l) => l.id),
          readLessons: readLessons,
          unlockedByHand: unlockedChapters.contains(
            grammarThemeKey(level, index),
          ),
        );

    void openTheme(GrammarTheme theme) => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            GrammarLessonListScreen(theme: theme, levelColor: color),
      ),
    );

    return Scaffold(
      backgroundColor: t.surface,
      floatingActionButton: hasExercises
          ? GrammarPracticeFab(
              title: title,
              color: color,
              lessonPaths: allLessonPaths,
            )
          : null,
      body: themesAsync.when(
        loading: () => const Center(child: AppSpinner.page()),
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
                      Builder(
                        builder: (_) {
                          final theme = themes[i];
                          final lessonCount = theme.chapters.fold(
                            0,
                            (sum, c) => sum + c.lessons.length,
                          );
                          final doneCount = theme.chapters.fold(
                            0,
                            (sum, c) =>
                                sum +
                                c.lessons
                                    .where((ls) => readLessons.contains(ls.id))
                                    .length,
                          );
                          final locked = isThemeLocked(i);
                          return ChapterCard(
                            chapterLabel: l.chapterN(
                              '${i + 1}'.padLeft(2, '0'),
                            ),
                            title: theme.title,
                            description: theme.description,
                            badge: l.nLessons(lessonCount),
                            doneCount: doneCount,
                            totalLessons: lessonCount,
                            progressLabel: l.lessonsProgress(
                              doneCount,
                              lessonCount,
                            ),
                            accentColor: color,
                            isLocked: locked,
                            onTap: () async {
                              if (locked) {
                                final confirmed = await confirmGrammarUnlock(
                                  context,
                                  title: l.chapterLocked,
                                  body: l.chapterLockedBody,
                                );
                                if (!confirmed) return;
                                await ref
                                    .read(grammarProgressServiceProvider)
                                    .unlockTheme(level, i);
                              }
                              if (context.mounted) openTheme(theme);
                            },
                          );
                        },
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
