import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

const _assetDbVersion = '8.22';

/// A table holding user data rather than shipped content. Refreshing the
/// content DB overwrites the file wholesale, so these rows are read out
/// beforehand and written back into the fresh copy.
class _PreservedTable {
  final String name;
  final List<String> columns;
  final String createSql;

  const _PreservedTable({
    required this.name,
    required this.columns,
    required this.createSql,
  });
}

const List<_PreservedTable> _preservedTables = [
  _PreservedTable(
    name: 'srs_cards',
    columns: ['item_type', 'item_id', 'due', 'first_seen_at', 'card_json'],
    createSql:
        'CREATE TABLE IF NOT EXISTS srs_cards ('
        '  item_type TEXT NOT NULL,'
        '  item_id INTEGER NOT NULL,'
        '  due INTEGER NOT NULL,'
        '  first_seen_at INTEGER,'
        '  card_json TEXT NOT NULL,'
        '  PRIMARY KEY (item_type, item_id)'
        ')',
  ),
  _PreservedTable(
    name: 'progress_entries',
    columns: ['item_type', 'item_id', 'is_known', 'toggled_at'],
    createSql:
        'CREATE TABLE IF NOT EXISTS progress_entries ('
        '  id INTEGER PRIMARY KEY AUTOINCREMENT,'
        '  item_type TEXT NOT NULL,'
        '  item_id INTEGER NOT NULL,'
        '  is_known INTEGER NOT NULL,'
        '  toggled_at INTEGER NOT NULL,'
        '  UNIQUE (item_type, item_id)'
        ')',
  ),
  _PreservedTable(
    name: 'grammar_lesson_progress',
    columns: ['lesson_path', 'read_at'],
    createSql:
        'CREATE TABLE IF NOT EXISTS grammar_lesson_progress ('
        '  lesson_path TEXT NOT NULL PRIMARY KEY,'
        '  read_at INTEGER NOT NULL'
        ')',
  ),
  _PreservedTable(
    name: 'grammar_lesson_starts',
    columns: ['lesson_path'],
    createSql:
        'CREATE TABLE IF NOT EXISTS grammar_lesson_starts ('
        '  lesson_path TEXT NOT NULL PRIMARY KEY'
        ')',
  ),
  _PreservedTable(
    name: 'grammar_chapter_unlocks',
    columns: ['chapter_key'],
    createSql:
        'CREATE TABLE IF NOT EXISTS grammar_chapter_unlocks ('
        '  chapter_key TEXT NOT NULL PRIMARY KEY'
        ')',
  ),
];

Map<String, List<List<Object?>>> _readUserData(File file) {
  final Map<String, List<List<Object?>>> saved = {};
  if (!file.existsSync()) return saved;
  raw.Database? old;
  try {
    old = raw.sqlite3.open(file.path);
  } catch (_) {
    return saved;
  }
  for (final table in _preservedTables) {
    try {
      final result = old.select(
        'SELECT ${table.columns.join(', ')} FROM ${table.name}',
      );
      if (result.isEmpty) continue;
      saved[table.name] = [
        for (final row in result) List<Object?>.from(row.values),
      ];
    } catch (_) {
      // Table absent in this install (older schema) – nothing to carry over.
    }
  }
  old.close();
  return saved;
}

void _writeUserData(
  raw.Database setup,
  Map<String, List<List<Object?>>> saved,
) {
  for (final table in _preservedTables) {
    final rows = saved[table.name];
    if (rows == null) continue;
    setup.execute(table.createSql);
    final placeholders = List.filled(table.columns.length, '?').join(', ');
    final stmt = setup.prepare(
      'INSERT OR REPLACE INTO ${table.name} '
      '(${table.columns.join(', ')}) VALUES ($placeholders)',
    );
    for (final row in rows) {
      stmt.execute(row);
    }
    stmt.close();
  }
}

// Walk up from the executable until a .git directory is found (repo root).
String? _repoRoot() {
  try {
    var dir = File(Platform.resolvedExecutable).parent;
    for (var i = 0; i < 12; i++) {
      if (Directory(p.join(dir.path, '.git')).existsSync()) return dir.path;
      final parent = dir.parent;
      if (parent.path == dir.path) break;
      dir = parent;
    }
  } catch (_) {}
  return null;
}

Future<String> _dbDir() async {
  if (Platform.isLinux) {
    if (kDebugMode) {
      // Debug: store next to the repo so the DB is easy to inspect.
      final root = _repoRoot();
      if (root != null) return root;
    }
    // Release (or fallback): use the proper XDG support directory.
    return (await getApplicationSupportDirectory()).path;
  }
  return (await getApplicationDocumentsDirectory()).path;
}

QueryExecutor openDbConnection() {
  return LazyDatabase(() async {
    final dbDir = await _dbDir();
    final file = File(p.join(dbDir, 'manabi_do.db'));
    final marker = File(p.join(dbDir, 'manabi_do.db.version'));

    final currentVersion = marker.existsSync()
        ? marker.readAsStringSync().trim()
        : '';
    final needsCopy = !file.existsSync() || currentVersion != _assetDbVersion;

    if (needsCopy) {
      // Save user data so it survives the content DB refresh.
      final Map<String, List<List<Object?>>> savedUserData = _readUserData(
        file,
      );

      // Remove stale WAL/SHM files so SQLite doesn't try to replay old frames.
      for (final suffix in ['-wal', '-shm']) {
        final side = File('${file.path}$suffix');
        if (side.existsSync()) side.deleteSync();
      }

      final blob = await rootBundle.load('assets/manabi_do_content.db');
      await file.writeAsBytes(
        blob.buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
      );

      // The asset DB ships with user_version > 7, which would cause drift to
      // skip migrations that create runtime-only tables (e.g. srs_cards).
      // Reset to 7 so all drift migrations run on the fresh copy.
      final setup = raw.sqlite3.open(file.path);
      setup.execute('PRAGMA user_version = 7');

      // Restore user data into the fresh DB before drift opens it.
      _writeUserData(setup, savedUserData);
      setup.close();

      // Write the marker only after setup succeeds so a crash here retries next launch.
      await marker.writeAsString(_assetDbVersion);
    }

    return NativeDatabase(file);
  });
}
