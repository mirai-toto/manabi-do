import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/mcq_option.dart';
import '../../core/providers/locale_provider.dart';
import '../../data/database/app_database.dart';
import '../../data/grammar/grammar_models.dart';
import '../providers/database_provider.dart';
import '../providers/mcq_settings_provider.dart';
import '../../core/models/practice_item.dart';
import '../../core/models/practice_question.dart';

const _letters = ['A', 'B', 'C', 'D'];

class GrammarSessionService {
  const GrammarSessionService();

  Future<List<PracticeItem>> buildQueueForChapter({
    required List<String> lessonPaths,
    required WidgetRef ref,
  }) async {
    final db = ref.read(databaseProvider);
    final locale = ref.read(localeProvider).languageCode;
    final sessionLength = ref.read(mcqSettingsProvider).sessionLength;
    final rng = math.Random();

    var rows = await db.getGrammarExercisesForLessons(lessonPaths);
    if (rows.isEmpty) return [];
    rows = List<GrammarExerciseRow>.of(rows)..shuffle(rng);
    if (sessionLength != null) rows = rows.take(sessionLength).toList();

    final items = <PracticeItem>[];
    for (var i = 0; i < rows.length; i++) {
      final exercise = GrammarExercise.fromJson(
        Map<String, dynamic>.from(jsonDecode(rows[i].dataJson) as Map),
      );
      items.add(_buildItem(i, exercise, locale, rng));
    }
    return items;
  }

  PracticeItem _buildItem(
    int id,
    GrammarExercise exercise,
    String locale,
    math.Random rng,
  ) {
    return switch (exercise) {
      FlashcardExercise() => PracticeItem(
        id: id,
        srsType: 'grammar',
        card: null,
        summary: PracticeSummary(
          item: exercise.front,
          question: (l) =>
              exercise.question?[locale] ??
              exercise.question?['en'] ??
              (exercise.isReversed
                  ? l.flashcardJapaneseQuestion
                  : l.flashcardDefaultPrompt),
          answer: exercise.isReversed
              ? exercise.front
              : (exercise.back[locale] ?? exercise.back['en'] ?? ''),
          kindLabel: (l) => l.sectionGrammar,
          selfAssessed: true,
        ),
        question: FlashcardQuestion(
          japanese: exercise.front,
          answer: exercise.back[locale] ?? exercise.back['en'] ?? '',
          example: exercise.example,
          locale: locale,
          isReversed: exercise.isReversed,
          questionOverride:
              exercise.question?[locale] ?? exercise.question?['en'] ?? '',
          isFreeMode: true,
        ),
      ),
      McqExercise() => PracticeItem(
        id: id,
        srsType: 'grammar',
        card: null,
        summary: PracticeSummary(
          item: exercise.sentence,
          question: (l) => l.grammarMcqPrompt,
          answer:
              exercise.choices[locale]?[exercise.answerIndex] ??
              exercise.choices['en']?[exercise.answerIndex] ??
              '',
          kindLabel: (l) => l.sectionGrammar,
          selfAssessed: false,
        ),
        question: McqQuestion(
          prompt: (l) => l.grammarMcqPrompt,
          japanesePrompt: exercise.sentence,
          options: _options(
            exercise.choices[locale] ?? exercise.choices['en'] ?? [],
          ),
          correctIndex: exercise.answerIndex,
          isFreeMode: true,
        ),
      ),
      ClozeExercise() => _clozeItem(id, exercise, rng),
      BuilderExercise() => PracticeItem(
        id: id,
        srsType: 'grammar',
        card: null,
        summary: PracticeSummary(
          item: exercise.parts.join(),
          question: (l) => l.grammarBuilderPrompt,
          answer: exercise.parts.join(),
          kindLabel: (l) => l.sectionGrammar,
          selfAssessed: false,
        ),
        question: GrammarBuilderQuestion(
          parts: exercise.parts,
          translation:
              exercise.translation[locale] ?? exercise.translation['en'] ?? '',
          isFreeMode: true,
        ),
      ),
      ErrorDetectionExercise() => PracticeItem(
        id: id,
        srsType: 'grammar',
        card: null,
        summary: PracticeSummary(
          item: exercise.correct,
          question: (l) => l.grammarErrorDetectionPrompt,
          answer: exercise.correct,
          kindLabel: (l) => l.sectionGrammar,
          selfAssessed: false,
        ),
        question: GrammarErrorQuestion(
          correct: exercise.correct,
          wrong: exercise.wrong,
          explanation:
              exercise.explanation[locale] ?? exercise.explanation['en'] ?? '',
          isFreeMode: true,
        ),
      ),
    };
  }

  /// The choices are shuffled once, here, rather than every time the card is
  /// drawn — a rebuild used to reorder them under the learner's finger.
  PracticeItem _clozeItem(int id, ClozeExercise exercise, math.Random rng) {
    final choices = [exercise.answer, ...exercise.distractors]..shuffle(rng);
    return PracticeItem(
      id: id,
      srsType: 'grammar',
      card: null,
      summary: PracticeSummary(
        item: exercise.sentence,
        question: (l) => l.reviewClozePrompt,
        answer: exercise.answer,
        kindLabel: (l) => l.sectionGrammar,
        selfAssessed: false,
        sentence: exercise.sentence,
      ),
      question: GrammarClozeQuestion(
        sentence: exercise.sentence,
        options: _options(choices, useJpFont: true),
        correctIndex: choices.indexOf(exercise.answer),
        isFreeMode: true,
      ),
    );
  }

  List<McqOption> _options(List<String> choices, {bool useJpFont = false}) =>
      List.generate(
        choices.length,
        (i) => McqOption(
          letter: _letters[i],
          text: choices[i],
          useJpFont: useJpFont,
        ),
      );
}

final grammarSessionServiceProvider = Provider(
  (_) => const GrammarSessionService(),
);
