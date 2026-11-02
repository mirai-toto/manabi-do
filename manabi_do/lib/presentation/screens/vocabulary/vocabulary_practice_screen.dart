import 'package:flutter/material.dart';

import '../../../core/theme/vocabulary_level.dart';
import '../../../l10n/vocabulary_level_label.dart';
import '../../services/vocabulary_session_service.dart';
import '../practice/practice_session_screen.dart';

class VocabularyPracticeScreen extends StatelessWidget {
  final int level;
  final Set<int>? allowedIds;
  final bool freeMode;
  final bool sentenceOnly;
  final bool mcqOnly;
  final bool flashcardOnly;

  const VocabularyPracticeScreen({
    super.key,
    required this.level,
    this.allowedIds,
    this.freeMode = false,
    this.sentenceOnly = false,
    this.mcqOnly = false,
    this.flashcardOnly = false,
  });

  Set<SettingsContext> get _contexts {
    if (sentenceOnly) return const {SettingsContext.sentence};
    if (mcqOnly) return const {SettingsContext.mcq};
    if (flashcardOnly) return const {SettingsContext.flashcard};
    return const {
      SettingsContext.flashcard,
      SettingsContext.mcq,
      SettingsContext.sentence,
    };
  }

  @override
  Widget build(BuildContext context) {
    return PracticeSessionScreen(
      title: vocabularyLevelLabel(level, context),
      color: vocabularyLevelColor(level, Theme.of(context).brightness),
      loadQueue: (ref) => ref
          .read(vocabularySessionServiceProvider)
          .buildQueue(
            level: level,
            allowedIds: allowedIds,
            freeMode: freeMode,
            sentenceOnly: sentenceOnly,
            mcqOnly: mcqOnly,
            flashcardOnly: flashcardOnly,
          ),
      persistSrs: !freeMode && !mcqOnly && !flashcardOnly && !sentenceOnly,
      settingsContexts: _contexts,
    );
  }
}
