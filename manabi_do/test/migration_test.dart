import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manabi_do/data/database/app_database.dart';

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
}
