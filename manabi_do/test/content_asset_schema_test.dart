import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manabi_do/data/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

/// The content release this app pins, as scripts/content/fetch_content.sh
/// leaves it.
final File _assetDb = File('assets/manabi_do_content.db');
final File _lock = File('content.lock');

/// A table's columns as SQLite reports them: name, type, not null, default,
/// primary key.
typedef _Column = (String, String, int, String?, int);

Map<String, List<_Column>> _layout(raw.Database db) {
  final Map<String, List<_Column>> tables = {};
  final names = db.select(
    "SELECT name FROM sqlite_master WHERE type = 'table' "
    "AND name NOT LIKE 'sqlite_%' AND name <> 'android_metadata' ORDER BY name",
  );
  for (final row in names) {
    final String table = row['name'] as String;
    tables[table] = [
      for (final c in db.select('PRAGMA table_info("$table")'))
        (
          c['name'] as String,
          (c['type'] as String).toUpperCase(),
          c['notnull'] as int,
          c['dflt_value'] as String?,
          c['pk'] as int,
        ),
    ];
  }
  return tables;
}

/// The app copies the pinned content database in whole and opens it with
/// nothing to migrate, so it must be exactly the schema drift builds from
/// schema.drift: the same number, tables and columns. The dependency runs one
/// way: manabi-content never checks the app, the app checks the release it pins.
void main() {
  test('the pinned content release fits this app\'s schema', () async {
    expect(
      _assetDb.existsSync(),
      isTrue,
      reason: 'no content database: run scripts/content/fetch_content.sh',
    );

    final String tag = RegExp(
      r'^tag\s*=\s*(\S+)',
      multiLine: true,
    ).firstMatch(_lock.readAsStringSync())!.group(1)!;
    final int tagSchema = int.parse(
      RegExp(r'^v(\d+)\.').firstMatch(tag)!.group(1)!,
    );

    final memory = File('${Directory.systemTemp.path}/content_asset_schema.db');
    if (memory.existsSync()) memory.deleteSync();
    final app = AppDatabase.withExecutor(NativeDatabase(memory));
    await app.customSelect('SELECT 1').get(); // creates every table
    final int appSchema = app.schemaVersion;
    await app.close();

    final raw.Database asset = raw.sqlite3.open(
      _assetDb.path,
      mode: raw.OpenMode.readOnly,
    );
    final raw.Database fresh = raw.sqlite3.open(
      memory.path,
      mode: raw.OpenMode.readOnly,
    );
    addTearDown(() {
      asset.close();
      fresh.close();
    });
    final int assetSchema =
        asset.select('PRAGMA user_version').first.values.first as int;

    expect(
      tagSchema,
      appSchema,
      reason:
          'content.lock pins $tag (schema $tagSchema) but the app is schema $appSchema: '
          'pin a v$appSchema release of manabi-content',
    );
    expect(
      assetSchema,
      appSchema,
      reason:
          'the fetched database is schema $assetSchema, the app is $appSchema: '
          'run scripts/content/fetch_content.sh',
    );

    final want = _layout(fresh);
    final have = _layout(asset);
    final List<String> faults = [
      for (final t in want.keys.where((t) => !have.containsKey(t)))
        'table $t is missing from $tag',
      for (final t in have.keys.where((t) => !want.containsKey(t)))
        'table $t in $tag is not in schema.drift',
      for (final t in want.keys.where(have.containsKey))
        if (want[t].toString() != have[t].toString())
          'table $t differs:\n  schema.drift ${want[t]}\n  $tag ${have[t]}',
    ];
    expect(faults, isEmpty, reason: faults.join('\n'));
  });
}
