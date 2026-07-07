import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/mcq_settings.dart';
import '../../core/models/sentence_settings.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/srs_settings_provider.dart';
import '../../core/theme/jlpt_level.dart';
import '../../data/database/app_database.dart';
import '../../l10n/l10n.dart';
import '../providers/database_provider.dart';
import '../providers/flashcard_settings_provider.dart';
import '../providers/mcq_settings_provider.dart';
import '../providers/sentence_settings_provider.dart';
import '../screens/practice/practice_session_screen.dart';
import '../screens/practice/sentence_cloze_body.dart';
import 'session_item_builders.dart';

class VocabSessionService {
  const VocabSessionService();

  Future<List<PracticeItem>> buildQueue({
    required WidgetRef ref,
    required String level,
    required Set<int>? allowedIds,
    required bool freeMode,
    required bool sentenceOnly,
    required bool mcqOnly,
    required bool flashcardOnly,
  }) async {
    final db = ref.read(databaseProvider);
    final locale = ref.read(localeProvider).languageCode;
    final color = levelColor(level);
    final rng = Random();
    final mcqSettings = ref.read(mcqSettingsProvider);
    final sentenceSettings = ref.read(sentenceSettingsProvider);
    final flashcardSettings = ref.read(flashcardSettingsProvider);

    final int? sessionLimit = sentenceOnly
        ? sentenceSettings.sessionLength
        : mcqOnly
        ? mcqSettings.sessionLength
        : flashcardSettings.sessionLength;

    // Fetch pairs: (entry, SRS card) for the items to quiz on.
    final List<(VocabularyEntry, dynamic)> pairs;
    if (sentenceOnly) {
      pairs = [];
    } else if (freeMode || mcqOnly || flashcardOnly) {
      final all = await db.getVocabByLevel(level);
      final filtered = allowedIds != null
          ? all.where((v) => allowedIds.contains(v.id)).toList()
          : all;
      filtered.shuffle(rng);
      final limited = sessionLimit != null
          ? filtered.take(sessionLimit).toList()
          : filtered;
      pairs = limited.map((v) => (v, null)).toList();
    } else {
      final settings = await ref.read(srsSettingsProvider.future);
      final allPairs = await db.getVocabSrsSession(
        level,
        newCardLimit: settings.newVocabPerDay,
      );
      final filtered = allowedIds != null
          ? allPairs.where((p) => allowedIds.contains(p.$1.id)).toList()
          : allPairs;
      pairs = sessionLimit != null
          ? filtered.take(sessionLimit).toList()
          : filtered;
    }

    // Pool (for MCQ distractors) and translations — shared across all modes.
    final allPool = await db.getVocabByLevel(level);
    final pool = allowedIds != null
        ? allPool.where((v) => allowedIds.contains(v.id)).toList()
        : allPool;
    final translations = locale != 'en'
        ? await db.getVocabTranslations(pool.map((v) => v.id).toList(), locale)
        : <int, String>{};

    String meaningOf(VocabularyEntry v) =>
        translations[v.id]?.isNotEmpty == true
        ? translations[v.id]!
        : v.meaning;

    if (flashcardOnly) {
      return _buildFlashcardItems(
        pairs: pairs,
        color: color,
        rng: rng,
        isFreeMode: true,
        meaningOf: meaningOf,
      );
    }
    if (sentenceOnly) {
      return _buildSentenceItems(
        db: db,
        pool: pool,
        color: color,
        locale: locale,
        rng: rng,
        sessionLimit: sessionLimit,
        sentenceSettings: sentenceSettings,
      );
    }
    if (mcqOnly) {
      return _buildMcqItems(
        pairs: pairs,
        pool: pool,
        color: color,
        rng: rng,
        mcqSettings: mcqSettings,
        isFreeMode: true,
        meaningOf: meaningOf,
      );
    }
    return _buildMixedItems(
      db: db,
      pairs: pairs,
      pool: pool,
      color: color,
      locale: locale,
      rng: rng,
      freeMode: freeMode,
      mcqSettings: mcqSettings,
      sentenceSettings: sentenceSettings,
      meaningOf: meaningOf,
    );
  }

