import 'package:drift/drift.dart';

import 'grammar_lessons_table.dart';

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get locale => text()();
  TextColumn get type => text()(); // ExerciseType name
  TextColumn get source => text()(); // ExerciseSource name
  IntColumn get sourceId => integer()();
  TextColumn get prompt => text()();
  TextColumn get answer => text()();
  TextColumn get distractors => text().withDefault(const Constant('[]'))(); // JSON array
  IntColumn get lessonId => integer().nullable().references(GrammarLessons, #id)();
}
