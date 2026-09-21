part of '../app_database.dart';

/// Localized meanings for kanji and vocabulary.
extension TranslationQueries on AppDatabase {
  Future<Map<int, String>> getKanjiTranslations(List<int> ids, String locale) =>
      (select(kanjiTranslations)
            ..where((t) => t.kanjiId.isIn(ids) & t.locale.equals(locale)))
          .get()
          .then((rows) => {for (final r in rows) r.kanjiId: r.meaning});

  Future<Map<int, String>> getVocabularyTranslations(
    List<int> ids,
    String locale,
  ) =>
      (select(vocabularyTranslations)
            ..where((t) => t.vocabularyId.isIn(ids) & t.locale.equals(locale)))
          .get()
          .then((rows) => {for (final r in rows) r.vocabularyId: r.meaning});
}
