import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';
import '../../data/database/app_database.dart';
import 'database_provider.dart';

class KanjiLevelData {
  final String level;
  final List<Kanji> kanji;
  const KanjiLevelData({required this.level, required this.kanji});
  int get total => kanji.length;
}

final kanjiListProvider = StreamProvider.family<KanjiLevelData, String>((ref, level) {
  return ref.watch(databaseProvider).watchKanjiByLevel(level).map(
    (kanji) => KanjiLevelData(level: level, kanji: kanji),
  );
});

final kanjiDetailProvider = StreamProvider.family<Kanji?, int>((ref, id) {
  return ref.watch(databaseProvider).watchKanjiById(id);
});

final knownKanjiIdsProvider = StreamProvider<Set<int>>((ref) {
  return ref.watch(databaseProvider).watchKnownKanjiIds();
});

final kanjiSrsCardsProvider = StreamProvider<Map<int, Card>>((ref) =>
    ref.watch(databaseProvider).watchAllSrsCardsForType('kanji'));
