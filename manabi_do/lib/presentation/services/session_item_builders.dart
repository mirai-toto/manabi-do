import 'dart:math';

import '../../data/database/app_database.dart';
import '../widgets/exercise/mcq_card.dart';

({List<McqOption> options, int correctIndex}) buildKanjiMcqOptions({
  required Kanji target,
  required List<Kanji> pool,
  required int n,
  required bool isKanjiToMeaning,
  required String Function(Kanji) meaningOf,
  required Random rng,
}) {
  final distractors = pool.where((k) => k.id != target.id).toList()
    ..shuffle(rng);
  final options = [target, ...distractors.take(n - 1)]..shuffle(rng);
  final correctIndex = options.indexWhere((k) => k.id == target.id);
  final mcqOptions = List.generate(
    options.length,
    (i) => McqOption(
      letter: String.fromCharCode(65 + i),
      text: isKanjiToMeaning ? meaningOf(options[i]) : options[i].character,
      useJpFont: !isKanjiToMeaning,
    ),
  );
  return (options: mcqOptions, correctIndex: correctIndex);
}

({List<McqOption> options, int correctIndex}) buildVocabMcqOptions({
  required VocabularyEntry target,
  required List<VocabularyEntry> pool,
  required int n,
  required String Function(VocabularyEntry) meaningOf,
  required Random rng,
}) {
  final distractors = pool.where((v) => v.id != target.id).toList()
    ..shuffle(rng);
  final optionEntries = [target, ...distractors.take(n - 1)]..shuffle(rng);
  final correctIndex = optionEntries.indexWhere((v) => v.id == target.id);
  final mcqOptions = List.generate(
    optionEntries.length,
    (i) => McqOption(
      letter: String.fromCharCode(65 + i),
      text: meaningOf(optionEntries[i]),
    ),
  );
  return (options: mcqOptions, correctIndex: correctIndex);
}

({List<McqOption> options, int correctIndex}) buildClozeOptions({
  required VocabularyEntry target,
  required List<VocabularyEntry> pool,
  required int n,
  required Random rng,
}) {
  final distractors = pool.where((v) => v.id != target.id).toList()
    ..shuffle(rng);
  final optionEntries = [target, ...distractors.take(n - 1)]..shuffle(rng);
  final correctIndex = optionEntries.indexWhere((v) => v.id == target.id);
  final clozeOptions = List.generate(
    optionEntries.length,
    (i) => McqOption(
      letter: String.fromCharCode(65 + i),
      text: optionEntries[i].word,
      reading: optionEntries[i].reading,
      useJpFont: true,
    ),
  );
  return (options: clozeOptions, correctIndex: correctIndex);
}
