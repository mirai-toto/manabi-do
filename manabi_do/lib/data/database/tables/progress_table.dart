import 'package:drift/drift.dart';

class ProgressEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get itemType => text()(); // ItemType name
  IntColumn get itemId => integer()();
  BoolColumn get isKnown => boolean()();
  DateTimeColumn get toggledAt => dateTime()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {itemType, itemId},
      ];
}
