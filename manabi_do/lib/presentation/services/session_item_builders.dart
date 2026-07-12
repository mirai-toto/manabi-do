import 'dart:math';

import '../../data/database/app_database.dart';
import '../widgets/exercise/mcq_card.dart';

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
      (i) => McqOption(
        letter: String.fromCharCode(65 + i),
        text: options[i].romaji,
      ),
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
        letter: String.fromCharCode(65 + i),
        text: displayOf(options[i]),
        useJpFont: !isKanjiToMeaning,
      ),
    ),
    correctIndex: correctIndex,
  );
}

({List<McqOption> options, int correctIndex}) buildVocabMcqOptions({
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
      (i) => McqOption(
        letter: String.fromCharCode(65 + i),
        text: meaningOf(optionEntries[i]),
      ),
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
        letter: String.fromCharCode(65 + i),
        text: optionEntries[i].word,
        reading: optionEntries[i].reading,
        useJpFont: true,
      ),
    ),
    correctIndex: correctIndex,
  );
}
