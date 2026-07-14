import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/locale_provider.dart';
import '../../data/grammar/grammar_models.dart';
import '../providers/database_provider.dart';
import '../providers/flashcard_settings_provider.dart';
import '../screens/practice/grammar_builder_body.dart';
import '../screens/practice/grammar_cloze_body.dart';
import '../screens/practice/grammar_error_detection_body.dart';
import '../screens/practice/practice_flashcard_body.dart';
import '../screens/practice/practice_item.dart';
import '../screens/practice/practice_mcq_body.dart';
import '../widgets/exercise/mcq_card.dart';

const _letters = ['A', 'B', 'C', 'D'];

class GrammarSessionService {
  const GrammarSessionService();

  Future<List<PracticeItem>> buildQueue({
    required String lessonPath,
    required WidgetRef ref,
    required Color color,
  }) async {
    final db = ref.read(databaseProvider);
    final locale = ref.read(localeProvider).languageCode;

    final rows = await db.getGrammarExercisesForLesson(lessonPath);
    if (rows.isEmpty) return [];

    final items = <PracticeItem>[];
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final exercise = GrammarExercise.fromJson(
        Map<String, dynamic>.from(jsonDecode(row.dataJson) as Map),
      );
      final item = _buildItem(i, exercise, locale, color, ref);
      if (item != null) items.add(item);
    }
    return items;
  }

  PracticeItem? _buildItem(
    int id,
    GrammarExercise exercise,
    String locale,
    Color color,
    WidgetRef ref,
  ) {
    return switch (exercise) {
      FlashcardExercise() => PracticeItem(
        id: id,
        srsType: 'grammar',
        card: null,
        buildBody: (index, total, onAnswer) => PracticeFlashcardBody(
          japanese: exercise.front,
          answer: exercise.back[locale] ?? exercise.back['en'] ?? '',
          example: ref.read(flashcardSettingsProvider).showExample
              ? exercise.example
              : null,
          locale: locale,
          card: null,
          isFreeMode: true,
          index: index,
          total: total,
          color: color,
          onAnswer: onAnswer,
        ),
      ),
      McqExercise() => PracticeItem(
        id: id,
        srsType: 'grammar',
        card: null,
        buildBody: (index, total, onAnswer) {
          final choices =
              exercise.choices[locale] ?? exercise.choices['en'] ?? [];
          final options = List.generate(
            choices.length,
            (i) => McqOption(letter: _letters[i], text: choices[i]),
          );
          return PracticeMcqBody(
            question: '',
            japanesePrompt: exercise.sentence,
            options: options,
            correctIndex: exercise.answerIndex,
            card: null,
            isFreeMode: true,
            index: index,
            total: total,
            color: color,
            onAnswer: onAnswer,
          );
        },
      ),
      ClozeExercise() => PracticeItem(
        id: id,
        srsType: 'grammar',
        card: null,
        buildBody: (index, total, onAnswer) {
          final allOptions = [exercise.answer, ...exercise.distractors];
          allOptions.shuffle(Random());
          final correctIndex = allOptions.indexOf(exercise.answer);
          final options = List.generate(
            allOptions.length,
            (i) => McqOption(
              letter: _letters[i],
              text: allOptions[i],
              useJpFont: true,
            ),
          );
          return GrammarClozeBody(
            sentence: exercise.sentence,
            options: options,
            correctIndex: correctIndex,
            index: index,
            total: total,
            color: color,
            onAnswer: onAnswer,
          );
        },
      ),
      BuilderExercise() => PracticeItem(
        id: id,
        srsType: 'grammar',
        card: null,
        buildBody: (index, total, onAnswer) => GrammarBuilderBody(
          parts: exercise.parts,
          translation:
              exercise.translation[locale] ?? exercise.translation['en'] ?? '',
          index: index,
          total: total,
          color: color,
          onAnswer: onAnswer,
        ),
      ),
      ErrorDetectionExercise() => PracticeItem(
        id: id,
        srsType: 'grammar',
        card: null,
        buildBody: (index, total, onAnswer) => GrammarErrorDetectionBody(
          correct: exercise.correct,
          wrong: exercise.wrong,
          explanation:
              exercise.explanation[locale] ?? exercise.explanation['en'] ?? '',
          index: index,
          total: total,
          color: color,
          onAnswer: onAnswer,
        ),
      ),
    };
  }
}

final grammarSessionServiceProvider = Provider(
  (_) => const GrammarSessionService(),
);
