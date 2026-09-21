/// Shared helpers for the schema guards.
///
/// `schema.drift` is read by two independent implementations — drift's code
/// generator, and `tools/build_content_db.py` via plain sqlite3 — so the tests
/// compare the DDL each one produces. Quoting, whitespace and an explicit
/// `NULL` carry no meaning in SQLite, so normalise them away first.
library;

import 'package:drift/drift.dart';

String normaliseDdl(String sql) => sql
    .replaceAll('"', '')
    .replaceAll(RegExp(r'(?<!NOT )\bNULL\b'), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .replaceAllMapped(RegExp(r'\s*([(),])\s*'), (m) => m[1]!)
    .trim()
    .toLowerCase();

/// Every `CREATE TABLE` statement in [db], normalised and ordered by name.
Future<List<String>> tableDdl(GeneratedDatabase db) => db
    .customSelect(
      "SELECT sql FROM sqlite_master WHERE type = 'table' "
      "AND name NOT LIKE 'sqlite_%' ORDER BY name",
    )
    .get()
    .then(
      (rows) => rows.map((r) => normaliseDdl(r.read<String>('sql'))).toList(),
    );
