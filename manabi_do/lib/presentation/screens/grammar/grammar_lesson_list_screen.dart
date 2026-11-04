import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/learning_state.dart';
import '../../../core/theme/accent_theme.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/grammar_provider.dart';
import '../../services/grammar_progress_service.dart';
import '../../widgets/widgets.dart';
import 'grammar_navigation.dart';

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
    _allLessonPaths = widget.theme.lessons.map((l) => l.id).toList();
    _lessonPathsKey = _allLessonPaths.join('\n');
    _collapsed = {};
  }

  LearningState _lessonState(
    String lessonId,
    Set<String> readLessons,
    Set<String> startedLessons, {
    bool isLocked = false,
  }) {
    if (isLocked) return LearningState.locked;
    if (readLessons.contains(lessonId)) return LearningState.known;
    if (startedLessons.contains(lessonId)) return LearningState.started;
    return LearningState.notStarted;
  }

  bool _isGroupLocked(
    int ci,
    Set<String> readLessons,
    Set<String> unlockedKeys,
  ) =>
      ci > 0 &&
      isGrammarStepLocked(
        previousLessonIds: widget.theme.chapters[ci - 1].lessons.map(
          (l) => l.id,
        ),
        readLessons: readLessons,
        unlockedByHand: unlockedKeys.contains(
          grammarGroupKey(widget.theme.title, ci),
        ),
      );

  bool _isLessonLocked(
    int ci,
    int li,
    Set<String> readLessons,
    Set<String> unlockedKeys,
  ) {
    if (li == 0) return false;
    final lessons = widget.theme.chapters[ci].lessons;
    return isGrammarStepLocked(
      previousLessonIds: [lessons[li - 1].id],
      readLessons: readLessons,
      unlockedByHand: unlockedKeys.contains(grammarLessonKey(lessons[li].id)),
    );
  }

  void _openLesson(GrammarLesson lesson) =>
      openGrammarLesson(context, ref, lesson, widget.levelColor);

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
    final unlockedKeys =
        ref.watch(grammarUnlockedChaptersProvider).asData?.value ?? {};
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
          ? GrammarPracticeFab(
              title: widget.theme.title,
              color: widget.levelColor,
              lessonPaths: _allLessonPaths,
            )
          : null,
      body: AccentTheme(
        accent: widget.levelColor,
        child: ScrollFade(
          builder: (controller) => ListView(
            controller: controller,
            // Room to scroll the last chapter out from under the Practice
            // button, which otherwise floats over it.
            padding: EdgeInsets.fromLTRB(
              AppDimens.spaceMd,
              AppDimens.spaceMd,
              AppDimens.spaceMd,
              hasExercises ? AppDimens.fabClearance : AppDimens.spaceMd,
            ),
            children: [
              for (int ci = 0; ci < widget.theme.chapters.length; ci++) ...[
                if (ci > 0 && !showChapterHeaders)
                  const SizedBox(height: AppDimens.spaceSm),
                if (showChapterHeaders) ...[
                  if (ci > 0) const SizedBox(height: AppDimens.spaceSm),
                  Builder(
                    builder: (_) {
                      final groupLocked = _isGroupLocked(
                        ci,
                        readLessons,
                        unlockedKeys,
                      );
                      return CollapsibleSection(
                        title: widget.theme.chapters[ci].title,
                        isCollapsed: groupLocked || _collapsed.contains(ci),
                        isLocked: groupLocked,
                        badge: context.l10n.nLessons(
                          widget.theme.chapters[ci].lessons.length,
                        ),
                        accentColor: widget.levelColor,
                        onToggle: () async {
                          if (groupLocked) {
                            final l = context.l10n;
                            final confirmed = await confirmGrammarUnlock(
                              context,
                              title: l.groupLocked,
                              body: l.groupLockedBody,
                            );
                            if (confirmed) {
                              await ref
                                  .read(grammarProgressServiceProvider)
                                  .unlockGroup(widget.theme.title, ci);
                            }
                          } else {
                            setState(() {
                              if (_collapsed.contains(ci)) {
                                _collapsed.remove(ci);
                              } else {
                                _collapsed.add(ci);
                              }
                            });
                          }
                        },
                      );
                    },
                  ),
                ],
                if (!_collapsed.contains(ci) &&
                    !_isGroupLocked(ci, readLessons, unlockedKeys))
                  for (
                    int li = 0;
                    li < widget.theme.chapters[ci].lessons.length;
                    li++
                  ) ...[
                    if (li > 0 || showChapterHeaders)
                      const SizedBox(height: AppDimens.spaceSm),
                    Builder(
                      builder: (_) {
                        final lesson = widget.theme.chapters[ci].lessons[li];
                        final lessonLocked = _isLessonLocked(
                          ci,
                          li,
                          readLessons,
                          unlockedKeys,
                        );
                        return LessonRow(
                          title: lesson.title,
                          index: li,
                          difficulty: lesson.difficulty,
                          state: _lessonState(
                            lesson.id,
                            readLessons,
                            startedLessons,
                            isLocked: lessonLocked,
                          ),
                          accentColor: widget.levelColor,
                          exerciseCount: exerciseCounts[lesson.id] ?? 0,
                          onTap: lessonLocked
                              ? () async {
                                  final l = context.l10n;
                                  final confirmed = await confirmGrammarUnlock(
                                    context,
                                    title: l.lessonLocked,
                                    body: l.lessonLockedBody,
                                  );
                                  if (!confirmed || !mounted) return;
                                  await ref
                                      .read(grammarProgressServiceProvider)
                                      .unlockLesson(lesson.id);
                                  _openLesson(lesson);
                                }
                              : () => _openLesson(lesson),
                        );
                      },
                    ),
                  ],
              ],
              const SizedBox(height: AppDimens.spaceLg),
            ],
          ),
        ),
      ),
    );
  }
}
