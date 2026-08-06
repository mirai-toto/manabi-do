import 'package:drift/drift.dart';

@DataClassName('GrammarChapterUnlockRow')
class GrammarChapterUnlocks extends Table {
  TextColumn get chapterKey => text()();

  @override
  Set<Column<Object>> get primaryKey => {chapterKey};
}
