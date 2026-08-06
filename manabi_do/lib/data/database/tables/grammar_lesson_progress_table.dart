import 'package:drift/drift.dart';

@DataClassName('GrammarLessonProgressRow')
class GrammarLessonProgress extends Table {
  TextColumn get lessonPath => text()();
  DateTimeColumn get readAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {lessonPath};
}
