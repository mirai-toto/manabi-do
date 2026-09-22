import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/home_settings_provider.dart';
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
import '../widgets/exercise/sentence_cloze_body.dart';
import 'session_item_builders.dart';

Future<List<PracticeItem>> loadKanaPracticeQueue(
  String type,
  WidgetRef ref,
) async {
  final db = ref.read(databaseProvider);
  final settings = await ref.read(srsSettingsProvider.future);
  final mcqSettings = ref.read(mcqSettingsProvider);
  final color = levelColor('kana');
  final queue = await db.getKanaSrsSession(
    type,
    newCardLimit: settings.newCharactersPerDay,
  );
  final allKana = await db.getKanaByType(type);
  final rng = Random();

  return queue.map((pair) {
    final (kana, card) = pair;
    if (rng.nextBool()) {
      final kanaMcq = buildKanaMcqOptions(
        target: kana,
        pool: allKana,
        n: mcqSettings.mcqChoiceCount,
        rng: rng,
      );
      return PracticeItem(
        id: kana.id,
        srsType: type,
        card: card,
        summary: PracticeSummary(
          item: kana.character,
          question: (l) => l.mcqSelectKanaReading,
          answer: kana.romaji,
          kindLabel: (l) => type == 'hiragana' ? l.tabHiragana : l.tabKatakana,
          selfAssessed: false,
        ),
        buildBody: (index, total, onAnswer, settings) => Builder(
          builder: (ctx) => PracticeMcqBody(
            question: ctx.l10n.mcqSelectKanaReading,
            japanesePrompt: kana.character,
            options: kanaMcq.options,
            correctIndex: kanaMcq.correctIndex,
            card: card,
            index: index,
            total: total,
            color: color,
            onAnswer: onAnswer,
            autoAdvance: settings.autoAdvance,
            showPromptFurigana: settings.mcq.showPromptFurigana,
          ),
        ),
      );
    }
    return PracticeItem(
      id: kana.id,
      srsType: type,
      card: card,
      summary: PracticeSummary(
        item: kana.character,
        question: (l) => l.flashcardDefaultPrompt,
        answer: kana.romaji,
        kindLabel: (l) => type == 'hiragana' ? l.tabHiragana : l.tabKatakana,
        selfAssessed: true,
      ),
      buildBody: (index, total, onAnswer, settings) => PracticeFlashcardBody(
        japanese: kana.character,
        answer: kana.romaji,
        card: card,
        index: index,
        total: total,
        color: color,
        onAnswer: onAnswer,
        showExample: settings.flashcard.showExample,
      ),
    );
  }).toList();
}

Future<List<PracticeItem>> loadKanaQueue(WidgetRef ref) async {
  final db = ref.read(databaseProvider);
  final settings = await ref.read(srsSettingsProvider.future);
  final mcqSettings = ref.read(mcqSettingsProvider);
  final pairs = await db.getAllDueKanaSrsSession(
    newCardLimit: settings.newCharactersPerDay,
  );
  final allHiragana = await db.getKanaByType('hiragana');
  final allKatakana = await db.getKanaByType('katakana');
  final color = levelColor('kana');
  final rng = Random();

  return (pairs.map((pair) {
    final (k, card) = pair;
    final pool = k.type == 'hiragana' ? allHiragana : allKatakana;
    final kanaMcq = buildKanaMcqOptions(
      target: k,
      pool: pool,
      n: mcqSettings.mcqChoiceCount,
      rng: rng,
    );
    return PracticeItem(
      id: k.id,
      srsType: k.type,
      card: card,
      summary: PracticeSummary(
        item: k.character,
        question: (l) => l.mcqSelectKanaReading,
        answer: k.romaji,
        kindLabel: (l) => k.type == 'hiragana' ? l.tabHiragana : l.tabKatakana,
        selfAssessed: false,
      ),
      buildBody: (index, total, onAnswer, settings) => Builder(
        builder: (ctx) => PracticeMcqBody(
          question: ctx.l10n.mcqSelectKanaReading,
          japanesePrompt: k.character,
          options: kanaMcq.options,
          correctIndex: kanaMcq.correctIndex,
          card: card,
          index: index,
          total: total,
          color: color,
          onAnswer: onAnswer,
          autoAdvance: settings.autoAdvance,
          showPromptFurigana: settings.mcq.showPromptFurigana,
        ),
      ),
    );
  }).toList())..shuffle(rng);
}

