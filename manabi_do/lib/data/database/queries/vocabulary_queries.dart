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
  ///
  /// Ordered by study order, the same as [getVocabularyByLevel]. `difficulty`
  /// alone disagrees with the level the row's dots show: for 日 it put 昨日
  /// (level 1) after 日 (level 3), and あくる日 (level 5) ahead of level 3.
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
            OrderingTerm.asc(vocabularyEntries.vocabularyLevel),
            OrderingTerm.asc(vocabularyEntries.groupIndex),
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
  Future<List<VocabularyEntry>> getVocabularyByLevel(int level) =>
      (select(vocabularyEntries)
            ..where((v) => v.vocabularyLevel.equals(level))
            ..orderBy([
              (v) => OrderingTerm.asc(v.groupIndex),
              (v) => OrderingTerm.asc(v.difficulty),
              (v) => OrderingTerm.asc(v.word),
            ]))
          .get();

  /// A word's meanings in [locale], in JMdict's own order.
  ///
  /// Empty when the content has no senses for that language, which is the
  /// caller's cue to fall back to `VocabularyEntry.meaning`.
  Future<List<VocabularySense>> getVocabularySenses(
    int vocabularyId,
    String locale,
  ) =>
      (select(vocabularySenses)
            ..where(
              (s) =>
                  s.vocabularyId.equals(vocabularyId) & s.locale.equals(locale),
            )
            ..orderBy([(s) => OrderingTerm.asc(s.position)]))
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

  Future<int> countVocabularyEntries() {
    final count = vocabularyEntries.id.count();
    return (selectOnly(
      vocabularyEntries,
    )..addColumns([count])).map((r) => r.read(count)!).getSingle();
  }

  /// Every word whose spelling, reading or meaning contains [query], in no
  /// particular order. `SearchService` ranks them.
  ///
  /// `vocabulary_entries.meaning` is English. The reader's own glosses are in
  /// `vocabulary_senses`, so both are searched: without it "manger" found
  /// nothing and "to eat" found 食べる.
  Future<List<VocabularyEntry>> searchVocabularyCandidates(
    String query,
    String locale,
  ) async {
    final q = '%$query%';
    final direct =
        await (select(vocabularyEntries)..where(
              (v) => v.word.like(q) | v.reading.like(q) | v.meaning.like(q),
            ))
            .get();
    if (locale == 'en') return direct;

    final translated =
        await (select(vocabularyEntries).join([
              innerJoin(
                vocabularySenses,
                vocabularySenses.vocabularyId.equalsExp(vocabularyEntries.id),
              ),
            ])..where(
              vocabularySenses.locale.equals(locale) &
                  vocabularySenses.glosses.like(q),
            ))
            .map((row) => row.readTable(vocabularyEntries))
            .get();

    final Map<int, VocabularyEntry> merged = {for (final v in direct) v.id: v};
    for (final v in translated) {
      merged.putIfAbsent(v.id, () => v);
    }
    return merged.values.toList();
  }
}
