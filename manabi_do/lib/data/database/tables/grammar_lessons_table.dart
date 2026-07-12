import 'package:drift/drift.dart';

@DataClassName('GrammarLessonRow')
class GrammarLessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get level => text()();
  TextColumn get path => text()();
  TextColumn get chapter => text()();
  TextColumn get title => text()();
  TextColumn get blocksJson => text()();
  IntColumn get orderIndex => integer()();
}
