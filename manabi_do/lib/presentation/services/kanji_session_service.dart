import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card;

import '../../core/models/exercise_filter.dart';
import '../../core/models/mcq_settings.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/srs_settings_provider.dart';
import '../../core/text/short_meaning.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';
import '../providers/flashcard_settings_provider.dart';
import '../providers/mcq_settings_provider.dart';
import '../../core/models/practice_item.dart';
import '../../core/models/practice_question.dart';
import 'session_item_builders.dart';
import 'srs_queue_service.dart';

class KanjiSessionService {
  final Ref _ref;

  const KanjiSessionService(this._ref);

  Future<List<PracticeItem>> buildQueue({
    required String level,
    required Set<int>? allowedIds,
    required ExerciseFilter exerciseFilter,
    required bool freeMode,
  }) async {
    final db = _ref.read(databaseProvider);
    final rng = Random();
    final locale = _ref.read(localeProvider).languageCode;
    final mcqSettings = _ref.read(mcqSettingsProvider);
    final flashcardSettings = _ref.read(flashcardSettingsProvider);

    final int? sessionLimit = switch (exerciseFilter) {
      ExerciseFilter.flashcardOnly => flashcardSettings.sessionLength,
      _ => mcqSettings.sessionLength,
    };

    // Fetch pairs: (kanji, SRS card) for the items to quiz on.
    final List<(Kanji, Card?)> pairs;
    if (freeMode) {
      final all = await db.getKanjiByLevel(level);
      final filtered = allowedIds != null
          ? all.where((k) => allowedIds.contains(k.id)).toList()
          : all;
      filtered.shuffle(rng);
      final limited = sessionLimit != null
          ? filtered.take(sessionLimit).toList()
          : filtered;
      pairs = limited.map((k) => (k, null)).toList();
    } else {
      final settings = await _ref.read(srsSettingsProvider.future);
      final allPairs = await _ref
          .read(srsQueueServiceProvider)
          .kanji(level, newCardLimit: settings.newCharactersPerDay);
      final filtered = allowedIds != null
          ? allPairs.where((p) => allowedIds.contains(p.$1.id)).toList()
          : allPairs;
      pairs = sessionLimit != null
          ? filtered.take(sessionLimit).toList()
          : filtered;
    }

    // Pool (for MCQ distractors) — always the full level, never group-filtered.
    final allPool = await db.getKanjiByLevel(level);
    final pool = allPool;
    final allIds = [...pairs.map((p) => p.$1.id), ...pool.map((k) => k.id)];
    final kanjiTranslations = locale != 'en'
        ? await db.getKanjiTranslations(allIds.toSet().toList(), locale)
        : <int, String>{};
    String meaningOf(Kanji k) => shortMeaning(
      kanjiTranslations[k.id]?.isNotEmpty == true
          ? kanjiTranslations[k.id]!
          : k.meaning,
    );

    final availableTypes = switch (exerciseFilter) {
      ExerciseFilter.flashcardOnly => [_QuizType.flashcard],
      ExerciseFilter.mcqOnly => [
        _QuizType.kanjiToMeaning,
        _QuizType.meaningToKanji,
      ],
      ExerciseFilter.mixed => _QuizType.values,
    };

    return pairs.map((pair) {
      final (kanji, card) = pair;
      final type = availableTypes[rng.nextInt(availableTypes.length)];
      return switch (type) {
        _QuizType.flashcard => _buildFlashcardItem(
          kanji: kanji,
          card: card,
          level: level,
          freeMode: freeMode,
          meaningOf: meaningOf,
        ),
        _QuizType.drawing => _buildDrawingItem(
          kanji: kanji,
          card: card,
          level: level,
          freeMode: freeMode,
          meaningOf: meaningOf,
        ),
        _QuizType.kanjiToMeaning || _QuizType.meaningToKanji => _buildMcqItem(
          kanji: kanji,
          card: card,
          level: level,
          pool: pool,
          freeMode: freeMode,
          isKanjiToMeaning: type == _QuizType.kanjiToMeaning,
          mcqSettings: mcqSettings,
          meaningOf: meaningOf,
          rng: rng,
        ),
      };
    }).toList();
  }

  PracticeItem _buildFlashcardItem({
    required Kanji kanji,
    required Card? card,
    required String level,
    required bool freeMode,
    required String Function(Kanji) meaningOf,
  }) {
    return PracticeItem(
      id: kanji.id,
      srsType: 'kanji',
      card: card,
      summary: PracticeSummary(
        item: kanji.character,
        question: (l) => l.flashcardDefaultPrompt,
        answer: meaningOf(kanji),
        kindLabel: (l) => l.tabKanji,
        selfAssessed: true,
      ),
      question: FlashcardQuestion(
        japanese: kanji.character,
        answer: meaningOf(kanji),
        level: level,
        isFreeMode: freeMode,
        kanjiDetailId: kanji.id,
      ),
    );
  }

  PracticeItem _buildDrawingItem({
    required Kanji kanji,
    required Card? card,
    required String level,
    required bool freeMode,
    required String Function(Kanji) meaningOf,
  }) {
    return PracticeItem(
      id: kanji.id,
      srsType: 'kanji',
      card: card,
      summary: PracticeSummary(
        item: kanji.character,
        question: (l) => l.reviewDrawPrompt(meaningOf(kanji)),
        answer: meaningOf(kanji),
        kindLabel: (l) => l.reviewKindKanjiWriting,
        selfAssessed: true,
      ),
      question: DrawingQuestion(
        kanji: kanji,
        meaning: meaningOf(kanji),
        level: level,
        isFreeMode: freeMode,
        kanjiDetailId: kanji.id,
      ),
    );
  }

  PracticeItem _buildMcqItem({
    required Kanji kanji,
    required Card? card,
    required String level,
    required List<Kanji> pool,
    required bool freeMode,
    required bool isKanjiToMeaning,
    required McqSettings mcqSettings,
    required String Function(Kanji) meaningOf,
    required Random rng,
  }) {
    final kanjiMcq = buildKanjiMcqOptions(
      target: kanji,
      pool: pool,
      n: mcqSettings.mcqChoiceCount,
      isKanjiToMeaning: isKanjiToMeaning,
      meaningOf: meaningOf,
      rng: rng,
    );
    return PracticeItem(
      id: kanji.id,
      srsType: 'kanji',
      card: card,
      summary: PracticeSummary(
        item: kanji.character,
        question: (l) => isKanjiToMeaning
            ? l.mcqSelectMeaning
            : l.mcqSelectKanji(meaningOf(kanji)),
        answer: isKanjiToMeaning ? meaningOf(kanji) : kanji.character,
        kindLabel: (l) => l.tabKanji,
        selfAssessed: false,
      ),
      question: McqQuestion(
        prompt: (l) => isKanjiToMeaning
            ? l.mcqSelectMeaning
            : l.mcqSelectKanji(meaningOf(kanji)),
        japanesePrompt: isKanjiToMeaning ? kanji.character : null,
        japaneseReading: isKanjiToMeaning
            ? (kanji.onReading.isNotEmpty
                  ? kanji.onReading.split('、').first
                  : kanji.kunReading.split('、').firstOrNull)
            : null,
        options: kanjiMcq.options,
        correctIndex: kanjiMcq.correctIndex,
        compactGrid: !isKanjiToMeaning,
        level: level,
        isFreeMode: freeMode,
        kanjiDetailId: kanji.id,
      ),
    );
  }
}

final kanjiSessionServiceProvider = Provider((ref) => KanjiSessionService(ref));

enum _QuizType { kanjiToMeaning, meaningToKanji, drawing, flashcard }
