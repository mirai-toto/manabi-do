import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/learning_state.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/database_provider.dart';
import '../../providers/grammar_provider.dart';
import '../../services/grammar_session_service.dart';
import '../../widgets/widgets.dart';
import '../practice/practice_session_screen.dart';
import 'grammar_lesson_screen.dart';

class GrammarLessonListScreen extends ConsumerStatefulWidget {
  final GrammarTheme theme;
  final Color levelColor;

  const GrammarLessonListScreen({
    super.key,
    required this.theme,
    required this.levelColor,
  });

  @override
  ConsumerState<GrammarLessonListScreen> createState() =>
      _GrammarLessonListScreenState();
}

class _GrammarLessonListScreenState
    extends ConsumerState<GrammarLessonListScreen> {
  late final Set<int> _collapsed;
  late final List<String> _allLessonPaths;
  late final String _lessonPathsKey;

  @override
  void initState() {
    super.initState();
    _allLessonPaths = widget.theme.chapters
        .expand((c) => c.lessons.map((l) => l.id))
        .toList();
    _lessonPathsKey = _allLessonPaths.join('\n');
    _collapsed = {};
  }

  LearningState _lessonState(
    String lessonId,
    Set<String> readLessons,
    Set<String> startedLessons,
  ) {
    if (readLessons.contains(lessonId)) return LearningState.known;
    if (startedLessons.contains(lessonId)) return LearningState.started;
    return LearningState.notStarted;
  }

  void _openLesson(GrammarLesson lesson) {
    ref.read(databaseProvider).markGrammarLessonStarted(lesson.id);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GrammarLessonScreen(
          lessonId: lesson.id,
          title: lesson.title,
          blocks: lesson.blocks,
          levelColor: widget.levelColor,
        ),
      ),
    );
  }

  void _openExercises() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PracticeSessionScreen(
          title: widget.theme.title,
          color: widget.levelColor,
          persistSrs: false,
          settingsContexts: const {SettingsContext.grammar},
          hasExamples: true,
          loadQueue: (ref) => ref
              .read(grammarSessionServiceProvider)
              .buildQueueForChapter(
                lessonPaths: _allLessonPaths,
                ref: ref,
                color: widget.levelColor,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final hasExercises = ref
        .watch(grammarChapterHasExercisesProvider(_lessonPathsKey))
        .when(data: (v) => v, loading: () => false, error: (_, _) => false);
    final startedLessons =
        ref.watch(grammarStartedLessonsProvider).asData?.value ?? {};
    final readLessons =
        ref.watch(grammarReadLessonsProvider).asData?.value ?? {};
    final exerciseCounts =
        ref
            .watch(grammarExerciseCountsProvider(_lessonPathsKey))
            .asData
            ?.value ??
        {};

    final showChapterHeaders = widget.theme.chapters.length > 1;

    return Scaffold(
      backgroundColor: t.surface,
      appBar: AppBar(
        backgroundColor: t.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: t.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.theme.title,
          style: AppTextStyles.title.copyWith(color: t.onSurface),
        ),
      ),
      floatingActionButton: hasExercises
          ? FloatingActionButton.extended(
              onPressed: _openExercises,
              icon: const Icon(Icons.school_rounded),
              label: Text(context.l10n.grammarPractice),
              backgroundColor: widget.levelColor,
              foregroundColor: Colors.white,
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        children: [
          for (int ci = 0; ci < widget.theme.chapters.length; ci++) ...[
            if (ci > 0 && !showChapterHeaders)
              const SizedBox(height: AppDimens.spaceSm),
            if (showChapterHeaders) ...[
              if (ci > 0) const SizedBox(height: AppDimens.spaceSm),
              CollapsibleSection(
                title: widget.theme.chapters[ci].title,
                isCollapsed: _collapsed.contains(ci),
                accentColor: widget.levelColor,
                onToggle: () => setState(() {
                  if (_collapsed.contains(ci)) {
                    _collapsed.remove(ci);
                  } else {
                    _collapsed.add(ci);
                  }
                }),
              ),
            ],
            if (!_collapsed.contains(ci))
              for (
                int li = 0;
                li < widget.theme.chapters[ci].lessons.length;
                li++
              ) ...[
                if (li > 0 || showChapterHeaders)
                  const SizedBox(height: AppDimens.spaceSm),
                _LessonRow(
                  lesson: widget.theme.chapters[ci].lessons[li],
                  index: li,
                  accentColor: widget.levelColor,
                  state: _lessonState(
                    widget.theme.chapters[ci].lessons[li].id,
                    readLessons,
                    startedLessons,
                  ),
                  exerciseCount:
                      exerciseCounts[widget
                          .theme
                          .chapters[ci]
                          .lessons[li]
                          .id] ??
                      0,
                  onTap: () =>
                      _openLesson(widget.theme.chapters[ci].lessons[li]),
                ),
              ],
          ],
          const SizedBox(height: AppDimens.spaceLg),
        ],
      ),
    );
  }
}