  List<PracticeItem> _buildFlashcardItems({
    required List<(VocabularyEntry, dynamic)> pairs,
    required Color color,
    required Random rng,
    required bool isFreeMode,
    required String Function(VocabularyEntry) meaningOf,
  }) {
    return pairs.map((pair) {
      final (entry, card) = pair;
      final isReversed = rng.nextBool();
      return PracticeItem(
        id: entry.id,
        srsType: 'vocabulary',
        card: card,
        buildBody: (index, total, onAnswer) => PracticeFlashcardBody(
          japanese: entry.word,
          label: entry.reading != entry.word ? entry.reading : null,
          answer: meaningOf(entry),
          isReversed: isReversed,
          isFreeMode: isFreeMode,
          card: card,
          index: index,
          total: total,
          color: color,
          onAnswer: onAnswer,
        ),
      );
    }).toList();
  }

  List<PracticeItem> _buildMcqItems({
    required List<(VocabularyEntry, dynamic)> pairs,
    required List<VocabularyEntry> pool,
    required Color color,
    required Random rng,
    required McqSettings mcqSettings,
    required bool isFreeMode,
    required String Function(VocabularyEntry) meaningOf,
  }) {
    return pairs.map((pair) {
      final (entry, card) = pair;
      final vocabMcq = buildVocabMcqOptions(
        target: entry,
        pool: pool,
        n: mcqSettings.mcqChoiceCount,
        meaningOf: meaningOf,
        rng: rng,
      );
      return PracticeItem(
        id: entry.id,
        srsType: 'vocabulary',
        card: card,
        buildBody: (index, total, onAnswer) => Builder(
          builder: (context) => PracticeMcqBody(
            question: context.l10n.mcqSelectWordMeaning,
            japanesePrompt: entry.word,
            japaneseReading: entry.reading != entry.word ? entry.reading : null,
            options: vocabMcq.options,
            correctIndex: vocabMcq.correctIndex,
            isFreeMode: isFreeMode,
            card: card,
            index: index,
            total: total,
            color: color,
            onAnswer: onAnswer,
          ),
        ),
      );
    }).toList();
  }

  Future<List<PracticeItem>> _buildSentenceItems({
    required AppDatabase db,
    required List<VocabularyEntry> pool,
    required Color color,
    required String locale,
    required Random rng,
    required int? sessionLimit,
    required SentenceSettings sentenceSettings,
  }) async {
    final nativeOnly = sentenceSettings.nativeTranslationOnly && locale != 'en';
    final sentencesByVocabId = await db.getSentencesBatch(
      pool.map((v) => v.id).toList(),
    );
    final allSentenceIds = sentencesByVocabId.values
        .expand((list) => list)
        .map((s) => s.id)
        .toList();
    final sentenceTranslations = await db.getSentenceTranslations(
      allSentenceIds,
      locale,
      nativeOnly: nativeOnly,
    );

    final withSentences = pool.where((v) {
      final ss = sentencesByVocabId[v.id] ?? [];
      if (ss.isEmpty) return false;
      if (nativeOnly) {
        return ss.any((s) => sentenceTranslations.containsKey(s.id));
      }
      return true;
    }).toList()..shuffle(rng);
    final limited = sessionLimit != null
        ? withSentences.take(sessionLimit).toList()
        : withSentences;

    return limited.map((entry) {
      final allEntSentences = sentencesByVocabId[entry.id]!;
      final sentences = nativeOnly
          ? allEntSentences
                .where((s) => sentenceTranslations.containsKey(s.id))
                .toList()
          : allEntSentences;
      final sentence = sentences[rng.nextInt(sentences.length)];
      final cloze = buildClozeOptions(
        target: entry,
        pool: pool,
        n: sentenceSettings.mcqChoiceCount,
        rng: rng,
      );
      return PracticeItem(
        id: entry.id,
        srsType: 'vocabulary',
        card: null,
        buildBody: (index, total, onAnswer) => SentenceClozeBody(
          sentence: sentence,
          translation: sentenceTranslations[sentence.id],
          targetReading: entry.reading,
          options: cloze.options,
          correctIndex: cloze.correctIndex,
          isFreeMode: true,
          card: null,
          index: index,
          total: total,
          color: color,
          onAnswer: onAnswer,
        ),
      );
    }).toList();
  }

