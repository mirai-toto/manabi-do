import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/locale_provider.dart';
import '../../core/providers/srs_settings_provider.dart';
import '../../core/theme/jlpt_level.dart';
import '../../data/database/app_database.dart';
import '../../l10n/l10n.dart';
import '../providers/database_provider.dart';
import '../providers/mcq_settings_provider.dart';
import '../providers/sentence_settings_provider.dart';
import '../screens/characters/kanji/kanji_practice_screen.dart';
import '../screens/practice/practice_session_screen.dart';
import '../screens/practice/sentence_cloze_body.dart';
import '../widgets/exercise/mcq_card.dart';

Future<List<PracticeItem>> loadKanaPracticeQueue(
  String type,
  WidgetRef ref,
) async {
  final db = ref.read(databaseProvider);
  final settings = await ref.read(srsSettingsProvider.future);
  final color = levelColor('kana');
  final queue = await db.getKanaSrsSession(
    type,
    newCardLimit: settings.newCharactersPerDay,
  );
  return queue.map((pair) {
    final (kana, card) = pair;
    return PracticeItem(
      id: kana.id,
      srsType: type,
      card: card,
      buildBody: (index, total, onAnswer) => PracticeFlashcardBody(
        japanese: kana.character,
        answer: kana.romaji,
        card: card,
        index: index,
        total: total,
        color: color,
        onAnswer: onAnswer,
      ),
    );
  }).toList();
}

Future<List<PracticeItem>> loadKanaQueue(WidgetRef ref) async {
  final db = ref.read(databaseProvider);
  final settings = await ref.read(srsSettingsProvider.future);
  final pairs = await db.getAllDueKanaSrsSession(
    newCardLimit: settings.newCharactersPerDay,
  );
  final color = levelColor('kana');
  return pairs.map((pair) {
    final (k, card) = pair;
    return PracticeItem(
      id: k.id,
      srsType: k.type,
      card: card,
      buildBody: (index, total, onAnswer) => PracticeFlashcardBody(
        japanese: k.character,
        answer: k.romaji,
        card: card,
        index: index,
        total: total,
        color: color,
        onAnswer: onAnswer,
      ),
    );
  }).toList()..shuffle();
}

Future<List<PracticeItem>> loadKanjiQueue(WidgetRef ref) async {
  final db = ref.read(databaseProvider);
  final settings = await ref.read(srsSettingsProvider.future);
  final mcqSettings = ref.read(mcqSettingsProvider);
  final locale = ref.read(localeProvider).languageCode;
  final pairs = await db.getAllDueKanjiSrsSession(
    newCardLimit: settings.newCharactersPerDay,
  );
  final allKanji = await db.getAllKanji();
  final kanjiTranslations = locale != 'en'
      ? await db.getKanjiTranslations(
          allKanji.map((k) => k.id).toList(),
          locale,
        )
      : <int, String>{};
  String meaningOf(Kanji k) => kanjiTranslations[k.id]?.isNotEmpty == true
      ? kanjiTranslations[k.id]!
      : k.meaning;
  final rng = Random();

  return pairs.map((pair) {
    final (k, card) = pair;
    final color = levelColor(k.jlptLevel);
    final quizType = rng.nextInt(4);

    if (quizType == 0) {
      return PracticeItem(
        id: k.id,
        srsType: 'kanji',
        card: card,
        buildBody: (index, total, onAnswer) => PracticeFlashcardBody(
          japanese: k.character,
          answer: meaningOf(k),
          card: card,
          index: index,
          total: total,
          color: color,
          onAnswer: onAnswer,
        ),
      );
    }

    if (quizType == 3) {
      return PracticeItem(
        id: k.id,
        srsType: 'kanji',
        card: card,
        buildBody: (index, total, onAnswer) => KanjiDrawingBody(
          kanji: k,
          meaning: meaningOf(k),
          card: card,
          index: index,
          total: total,
          color: color,
          onAnswer: onAnswer,
        ),
      );
    }

    final isKanjiToMeaning = quizType == 1;
    final n = mcqSettings.mcqChoiceCount;
    final distractors = allKanji.where((d) => d.id != k.id).toList()
      ..shuffle(rng);
    final options = [k, ...distractors.take(n - 1)]..shuffle(rng);
    final correctIndex = options.indexWhere((d) => d.id == k.id);
    final mcqOptions = List.generate(
      options.length,
      (i) => McqOption(
        letter: String.fromCharCode(65 + i),
        text: isKanjiToMeaning ? meaningOf(options[i]) : options[i].character,
        useJpFont: !isKanjiToMeaning,
      ),
    );

    return PracticeItem(
      id: k.id,
      srsType: 'kanji',
      card: card,
      buildBody: (index, total, onAnswer) => Builder(
        builder: (ctx) => PracticeMcqBody(
          question: isKanjiToMeaning
              ? ctx.l10n.mcqSelectMeaning
              : ctx.l10n.mcqSelectKanji(meaningOf(k)),
          japanesePrompt: isKanjiToMeaning ? k.character : null,
          options: mcqOptions,
          correctIndex: correctIndex,
          card: card,
          index: index,
          total: total,
          color: color,
          onAnswer: onAnswer,
          compactGrid: !isKanjiToMeaning,
        ),
      ),
    );
  }).toList()..shuffle(rng);
}

