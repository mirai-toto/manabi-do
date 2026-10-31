part of '../app_database.dart';

/// Vocabulary lookups.
extension VocabularyQueries on AppDatabase {
  /// Words written with a given kanji.
  ///
  /// Joined through `vocabulary_kanji`, so a word is found by any of its
  /// kanji rather than only its first. This used to read
  /// `kanjiId.equals(id) | word.like('%$character%')` — the `like` was there
  /// to paper over the single-kanji column, and it matched on the character
  /// appearing anywhere, including inside a different kanji's reading. The
  /// join is exact, so the fallback is gone and so is the `character`
  /// argument.
  Future<List<VocabularyEntry>> getVocabularyForKanji(int kanjiId) {
    final query = select(vocabularyEntries).join([
      innerJoin(
        vocabularyKanji,
        vocabularyKanji.vocabularyId.equalsExp(vocabularyEntries.id),
      ),
    ])
      ..where(vocabularyKanji.kanjiId.equals(kanjiId))
      ..orderBy([
        OrderingTerm.desc(vocabularyEntries.jlptLevel),
        OrderingTerm.asc(vocabularyEntries.word),
      ])
      ..limit(30);
    return query.map((row) => row.readTable(vocabularyEntries)).get();
  }

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
