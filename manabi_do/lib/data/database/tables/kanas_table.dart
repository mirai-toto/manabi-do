import 'package:drift/drift.dart';

class Kanas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get character => text()();
  TextColumn get romaji => text()();
  TextColumn get type => text()(); // 'hiragana' | 'katakana'
  TextColumn get row => text()();
}
