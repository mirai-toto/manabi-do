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

  /// The kanji a word is written with, in the order they appear in it.
  ///
  /// The mirror of [getVocabularyForKanji]. Joined through `vocabulary_kanji`,
  /// whose `position` is where each kanji first appears, so 今日 comes back as
  /// 今 then 日 rather than in id order.
  ///
  /// A kanji the app does not teach is simply absent: the join only holds rows
  /// for characters that have a `kanjis` entry, which is the 2,211 with a JLPT
  /// level.
  Future<List<Kanji>> getKanjiForVocabulary(int vocabularyId) {
    final query =
        select(kanjis).join([
            innerJoin(
              vocabularyKanji,
              vocabularyKanji.kanjiId.equalsExp(kanjis.id),
            ),
          ])
          ..where(vocabularyKanji.vocabularyId.equals(vocabularyId))
          ..orderBy([OrderingTerm.asc(vocabularyKanji.position)]);
    return query.map((row) => row.readTable(kanjis)).get();
  }

  /// The kanji of each JLPT level that have no SRS card yet.
  Future<Map<String, List<Kanji>>> unseenKanjiByLevel() async {
    final seenIds =
        await (select(srsCards)..where((s) => s.itemType.equals('kanji')))
            .get()
            .then((rows) => {for (final r in rows) r.itemId});

    final byLevel = <String, List<Kanji>>{};
    for (final kanji in await select(kanjis).get()) {
      if (!seenIds.contains(kanji.id)) {
        (byLevel[kanji.jlptLevel] ??= []).add(kanji);
      }
    }
    return byLevel;
  }

  Stream<List<Kanji>> watchKanjiByLevel(String level) =>
      (select(kanjis)..where((k) => k.jlptLevel.equals(level))).watch();

  Stream<Kanji?> watchKanjiById(int id) =>
      (select(kanjis)..where((k) => k.id.equals(id))).watchSingleOrNull();

  /// Every kanji whose character, meaning or readings contain [query], in no
  /// particular order. `SearchService` ranks them.
  Future<List<Kanji>> searchKanjiCandidates(String query) {
    final q = '%$query%';
    return (select(kanjis)..where(
          (k) =>
              k.character.like(q) |
              k.meaning.like(q) |
              k.onReading.like(q) |
              k.kunReading.like(q),
        ))
        .get();
  }
}
