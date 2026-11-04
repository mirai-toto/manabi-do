import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/grammar/grammar_models.dart';
import '../../../l10n/l10n.dart';
import '../../services/grammar_progress_service.dart';
import '../../services/grammar_session_service.dart';
import '../../widgets/widgets.dart';
import '../practice/practice_session_screen.dart';
import 'grammar_lesson_screen.dart';

/// Records that [lesson] was started and opens it.
void openGrammarLesson(
  BuildContext context,
  WidgetRef ref,
  GrammarLesson lesson,
  Color levelColor,
) {
  ref.read(grammarProgressServiceProvider).markLessonStarted(lesson.id);
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => GrammarLessonScreen(
        lessonId: lesson.id,
        title: lesson.title,
        blocks: lesson.blocks,
        levelColor: levelColor,
      ),
    ),
  );
}

/// Asks before opening a locked theme, group or lesson anyway.
Future<bool> confirmGrammarUnlock(
  BuildContext context, {
  required String title,
  required String body,
}) => showConfirmDialog(
  context,
  title: title,
  body: body,
  confirmLabel: context.l10n.chapterUnlockAnyway,
  isDestructive: false,
);

/// The floating Practice button on a grammar level or theme: a session over
/// the exercises of [lessonPaths], which nothing is written back to the SRS
/// from.
class GrammarPracticeFab extends StatelessWidget {
  final String title;
  final Color color;
  final List<String> lessonPaths;

  const GrammarPracticeFab({
    super.key,
    required this.title,
    required this.color,
    required this.lessonPaths,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
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
                .buildQueueForChapter(lessonPaths: lessonPaths),
          ),
        ),
      ),
      icon: const Icon(Icons.school_rounded),
      label: Text(context.l10n.grammarPractice),
      backgroundColor: color,
      foregroundColor: onAccentFor(color),
    );
  }
}
