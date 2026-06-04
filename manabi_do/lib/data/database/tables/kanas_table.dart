import 'package:drift/drift.dart';

class Kanas extends Table {
  IntColumn get id        => integer().autoIncrement()();
  TextColumn get character => text()();
  TextColumn get romaji    => text()();
  TextColumn get type      => text()(); // 'hiragana' | 'katakana'
  TextColumn get row       => text()(); // row label, e.g. 'Vowels', 'K'
  TextColumn get kanaGroup => text()(); // 'gojuuon' | 'dakuten'
  IntColumn  get slot      => integer()(); // column position 0-4
}
