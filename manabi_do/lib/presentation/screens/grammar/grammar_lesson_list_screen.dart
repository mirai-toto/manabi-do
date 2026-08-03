import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
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
    _collapsed = widget.theme.chapters.length > 1
        ? Set.from(Iterable.generate(widget.theme.chapters.length))
        : {};
  }

  void _openLesson(GrammarLesson lesson) {
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
  final VoidCallback onTap;

  const _LessonRow({
    required this.lesson,
    required this.index,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return TappableSurface(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: accentColor.withValues(alpha: 0.35)),
      ),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceLg,
        ),
        child: Row(
          children: [
            NumberBadge(number: index + 1, color: accentColor),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Text(
                lesson.title,
                style: AppTextStyles.body.copyWith(
                  color: t.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: t.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
