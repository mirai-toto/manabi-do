part of '../app_database.dart';

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

  /// Words whose spelling, reading or meaning contains [query], easiest first.
  ///
  /// Descending on the level string runs N5 to N1, which is the order we want:
  /// searching "water" should surface 水 above the rare N1 words whose meaning
  /// happens to mention water. Capped because a one-letter query matches
  /// thousands of entries and nobody scrolls that far.
  Future<List<VocabularyEntry>> searchVocabulary(String query) {
    final q = '%$query%';
    return (select(vocabularyEntries)
          ..where((v) => v.word.like(q) | v.reading.like(q) | v.meaning.like(q))
          ..orderBy([
            (v) => OrderingTerm.desc(v.jlptLevel),
            (v) => OrderingTerm.asc(v.word),
          ])
          ..limit(_searchResultLimit))
        .get();
  }

  Future<int> countTotalVocabulary() =>
      (select(vocabularyEntries)).get().then((r) => r.length);
}
