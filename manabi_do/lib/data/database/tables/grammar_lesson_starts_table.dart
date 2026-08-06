import 'package:drift/drift.dart';

@DataClassName('GrammarLessonStartRow')
class GrammarLessonStarts extends Table {
  TextColumn get lessonPath => text()();

  @override
  Set<Column<Object>> get primaryKey => {lessonPath};
}
