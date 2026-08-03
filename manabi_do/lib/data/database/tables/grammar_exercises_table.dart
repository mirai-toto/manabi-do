import 'package:drift/drift.dart';

@DataClassName('GrammarExerciseRow')
class GrammarExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lessonPath => text()();
  IntColumn get orderIndex => integer()();
  TextColumn get type => text()();
  TextColumn get dataJson => text()();
}
