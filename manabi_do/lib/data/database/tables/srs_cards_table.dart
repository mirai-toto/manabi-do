import 'package:drift/drift.dart';

class SrsCards extends Table {
  TextColumn     get itemType => text()();    // 'hiragana' | 'katakana' | 'kanji' | 'vocab'
  IntColumn      get itemId   => integer()();  // row ID in the corresponding table
  DateTimeColumn get due         => dateTime()();   // next review date (queryable)
  DateTimeColumn get firstSeenAt => dateTime().nullable()(); // set once on first insert, never updated
  TextColumn     get cardJson    => text()();        // full Card serialized via card.toMap()

  @override
  Set<Column> get primaryKey => {itemType, itemId};
}
