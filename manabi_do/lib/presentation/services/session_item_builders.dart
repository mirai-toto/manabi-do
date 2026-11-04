import 'dart:math';

import 'package:fsrs/fsrs.dart' show Card;

import '../../core/models/mcq_option.dart';
import '../../core/models/practice_item.dart';
import '../../core/models/practice_question.dart';
import '../../core/text/sentence_language.dart';
import '../../l10n/app_localizations.dart';
import '../../data/database/app_database.dart';

// The reading shown under a kanji prompt: first on'yomi, else first kun'yomi.
String? kanjiPromptReading(Kanji kanji) => kanji.onReading.isNotEmpty
    ? kanji.onReading.split('、').first
    : kanji.kunReading.split('、').firstOrNull;

// Picks up to [count] distractors from [pool], shuffling first and skipping
// any whose display key is already in [seen]. Mutates [seen] as it picks.
List<T> _pickDistractors<T>({
  required List<T> pool,
  required String Function(T) key,
  required Set<String> seen,
  required int count,
  required Random rng,
}) {
  final shuffled = [...pool]..shuffle(rng);
  final result = <T>[];
  for (final item in shuffled) {
    if (seen.add(key(item))) {
      result.add(item);
      if (result.length >= count) break;
    }
  }
  return result;
}

({List<McqOption> options, int correctIndex}) buildKanaMcqOptions({
  required Kana target,
  required List<Kana> pool,
  required int n,
  required Random rng,
}) {
  final seen = <String>{target.romaji};
  final distractors = _pickDistractors(
    pool: pool.where((k) => k.id != target.id).toList(),
    key: (k) => k.romaji,
    seen: seen,
    count: n - 1,
    rng: rng,
  );
  final options = [target, ...distractors]..shuffle(rng);
  final correctIndex = options.indexWhere((k) => k.id == target.id);
  return (
    options: List.generate(
      options.length,
      (i) => McqOption(letter: optionLetter(i), text: options[i].romaji),
    ),
    correctIndex: correctIndex,
  );
}

({List<McqOption> options, int correctIndex}) buildKanjiMcqOptions({
  required Kanji target,
  required List<Kanji> pool,
  required int n,
  required bool isKanjiToMeaning,
  required String Function(Kanji) meaningOf,
  required Random rng,
}) {
  final displayOf = isKanjiToMeaning
      ? (Kanji k) => meaningOf(k)
      : (Kanji k) => k.character;
  final seen = <String>{displayOf(target)};
  final distractors = _pickDistractors(
    pool: pool.where((k) => k.id != target.id).toList(),
    key: displayOf,
    seen: seen,
    count: n - 1,
    rng: rng,
  );
  final options = [target, ...distractors]..shuffle(rng);
  final correctIndex = options.indexWhere((k) => k.id == target.id);
  return (
    options: List.generate(
      options.length,
      (i) => McqOption(
        letter: optionLetter(i),
        text: displayOf(options[i]),
        useJpFont: !isKanjiToMeaning,
      ),
    ),
    correctIndex: correctIndex,
  );
}

({List<McqOption> options, int correctIndex}) buildVocabularyMcqOptions({
  required VocabularyEntry target,
  required List<VocabularyEntry> pool,
  required int n,
  required String Function(VocabularyEntry) meaningOf,
  required Random rng,
}) {
  final seen = <String>{meaningOf(target)};
  final distractors = _pickDistractors(
    pool: pool.where((v) => v.id != target.id).toList(),
    key: meaningOf,
    seen: seen,
    count: n - 1,
    rng: rng,
  );
  final optionEntries = [target, ...distractors]..shuffle(rng);
  final correctIndex = optionEntries.indexWhere((v) => v.id == target.id);
  return (
    options: List.generate(
      optionEntries.length,
      (i) =>
          McqOption(letter: optionLetter(i), text: meaningOf(optionEntries[i])),
    ),
    correctIndex: correctIndex,
  );
}

({List<McqOption> options, int correctIndex}) buildClozeOptions({
  required VocabularyEntry target,
  required List<VocabularyEntry> pool,
  required int n,
  required Random rng,
}) {
  final seen = <String>{target.word};
  final distractors = _pickDistractors(
    pool: pool.where((v) => v.id != target.id).toList(),
    key: (v) => v.word,
    seen: seen,
    count: n - 1,
    rng: rng,
  );
  final optionEntries = [target, ...distractors]..shuffle(rng);
  final correctIndex = optionEntries.indexWhere((v) => v.id == target.id);
  return (
    options: List.generate(
      optionEntries.length,
      (i) => McqOption(
        letter: optionLetter(i),
        text: optionEntries[i].word,
        reading: optionEntries[i].reading,
        useJpFont: true,
      ),
    ),
    correctIndex: correctIndex,
  );
}

