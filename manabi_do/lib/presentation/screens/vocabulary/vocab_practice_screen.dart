import 'package:flutter/material.dart';

import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/level_label.dart';
import '../../services/vocab_session_service.dart';
import '../practice/practice_session_screen.dart';

class VocabPracticeScreen extends StatelessWidget {
  final String level;
  final Set<int>? allowedIds;
  final bool freeMode;
  final bool sentenceOnly;
  final bool mcqOnly;
  final bool flashcardOnly;

  const VocabPracticeScreen({
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
      title: levelLabel(level, context),
      color: levelColor(level),
      loadQueue: (db, ref) => ref
          .read(vocabSessionServiceProvider)
          .buildQueue(
            db: db,
            ref: ref,
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
