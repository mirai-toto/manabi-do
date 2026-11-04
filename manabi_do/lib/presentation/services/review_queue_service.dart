import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/home_settings_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/srs_settings_provider.dart';
import '../../core/text/short_meaning.dart';
import '../../core/text/translated_or.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';
import '../providers/mcq_settings_provider.dart';
import '../providers/sentence_settings_provider.dart';
import '../../core/models/practice_item.dart';
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
    final settings = _ref.read(srsSettingsProvider);
    final mcqSettings = _ref.read(mcqSettingsProvider);
    final queue = await _ref
        .read(srsQueueServiceProvider)
        .kana(type, newCardLimit: settings.newCharactersPerDay);
    final allKana = await db.getKanaByType(type);
    final rng = Random();

    return queue.map((pair) {
      final (kana, card) = pair;
      return rng.nextBool()
          ? kanaMcqItem(
              kana,
              card,
              pool: allKana,
              choiceCount: mcqSettings.mcqChoiceCount,
              rng: rng,
            )
          : kanaFlashcardItem(kana, card);
    }).toList();
  }

  Future<List<PracticeItem>> kana() async {
    final db = _ref.read(databaseProvider);
    final settings = _ref.read(srsSettingsProvider);
    final mcqSettings = _ref.read(mcqSettingsProvider);
    final pairs = await _ref
        .read(srsQueueServiceProvider)
        .allDueKana(newCardLimit: settings.newCharactersPerDay);
    final allHiragana = await db.getKanaByType('hiragana');
    final allKatakana = await db.getKanaByType('katakana');
    final rng = Random();

    return pairs.map((pair) {
      final (kana, card) = pair;
      return kanaMcqItem(
        kana,
        card,
        pool: kana.type == 'hiragana' ? allHiragana : allKatakana,
        choiceCount: mcqSettings.mcqChoiceCount,
        rng: rng,
      );
    }).toList()..shuffle(rng);
  }

  /// Everything due today across the decks enabled in the home settings,
  /// shuffled together.
  Future<List<PracticeItem>> allDue() async {
    final settings = _ref.read(homeSettingsProvider);
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
    final settings = _ref.read(srsSettingsProvider);
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
    String meaningOf(Kanji k) =>
        shortMeaning(translatedOr(kanjiTranslations, k.id, k.meaning));
    final rng = Random();

    return pairs.map((pair) {
      final (kanji, card) = pair;
      // 0: kanji -> meaning, 1: meaning -> kanji, 2: drawing. No flashcard here:
      // the daily queue only asks questions you have to answer.
      final quizType = rng.nextInt(3);
      if (quizType == 2) {
        return kanjiDrawingItem(kanji, card, meaning: meaningOf(kanji));
      }
      return kanjiMcqItem(
        kanji,
        card,
        isKanjiToMeaning: quizType == 0,
        pool: allKanji,
        meaningOf: meaningOf,
        choiceCount: mcqSettings.mcqChoiceCount,
        rng: rng,
      );
    }).toList()..shuffle(rng);
  }

  Future<List<PracticeItem>> vocabulary() async {
    final db = _ref.read(databaseProvider);
    final locale = _ref.read(localeProvider).languageCode;
    final settings = _ref.read(srsSettingsProvider);
    final mcqSettings = _ref.read(mcqSettingsProvider);
    final sentenceSettings = _ref.read(sentenceSettingsProvider);
    final pairs = await _ref
        .read(srsQueueServiceProvider)
        .allDueVocabulary(newCardLimit: settings.newVocabularyPerDay);
    final allVocabulary = await db.getAllVocabulary();
    final allTranslations = locale != 'en'
        ? await db.getVocabularyTranslations(
            allVocabulary.map((v) => v.id).toList(),
            locale,
          )
        : <int, String>{};
    final sentences = await loadVocabularySentences(
      db,
      pairs.map((p) => p.$1.id).toList(),
      locale: locale,
      nativeTranslationOnly: sentenceSettings.nativeTranslationOnly,
    );
    final rng = Random();

    String meaningOf(VocabularyEntry v) =>
        shortMeaning(translatedOr(allTranslations, v.id, v.meaning));

    return pairs.map((pair) {
      final (entry, card) = pair;
      final wordSentences = sentences.forWord(entry.id);
      // Multiple choice, or a sentence cloze when the word has a sentence to
      // hide it in. No flashcard here: the daily queue only asks questions you
      // have to answer.
      if (wordSentences.isEmpty || rng.nextBool()) {
        return vocabularyMcqItem(
          entry,
          card,
          pool: allVocabulary,
          meaningOf: meaningOf,
          choiceCount: mcqSettings.mcqChoiceCount,
          rng: rng,
        );
      }
      return vocabularyClozeItem(
        entry,
        card,
        sentence: wordSentences[rng.nextInt(wordSentences.length)],
        sentences: sentences,
        pool: allVocabulary,
        choiceCount: sentenceSettings.mcqChoiceCount,
        rng: rng,
      );
    }).toList()..shuffle(rng);
  }
}

final reviewQueueServiceProvider = Provider((ref) => ReviewQueueService(ref));
