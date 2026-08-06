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
  ) {
    if (ci == 0) return false;
    final prev = widget.theme.chapters[ci - 1];
    if (prev.lessons.isEmpty) return false;
    final prevDone = prev.lessons
        .where((l) => readLessons.contains(l.id))
        .length;
    if (prevDone == prev.lessons.length) return false;
    return !unlockedKeys.contains('group:${widget.theme.title}:$ci');
  }

  bool _isLessonLocked(
    int ci,
    int li,
    Set<String> readLessons,
    Set<String> unlockedKeys,
  ) {
    if (li == 0) return false;
    final prevLesson = widget.theme.chapters[ci].lessons[li - 1];
    if (readLessons.contains(prevLesson.id)) return false;
    final lessonId = widget.theme.chapters[ci].lessons[li].id;
    return !unlockedKeys.contains('lesson:$lessonId');
  }

  void _showUnlockDialog({
    required String title,
    required String body,
    required VoidCallback onConfirm,
  }) {
    final l = context.l10n;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm();
            },
            child: Text(l.chapterUnlockAnyway),
          ),
        ],
      ),
    );
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
          ? FloatingActionButton.extended(
              onPressed: _openExercises,
              icon: const Icon(Icons.school_rounded),
              label: Text(context.l10n.grammarPractice),
              backgroundColor: widget.levelColor,
              foregroundColor: Colors.white,
            )
          : null,
      body: ScrollFade(
        builder: (controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(AppDimens.spaceMd),
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
                      onToggle: () {
                        if (groupLocked) {
                          final l = context.l10n;
                          _showUnlockDialog(
                            title: l.groupLocked,
                            body: l.groupLockedBody,
                            onConfirm: () => ref
                                .read(databaseProvider)
                                .unlockGrammarChapter(
                                  'group:${widget.theme.title}:$ci',
                                ),
                          );
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
                            ? () {
                                final l = context.l10n;
                                _showUnlockDialog(
                                  title: l.lessonLocked,
                                  body: l.lessonLockedBody,
                                  onConfirm: () {
                                    ref
                                        .read(databaseProvider)
                                        .unlockGrammarChapter(
                                          'lesson:${lesson.id}',
                                        );
                                    _openLesson(lesson);
                                  },
                                );
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
    );
  }
}