/// Everything due today across the decks enabled in the home settings,
/// shuffled together.
Future<List<PracticeItem>> loadAllDueQueue(WidgetRef ref) async {
  final settings = await ref.read(homeSettingsProvider.future);
  final queues = await Future.wait([
    if (settings.showKana) loadKanaQueue(ref),
    if (settings.showKanji) loadKanjiQueue(ref),
    if (settings.showVocabulary) loadVocabularyQueue(ref),
  ]);
  return queues.expand((q) => q).toList()..shuffle();
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
    // 0: kanji -> meaning, 1: meaning -> kanji, 2: drawing. No flashcard here:
    // the daily queue only asks questions you have to answer.
    final quizType = rng.nextInt(3);

    if (quizType == 2) {
      return PracticeItem(
        id: k.id,
        srsType: 'kanji',
        card: card,
        summary: PracticeSummary(
          item: k.character,
          question: (l) => l.reviewDrawPrompt(meaningOf(k)),
          answer: meaningOf(k),
          kindLabel: (l) => l.reviewKindKanjiWriting,
          selfAssessed: true,
        ),
        buildBody: (index, total, onAnswer, settings) => KanjiDrawingBody(
          kanji: k,
          meaning: meaningOf(k),
          card: card,
          index: index,
          total: total,
          color: color,
          onAnswer: onAnswer,
          autoAdvance: settings.autoAdvance,
        ),
      );
    }

    final isKanjiToMeaning = quizType == 0;
    final kanjiMcq = buildKanjiMcqOptions(
      target: k,
      pool: allKanji,
      n: mcqSettings.mcqChoiceCount,
      isKanjiToMeaning: isKanjiToMeaning,
      meaningOf: meaningOf,
      rng: rng,
    );
    final mcqOptions = kanjiMcq.options;
    final correctIndex = kanjiMcq.correctIndex;

    return PracticeItem(
      id: k.id,
      srsType: 'kanji',
      card: card,
      summary: PracticeSummary(
        item: k.character,
        question: (l) => isKanjiToMeaning
            ? l.mcqSelectMeaning
            : l.mcqSelectKanji(meaningOf(k)),
        answer: isKanjiToMeaning ? meaningOf(k) : k.character,
        kindLabel: (l) => l.tabKanji,
        selfAssessed: false,
      ),
      buildBody: (index, total, onAnswer, settings) => Builder(
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
          autoAdvance: settings.autoAdvance,
          showPromptFurigana: settings.mcq.showPromptFurigana,
          compactGrid: !isKanjiToMeaning,
        ),
      ),
    );
  }).toList()..shuffle(rng);
}

Future<List<PracticeItem>> loadVocabularyQueue(WidgetRef ref) async {
  final db = ref.read(databaseProvider);
  final locale = ref.read(localeProvider).languageCode;
  final settings = await ref.read(srsSettingsProvider.future);
  final mcqSettings = ref.read(mcqSettingsProvider);
  final sentenceSettings = ref.read(sentenceSettingsProvider);
  final pairs = await db.getAllDueVocabularySrsSession(
    newCardLimit: settings.newVocabularyPerDay,
  );
  final allVocabulary = await db.getAllVocabulary();
  final ids = pairs.map((p) => p.$1.id).toList();
  final allIds = allVocabulary.map((v) => v.id).toList();
  final allTranslations = locale != 'en'
      ? await db.getVocabularyTranslations(allIds, locale)
      : <int, String>{};
  final nativeOnly = sentenceSettings.nativeTranslationOnly && locale != 'en';
  final sentencesByVocabularyId = await db.getSentencesBatch(ids);
  final allSentenceIds = sentencesByVocabularyId.values
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
    final allSentences = sentencesByVocabularyId[entry.id] ?? [];
    final sentences = nativeOnly
        ? allSentences
              .where((s) => sentenceTranslations.containsKey(s.id))
              .toList()
        : allSentences;
    // Multiple choice, or a sentence cloze when the word has a sentence to
    // hide it in. No flashcard here: the daily queue only asks questions you
    // have to answer.
    final useCloze = sentences.isNotEmpty && rng.nextBool();

    if (!useCloze) {
      final vocabularyMcq = buildVocabularyMcqOptions(
        target: entry,
        pool: allVocabulary,
        n: mcqSettings.mcqChoiceCount,
        meaningOf: meaningOf,
        rng: rng,
      );
      final mcqOptions = vocabularyMcq.options;
      final correctIndex = vocabularyMcq.correctIndex;
      return PracticeItem(
        id: entry.id,
        srsType: 'vocabulary',
        card: card,
        summary: PracticeSummary(
          item: entry.word,
          reading: entry.reading != entry.word ? entry.reading : null,
          question: (l) => l.mcqSelectWordMeaning,
          answer: meaningOf(entry),
          kindLabel: (l) => l.sectionVocabulary,
          selfAssessed: false,
        ),
        buildBody: (index, total, onAnswer, settings) => Builder(
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
            autoAdvance: settings.autoAdvance,
            showPromptFurigana: settings.mcq.showPromptFurigana,
          ),
        ),
      );
    }

    final sentence = sentences[rng.nextInt(sentences.length)];
    final cloze = buildClozeOptions(
      target: entry,
      pool: allVocabulary,
      n: sentenceSettings.mcqChoiceCount,
      rng: rng,
    );
    final clozeOptions = cloze.options;
    final correctIndex = cloze.correctIndex;
    return PracticeItem(
      id: entry.id,
      srsType: 'vocabulary',
      card: card,
      summary: PracticeSummary(
        item: entry.word,
        reading: entry.reading != entry.word ? entry.reading : null,
        question: (l) => l.reviewClozePrompt,
        answer: entry.word,
        kindLabel: (l) => l.reviewKindVocabularySentence,
        selfAssessed: false,
        sentence: sentence.japanese,
        sentenceTranslation: sentenceTranslations[sentence.id],
      ),
      buildBody: (index, total, onAnswer, settings) => SentenceClozeBody(
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
        autoAdvance: settings.autoAdvance,
        translationMode: settings.sentence.translationMode,
        showSentenceFurigana: settings.sentence.showSentenceFurigana,
        showChoiceFurigana: settings.sentence.showChoiceFurigana,
      ),
    );
  }).toList()..shuffle(rng);
}
