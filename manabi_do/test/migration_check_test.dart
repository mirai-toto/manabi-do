import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manabi_do/data/database/app_database.dart';

void main() {
  test('a v22 content database migrates to 28, gaining levels and losing the '
      'flattened translations', () async {
    final source = File(
      '${Platform.environment['HOME']}/.cache/manabi-content/v22.1-manabi_do_content.db',
    );
    if (!source.existsSync()) {
      markTestSkipped('no cached v22 database');
      return;
    }
    final work = File('${Directory.systemTemp.path}/migration_check.db');
    if (work.existsSync()) work.deleteSync();
    source.copySync(work.path);

    final db = AppDatabase.withExecutor(NativeDatabase(work));
    final version = await db
        .customSelect('PRAGMA user_version')
        .getSingle()
        .then((row) => row.data.values.first);
    final columns = await db
        .customSelect('PRAGMA table_info(vocabulary_entries)')
        .get()
        .then((rows) => rows.map((r) => r.data['name']).toList());
    // Reads to prove the new table exists and the copied rows took their
    // defaults. A migrated database has no coverage figures until the matching
    // content asset replaces it, which is what ships with a schema change.
    await db.customSelect('SELECT COUNT(*) FROM coverage_groups').getSingle();
    final tables = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
        .get()
        .then((rows) => rows.map((r) => r.data['name']).toList());

    expect(version, 28);
    expect(tables, contains('vocabulary_senses'));
    expect(tables, isNot(contains('vocabulary_translations')));
    expect(columns, contains('vocabulary_level'));
    expect(columns, contains('group_index'));
    expect(columns, isNot(contains('jlpt_level')));
    expect(columns, isNot(contains('difficulty_tier')));

    await db.close();
    work.deleteSync();
  });
}