Future<List<PracticeItem>> loadVocabQueue(WidgetRef ref) async {
  final db = ref.read(databaseProvider);
  final locale = ref.read(localeProvider).languageCode;
  final settings = await ref.read(srsSettingsProvider.future);
  final mcqSettings = ref.read(mcqSettingsProvider);
  final sentenceSettings = ref.read(sentenceSettingsProvider);
  final pairs = await db.getAllDueVocabSrsSession(
    newCardLimit: settings.newVocabPerDay,
  );
  final allVocab = await db.getAllVocab();
  final ids = pairs.map((p) => p.$1.id).toList();
  final allIds = allVocab.map((v) => v.id).toList();
  final allTranslations = locale != 'en'
      ? await db.getVocabTranslations(allIds, locale)
      : <int, String>{};
  final nativeOnly = sentenceSettings.nativeTranslationOnly && locale != 'en';
  final sentencesByVocabId = await db.getSentencesBatch(ids);
  final allSentenceIds = sentencesByVocabId.values
      .expand((list) => list)
      .map((s) => s.id)
      .toList();
  final sentenceTranslations = await db.getSentenceTranslations(
    allSentenceIds,
    locale,
    nativeOnly: nativeOnly,
  );
  final rng = Random();

  String meaningOf(VocabularyEntry v) =>
      allTranslations[v.id]?.isNotEmpty == true
      ? allTranslations[v.id]!
      : v.meaning;

  return pairs.map((pair) {
    final (entry, card) = pair;
    final color = levelColor(entry.jlptLevel);
    final allSentences = sentencesByVocabId[entry.id] ?? [];
    final sentences = nativeOnly
        ? allSentences
              .where((s) => sentenceTranslations.containsKey(s.id))
              .toList()
        : allSentences;
    final hasSentence = sentences.isNotEmpty;
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
      final distractors = allVocab.where((v) => v.id != entry.id).toList()
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
          builder: (ctx) => PracticeMcqBody(
            question: ctx.l10n.mcqSelectWordMeaning,
            japanesePrompt: entry.word,
            japaneseReading: entry.reading != entry.word ? entry.reading : null,
            options: mcqOptions,
            correctIndex: correctIndex,
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
    final n = sentenceSettings.mcqChoiceCount;
    final distractors = allVocab.where((v) => v.id != entry.id).toList()
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
        translation: sentenceTranslations[sentence.id],
        targetReading: entry.reading,
        options: clozeOptions,
        correctIndex: correctIndex,
        card: card,
        index: index,
        total: total,
        color: color,
        onAnswer: onAnswer,
      ),
    );
  }).toList()..shuffle(rng);
}
