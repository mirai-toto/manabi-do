part of '../app_database.dart';

/// Localized meanings for kanji and vocabulary.
extension TranslationQueries on AppDatabase {
  Future<Map<int, String>> getKanjiTranslations(List<int> ids, String locale) =>
      (select(kanjiTranslations)
            ..where((t) => t.kanjiId.isIn(ids) & t.locale.equals(locale)))
          .get()
          .then((rows) => {for (final r in rows) r.kanjiId: r.meaning});

  /// A word's headline meaning in [locale] — its first sense, not all of them.
  ///
  /// This read `vocabulary_translations` until schema 28, a row per word per
  /// language holding every gloss joined with "; ". A list row has space for
  /// one line, so する showed "coûter; essayer; faire; jouer; pratiquer"
  /// truncated mid-word. The first sense is the one a dictionary leads with.
  Future<Map<int, String>> getVocabularyTranslations(
    List<int> ids,
    String locale,
  ) async {
    if (ids.isEmpty) return {};
    final rows =
        await (select(vocabularySenses)..where(
              (s) =>
                  s.vocabularyId.isIn(ids) &
                  s.locale.equals(locale) &
                  s.position.equals(1),
            ))
            .get();
    return {for (final r in rows) r.vocabularyId: r.glosses};
  }
}
