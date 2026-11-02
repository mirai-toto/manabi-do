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
    final query =
        select(vocabularyEntries).join([
            innerJoin(
              vocabularyKanji,
              vocabularyKanji.vocabularyId.equalsExp(vocabularyEntries.id),
            ),
          ])
          ..where(vocabularyKanji.kanjiId.equals(kanjiId))
          ..orderBy([
            OrderingTerm.asc(vocabularyEntries.difficulty),
            OrderingTerm.asc(vocabularyEntries.word),
          ])
          ..limit(30);
    return query.map((row) => row.readTable(vocabularyEntries)).get();
  }

  /// Every word in a vocabulary level, in study order.
  ///
  /// Ordered by `group_index` first, so skipping thirty at a time lands on the
  /// groups the content pipeline cut. The groups are a property of the content,
  /// not something the app recomputes: they are where the per-group coverage
  /// figures in `coverage_groups` apply.
  Future<List<VocabularyEntry>> getVocabularyByBand(int level) =>
      (select(vocabularyEntries)
            ..where((v) => v.vocabularyLevel.equals(level))
            ..orderBy([
              (v) => OrderingTerm.asc(v.groupIndex),
              (v) => OrderingTerm.asc(v.difficulty),
              (v) => OrderingTerm.asc(v.word),
            ]))
          .get();

  /// What each study group buys, as a share of running Japanese.
  Future<List<CoverageGroup>> getCoverageGroups() =>
      (select(coverageGroups)..orderBy([
            (g) => OrderingTerm.asc(g.vocabularyLevel),
            (g) => OrderingTerm.asc(g.groupIndex),
          ]))
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
