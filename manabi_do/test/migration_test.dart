import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manabi_do/data/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

import 'generated_migrations/schema.dart';

/// Guards the schema snapshots in `drift_schemas/`.
///
/// There are no upgrade steps today: every install lands on the current schema
/// directly, so this asserts the baseline is intact. When the schema next
/// changes, dump a new snapshot and add a `from22To23` case here — the helper
/// builds a real database at the old version, runs the migration, and verifies
/// the result matches the new snapshot exactly.
void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test('current schema matches the v22 snapshot', () async {
    final connection = await verifier.startAt(22);
    final db = AppDatabase.withExecutor(connection);
    await verifier.migrateAndValidate(db, 22);
    await db.close();
  });

  test('a fresh database is created at the declared schemaVersion', () async {
    final db = AppDatabase.withExecutor(NativeDatabase.memory());
    await Migrator(db).createAll();
    final version = await db
        .customSelect('PRAGMA user_version')
        .getSingle()
        .then((r) => r.read<int>('user_version'));
    // drift stamps the version on create; the asset DB builder reads the same
    // number out of this file, so the two can never disagree.
    expect(version, db.schemaVersion);
    await db.close();
  });

  // With no upgrade steps left, nothing repairs a stale asset at runtime. These
  // two guard the cost of that: change the schema without rebuilding the asset
  // and the failure shows up here rather than on a user's device.
  group('the shipped asset DB matches the declared schema', () {
    late raw.Database asset;

    setUpAll(() => asset = raw.sqlite3.open('assets/manabi_do_content.db'));
    tearDownAll(() => asset.close());

    test('is stamped with the current schemaVersion', () {
      final db = AppDatabase.withExecutor(NativeDatabase.memory());
      final stamped = asset.select('PRAGMA user_version').first.values.first;
      expect(
        stamped,
        db.schemaVersion,
        reason:
            'assets/manabi_do_content.db is stale. Rebuild it with '
            'python3 tools/build_content_db.py and bump _assetDbVersion.',
      );
      db.close();
    });

    test('contains every table drift expects', () async {
      final db = AppDatabase.withExecutor(NativeDatabase.memory());
      await Migrator(db).createAll();
      final expected = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'table' "
            "AND name NOT LIKE 'sqlite_%' ORDER BY name",
          )
          .get()
          .then((rows) => rows.map((r) => r.read<String>('name')).toList());
      await db.close();

      final actual = asset
          .select(
            "SELECT name FROM sqlite_master WHERE type = 'table' "
            "AND name NOT LIKE 'sqlite_%' ORDER BY name",
          )
          .map((r) => r['name'] as String)
          .toList();

      expect(actual, orderedEquals(expected));
    });
  });
}
