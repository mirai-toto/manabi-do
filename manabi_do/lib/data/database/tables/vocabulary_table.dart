import 'package:drift/drift.dart';

import 'kanjis_table.dart';

class VocabularyEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get word => text()();
  TextColumn get reading => text()();
  TextColumn get meaning => text()();
  TextColumn get jlptLevel => text()();
  TextColumn get partOfSpeech => text()();
  IntColumn get kanjiId => integer().nullable().references(Kanjis, #id)();
}
