import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/locale_provider.dart';
import '../../data/database/app_database.dart';
import 'database_provider.dart';

typedef KanjiVocabularyArgs = ({int kanjiId});

final kanjiVocabularyProvider =
    FutureProvider.family<List<VocabularyEntry>, KanjiVocabularyArgs>((
      ref,
      args,
    ) {
      return ref.watch(databaseProvider).getVocabularyForKanji(args.kanjiId);
    });

/// Each element is (entry, localizedMeaning). Falls back to English.
final localizedKanjiVocabularyProvider =
    FutureProvider.family<List<(VocabularyEntry, String)>, KanjiVocabularyArgs>(
      (ref, args) async {
        final locale = ref.watch(localeProvider).languageCode;
        final db = ref.watch(databaseProvider);
        final entries = await db.getVocabularyForKanji(args.kanjiId);
        if (locale == 'en' || entries.isEmpty) {
          return entries.map((e) => (e, e.meaning)).toList();
        }
        final ids = entries.map((e) => e.id).toList();
        final tr = await db.getVocabularyTranslations(ids, locale);
        return entries.map((e) => (e, tr[e.id] ?? e.meaning)).toList();
      },
    );

/// Returns the localized meaning for a single vocabulary entry. Falls back to English.
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

/// Returns the localized meaning for a single kanji. Falls back to English.
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

/// A word's meanings, split into senses, in the reader's language.
///
/// Falls back to English when the content has nothing in that language, and
/// the caller falls back to the flattened `meaning` when even that is empty.
final vocabularySensesProvider =
    FutureProvider.family<List<VocabularySense>, int>((
      ref,
      vocabularyId,
    ) async {
      final locale = ref.watch(localeProvider).languageCode;
      final db = ref.watch(databaseProvider);
      final mine = await db.getVocabularySenses(vocabularyId, locale);
      if (mine.isNotEmpty || locale == 'en') return mine;
      return db.getVocabularySenses(vocabularyId, 'en');
    });
