import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card;

import '../../core/models/sentence_settings.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/srs_settings_provider.dart';
import '../../core/text/short_meaning.dart';
import '../../core/text/translated_or.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';
import '../providers/flashcard_settings_provider.dart';
import '../providers/mcq_settings_provider.dart';
import '../providers/sentence_settings_provider.dart';
import '../../core/models/practice_item.dart';
import 'session_item_builders.dart';
import 'srs_queue_service.dart';

class VocabularySessionService {
  final Ref _ref;

  const VocabularySessionService(this._ref);

  Future<List<PracticeItem>> buildQueue({
    required int level,
    required Set<int>? allowedIds,
    required bool freeMode,
    required bool sentenceOnly,
    required bool mcqOnly,
    required bool flashcardOnly,
  }) async {
    final db = _ref.read(databaseProvider);
    final locale = _ref.read(localeProvider).languageCode;
    final rng = Random();
    final mcqSettings = _ref.read(mcqSettingsProvider);
    final sentenceSettings = _ref.read(sentenceSettingsProvider);
    final flashcardSettings = _ref.read(flashcardSettingsProvider);

    final int? sessionLimit = sentenceOnly
        ? sentenceSettings.sessionLength
        : mcqOnly
        ? mcqSettings.sessionLength
        : flashcardSettings.sessionLength;

    // Fetch pairs: (entry, SRS card) for the items to quiz on.
    final List<(VocabularyEntry, Card?)> pairs;
    if (sentenceOnly) {
      pairs = [];
    } else if (freeMode || mcqOnly || flashcardOnly) {
      final all = await db.getVocabularyByLevel(level);
      final filtered = allowedIds != null
          ? all.where((v) => allowedIds.contains(v.id)).toList()
          : all;
      filtered.shuffle(rng);
      final limited = sessionLimit != null
          ? filtered.take(sessionLimit).toList()
          : filtered;
      pairs = limited.map((v) => (v, null)).toList();
    } else {
      final settings = await _ref.read(srsSettingsProvider.future);
      final allPairs = await _ref
          .read(srsQueueServiceProvider)
          .vocabulary(level, newCardLimit: settings.newVocabularyPerDay);
      final filtered = allowedIds != null
          ? allPairs.where((p) => allowedIds.contains(p.$1.id)).toList()
          : allPairs;
      pairs = sessionLimit != null
          ? filtered.take(sessionLimit).toList()
          : filtered;
    }

    // Full level pool for MCQ distractors; group pool only for sentence selection.
    final allPool = await db.getVocabularyByLevel(level);
    final translations = locale != 'en'
        ? await db.getVocabularyTranslations(
            allPool.map((v) => v.id).toList(),
            locale,
          )
        : <int, String>{};

    String meaningOf(VocabularyEntry v) =>
        shortMeaning(translatedOr(translations, v.id, v.meaning));

    if (flashcardOnly) {
      return [
        for (final (entry, card) in pairs)
          vocabularyFlashcardItem(
            entry,
            card,
            meaning: meaningOf(entry),
            isReversed: rng.nextBool(),
            isFreeMode: true,
          ),
      ];
    }
    if (mcqOnly) {
      return [
        for (final (entry, card) in pairs)
          vocabularyMcqItem(
            entry,
            card,
            pool: allPool,
            meaningOf: meaningOf,
            choiceCount: mcqSettings.mcqChoiceCount,
            rng: rng,
            isFreeMode: true,
          ),
      ];
    }
    if (sentenceOnly) {
      final groupPool = allowedIds != null
          ? allPool.where((v) => allowedIds.contains(v.id)).toList()
          : allPool;
      final sentences = await loadVocabularySentences(
        db,
        groupPool.map((v) => v.id).toList(),
        locale: locale,
        nativeTranslationOnly: sentenceSettings.nativeTranslationOnly,
      );
      final withSentences =
          groupPool.where((v) => sentences.forWord(v.id).isNotEmpty).toList()
            ..shuffle(rng);
      final limited = sessionLimit != null
          ? withSentences.take(sessionLimit)
          : withSentences;
      return [
        for (final entry in limited)
          _clozeItem(
            entry,
            null,
            sentences,
            allPool,
            sentenceSettings,
            rng,
            true,
          ),
      ];
    }

    // Mixed: a flashcard either way round, multiple choice, or a sentence
    // cloze when the word has a sentence to hide it in.
    final sentences = await loadVocabularySentences(
      db,
      pairs.map((p) => p.$1.id).toList(),
      locale: locale,
      nativeTranslationOnly: sentenceSettings.nativeTranslationOnly,
    );
    return pairs.map((pair) {
      final (entry, card) = pair;
      final hasSentence = sentences.forWord(entry.id).isNotEmpty;
      // 0: JP→EN flashcard, 1: EN→JP flashcard, 2: MCQ, 3: sentence cloze
      final quizType = rng.nextInt(hasSentence ? 4 : 3);
      return switch (quizType) {
        0 || 1 => vocabularyFlashcardItem(
          entry,
          card,
          meaning: meaningOf(entry),
          isReversed: quizType == 1,
          isFreeMode: freeMode,
        ),
        2 => vocabularyMcqItem(
          entry,
          card,
          pool: allPool,
          meaningOf: meaningOf,
          choiceCount: mcqSettings.mcqChoiceCount,
          rng: rng,
          isFreeMode: freeMode,
        ),
        _ => _clozeItem(
          entry,
          card,
          sentences,
          allPool,
          sentenceSettings,
          rng,
          freeMode,
        ),
      };
    }).toList();
  }

  PracticeItem _clozeItem(
    VocabularyEntry entry,
    Card? card,
    VocabularySentences sentences,
    List<VocabularyEntry> pool,
    SentenceSettings sentenceSettings,
    Random rng,
    bool isFreeMode,
  ) {
    final wordSentences = sentences.forWord(entry.id);
    return vocabularyClozeItem(
      entry,
      card,
      sentence: wordSentences[rng.nextInt(wordSentences.length)],
      sentences: sentences,
      pool: pool,
      choiceCount: sentenceSettings.mcqChoiceCount,
      rng: rng,
      isFreeMode: isFreeMode,
    );
  }
}

final vocabularySessionServiceProvider = Provider(
  (ref) => VocabularySessionService(ref),
);
