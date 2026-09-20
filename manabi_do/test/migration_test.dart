import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manabi_do/data/database/app_database.dart';

import 'generated_migrations/schema.dart';

/// Guards the schema snapshots in `drift_schemas/`.
///
/// There are no upgrade steps today; v22 is the baseline. The first test below
/// is the template every future one copies — see `app_database.dart` for the
/// full worked example of adding a version.
void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  // The shape every future migration test takes. `startAt` builds a real
  // database at the old version from its snapshot, `migrateAndValidate` runs
  // the steps and fails unless the result matches the target snapshot exactly.
  //
  // v22 is the baseline, so this migrates from 22 to 22 — it proves the
  // snapshot still describes the live schema. Adding `audio_url` in v23 would
  // mean copying this test and changing the two numbers:
  //
  //   test('22 to 23 adds audio_url', () async {
  //     final connection = await verifier.startAt(22);
  //     final db = AppDatabase.withExecutor(connection);
  //     await verifier.migrateAndValidate(db, 23);
  //     await db.close();
  //   });
  //
  // Nothing else changes. The step itself lives in `schema_versions.dart`.
  test('current schema matches the v22 snapshot', () async {
    final connection = await verifier.startAt(22);
    final db = AppDatabase.withExecutor(connection);
    await verifier.migrateAndValidate(db, 22);
    await db.close();
  });

  test('20 to 21 spells the vocabulary tables out in full', () async {
    final connection = await verifier.startAt(20);
    final db = AppDatabase.withExecutor(connection);
    await verifier.migrateAndValidate(db, 21);
    await db.close();
  });

  test('21 to 22 rewrites the grammar block type', () async {
    final connection = await verifier.startAt(21);
    final db = AppDatabase.withExecutor(connection);
    await verifier.migrateAndValidate(db, 22);
    await db.close();
  });

  test('a v20 database migrates all the way to the current schema', () async {
    final connection = await verifier.startAt(20);
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

  // End-to-end: a user opens the DB we actually ship. Whether the asset is at
  // the head version or lags behind it, drift must land on the current schema —
  // via `stepByStep` if there is a gap. A stale asset with no step to cover it
  // fails here instead of on a device.
  test('opening the shipped asset lands on the current schema', () async {
    final tmp = Directory.systemTemp.createTempSync('manabi_asset');
    addTearDown(() => tmp.deleteSync(recursive: true));
    final copy = File('${tmp.path}/content.db')
      ..writeAsBytesSync(File('assets/manabi_do_content.db').readAsBytesSync());

    final expected = AppDatabase.withExecutor(NativeDatabase.memory());
    await Migrator(expected).createAll();
    final want = await _tableNames(expected);
    await expected.close();

    final opened = AppDatabase.withExecutor(NativeDatabase(copy));
    final got = await _tableNames(opened);
    final version = await opened
        .customSelect('PRAGMA user_version')
        .getSingle()
        .then((r) => r.read<int>('user_version'));
    await opened.close();

    expect(
      got,
      orderedEquals(want),
      reason:
          'assets/manabi_do_content.db does not open at the current schema. '
          'Rebuild it with python3 tools/build_content_db.py, or add the '
          'missing migration step.',
    );
    expect(version, lessThanOrEqualTo(22));
  });
}

Future<List<String>> _tableNames(AppDatabase db) => db
    .customSelect(
      "SELECT name FROM sqlite_master WHERE type = 'table' "
      "AND name NOT LIKE 'sqlite_%' ORDER BY name",
    )
    .get()
    .then((rows) => rows.map((r) => r.read<String>('name')).toList());
