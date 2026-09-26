import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fsrs/fsrs.dart';

import 'db_connection_native.dart'
    if (dart.library.js_interop) 'db_connection_web.dart';

import '../../domain/data/kana_data.dart';
import 'schema_versions.dart';

part 'app_database.g.dart';
part 'queries/kana_queries.dart';
part 'queries/kanji_queries.dart';
part 'queries/vocabulary_queries.dart';
part 'queries/translation_queries.dart';
part 'queries/sentence_queries.dart';
part 'queries/grammar_queries.dart';
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
  /// `drift_dev schema steps drift_schemas/`. Each step receives the schema
  /// **frozen at that version**, so renaming a column in 2027 cannot change
  /// what `from20To21` meant in 2026. The old `if (from < N)` chain referenced
  /// current definitions instead, which is why every step there needed
  /// `try/catch` to survive edits made after it was written.
  ///
  /// To add v23: edit `schema.drift`, bump [schemaVersion], then
  ///
  /// ```sh
  /// dart run drift_dev schema dump lib/data/database/app_database.dart drift_schemas/
  /// dart run drift_dev schema steps drift_schemas/ lib/data/database/schema_versions.dart
  /// ```
  ///
  /// The generator adds a `from22To23` parameter here for the step to be filled
  /// in. The 22 MB asset does not need rebuilding for a schema change — drift
  /// migrates it forward on open.
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: stepByStep(
      // Spell "vocabulary" in full in the schema. `vocabulary_entries` was
      // always spelled out; only these two carried the truncation.
      from20To21: (m, schema) async {
        await m.renameTable(
          schema.vocabularyTranslations,
          'vocab_translations',
        );
        await m.renameColumn(
          schema.vocabularyTranslations,
          'vocab_id',
          schema.vocabularyTranslations.vocabularyId,
        );
        await m.renameColumn(
          schema.sentences,
          'vocab_id',
          schema.sentences.vocabularyId,
        );
      },

      // Data, not schema: the grammar block type was renamed in content, and
      // lessons already stored carry the old token inside `blocks_json` where
      // no column rename can reach it.
      from21To22: (m, schema) async {
        await m.database.customStatement(
          'UPDATE grammar_lessons '
          'SET blocks_json = replace(blocks_json, ?, ?) '
          'WHERE blocks_json LIKE ?',
          ['"vocab_table"', '"vocabulary_table"', '%"vocab_table"%'],
        );
      },
    ),
  );

  /// Cards of [itemType] first seen today, which the daily new-card budget
  /// is measured against.
  Future<int> countSeenToday(String itemType) {
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
