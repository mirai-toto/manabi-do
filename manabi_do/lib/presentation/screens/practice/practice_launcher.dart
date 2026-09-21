import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../characters/kanji/kanji_practice_screen.dart';
import '../vocabulary/vocabulary_practice_screen.dart';
import 'practice_selection_screen.dart';
import 'writing_session_screen.dart';

/// Opens the kanji practice picker for a whole [level], or for a single group
/// when [kanjiIds] is given.
Future<void> openKanjiPractice(
  BuildContext context, {
  required String title,
  required String level,
  required Color color,
  Set<int>? kanjiIds,
}) {
  final l = context.l10n;
  return Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (ctx) => PracticeSelectionScreen(
        title: title,
        color: color,
        modes: [
          PracticeMode(
            icon: Icons.shuffle_rounded,
            title: l.freePractice,
            onTap: () => _push(
              ctx,
              KanjiPracticeScreen(
                level: level,
                allowedIds: kanjiIds,
                freeMode: true,
              ),
            ),
          ),
          PracticeMode(
            icon: Icons.edit_rounded,
            title: l.writingPractice,
            onTap: () => _push(
              ctx,
              WritingSessionScreen(
                level: level,
                color: color,
                kanjiIds: kanjiIds,
              ),
            ),
          ),
          PracticeMode(
            icon: Icons.style_rounded,
            title: l.flashcardPractice,
            onTap: () => _push(
              ctx,
              KanjiPracticeScreen(
                level: level,
                allowedIds: kanjiIds,
                exerciseFilter: ExerciseFilter.flashcardOnly,
                freeMode: true,
              ),
            ),
          ),
          PracticeMode(
            icon: Icons.quiz_rounded,
            title: l.mcqPractice,
            onTap: () => _push(
              ctx,
              KanjiPracticeScreen(
                level: level,
                allowedIds: kanjiIds,
                exerciseFilter: ExerciseFilter.mcqOnly,
                freeMode: true,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Opens the vocabulary practice picker for a whole [level], or for a single
/// group when [vocabularyIds] is given.
Future<void> openVocabularyPractice(
  BuildContext context, {
  required String title,
  required String level,
  required Color color,
  Set<int>? vocabularyIds,
}) {
  final l = context.l10n;
  return Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (ctx) => PracticeSelectionScreen(
        title: title,
        color: color,
        modes: [
          PracticeMode(
            icon: Icons.shuffle_rounded,
            title: l.freePractice,
            onTap: () => _push(
              ctx,
              VocabularyPracticeScreen(
                level: level,
                allowedIds: vocabularyIds,
                freeMode: true,
              ),
            ),
          ),
          PracticeMode(
            icon: Icons.style_rounded,
            title: l.flashcardPractice,
            onTap: () => _push(
              ctx,
              VocabularyPracticeScreen(
                level: level,
                allowedIds: vocabularyIds,
                flashcardOnly: true,
              ),
            ),
          ),
          PracticeMode(
            icon: Icons.quiz_rounded,
            title: l.mcqPractice,
            onTap: () => _push(
              ctx,
              VocabularyPracticeScreen(
                level: level,
                allowedIds: vocabularyIds,
                mcqOnly: true,
              ),
            ),
          ),
          PracticeMode(
            icon: Icons.chat_bubble_outline_rounded,
            title: l.sentencePractice,
            onTap: () => _push(
              ctx,
              VocabularyPracticeScreen(
                level: level,
                allowedIds: vocabularyIds,
                sentenceOnly: true,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _push(BuildContext context, Widget screen) =>
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
