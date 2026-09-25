import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/home_settings_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/srs_settings_provider.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';
import '../providers/mcq_settings_provider.dart';
import '../providers/sentence_settings_provider.dart';
import '../../core/models/practice_item.dart';
import '../../core/models/practice_question.dart';
import 'session_item_builders.dart';
import 'srs_queue_service.dart';

/// The daily review queues, and the per-deck ones the home screen offers.
///
/// Everything here is due-now work drawn from the SRS, as opposed to the free
/// practice a session service builds for a level you picked yourself.
class ReviewQueueService {
  final Ref _ref;

  const ReviewQueueService(this._ref);

  Future<List<PracticeItem>> kanaPractice(String type) async {
    final db = _ref.read(databaseProvider);
    final settings = await _ref.read(srsSettingsProvider.future);
    final mcqSettings = _ref.read(mcqSettingsProvider);
    final queue = await _ref
        .read(srsQueueServiceProvider)
        .kana(type, newCardLimit: settings.newCharactersPerDay);
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
            kindLabel: (l) =>
                type == 'hiragana' ? l.tabHiragana : l.tabKatakana,
            selfAssessed: false,
          ),
          question: McqQuestion(
            prompt: (l) => l.mcqSelectKanaReading,
            japanesePrompt: kana.character,
            options: kanaMcq.options,
            correctIndex: kanaMcq.correctIndex,
            level: 'kana',
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
        question: FlashcardQuestion(
          japanese: kana.character,
          answer: kana.romaji,
          level: 'kana',
        ),
      );
    }).toList();
  }

  Future<List<PracticeItem>> kana() async {
    final db = _ref.read(databaseProvider);
    final settings = await _ref.read(srsSettingsProvider.future);
    final mcqSettings = _ref.read(mcqSettingsProvider);
    final pairs = await _ref
        .read(srsQueueServiceProvider)
        .allDueKana(newCardLimit: settings.newCharactersPerDay);
    final allHiragana = await db.getKanaByType('hiragana');
    final allKatakana = await db.getKanaByType('katakana');
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
          kindLabel: (l) =>
              k.type == 'hiragana' ? l.tabHiragana : l.tabKatakana,
          selfAssessed: false,
        ),
        question: McqQuestion(
          prompt: (l) => l.mcqSelectKanaReading,
          japanesePrompt: k.character,
          options: kanaMcq.options,
          correctIndex: kanaMcq.correctIndex,
          level: 'kana',
        ),
      );
    }).toList())..shuffle(rng);
  }

  /// Everything due today across the decks enabled in the home settings,
  /// shuffled together.
  Future<List<PracticeItem>> allDue() async {
    final settings = await _ref.read(homeSettingsProvider.future);
    final queues = await Future.wait([
      if (settings.showKana) kana(),
      if (settings.showKanji) kanji(),
      if (settings.showVocabulary) vocabulary(),
    ]);
    // Shuffled before the dedupe, not after, so which copy of a duplicated word
    // survives varies per session. Dropping a fixed one would leave the other
    // permanently due and never reviewed.
    return _dropRepeatedPrompts(queues.expand((q) => q).toList()..shuffle());
  }

  /// Drops items that would read as the same question as one already in the
  /// queue.
  ///
  /// 57 vocabulary rows are exact duplicates — same word, same reading, same
  /// meaning — differing only by `id` and the JLPT level they were filed under.
  /// Each is its own SRS card, so both fall due together and the daily queue,
  /// which merges every level, asks the identical question twice.
  ///
  /// Matching is on the prompt and answer the learner actually sees rather than
  /// on the id, because the ids are exactly what differ. Items of the same kind
  /// only: a kanji and a one-character word that share a character are a
  /// different question about the same glyph, and that is deliberately kept —
  /// see the note in `docs/03_database.md`.
  List<PracticeItem> _dropRepeatedPrompts(List<PracticeItem> items) {
    final seen = <String>{};
    return items
        .where(
          (i) => seen.add(
            '${i.srsType}\u0000${i.summary.item}\u0000${i.summary.answer}',
          ),
        )
        .toList();
  }

  Future<List<PracticeItem>> kanji() async {
    final db = _ref.read(databaseProvider);
    final settings = await _ref.read(srsSettingsProvider.future);
    final mcqSettings = _ref.read(mcqSettingsProvider);
    final locale = _ref.read(localeProvider).languageCode;
    final pairs = await _ref
        .read(srsQueueServiceProvider)
        .allDueKanji(newCardLimit: settings.newCharactersPerDay);
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
          question: DrawingQuestion(
            kanji: k,
            meaning: meaningOf(k),
            level: k.jlptLevel,
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
        question: McqQuestion(
          prompt: (l) => isKanjiToMeaning
              ? l.mcqSelectMeaning
              : l.mcqSelectKanji(meaningOf(k)),
          japanesePrompt: isKanjiToMeaning ? k.character : null,
          options: mcqOptions,
          correctIndex: correctIndex,
          compactGrid: !isKanjiToMeaning,
          level: k.jlptLevel,
        ),
      );
    }).toList()..shuffle(rng);
  }

  Future<List<PracticeItem>> vocabulary() async {
    final db = _ref.read(databaseProvider);
    final locale = _ref.read(localeProvider).languageCode;
    final settings = await _ref.read(srsSettingsProvider.future);
    final mcqSettings = _ref.read(mcqSettingsProvider);
    final sentenceSettings = _ref.read(sentenceSettingsProvider);
    final pairs = await _ref
        .read(srsQueueServiceProvider)
        .allDueVocabulary(newCardLimit: settings.newVocabularyPerDay);
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
          question: McqQuestion(
            prompt: (l) => l.mcqSelectWordMeaning,
            japanesePrompt: entry.word,
            japaneseReading: entry.reading != entry.word ? entry.reading : null,
            options: mcqOptions,
            correctIndex: correctIndex,
            level: entry.jlptLevel,
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
        question: SentenceClozeQuestion(
          sentence: sentence,
          translation: sentenceTranslations[sentence.id],
          targetReading: entry.reading,
          options: clozeOptions,
          correctIndex: correctIndex,
          level: entry.jlptLevel,
        ),
      );
    }).toList()..shuffle(rng);
  }
}

final reviewQueueServiceProvider = Provider((ref) => ReviewQueueService(ref));
