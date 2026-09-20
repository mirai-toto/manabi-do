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
  /// There are no steps yet — v22 is the baseline.
  ///
  /// ## Worked example: adding `sentences.audio_url`
  ///
  /// 1. Add the column in `schema.drift`:
  ///
  /// ```sql
  /// CREATE TABLE sentences (
  ///   ...
  ///   audio_url TEXT          -- nullable: existing rows have no audio
  /// );
  /// ```
  ///
  /// 2. Bump [schemaVersion] to 23.
  ///
  /// 3. Snapshot the new shape and regenerate the steps:
  ///
  /// ```sh
  /// dart run drift_dev schema dump lib/data/database/app_database.dart drift_schemas/
  /// dart run drift_dev schema steps drift_schemas/ lib/data/database/schema_versions.dart
  /// dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
  /// ```
  ///
  /// 4. Fill in the case the generator stubbed out in `schema_versions.dart`:
  ///
  /// ```dart
  /// from22To23: (m, schema) async {
  ///   await m.addColumn(schema.sentences, schema.sentences.audioUrl);
  /// },
  /// ```
  ///
  /// `schema.sentences` is the **v23** table, not the live one. Rename that
  /// column in 2027 and this step keeps meaning what it meant in 2026 — which
  /// is why no `try/catch` is needed here.
  ///
  /// 5. Add the check to `test/migration_test.dart`:
  ///
  /// ```dart
  /// test('22 to 23 adds audio_url', () async {
  ///   final connection = await verifier.startAt(22);
  ///   final db = AppDatabase.withExecutor(connection);
  ///   await verifier.migrateAndValidate(db, 23);
  ///   await db.close();
  /// });
  /// ```
  ///
  /// That builds a real database at v22, runs the step, and fails unless the
  /// result matches the v23 snapshot exactly.
  ///
  /// The 22 MB asset does **not** need rebuilding for this — drift migrates it
  /// forward on open. Rebuild only when the *content* changes, and bump
  /// `_assetDbVersion` so `user_data_preservation.dart` carries progress across.
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