  Future<List<PracticeItem>> _buildMixedItems({
    required AppDatabase db,
    required List<(VocabularyEntry, dynamic)> pairs,
    required List<VocabularyEntry> pool,
    required Color color,
    required String locale,
    required Random rng,
    required bool freeMode,
    required McqSettings mcqSettings,
    required SentenceSettings sentenceSettings,
    required String Function(VocabularyEntry) meaningOf,
  }) async {
    final nativeOnly = sentenceSettings.nativeTranslationOnly && locale != 'en';
    final sentencesByVocabId = await db.getSentencesBatch(
      pairs.map((p) => p.$1.id).toList(),
    );
    final allSentenceIds = sentencesByVocabId.values
        .expand((list) => list)
        .map((s) => s.id)
        .toList();
    final sentenceTranslations = await db.getSentenceTranslations(
      allSentenceIds,
      locale,
      nativeOnly: nativeOnly,
    );

    return pairs.map((pair) {
      final (entry, card) = pair;
      final allSentences = sentencesByVocabId[entry.id] ?? [];
      final sentences = nativeOnly
          ? allSentences
                .where((s) => sentenceTranslations.containsKey(s.id))
                .toList()
          : allSentences;

      // 0: JP→EN flashcard, 1: EN→JP flashcard, 2: MCQ, 3: sentence cloze
      final quizType = rng.nextInt(sentences.isNotEmpty ? 4 : 3);

      if (quizType == 0 || quizType == 1) {
        return PracticeItem(
          id: entry.id,
          srsType: 'vocabulary',
          card: card,
          buildBody: (index, total, onAnswer) => PracticeFlashcardBody(
            japanese: entry.word,
            label: entry.reading != entry.word ? entry.reading : null,
            answer: meaningOf(entry),
            isReversed: quizType == 1,
            isFreeMode: freeMode,
            card: card,
            index: index,
            total: total,
            color: color,
            onAnswer: onAnswer,
          ),
        );
      }

      if (quizType == 2) {
        final vocabMcq = buildVocabMcqOptions(
          target: entry,
          pool: pool,
          n: mcqSettings.mcqChoiceCount,
          meaningOf: meaningOf,
          rng: rng,
        );
        return PracticeItem(
          id: entry.id,
          srsType: 'vocabulary',
          card: card,
          buildBody: (index, total, onAnswer) => Builder(
            builder: (context) => PracticeMcqBody(
              question: context.l10n.mcqSelectWordMeaning,
              japanesePrompt: entry.word,
              japaneseReading: entry.reading != entry.word
                  ? entry.reading
                  : null,
              options: vocabMcq.options,
              correctIndex: vocabMcq.correctIndex,
              isFreeMode: freeMode,
              card: card,
              index: index,
              total: total,
              color: color,
              onAnswer: onAnswer,
            ),
          ),
        );
      }

      // quizType == 3: sentence cloze
      final sentence = sentences[rng.nextInt(sentences.length)];
      final cloze = buildClozeOptions(
        target: entry,
        pool: pool,
        n: sentenceSettings.mcqChoiceCount,
        rng: rng,
      );
      return PracticeItem(
        id: entry.id,
        srsType: 'vocabulary',
        card: card,
        buildBody: (index, total, onAnswer) => SentenceClozeBody(
          sentence: sentence,
          translation: sentenceTranslations[sentence.id],
          targetReading: entry.reading,
          options: cloze.options,
          correctIndex: cloze.correctIndex,
          isFreeMode: freeMode,
          card: card,
          index: index,
          total: total,
          color: color,
          onAnswer: onAnswer,
        ),
      );
    }).toList();
  }
}

final vocabSessionServiceProvider = Provider(
  (_) => const VocabSessionService(),
);
