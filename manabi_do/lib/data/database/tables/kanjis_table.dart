import 'package:drift/drift.dart';

class Kanjis extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get character => text()();
  TextColumn get meaning => text()();
  TextColumn get onReading => text()();
  TextColumn get kunReading => text()();
  TextColumn get jlptLevel => text()();
  TextColumn get strokeSvg => text().nullable()();
}
