import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card;

import '../../core/providers/locale_provider.dart';
import '../../core/providers/srs_settings_provider.dart';
import '../../core/theme/jlpt_level.dart';
import '../../data/database/app_database.dart';
import '../../l10n/l10n.dart';
import '../providers/database_provider.dart';
import '../providers/flashcard_settings_provider.dart';
import '../providers/mcq_settings_provider.dart';
import '../screens/characters/kanji/kanji_detail_screen.dart';
import '../screens/characters/kanji/kanji_practice_screen.dart';
import '../screens/practice/practice_session_screen.dart';
import '../widgets/exercise/mcq_card.dart';

class KanjiSessionService {
  const KanjiSessionService();

  Future<List<PracticeItem>> buildQueue({
    required WidgetRef ref,
    required String level,
    required Set<int>? allowedIds,
    required ExerciseFilter exerciseFilter,
    required bool freeMode,
  }) async {
    final db = ref.read(databaseProvider);
    final color = levelColor(level);
    final rng = Random();
    final locale = ref.read(localeProvider).languageCode;
    final mcqSettings = ref.read(mcqSettingsProvider);
    final flashcardSettings = ref.read(flashcardSettingsProvider);

    final int? sessionLimit = switch (exerciseFilter) {
      ExerciseFilter.flashcardOnly => flashcardSettings.sessionLength,
      _ => mcqSettings.sessionLength,
    };

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
      final settings = await ref.read(srsSettingsProvider.future);
      final allPairs = await db.getKanjiSrsSession(
        level,
        newCardLimit: settings.newCharactersPerDay,
      );
      final filteredPairs = allowedIds != null
          ? allPairs.where((p) => allowedIds.contains(p.$1.id)).toList()
          : allPairs;
      pairs = sessionLimit != null
          ? filteredPairs.take(sessionLimit).toList()
          : filteredPairs;
    }

    final allPool = await db.getKanjiByLevel(level);
    final pool = allowedIds != null
        ? allPool.where((k) => allowedIds.contains(k.id)).toList()
        : allPool;

    final allIds = [...pairs.map((p) => p.$1.id), ...pool.map((k) => k.id)];
    final kanjiTranslations = locale != 'en'
        ? await db.getKanjiTranslations(allIds.toSet().toList(), locale)
        : <int, String>{};
    String meaningOf(Kanji k) => kanjiTranslations[k.id]?.isNotEmpty == true
        ? kanjiTranslations[k.id]!
        : k.meaning;

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

      if (type == _QuizType.flashcard) {
        return PracticeItem(
          id: kanji.id,
          srsType: 'kanji',
          card: card,
          buildBody: (index, total, onAnswer) => Builder(
            builder: (ctx) => PracticeFlashcardBody(
              japanese: kanji.character,
              answer: meaningOf(kanji),
              isFreeMode: freeMode,
              card: card,
              index: index,
              total: total,
              color: color,
              onAnswer: onAnswer,
              onDetailTap: () => Navigator.of(ctx).push(
                MaterialPageRoute(
                  builder: (_) => KanjiDetailScreen(kanjiId: kanji.id),
                ),
              ),
            ),
          ),
        );
      }

      if (type == _QuizType.drawing) {
        return PracticeItem(
          id: kanji.id,
          srsType: 'kanji',
          card: card,
          buildBody: (index, total, onAnswer) => Builder(
            builder: (ctx) => KanjiDrawingBody(
              kanji: kanji,
              meaning: meaningOf(kanji),
              card: card,
              isFreeMode: freeMode,
              index: index,
              total: total,
              color: color,
              onAnswer: onAnswer,
              onDetailTap: () => Navigator.of(ctx).push(
                MaterialPageRoute(
                  builder: (_) => KanjiDetailScreen(kanjiId: kanji.id),
                ),
              ),
            ),
          ),
        );
      }

      // MCQ: kanjiToMeaning or meaningToKanji
      final isKanjiToMeaning = type == _QuizType.kanjiToMeaning;
      final n = mcqSettings.mcqChoiceCount;
      final distractors = pool.where((k) => k.id != kanji.id).toList()
        ..shuffle(rng);
      final options = [kanji, ...distractors.take(n - 1)]..shuffle(rng);
      final correctIndex = options.indexWhere((k) => k.id == kanji.id);
      final mcqOptions = List.generate(
        options.length,
        (i) => McqOption(
          letter: String.fromCharCode(65 + i),
          text: isKanjiToMeaning ? meaningOf(options[i]) : options[i].character,
          useJpFont: !isKanjiToMeaning,
        ),
      );

      return PracticeItem(
        id: kanji.id,
        srsType: 'kanji',
        card: card,
        buildBody: (index, total, onAnswer) => Builder(
          builder: (ctx) => PracticeMcqBody(
            question: isKanjiToMeaning
                ? ctx.l10n.mcqSelectMeaning
                : ctx.l10n.mcqSelectKanji(meaningOf(kanji)),
            japanesePrompt: isKanjiToMeaning ? kanji.character : null,
            options: mcqOptions,
            correctIndex: correctIndex,
            isFreeMode: freeMode,
            card: card,
            index: index,
            total: total,
            color: color,
            onAnswer: onAnswer,
            onDetailTap: () => Navigator.of(ctx).push(
              MaterialPageRoute(
                builder: (_) => KanjiDetailScreen(kanjiId: kanji.id),
              ),
            ),
            compactGrid: !isKanjiToMeaning,
          ),
        ),
      );
    }).toList();
  }
}

const kanjiSessionService = KanjiSessionService();

enum _QuizType { kanjiToMeaning, meaningToKanji, drawing, flashcard }
