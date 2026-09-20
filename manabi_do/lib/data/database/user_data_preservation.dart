import 'dart:io';

import 'package:sqlite3/sqlite3.dart' as raw;

/// A table holding user data rather than shipped content.
///
/// Refreshing the content DB overwrites the file wholesale, so these rows are
/// read out beforehand and written back into the fresh copy.
class PreservedTable {
  final String name;
  final List<String> columns;

  const PreservedTable({required this.name, required this.columns});
}

/// Everything the user creates. Content tables are rebuilt from the asset and
/// deliberately absent here.
const List<PreservedTable> preservedTables = [
  PreservedTable(
    name: 'srs_cards',
    columns: ['item_type', 'item_id', 'due', 'first_seen_at', 'card_json'],
  ),
  PreservedTable(
    name: 'progress_entries',
    columns: ['item_type', 'item_id', 'is_known', 'toggled_at'],
  ),
  PreservedTable(
    name: 'grammar_lesson_progress',
    columns: ['lesson_path', 'read_at'],
  ),
  PreservedTable(name: 'grammar_lesson_starts', columns: ['lesson_path']),
  PreservedTable(name: 'grammar_chapter_unlocks', columns: ['chapter_key']),
];

/// Thrown when user data could not be read. The caller must not continue with
/// the refresh: overwriting the file after a failed read destroys the very
/// rows this module exists to protect.
class UserDataReadException implements Exception {
  final String table;
  final Object cause;

  const UserDataReadException(this.table, this.cause);

  @override
  String toString() =>
      'Failed to read preserved table "$table" before refreshing the content '
      'DB: $cause. Refusing to overwrite the database.';
}

bool _isMissingTable(Object e) =>
    e is raw.SqliteException &&
    e.message.toLowerCase().contains('no such table');

/// Reads every preserved table out of [file].
///
/// A table that does not exist yet is fine — that is simply an install from
/// before the table was introduced. Any other failure throws
/// [UserDataReadException] rather than returning partial data, because the
/// caller is about to overwrite this file. A renamed or dropped column would
/// otherwise look identical to "nothing to carry over" and silently wipe the
/// user's review history.
Map<String, List<List<Object?>>> readUserData(File file) {
  final Map<String, List<List<Object?>>> saved = {};
  if (!file.existsSync()) return saved;

  raw.Database? old;
  try {
    old = raw.sqlite3.open(file.path);
  } catch (_) {
    // The file exists but is not a usable database — nothing to rescue.
    return saved;
  }

  try {
    for (final table in preservedTables) {
      try {
        final result = old.select(
          'SELECT ${table.columns.join(', ')} FROM ${table.name}',
        );
        if (result.isEmpty) continue;
        saved[table.name] = [
          for (final row in result) List<Object?>.from(row.values),
        ];
      } catch (e) {
        if (_isMissingTable(e)) continue;
        throw UserDataReadException(table.name, e);
      }
    }
  } finally {
    old.close();
  }
  return saved;
}

/// Writes previously saved rows back into the fresh database.
void writeUserData(
  raw.Database target,
  Map<String, List<List<Object?>>> saved,
) {
  for (final table in preservedTables) {
    final rows = saved[table.name];
    if (rows == null) continue;
    final placeholders = List.filled(table.columns.length, '?').join(', ');
    final stmt = target.prepare(
      'INSERT OR REPLACE INTO ${table.name} '
      '(${table.columns.join(', ')}) VALUES ($placeholders)',
    );
    for (final row in rows) {
      stmt.execute(row);
    }
    stmt.close();
  }
}
