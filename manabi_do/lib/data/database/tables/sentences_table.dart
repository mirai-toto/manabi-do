import 'package:drift/drift.dart';

import 'vocabulary_table.dart';

class Sentences extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get japanese => text()();
  TextColumn get targetWord => text()();
  IntColumn get vocabId => integer().references(VocabularyEntries, #id)();
  TextColumn get furiganaBefore => text().nullable()();
  TextColumn get furiganaAfter => text().nullable()();
  TextColumn get furigana => text().nullable()();
}

class SentenceTranslations extends Table {
  IntColumn get sentenceId => integer().references(Sentences, #id)();
  TextColumn get locale => text()();
  TextColumn get translation => text()();

  @override
  Set<Column> get primaryKey => {sentenceId, locale};
}