class _LessonRow extends StatelessWidget {
  final GrammarLesson lesson;
  final int index;
  final Color accentColor;
  final LearningState state;
  final int exerciseCount;
  final VoidCallback onTap;

  const _LessonRow({
    required this.lesson,
    required this.index,
    required this.accentColor,
    required this.state,
    required this.exerciseCount,
    required this.onTap,
  });

  Color _borderColor(AppTokens t) => switch (state) {
    LearningState.known => t.success,
    LearningState.started => accentColor.withValues(alpha: 0.5),
    LearningState.locked => t.outlineVariant.withValues(alpha: 0.4),
    _ => t.outlineVariant,
  };

  Color _iconBg(AppTokens t) => switch (state) {
    LearningState.known => t.successContainer,
    _ => accentColor.withValues(alpha: 0.12),
  };

  Widget _iconChild(AppTokens t) => switch (state) {
    LearningState.known => Icon(
      Icons.check_rounded,
      size: 18,
      color: t.success,
    ),
    _ => Text(
      '${index + 1}',
      style: AppTextStyles.label.copyWith(
        color: accentColor,
        fontWeight: FontWeight.w700,
      ),
    ),
  };

  Color _chipBg(AppTokens t) => switch (state) {
    LearningState.known => t.successContainer,
    LearningState.started => accentColor.withValues(alpha: 0.12),
    _ => t.surfaceVariant,
  };

  Color _chipFg(AppTokens t) => switch (state) {
    LearningState.known => t.success,
    LearningState.started => accentColor,
    _ => t.onSurfaceVariant,
  };

  String _chipLabel(AppLocalizations l) => switch (state) {
    LearningState.notStarted => l.lessonStart,
    LearningState.started => l.lessonStateStarted,
    LearningState.known => l.lessonStateKnown,
    LearningState.unknown => l.lessonStateUnknown,
    LearningState.locked => l.lessonStateLocked,
  };

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    return TappableSurface(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: _borderColor(t)),
      ),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceMd,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _iconBg(t),
                shape: BoxShape.circle,
              ),
              child: Center(child: _iconChild(t)),
            ),
            const SizedBox(width: AppDimens.iconTextGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: AppTextStyles.body.copyWith(
                      color: t.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      for (int i = 1; i <= 3; i++) ...[
                        if (i > 1) const SizedBox(width: 3),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i <= lesson.difficulty
                                ? accentColor
                                : t.outlineVariant,
                          ),
                        ),
                      ],
                      if (exerciseCount > 0) ...[
                        const SizedBox(width: AppDimens.spaceSm),
                        Text(
                          '· $exerciseCount ex.',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: t.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.spaceSm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.badgePaddingH,
                vertical: AppDimens.badgePaddingV,
              ),
              decoration: BoxDecoration(
                color: _chipBg(t),
                borderRadius: BorderRadius.circular(AppDimens.radiusPill),
              ),
              child: Text(
                _chipLabel(l),
                style: AppTextStyles.labelSmall.copyWith(
                  color: _chipFg(t),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceXs),
            Icon(Icons.chevron_right_rounded, color: t.outlineVariant),
          ],
        ),
      ),
    );
  }
}
