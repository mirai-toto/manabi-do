import 'package:drift/drift.dart';
import 'kanjis_table.dart';
import 'vocabulary_table.dart';

class KanjiTranslations extends Table {
  IntColumn get kanjiId => integer().references(Kanjis, #id)();
  TextColumn get locale => text()();
  TextColumn get meaning => text()();

  @override
  Set<Column> get primaryKey => {kanjiId, locale};
}

class VocabularyTranslations extends Table {
  IntColumn get vocabularyId => integer().references(VocabularyEntries, #id)();
  TextColumn get locale => text()();
  TextColumn get meaning => text()();

  @override
  Set<Column> get primaryKey => {vocabularyId, locale};
}
