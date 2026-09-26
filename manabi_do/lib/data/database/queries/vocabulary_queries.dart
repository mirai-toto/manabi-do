part of '../app_database.dart';

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

  Future<int> countVocabularyEntries() =>
      select(vocabularyEntries).get().then((rows) => rows.length);

  /// Every word whose spelling, reading or meaning contains [query], in no
  /// particular order. `SearchService` ranks them.
  Future<List<VocabularyEntry>> searchVocabularyCandidates(String query) {
    final q = '%$query%';
    return (select(
          vocabularyEntries,
        )..where((v) => v.word.like(q) | v.reading.like(q) | v.meaning.like(q)))
        .get();
  }

  Future<int> countTotalVocabulary() =>
      (select(vocabularyEntries)).get().then((r) => r.length);
}
