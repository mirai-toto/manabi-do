import 'package:flutter/material.dart';

import '../../../core/models/exercise_filter.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/vocabulary_level.dart';
import '../../../l10n/vocabulary_level_label.dart';
import '../../services/vocabulary_session_service.dart';
import '../practice/practice_session_screen.dart';

class VocabularyPracticeScreen extends StatelessWidget {
  final int level;
  final Set<int>? allowedIds;
  final bool freeMode;
  final ExerciseFilter exerciseFilter;

  const VocabularyPracticeScreen({
    super.key,
    required this.level,
    this.allowedIds,
    this.freeMode = false,
    this.exerciseFilter = ExerciseFilter.mixed,
  });

  Set<SettingsContext> get _contexts => switch (exerciseFilter) {
    ExerciseFilter.sentenceOnly => const {SettingsContext.sentence},
    ExerciseFilter.mcqOnly => const {SettingsContext.mcq},
    ExerciseFilter.flashcardOnly => const {SettingsContext.flashcard},
    ExerciseFilter.mixed => const {
      SettingsContext.flashcard,
      SettingsContext.mcq,
      SettingsContext.sentence,
    },
  };

  @override
  Widget build(BuildContext context) {
    return PracticeSessionScreen(
      title: vocabularyLevelLabel(level, context),
      color: vocabularyLevelColor(level, context.tokens),
      loadQueue: (ref) => ref
          .read(vocabularySessionServiceProvider)
          .buildQueue(
            level: level,
            allowedIds: allowedIds,
            freeMode: freeMode,
            exerciseFilter: exerciseFilter,
          ),
      // A single-exercise drill is always free practice.
      persistSrs: !freeMode && exerciseFilter == ExerciseFilter.mixed,
      settingsContexts: _contexts,
    );
  }
}
