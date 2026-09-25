import 'package:flutter/material.dart';

import '../../../../core/models/exercise_filter.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../l10n/level_label.dart';
import '../../../services/kanji_session_service.dart';
import '../../practice/practice_session_screen.dart';

export '../../../../core/models/exercise_filter.dart';

class KanjiPracticeScreen extends StatelessWidget {
  final String level;
  final Set<int>? allowedIds;
  final ExerciseFilter exerciseFilter;
  final bool freeMode;

  const KanjiPracticeScreen({
    super.key,
    required this.level,
    this.allowedIds,
    this.exerciseFilter = ExerciseFilter.mixed,
    this.freeMode = false,
  });

  Set<SettingsContext> get _contexts => switch (exerciseFilter) {
    ExerciseFilter.flashcardOnly => const {SettingsContext.flashcard},
    ExerciseFilter.mcqOnly => const {SettingsContext.mcq},
    ExerciseFilter.mixed => const {
      SettingsContext.flashcard,
      SettingsContext.mcq,
    },
  };

  @override
  Widget build(BuildContext context) {
    return PracticeSessionScreen(
      title: levelLabel(level, context),
      color: levelColor(level),
      loadQueue: (ref) => ref
          .read(kanjiSessionServiceProvider)
          .buildQueue(
            level: level,
            allowedIds: allowedIds,
            exerciseFilter: exerciseFilter,
            freeMode: freeMode,
          ),
      persistSrs: !freeMode,
      settingsContexts: _contexts,
    );
  }
}
