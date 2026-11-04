import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card;

import '../../core/models/exercise_filter.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/srs_settings_provider.dart';
import '../../core/text/short_meaning.dart';
import '../../core/text/translated_or.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';
import '../providers/flashcard_settings_provider.dart';
import '../providers/mcq_settings_provider.dart';
import '../../core/models/practice_item.dart';
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
      final settings = _ref.read(srsSettingsProvider);
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
    final pool = await db.getKanjiByLevel(level);
    final allIds = [...pairs.map((p) => p.$1.id), ...pool.map((k) => k.id)];
    final kanjiTranslations = locale != 'en'
        ? await db.getKanjiTranslations(allIds.toSet().toList(), locale)
        : <int, String>{};
    String meaningOf(Kanji k) =>
        shortMeaning(translatedOr(kanjiTranslations, k.id, k.meaning));

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
        _QuizType.flashcard => kanjiFlashcardItem(
          kanji,
          card,
          meaning: meaningOf(kanji),
          isFreeMode: freeMode,
        ),
        _QuizType.drawing => kanjiDrawingItem(
          kanji,
          card,
          meaning: meaningOf(kanji),
          isFreeMode: freeMode,
        ),
        _QuizType.kanjiToMeaning || _QuizType.meaningToKanji => kanjiMcqItem(
          kanji,
          card,
          isKanjiToMeaning: type == _QuizType.kanjiToMeaning,
          pool: pool,
          meaningOf: meaningOf,
          choiceCount: mcqSettings.mcqChoiceCount,
          rng: rng,
          isFreeMode: freeMode,
        ),
      };
    }).toList();
  }
}

final kanjiSessionServiceProvider = Provider<KanjiSessionService>(
  (ref) => KanjiSessionService(ref),
);

enum _QuizType { kanjiToMeaning, meaningToKanji, drawing, flashcard }
