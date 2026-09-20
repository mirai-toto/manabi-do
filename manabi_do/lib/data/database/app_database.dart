import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:fsrs/fsrs.dart';

import 'db_connection_native.dart'
    if (dart.library.js_interop) 'db_connection_web.dart';

import '../../core/srs/srs_level.dart';
import '../../domain/data/kana_data.dart';

part 'app_database.g.dart';
part 'queries/kana_queries.dart';
part 'queries/kanji_queries.dart';
part 'queries/vocabulary_queries.dart';
part 'queries/translation_queries.dart';
part 'queries/sentence_queries.dart';
part 'queries/grammar_queries.dart';
part 'queries/dashboard_queries.dart';
part 'queries/srs_session_queries.dart';
part 'queries/srs_card_queries.dart';

@DriftDatabase(include: {'schema.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openDbConnection());

  /// Opens against a caller-supplied executor, for schema tests.
  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => 22;

  // No upgrade steps: every install lands on the current schema directly.
  //
  // The asset DB is built from `schema.drift` and stamped with this same
  // `schemaVersion`, so a fresh copy needs no migration. Existing installs are
  // handed that copy too — `db_connection_native.dart` carries user progress
  // across via `_preservedTables` whenever `_assetDbVersion` changes.
  //
  // Future schema changes go through `stepByStep` against the snapshots in
  // `drift_schemas/`, so each step is written against a frozen schema rather
  // than whatever the tables happen to look like today.

  Future<int> _countSeenToday(String itemType) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return (select(srsCards)..where(
          (s) =>
              s.itemType.equals(itemType) &
              s.firstSeenAt.isBiggerOrEqualValue(todayStart),
        ))
        .get()
        .then((rows) => rows.length);
  }
}
