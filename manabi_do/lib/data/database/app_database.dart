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
  int get schemaVersion => 28;

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

      // A word is written with as many kanji as it has. `kanji_id` held the
      // first and discarded the rest, so 今日 knew 今 and not 日 — which made
      // scoring a word by its kanji impossible.
      //
      // Nothing is backfilled here. A schema change ships a new asset, and the
      // refresh replaces the file wholesale, so the rows arrive already built.
      // This step exists for a database opened without that replacement.
      from22To23: (m, schema) async {
        await m.createTable(schema.vocabularyKanji);
        await m.alterTable(TableMigration(schema.vocabularyEntries));
      },

      // Difficulty stops being a number copied from a downloaded list and
      // becomes one computed from JMdict's frequency levels and KANJIDIC2's
      // school grades — both of which were already being downloaded and
      // thrown away. `jlpt_level` stays, so the two can be compared.
      //
      // Empty here for the same reason as the step above: a schema change
      // ships a new asset and the refresh replaces the file.
      from23To24: (m, schema) async {
        await m.addColumn(schema.kanjis, schema.kanjis.grade);
        await m.addColumn(schema.kanjis, schema.kanjis.freq);
        await m.addColumn(
          schema.vocabularyEntries,
          schema.vocabularyEntries.freqBand,
        );
        await m.addColumn(
          schema.vocabularyEntries,
          schema.vocabularyEntries.difficulty,
        );
        await m.addColumn(
          schema.vocabularyEntries,
          schema.vocabularyEntries.difficultyTier,
        );
        await m.addColumn(
          schema.vocabularyEntries,
          schema.vocabularyEntries.difficultySource,
        );
      },

      // A word's place in Japanese, rather than its place in our word list.
      //
      // `difficulty_tier` banded words by share of the roster, so tier 1 meant
      // "the easiest tenth of whatever we ship" — a fact about the app, not
      // about the language. `vocabulary_level` and `group_index` carry a share of
      // running Japanese instead, and `coverage_groups` says what each group of
      // thirty words buys.
      //
      // `jlpt_level` goes at the same time. The JLPT publishes a kanji list and
      // no vocabulary list, so the column only ever held somebody's guess.
      //
      // Nothing is backfilled: a schema change ships a new asset and the
      // refresh replaces the file wholesale, so the rows arrive already built.
      // This step exists for a database opened without that replacement.
      from24To25: (m, schema) async {
        await m.createTable(schema.coverageGroups);
        // `newColumns` is not optional here. `alterTable` copies the old rows
        // into the new shape, and without it drift writes a SELECT naming
        // `vocabulary_level` and `group_index` against the table that does not
        // have them yet, so opening the database throws "no such column".
        // Their SQL defaults fill the copied rows.
        await m.alterTable(
          TableMigration(
            schema.vocabularyEntries,
            newColumns: [
              schema.vocabularyEntries.coverageBand,
              schema.vocabularyEntries.groupIndex,
            ],
          ),
        );
      },

      // `coverage_band` becomes `vocabulary_level`, and `coverage_groups.band`
      // with it.
      //
      // A rename and nothing else. The word "band" was ours alone: the screens
      // call these levels, so the column now says the same thing. Spelled out
      // rather than plain `level` so it cannot be read as the exam level that
      // `kanjis.jlpt_level` holds.
      //
      // This needed its own version. The rename first went into v25 directly,
      // on the grounds that v25 had never been released — but a v25 database
      // already existed on a development machine, drift saw a version it had
      // nothing to do for, and every vocabulary query then asked for a column
      // that was no longer there. A schema that has reached any disk anywhere
      // is frozen.
      from25To26: (m, schema) async {
        await m.renameColumn(
          schema.vocabularyEntries,
          'coverage_band',
          schema.vocabularyEntries.vocabularyLevel,
        );
        await m.renameColumn(
          schema.coverageGroups,
          'band',
          schema.coverageGroups.vocabularyLevel,
        );
      },

      // A word's meanings become rows instead of one joined string.
      //
      // `vocabulary_entries.meaning` still holds every gloss of every sense
      // joined with "; " — 824 characters for する — because search matches
      // against it and a list row wants one truncated line. The word's own
      // screen reads `vocabulary_senses` instead, which keeps JMdict's sense
      // boundaries, its usage notes and the transitivity of each sense.
      //
      // Nothing is backfilled: a schema change ships a new asset and the
      // refresh replaces the file wholesale. This step exists so a database
      // opened without that replacement has the table and degrades to the
      // joined string rather than failing.
      from26To27: (m, schema) async {
        await m.createTable(schema.vocabularySenses);
      },
      // `vocabulary_senses` carries the same glosses split per sense, in
      // order, with JMdict's usage notes. `vocabulary_translations` held them
      // mashed into one string per language, which is where する's French read
      // "coûter; essayer; faire; jouer; pratiquer" with no sense of which
      // came first.
      from27To28: (m, schema) async {
        await m.deleteTable('vocabulary_translations');
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
