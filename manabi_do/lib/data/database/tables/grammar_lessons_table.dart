import 'package:drift/drift.dart';

@DataClassName('GrammarLessonRow')
class GrammarLessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get locale => text().withDefault(const Constant('en'))();
  TextColumn get level => text()();
  TextColumn get path => text()();
  TextColumn get themeName => text().withDefault(const Constant(''))();
  TextColumn get themeDescription => text().withDefault(const Constant(''))();
  TextColumn get chapter => text()();
  TextColumn get title => text()();
  TextColumn get blocksJson => text()();
  IntColumn get orderIndex => integer()();
  IntColumn get difficulty => integer().withDefault(const Constant(1))();
}
