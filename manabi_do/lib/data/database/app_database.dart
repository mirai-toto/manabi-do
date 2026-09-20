import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:fsrs/fsrs.dart';

import 'db_connection_native.dart'
    if (dart.library.js_interop) 'db_connection_web.dart';

import '../../core/srs/srs_level.dart';
import '../../domain/data/kana_data.dart';
import 'schema_versions.dart';

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

  /// Upgrades are generated, not hand-written.
  ///
  /// `schema_versions.dart` is produced by
  /// `drift_dev schema steps drift_schemas/`, and each step receives the schema
  /// **frozen at that version** rather than whatever the tables look like
  /// today. That is what the old `if (from < N)` chain could not do: it
  /// referenced current definitions, so old steps silently changed meaning and
  /// needed `try/catch` to survive.
  ///
  /// There are no steps yet — v22 is the baseline. Adding one means dumping a
  /// new snapshot and re-running the generator; drift then sequences them and
  /// `test/migration_test.dart` proves each lands on its snapshot exactly.
  ///
  /// Two mechanisms, deliberately separate:
  ///   * schema changes  → a step here, no asset rebuild needed
  ///   * content changes → a new asset DB and an `_assetDbVersion` bump
  @override
  MigrationStrategy get migration => MigrationStrategy(onUpgrade: stepByStep());

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