// ── Practice items ──────────────────────────────────────────────────────────
//
// One builder per exercise kind, shared by the free-practice session services
// and the daily review queue, so the two cannot drift apart.

String? _readingIfDifferent(VocabularyEntry entry) =>
    entry.reading != entry.word ? entry.reading : null;

PracticeItem kanaFlashcardItem(Kana kana, Card? card) => PracticeItem(
  id: kana.id,
  srsType: kana.type,
  card: card,
  summary: PracticeSummary(
    item: kana.character,
    question: (l) => l.flashcardDefaultPrompt,
    answer: kana.romaji,
    kindLabel: (l) => kana.type == 'hiragana' ? l.tabHiragana : l.tabKatakana,
  ),
  question: FlashcardQuestion(
    japanese: kana.character,
    answer: kana.romaji,
    level: 'kana',
  ),
);

PracticeItem kanaMcqItem(
  Kana kana,
  Card? card, {
  required List<Kana> pool,
  required int choiceCount,
  required Random rng,
}) {
  final mcq = buildKanaMcqOptions(
    target: kana,
    pool: pool,
    n: choiceCount,
    rng: rng,
  );
  return PracticeItem(
    id: kana.id,
    srsType: kana.type,
    card: card,
    summary: PracticeSummary(
      item: kana.character,
      question: (l) => l.mcqSelectKanaReading,
      answer: kana.romaji,
      kindLabel: (l) => kana.type == 'hiragana' ? l.tabHiragana : l.tabKatakana,
    ),
    question: McqQuestion(
      prompt: (l) => l.mcqSelectKanaReading,
      japanesePrompt: kana.character,
      options: mcq.options,
      correctIndex: mcq.correctIndex,
      level: 'kana',
    ),
  );
}

PracticeItem kanjiFlashcardItem(
  Kanji kanji,
  Card? card, {
  required String meaning,
  bool isFreeMode = false,
}) => PracticeItem(
  id: kanji.id,
  srsType: 'kanji',
  card: card,
  summary: PracticeSummary(
    item: kanji.character,
    question: (l) => l.flashcardDefaultPrompt,
    answer: meaning,
    kindLabel: (l) => l.tabKanji,
  ),
  question: FlashcardQuestion(
    japanese: kanji.character,
    answer: meaning,
    level: kanji.jlptLevel,
    isFreeMode: isFreeMode,
    kanjiDetailId: kanji.id,
  ),
);

PracticeItem kanjiDrawingItem(
  Kanji kanji,
  Card? card, {
  required String meaning,
  bool isFreeMode = false,
}) => PracticeItem(
  id: kanji.id,
  srsType: 'kanji',
  card: card,
  summary: PracticeSummary(
    item: kanji.character,
    question: (l) => l.reviewDrawPrompt(meaning),
    answer: meaning,
    kindLabel: (l) => l.reviewKindKanjiWriting,
  ),
  question: DrawingQuestion(
    kanji: kanji,
    meaning: meaning,
    level: kanji.jlptLevel,
    isFreeMode: isFreeMode,
    kanjiDetailId: kanji.id,
  ),
);

PracticeItem kanjiMcqItem(
  Kanji kanji,
  Card? card, {
  required bool isKanjiToMeaning,
  required List<Kanji> pool,
  required String Function(Kanji) meaningOf,
  required int choiceCount,
  required Random rng,
  bool isFreeMode = false,
}) {
  final meaning = meaningOf(kanji);
  final mcq = buildKanjiMcqOptions(
    target: kanji,
    pool: pool,
    n: choiceCount,
    isKanjiToMeaning: isKanjiToMeaning,
    meaningOf: meaningOf,
    rng: rng,
  );
  String prompt(AppLocalizations l) =>
      isKanjiToMeaning ? l.mcqSelectMeaning : l.mcqSelectKanji(meaning);
  return PracticeItem(
    id: kanji.id,
    srsType: 'kanji',
    card: card,
    summary: PracticeSummary(
      item: kanji.character,
      question: prompt,
      answer: isKanjiToMeaning ? meaning : kanji.character,
      kindLabel: (l) => l.tabKanji,
    ),
    question: McqQuestion(
      prompt: prompt,
      japanesePrompt: isKanjiToMeaning ? kanji.character : null,
      japaneseReading: isKanjiToMeaning ? kanjiPromptReading(kanji) : null,
      options: mcq.options,
      correctIndex: mcq.correctIndex,
      compactGrid: !isKanjiToMeaning,
      level: kanji.jlptLevel,
      isFreeMode: isFreeMode,
      kanjiDetailId: kanji.id,
    ),
  );
}

