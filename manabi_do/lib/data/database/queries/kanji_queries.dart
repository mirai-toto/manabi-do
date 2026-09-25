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

  Future<List<Kanji>> searchKanji(String query) async {
    final q = '%$query%';
    final results =
        await (select(kanjis)..where(
              (k) =>
                  k.character.like(q) |
                  k.meaning.like(q) |
                  k.onReading.like(q) |
                  k.kunReading.like(q),
            ))
            .get();

    final ranks = {
      for (final kanji in results)
        kanji.id: searchRank(
          query: query,
          japanese: kanji.character,
          readings: [kanji.onReading, kanji.kunReading],
          meaning: kanji.meaning,
        ),
    };

    // Best match first, then easiest. Ordering on the level string runs N1 to
    // N5, which is backwards: searching "water" should surface 水 above the rare
    // N1 kanji whose meanings happen to mention water.
    results.sort((a, b) {
      final byRank = ranks[a.id]!.compareTo(ranks[b.id]!);
      if (byRank != 0) return byRank;
      final byLevel = _levelRank(
        a.jlptLevel,
      ).compareTo(_levelRank(b.jlptLevel));
      return byLevel != 0 ? byLevel : a.id.compareTo(b.id);
    });
    return results;
  }

  static int _levelRank(String level) => switch (level) {
    'N5' => 0,
    'N4' => 1,
    'N3' => 2,
    'N2' => 3,
    'N1' => 4,
    _ => 5,
  };
}
