part of '../app_database.dart';

/// Example sentences and their translations.
extension SentenceQueries on AppDatabase {
  Future<List<Sentence>> getSentencesForVocabulary(int vocabularyId) => (select(
    sentences,
  )..where((s) => s.vocabularyId.equals(vocabularyId))).get();

  Future<Map<int, List<Sentence>>> getSentencesBatch(
    List<int> vocabularyIds,
  ) async {
    if (vocabularyIds.isEmpty) return {};
    final rows = await (select(
      sentences,
    )..where((s) => s.vocabularyId.isIn(vocabularyIds))).get();
    final result = <int, List<Sentence>>{};
    for (final row in rows) {
      result.putIfAbsent(row.vocabularyId, () => []).add(row);
    }
    return result;
  }

  /// Each sentence's translation, with the language it is actually in.
  ///
  /// Only English is guaranteed: a sentence is imported when it has one, and
  /// the others come along when Tatoeba has them. French reaches about 43% of
  /// imported sentences. The locale travels with the text so a reader shown
  /// English can be told that is what it is, rather than left wondering.
  Future<Map<int, ({String locale, String text})>> getSentenceTranslations(
    List<int> sentenceIds,
    String locale, {
    bool nativeOnly = false,
  }) async {
    if (sentenceIds.isEmpty) return {};
    final locale3 = sentenceLocaleCode(locale);
    final rows =
        await (select(sentenceTranslations)..where(
              (t) =>
                  t.sentenceId.isIn(sentenceIds) &
                  (nativeOnly
                      ? t.locale.equals(locale3)
                      : (t.locale.equals(locale3) | t.locale.equals('eng'))),
            ))
            .get();
    final result = <int, ({String locale, String text})>{};
    for (final row in rows) {
      if (!result.containsKey(row.sentenceId) || row.locale == locale3) {
        result[row.sentenceId] = (locale: row.locale, text: row.translation);
      }
    }
    return result;
  }
}