PracticeItem vocabularyFlashcardItem(
  VocabularyEntry entry,
  Card? card, {
  required String meaning,
  required bool isReversed,
  bool isFreeMode = false,
}) => PracticeItem(
  id: entry.id,
  srsType: 'vocabulary',
  card: card,
  summary: PracticeSummary(
    item: entry.word,
    reading: _readingIfDifferent(entry),
    question: (l) =>
        isReversed ? l.flashcardJapaneseQuestion : l.flashcardDefaultPrompt,
    answer: isReversed ? entry.word : meaning,
    kindLabel: (l) => l.sectionVocabulary,
  ),
  question: FlashcardQuestion(
    japanese: entry.word,
    label: _readingIfDifferent(entry),
    answer: meaning,
    isReversed: isReversed,
    vocabularyLevel: entry.vocabularyLevel,
    isFreeMode: isFreeMode,
  ),
);

PracticeItem vocabularyMcqItem(
  VocabularyEntry entry,
  Card? card, {
  required List<VocabularyEntry> pool,
  required String Function(VocabularyEntry) meaningOf,
  required int choiceCount,
  required Random rng,
  bool isFreeMode = false,
}) {
  final mcq = buildVocabularyMcqOptions(
    target: entry,
    pool: pool,
    n: choiceCount,
    meaningOf: meaningOf,
    rng: rng,
  );
  return PracticeItem(
    id: entry.id,
    srsType: 'vocabulary',
    card: card,
    summary: PracticeSummary(
      item: entry.word,
      reading: _readingIfDifferent(entry),
      question: (l) => l.mcqSelectWordMeaning,
      answer: meaningOf(entry),
      kindLabel: (l) => l.sectionVocabulary,
    ),
    question: McqQuestion(
      prompt: (l) => l.mcqSelectWordMeaning,
      japanesePrompt: entry.word,
      japaneseReading: _readingIfDifferent(entry),
      options: mcq.options,
      correctIndex: mcq.correctIndex,
      vocabularyLevel: entry.vocabularyLevel,
      isFreeMode: isFreeMode,
    ),
  );
}

PracticeItem vocabularyClozeItem(
  VocabularyEntry entry,
  Card? card, {
  required Sentence sentence,
  required VocabularySentences sentences,
  required List<VocabularyEntry> pool,
  required int choiceCount,
  required Random rng,
  bool isFreeMode = false,
}) {
  final cloze = buildClozeOptions(
    target: entry,
    pool: pool,
    n: choiceCount,
    rng: rng,
  );
  final translation = sentences.translations[sentence.id];
  return PracticeItem(
    id: entry.id,
    srsType: 'vocabulary',
    card: card,
    summary: PracticeSummary(
      item: entry.word,
      reading: _readingIfDifferent(entry),
      question: (l) => l.reviewClozePrompt,
      answer: entry.word,
      kindLabel: (l) => l.reviewKindVocabularySentence,
      sentence: sentence.japanese,
      sentenceTranslation: translation?.text,
    ),
    question: SentenceClozeQuestion(
      sentence: sentence,
      translation: translation?.text,
      translationMissingLanguage: missingLanguageForSentence(
        translation?.locale,
        sentences.locale,
      ),
      targetReading: entry.reading,
      options: cloze.options,
      correctIndex: cloze.correctIndex,
      vocabularyLevel: entry.vocabularyLevel,
      isFreeMode: isFreeMode,
    ),
  );
}

/// The example sentences of a set of words, with their translations, loaded
/// once for a whole queue.
class VocabularySentences {
  final Map<int, List<Sentence>> _byWord;
  final Map<int, ({String locale, String text})> translations;
  final String locale;
  final bool nativeOnly;

  const VocabularySentences._(
    this._byWord,
    this.translations,
    this.locale,
    this.nativeOnly,
  );

  /// The sentences a cloze for [entryId] may use. With [nativeOnly], only those
  /// translated into the reader's language.
  List<Sentence> forWord(int entryId) {
    final all = _byWord[entryId] ?? const <Sentence>[];
    if (!nativeOnly) return all;
    return all.where((s) => translations.containsKey(s.id)).toList();
  }
}

Future<VocabularySentences> loadVocabularySentences(
  AppDatabase db,
  List<int> vocabularyIds, {
  required String locale,
  required bool nativeTranslationOnly,
}) async {
  final nativeOnly = nativeTranslationOnly && locale != 'en';
  final byWord = await db.getSentencesBatch(vocabularyIds);
  final translations = await db.getSentenceTranslations(
    byWord.values.expand((list) => list).map((s) => s.id).toList(),
    locale,
    nativeOnly: nativeOnly,
  );
  return VocabularySentences._(byWord, translations, locale, nativeOnly);
}
