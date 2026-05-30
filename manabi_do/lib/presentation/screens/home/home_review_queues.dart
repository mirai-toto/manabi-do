import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/srs_settings_provider.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../providers/sentence_settings_provider.dart';
import '../../widgets/exercise/mcq_card.dart';
import '../practice/practice_item.dart';
import '../practice/practice_flashcard_body.dart';
import '../practice/sentence_cloze_body.dart';

Future<List<PracticeItem>> loadKanaQueue(AppDatabase db, WidgetRef ref) async {
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

Future<List<PracticeItem>> loadKanjiQueue(AppDatabase db, WidgetRef ref) async {
  final settings = await ref.read(srsSettingsProvider.future);
  final pairs = await db.getAllDueKanjiSrsSession(
    newCardLimit: settings.newCharactersPerDay,
  );
  return pairs.map((pair) {
    final (k, card) = pair;
    final color = levelColor(k.jlptLevel);
    return PracticeItem(
      id: k.id,
      srsType: 'kanji',
      card: card,
      buildBody: (index, total, onAnswer) => PracticeFlashcardBody(
        japanese: k.character,
        answer: k.meaning,
        card: card,
        index: index,
        total: total,
        color: color,
        onAnswer: onAnswer,
      ),
    );
  }).toList()..shuffle();
}

Future<List<PracticeItem>> loadVocabQueue(AppDatabase db, WidgetRef ref) async {
  final locale = ref.read(localeProvider).languageCode;
  final settings = await ref.read(srsSettingsProvider.future);
  final pairs = await db.getAllDueVocabSrsSession(
    newCardLimit: settings.newVocabPerDay,
  );
  final ids = pairs.map((p) => p.$1.id).toList();
  final translations = locale != 'en'
      ? await db.getVocabTranslations(ids, locale)
      : <int, String>{};
  final rng = Random();

  final items = pairs.map((pair) {
    final (entry, card) = pair;
    final color = levelColor(entry.jlptLevel);
    final meaning = translations[entry.id]?.isNotEmpty == true
        ? translations[entry.id]!
        : entry.meaning;
    return PracticeItem(
      id: entry.id,
      srsType: 'vocabulary',
      card: card,
      buildBody: (index, total, onAnswer) => PracticeFlashcardBody(
        japanese: entry.word,
        label: entry.reading,
        answer: meaning,
        isReversed: rng.nextBool(),
        card: card,
        index: index,
        total: total,
        color: color,
        onAnswer: onAnswer,
      ),
    );
  }).toList();

  return items..shuffle();
}

Future<List<PracticeItem>> loadVocabSentenceQueue(
  AppDatabase db,
  WidgetRef ref,
) async {
  final settings = await ref.read(srsSettingsProvider.future);
  final sentenceSettings = ref.read(sentenceSettingsProvider);
  final locale = ref.read(localeProvider).languageCode;
  final pairs = await db.getAllDueVocabSrsSession(
    newCardLimit: settings.newVocabPerDay,
  );
  final ids = pairs.map((p) => p.$1.id).toList();
  final sentencesByVocabId = await db.getSentencesBatch(ids);
  final withSentences = pairs
      .where((p) => (sentencesByVocabId[p.$1.id] ?? []).isNotEmpty)
      .toList();
  if (withSentences.isEmpty) return [];

  final rng = Random();
  final pool = withSentences.map((p) => p.$1).toList();

  final allSentenceIds = sentencesByVocabId.values
      .expand((list) => list)
      .map((s) => s.id)
      .toList();
  final translations = await db.getSentenceTranslations(allSentenceIds, locale);

  return withSentences.map((pair) {
    final (entry, card) = pair;
    final sentences = sentencesByVocabId[entry.id]!;
    final sentence = sentences[rng.nextInt(sentences.length)];
    final color = levelColor(entry.jlptLevel);
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
        translation: translations[sentence.id],
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
