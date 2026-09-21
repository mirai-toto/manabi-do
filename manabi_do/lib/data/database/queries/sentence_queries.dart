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

  // sentence_translations uses ISO 639-2 (3-letter) codes; map from 639-1.
  static const _iso1To2 = {
    'en': 'eng',
    'fr': 'fra',
    'de': 'deu',
    'es': 'spa',
    'pt': 'por',
    'it': 'ita',
    'ru': 'rus',
  };

  Future<Map<int, String>> getSentenceTranslations(
    List<int> sentenceIds,
    String locale, {
    bool nativeOnly = false,
  }) async {
    if (sentenceIds.isEmpty) return {};
    final locale3 = _iso1To2[locale] ?? locale;
    final rows =
        await (select(sentenceTranslations)..where(
              (t) =>
                  t.sentenceId.isIn(sentenceIds) &
                  (nativeOnly
                      ? t.locale.equals(locale3)
                      : (t.locale.equals(locale3) | t.locale.equals('eng'))),
            ))
            .get();
    final result = <int, String>{};
    for (final row in rows) {
      if (!result.containsKey(row.sentenceId) || row.locale == locale3) {
        result[row.sentenceId] = row.translation;
      }
    }
    return result;
  }
}
