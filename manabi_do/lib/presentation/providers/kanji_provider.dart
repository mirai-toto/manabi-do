import '../../core/providers/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../services/search_service.dart';
import 'database_provider.dart';

final kanjiSearchProvider =
    FutureProvider.family<List<Kanji>, SearchQuery<String>>(
      (ref, q) => ref
          .read(searchServiceProvider)
          .kanji(
            q.text,
            levels: q.filters,
            locale: ref.watch(localeProvider).languageCode,
          ),
    );

class KanjiLevelData {
  final String level;
  final List<Kanji> kanji;
  const KanjiLevelData({required this.level, required this.kanji});
  int get total => kanji.length;
}

final kanjiListProvider = StreamProvider.family<KanjiLevelData, String>((
  ref,
  level,
) {
  return ref
      .watch(databaseProvider)
      .watchKanjiByLevel(level)
      .map((kanji) => KanjiLevelData(level: level, kanji: kanji));
});

final kanjiDetailProvider = StreamProvider.family<Kanji?, int>((ref, id) {
  return ref.watch(databaseProvider).watchKanjiById(id);
});

/// The kanji a word is written with, in reading order.
final kanjiForVocabularyProvider = FutureProvider.family<List<Kanji>, int>(
  (ref, vocabularyId) =>
      ref.watch(databaseProvider).getKanjiForVocabulary(vocabularyId),
);

/// The kanji in a piece of Japanese text, in reading order and without
/// repeats. Only the ones the app teaches come back.
final kanjiInTextProvider = FutureProvider.family<List<Kanji>, String>((
  ref,
  text,
) {
  final List<String> characters = <String>{
    for (final int rune in text.runes)
      if (_isKanji(rune)) String.fromCharCode(rune),
  }.toList();
  return ref.watch(databaseProvider).getKanjiByCharacters(characters);
});

/// CJK unified ideographs, plus extension A.
bool _isKanji(int rune) =>
    (rune >= 0x4E00 && rune <= 0x9FFF) || (rune >= 0x3400 && rune <= 0x4DBF);
