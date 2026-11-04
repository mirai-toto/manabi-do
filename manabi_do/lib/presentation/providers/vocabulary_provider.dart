import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/text/sentence_language.dart';
import '../../data/database/app_database.dart';
import 'database_provider.dart';

typedef KanjiVocabularyArgs = ({int kanjiId});

/// A kanji's example words with their meanings, and whether each meaning is
/// in the reader's language.
///
/// JMdict has French for 72% of these words and German for 95%, so the rest
/// arrive in English. `translated` is false for those, which lets the screen
/// mark the section once rather than marking every row.
typedef LocalizedWord = ({
  VocabularyEntry entry,
  String meaning,
  bool translated,
});

final localizedKanjiVocabularyProvider =
    FutureProvider.family<List<LocalizedWord>, KanjiVocabularyArgs>((
      ref,
      args,
    ) async {
      final locale = ref.watch(localeProvider).languageCode;
      final db = ref.watch(databaseProvider);
      final entries = await db.getVocabularyForKanji(args.kanjiId);
      if (locale == 'en' || entries.isEmpty) {
        return entries
            .map((e) => (entry: e, meaning: e.meaning, translated: true))
            .toList();
      }
      final ids = entries.map((e) => e.id).toList();
      final tr = await db.getVocabularyTranslations(ids, locale);
      return entries
          .map(
            (e) => (
              entry: e,
              meaning: tr[e.id] ?? e.meaning,
              translated: tr[e.id] != null,
            ),
          )
          .toList();
    });

/// A word's meaning in the reader's language, or '' when the reader is on
/// English or the content has none. [vocabularyMeaningProvider] resolves the
/// fallback.
final localizedVocabularyMeaningProvider = FutureProvider.family<String, int>((
  ref,
  vocabularyId,
) async {
  final locale = ref.watch(localeProvider).languageCode;
  if (locale == 'en') return '';
  final db = ref.watch(databaseProvider);
  final tr = await db.getVocabularyTranslations([vocabularyId], locale);
  return tr[vocabularyId] ?? '';
});

/// A kanji's meaning in the reader's language, or '' when the reader is on
/// English or the content has none. [kanjiMeaningProvider] resolves the
/// fallback.
final localizedKanjiMeaningProvider = FutureProvider.family<String, int>((
  ref,
  kanjiId,
) async {
  final locale = ref.watch(localeProvider).languageCode;
  if (locale == 'en') return '';
  final db = ref.watch(databaseProvider);
  final tr = await db.getKanjiTranslations([kanjiId], locale);
  return tr[kanjiId] ?? '';
});

/// A meaning ready to show: in the reader's language when the content has it,
/// otherwise English, with the reader's language named when it fell back.
typedef ShownMeaning = ({String meaning, String? missingLanguage});

ShownMeaning _shownMeaning(
  Ref ref,
  AsyncValue<String> localized,
  String english,
) {
  final String? value = localized.asData?.value;
  return (
    meaning: value == null || value.isEmpty ? english : value,
    missingLanguage: missingMeaningLanguage(
      value,
      readerLocale: ref.watch(localeProvider).languageCode,
    ),
  );
}

final vocabularyMeaningProvider =
    Provider.family<ShownMeaning, VocabularyEntry>(
      (ref, entry) => _shownMeaning(
        ref,
        ref.watch(localizedVocabularyMeaningProvider(entry.id)),
        entry.meaning,
      ),
    );

/// KANJIDIC2 publishes kanji meanings in English, French, Spanish and
/// Portuguese only, so a German reader is always shown English.
final kanjiMeaningProvider = Provider.family<ShownMeaning, Kanji>(
  (ref, kanji) => _shownMeaning(
    ref,
    ref.watch(localizedKanjiMeaningProvider(kanji.id)),
    kanji.meaning,
  ),
);

/// Example sentences for a word, with their translations and the language
/// each translation is in.
///
/// Only English is guaranteed by the content pipeline, so the locale comes
/// back with the text: the screen names the language when it is not the
/// reader's, instead of silently showing English.
final vocabularySentencesProvider =
    FutureProvider.family<
      List<(Sentence, ({String locale, String text})?)>,
      int
    >((ref, vocabularyId) async {
      final locale = ref.watch(localeProvider).languageCode;
      final db = ref.watch(databaseProvider);
      final sentences = await db.getSentencesForVocabulary(vocabularyId);
      if (sentences.isEmpty) return const [];
      final translations = await db.getSentenceTranslations(
        sentences.map((s) => s.id).toList(),
        locale,
      );
      return sentences.map((s) => (s, translations[s.id])).toList();
    });

/// A word's meanings in the reader's language, and the English behind them.
///
/// [own] is empty when the content has nothing in that language, and [english]
/// then carries the fallback.
///
/// [english] is also filled when the reader's language has a single lumped
/// sense and English has several. JMdict's French contributors often wrote one
/// summary where the English has a sense list: する is 17 English senses
/// against one French line reading "coûter; essayer; faire; jouer; pratiquer",
/// in what looks like alphabetical order, so the first word a reader sees is
/// the rarest. 1,703 words are like this. The French stays — it is their
/// language — and the English senses go underneath it rather than replacing
/// it.
typedef WordMeanings = ({
  List<VocabularySense> own,
  List<VocabularySense> english,
});

/// How many English senses it takes before a single foreign sense counts as a
/// summary rather than a translation. Two would catch words that genuinely
/// have one meaning and a near-synonym.
const int _summaryThreshold = 3;

final vocabularySensesProvider = FutureProvider.family<WordMeanings, int>((
  ref,
  vocabularyId,
) async {
  final locale = ref.watch(localeProvider).languageCode;
  final db = ref.watch(databaseProvider);
  final mine = await db.getVocabularySenses(vocabularyId, locale);
  if (locale == 'en') return (own: mine, english: const <VocabularySense>[]);

  final english = await db.getVocabularySenses(vocabularyId, 'en');
  if (mine.isEmpty) {
    return (own: const <VocabularySense>[], english: english);
  }
  if (mine.length == 1 && english.length >= _summaryThreshold) {
    return (own: mine, english: english);
  }
  return (own: mine, english: const <VocabularySense>[]);
});
