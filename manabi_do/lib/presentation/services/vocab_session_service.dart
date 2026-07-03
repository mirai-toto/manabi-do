import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import '../widgets/exercise/mcq_card.dart';

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
    final flashcardSettings = ref.read(flashcardSettingsProvider);
    final mcqSettings = ref.read(mcqSettingsProvider);
    final sentenceSettings = ref.read(sentenceSettingsProvider);

    final bool useFreeModeLoading = freeMode || mcqOnly || flashcardOnly;

    final int? sessionLimit;
    if (mcqOnly) {
      sessionLimit = mcqSettings.sessionLength;
    } else if (flashcardOnly) {
      sessionLimit = flashcardSettings.sessionLength;
    } else if (sentenceOnly) {
      sessionLimit = sentenceSettings.sessionLength;
    } else {
      sessionLimit = flashcardSettings.sessionLength;
    }

    final List<(VocabularyEntry, dynamic)> pairs;
    if (useFreeModeLoading) {
      final all = await db.getVocabByLevel(level);
      final filtered = allowedIds != null
          ? all.where((v) => allowedIds.contains(v.id)).toList()
          : all;
      filtered.shuffle(rng);
      final limited = sessionLimit != null
          ? filtered.take(sessionLimit).toList()
          : filtered;
      pairs = limited.map((v) => (v, null)).toList();
    } else if (sentenceOnly) {
      pairs = [];
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

    final allPool = await db.getVocabByLevel(level);
    final pool = allowedIds != null
        ? allPool.where((v) => allowedIds.contains(v.id)).toList()
        : allPool;
    final poolIds = pool.map((v) => v.id).toList();
    final translations = locale != 'en'
        ? await db.getVocabTranslations(poolIds, locale)
        : <int, String>{};

    String meaningOf(VocabularyEntry v) =>
        translations[v.id]?.isNotEmpty == true
        ? translations[v.id]!
        : v.meaning;

    if (flashcardOnly) {
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
            isFreeMode: true,
            card: card,
            index: index,
            total: total,
            color: color,
            onAnswer: onAnswer,
          ),
        );
      }).toList();
    }

    if (sentenceOnly) {
      final nativeOnly =
          sentenceSettings.nativeTranslationOnly && locale != 'en';
      final all = await db.getVocabByLevel(level);
      final filtered = allowedIds != null
          ? all.where((v) => allowedIds.contains(v.id)).toList()
          : all;
      final allIds = filtered.map((v) => v.id).toList();
      final allSentencesByVocabId = await db.getSentencesBatch(allIds);
      final allSentenceIds = allSentencesByVocabId.values
          .expand((list) => list)
          .map((s) => s.id)
          .toList();
      final sentenceTranslations = await db.getSentenceTranslations(
        allSentenceIds,
        locale,
        nativeOnly: nativeOnly,
      );
      final withSentences = filtered.where((v) {
        final ss = allSentencesByVocabId[v.id] ?? [];
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
        final allEntSentences = allSentencesByVocabId[entry.id]!;
        final sentences = nativeOnly
            ? allEntSentences
                  .where((s) => sentenceTranslations.containsKey(s.id))
                  .toList()
            : allEntSentences;
        final sentence = sentences[rng.nextInt(sentences.length)];
        final translation = sentenceTranslations[sentence.id];
        final n = sentenceSettings.mcqChoiceCount;
        final distractors = pool.where((v) => v.id != entry.id).toList()
          ..shuffle(rng);
        final optionEntries = [entry, ...distractors.take(n - 1)]..shuffle(rng);
        final correctIndex = optionEntries.indexWhere((v) => v.id == entry.id);
        final clozeOptions = List.generate(
          optionEntries.length,
          (i) => McqOption(
            letter: String.fromCharCode(65 + i),
            text: optionEntries[i].word,
            reading: optionEntries[i].reading,
            useJpFont: true,
          ),
        );
        return PracticeItem(
          id: entry.id,
          srsType: 'vocabulary',
          card: null,
          buildBody: (index, total, onAnswer) => SentenceClozeBody(
            sentence: sentence,
            translation: translation,
            targetReading: entry.reading,
            options: clozeOptions,
            correctIndex: correctIndex,
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

    if (mcqOnly) {
      return pairs.map((pair) {
        final (entry, card) = pair;
        final n = mcqSettings.mcqChoiceCount;
        final distractors = pool.where((v) => v.id != entry.id).toList()
          ..shuffle(rng);
        final optionEntries = [entry, ...distractors.take(n - 1)]..shuffle(rng);
        final correctIndex = optionEntries.indexWhere((v) => v.id == entry.id);
        final mcqOptions = List.generate(
          optionEntries.length,
          (i) => McqOption(
            letter: String.fromCharCode(65 + i),
            text: meaningOf(optionEntries[i]),
          ),
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
              options: mcqOptions,
              correctIndex: correctIndex,
              isFreeMode: true,
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

    // Mixed mode (SRS): JP↔EN flashcard, MCQ, sentence cloze
    final nativeOnly = sentenceSettings.nativeTranslationOnly && locale != 'en';
    final sessionIds = pairs.map((p) => p.$1.id).toList();
    final sentencesByVocabId = await db.getSentencesBatch(sessionIds);
    final allSentenceIds = sentencesByVocabId.values
        .expand((list) => list)
        .map((s) => s.id)
        .toList();
    final sentenceTranslations = await db.getSentenceTranslations(
      allSentenceIds,
      locale,
      nativeOnly: nativeOnly,
    );

    PracticeItem buildClozeItem(
      VocabularyEntry entry,
      dynamic card,
      List<Sentence> sentences,
    ) {
      final sentence = sentences[rng.nextInt(sentences.length)];
      final translation = sentenceTranslations[sentence.id];
      final n = sentenceSettings.mcqChoiceCount;
      final distractors = pool.where((v) => v.id != entry.id).toList()
        ..shuffle(rng);
      final optionEntries = [entry, ...distractors.take(n - 1)]..shuffle(rng);
      final correctIndex = optionEntries.indexWhere((v) => v.id == entry.id);
      final clozeOptions = List.generate(
        optionEntries.length,
        (i) => McqOption(
          letter: String.fromCharCode(65 + i),
          text: optionEntries[i].word,
          reading: optionEntries[i].reading,
          useJpFont: true,
        ),
      );
      return PracticeItem(
        id: entry.id,
        srsType: 'vocabulary',
        card: card,
        buildBody: (index, total, onAnswer) => SentenceClozeBody(
          sentence: sentence,
          translation: translation,
          targetReading: entry.reading,
          options: clozeOptions,
          correctIndex: correctIndex,
          isFreeMode: freeMode,
          card: card,
          index: index,
          total: total,
          color: color,
          onAnswer: onAnswer,
        ),
      );
    }

    return pairs.map((pair) {
      final (entry, card) = pair;
      final allSentences = sentencesByVocabId[entry.id] ?? [];
      final sentences = nativeOnly
          ? allSentences
                .where((s) => sentenceTranslations.containsKey(s.id))
                .toList()
          : allSentences;
      final hasSentence = sentences.isNotEmpty;

      // 0: JP→EN flashcard, 1: EN→JP flashcard, 2: MCQ, 3: sentence cloze
      final typeCount = hasSentence ? 4 : 3;
      final quizType = rng.nextInt(typeCount);

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
        final n = mcqSettings.mcqChoiceCount;
        final distractors = pool.where((v) => v.id != entry.id).toList()
          ..shuffle(rng);
        final optionEntries = [entry, ...distractors.take(n - 1)]..shuffle(rng);
        final correctIndex = optionEntries.indexWhere((v) => v.id == entry.id);
        final mcqOptions = List.generate(
          optionEntries.length,
          (i) => McqOption(
            letter: String.fromCharCode(65 + i),
            text: meaningOf(optionEntries[i]),
          ),
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
              options: mcqOptions,
              correctIndex: correctIndex,
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

      return buildClozeItem(entry, card, sentences);
    }).toList();
  }
}

final vocabSessionServiceProvider = Provider(
  (_) => const VocabSessionService(),
);
