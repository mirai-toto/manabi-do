part of '../app_database.dart';

/// Capped because a one-letter query matches thousands of entries and nobody
/// scrolls that far.
const _searchResultLimit = 50;

/// Vocabulary lookups.
extension VocabularyQueries on AppDatabase {
  Future<List<VocabularyEntry>> getVocabularyForKanji(
    int kanjiId,
    String character,
  ) =>
      (select(vocabularyEntries)
            ..where(
              (v) => v.kanjiId.equals(kanjiId) | v.word.like('%$character%'),
            )
            ..orderBy([
              (v) => OrderingTerm.desc(v.jlptLevel),
              (v) => OrderingTerm.asc(v.word),
            ])
            ..limit(30))
          .get();

  Future<List<VocabularyEntry>> getVocabularyByLevel(String level) =>
      (select(vocabularyEntries)
            ..where((v) => v.jlptLevel.equals(level))
            ..orderBy([(v) => OrderingTerm.asc(v.word)]))
          .get();

  Future<List<VocabularyEntry>> getAllVocabulary() =>
      (select(vocabularyEntries)).get();

  /// Words whose spelling, reading or meaning contains [query], best match
  /// first.
  ///
  /// SQL only decides which rows match; [searchRank] decides the order, so the
  /// cap has to be applied here rather than as a `LIMIT` that would throw away
  /// the best match before it was ever ranked. Ties go to the easier word —
  /// descending on the level string runs N5 to N1 — so searching "water"
  /// surfaces 水 above the rare N1 words whose meaning happens to mention water.
  Future<List<VocabularyEntry>> searchVocabulary(String query) async {
    final q = '%$query%';
    final matches =
        await (select(vocabularyEntries)..where(
              (v) => v.word.like(q) | v.reading.like(q) | v.meaning.like(q),
            ))
            .get();

    final ranked =
        matches
            .map(
              (entry) => (
                entry: entry,
                rank: searchRank(
                  query: query,
                  japanese: entry.word,
                  readings: [entry.reading],
                  meaning: entry.meaning,
                ),
              ),
            )
            .toList()
          ..sort((a, b) {
            final byRank = a.rank.compareTo(b.rank);
            if (byRank != 0) return byRank;
            final byLevel = b.entry.jlptLevel.compareTo(a.entry.jlptLevel);
            return byLevel != 0
                ? byLevel
                : a.entry.word.compareTo(b.entry.word);
          });

    return ranked
        .take(_searchResultLimit)
        .map((scored) => scored.entry)
        .toList();
  }

  Future<int> countTotalVocabulary() =>
      (select(vocabularyEntries)).get().then((r) => r.length);
}
