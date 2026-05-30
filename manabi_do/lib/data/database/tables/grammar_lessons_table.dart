import 'package:drift/drift.dart';

class GrammarLessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get locale => text()();
  TextColumn get chapter => text()();
  TextColumn get title => text()();
  TextColumn get contentMd => text()();
  IntColumn get orderIndex => integer()();
  TextColumn get metadata => text().withDefault(const Constant('{}'))(); // JSON
}
