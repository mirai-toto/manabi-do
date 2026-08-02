import 'package:drift/drift.dart';

@DataClassName('GrammarLessonRow')
class GrammarLessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get locale => text().withDefault(const Constant('en'))();
  TextColumn get level => text()();
  TextColumn get path => text()();
  TextColumn get groupName => text().withDefault(const Constant(''))();
  TextColumn get chapter => text()();
  TextColumn get title => text()();
  TextColumn get blocksJson => text()();
  IntColumn get orderIndex => integer()();
}
