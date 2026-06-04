import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/locale_provider.dart';
import '../../data/database/app_database.dart';
import 'database_provider.dart';

typedef KanjiVocabArgs = ({int kanjiId, String character});

final kanjiVocabProvider =
    FutureProvider.family<List<VocabularyEntry>, KanjiVocabArgs>((ref, args) {
  return ref.watch(databaseProvider).getVocabForKanji(args.kanjiId, args.character);
});

/// Each element is (entry, localizedMeaning). Falls back to English.
final localizedKanjiVocabProvider =
    FutureProvider.family<List<(VocabularyEntry, String)>, KanjiVocabArgs>(
  (ref, args) async {
    final locale = ref.watch(localeProvider).languageCode;
    final db = ref.watch(databaseProvider);
    final entries = await db.getVocabForKanji(args.kanjiId, args.character);
    if (locale == 'en' || entries.isEmpty) {
      return entries.map((e) => (e, e.meaning)).toList();
    }
    final ids = entries.map((e) => e.id).toList();
    final tr = await db.getVocabTranslations(ids, locale);
    return entries.map((e) => (e, tr[e.id] ?? e.meaning)).toList();
  },
);

/// Returns the localized meaning for a single kanji. Falls back to English.
final localizedKanjiMeaningProvider =
    FutureProvider.family<String, int>((ref, kanjiId) async {
  final locale = ref.watch(localeProvider).languageCode;
  if (locale == 'en') return '';
  final db = ref.watch(databaseProvider);
  final tr = await db.getKanjiTranslations([kanjiId], locale);
  return tr[kanjiId] ?? '';
});
