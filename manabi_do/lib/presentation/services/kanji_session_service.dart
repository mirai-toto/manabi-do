import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card;

import '../../core/models/mcq_settings.dart';
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
import 'session_item_builders.dart';

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
      final settings = await ref.read(srsSettingsProvider.future);
      final allPairs = await db.getKanjiSrsSession(
        level,
        newCardLimit: settings.newCharactersPerDay,
      );
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
      return switch (type) {
        _QuizType.flashcard => _buildFlashcardItem(
          kanji: kanji,
          card: card,
          color: color,
          freeMode: freeMode,
          meaningOf: meaningOf,
        ),
        _QuizType.drawing => _buildDrawingItem(
          kanji: kanji,
          card: card,
          color: color,
          freeMode: freeMode,
          meaningOf: meaningOf,
        ),
        _QuizType.kanjiToMeaning || _QuizType.meaningToKanji => _buildMcqItem(
          kanji: kanji,
          card: card,
          color: color,
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
    required Color color,
    required bool freeMode,
    required String Function(Kanji) meaningOf,
  }) {
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

  PracticeItem _buildDrawingItem({
    required Kanji kanji,
    required Card? card,
    required Color color,
    required bool freeMode,
    required String Function(Kanji) meaningOf,
  }) {
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

  PracticeItem _buildMcqItem({
    required Kanji kanji,
    required Card? card,
    required Color color,
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
      buildBody: (index, total, onAnswer) => Builder(
        builder: (ctx) => PracticeMcqBody(
          question: isKanjiToMeaning
              ? ctx.l10n.mcqSelectMeaning
              : ctx.l10n.mcqSelectKanji(meaningOf(kanji)),
          japanesePrompt: isKanjiToMeaning ? kanji.character : null,
          japaneseReading: isKanjiToMeaning
              ? (kanji.onReading.isNotEmpty
                    ? kanji.onReading.split('、').first
                    : kanji.kunReading.split('、').firstOrNull)
              : null,
          options: kanjiMcq.options,
          correctIndex: kanjiMcq.correctIndex,
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
  }
}

const kanjiSessionService = KanjiSessionService();

enum _QuizType { kanjiToMeaning, meaningToKanji, drawing, flashcard }
