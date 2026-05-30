import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/exercises_table.dart';
import 'tables/grammar_lessons_table.dart';
import 'tables/kanas_table.dart';
import 'tables/kanjis_table.dart';
import 'tables/progress_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Kanjis, Kanas, GrammarLessons, Exercises, ProgressEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'manabi_do'));

  @override
  int get schemaVersion => 1;
}
