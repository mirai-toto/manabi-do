import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manabi_do/data/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

/// Quoting, whitespace and an explicit `NULL` carry no meaning in SQLite DDL.
String _normalise(String sql) => sql
    .replaceAll('"', '')
    .replaceAll(RegExp(r'(?<!NOT )\bNULL\b'), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .replaceAllMapped(RegExp(r'\s*([(),])\s*'), (m) => m[1]!)
    .trim()
    .toLowerCase();

/// `schema.drift` is read by two very different consumers: drift's code
/// generator, and `tools/build_content_db.py` via plain sqlite3. The only
/// drift-specific syntax allowed is the `) AS RowName` suffix, which a plain
/// SQL engine cannot parse, so strip it the same way Python does.
String _toPlainSql(String driftFile) => driftFile
    .replaceAll(RegExp(r'^\s*--.*$', multiLine: true), '')
    .replaceAll(RegExp(r'\)\s*AS\s+\w+\s*;', multiLine: true), ');')
    // drift stores DATETIME and BOOLEAN as INTEGER; a plain SQL engine would
    // keep the declared name and pick a different type affinity.
    .replaceAll(RegExp(r'\bDATETIME\b'), 'INTEGER')
    .replaceAll(RegExp(r'\bBOOLEAN\b'), 'INTEGER');

Future<List<String>> _schemaOf(AppDatabase db) async {
  final rows = await db
      .customSelect(
        "SELECT sql FROM sqlite_master WHERE type = 'table' "
        "AND name NOT LIKE 'sqlite_%' ORDER BY name",
      )
      .get();
  return rows.map((r) => _normalise(r.read<String>('sql'))).toList();
}

void main() {
  test(
    'schema.drift executed as plain SQL matches what drift generates',
    () async {
      final db = AppDatabase.withExecutor(NativeDatabase.memory());
      await Migrator(db).createAll();
      final fromDrift = await _schemaOf(db);
      await db.close();

      final plain = raw.sqlite3.openInMemory();
      plain.execute(
        _toPlainSql(File('lib/data/database/schema.drift').readAsStringSync()),
      );
      final fromSql =
          plain
              .select(
                "SELECT sql FROM sqlite_master WHERE type = 'table' "
                "AND name NOT LIKE 'sqlite_%' ORDER BY name",
              )
              .map((r) => _normalise(r['sql'] as String))
              .toList()
            ..sort();
      plain.close();

      expect(fromSql, isNotEmpty);
      expect(fromSql.length, fromDrift.length);
      expect(fromSql, orderedEquals(fromDrift));
    },
  );
}
