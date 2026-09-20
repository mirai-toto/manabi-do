part of '../app_database.dart';

/// Kanji lookups and search.
extension KanjiQueries on AppDatabase {
  Future<int> countTotalKanji() => (select(kanjis)).get().then((r) => r.length);

  Future<String?> getKanjiSvg(int kanjiId) =>
      (select(kanjis)..where((k) => k.id.equals(kanjiId)))
          .getSingleOrNull()
          .then((row) => row?.svg);

  Future<List<Kanji>> getKanjiByLevel(String level) =>
      (select(kanjis)..where((k) => k.jlptLevel.equals(level))).get();

  Future<List<Kanji>> getAllKanji() => select(kanjis).get();

  Stream<List<Kanji>> watchKanjiByLevel(String level) =>
      (select(kanjis)..where((k) => k.jlptLevel.equals(level))).watch();

  Stream<Kanji?> watchKanjiById(int id) =>
      (select(kanjis)..where((k) => k.id.equals(id))).watchSingleOrNull();

  Future<List<Kanji>> searchKanji(String query) {
    final q = '%$query%';
    return (select(kanjis)
          ..where(
            (k) =>
                k.character.like(q) |
                k.meaning.like(q) |
                k.onReading.like(q) |
                k.kunReading.like(q),
          )
          ..orderBy([
            (k) => OrderingTerm.asc(k.jlptLevel),
            (k) => OrderingTerm.asc(k.id),
          ]))
        .get();
  }
}
