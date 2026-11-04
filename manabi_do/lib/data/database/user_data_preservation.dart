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

/// The item_type that vocabulary cards use. Kanji and grammar key on values
/// that do not move, so only vocabulary needs translating.
const String vocabularyItemType = 'vocabulary';

/// Joins a word and its reading into one map key. U+0000 cannot occur in
/// either, so the pair cannot collide with a different pair.
String vocabularyKey(String word, String reading) => '$word\u0000$reading';

/// Reads `id → (word, reading)` out of a content database.
///
/// `vocabulary_entries.id` is an autoincrement rowid assigned in insertion
/// order, so it moves whenever the word list changes. A user's review history
/// keys on it. Without translating, adding a word near the start of the list
/// silently repoints every later card at a different word — not lost, which
/// would at least be visible, but wrong.
///
/// `(word, reading)` is unique in the shipped content and is what identifies a
/// word to a learner, so it is the key both sides are translated through.
Map<int, String> readVocabularyIdentity(raw.Database db) {
  final Map<int, String> identity = {};
  try {
    final rows = db.select('SELECT id, word, reading FROM vocabulary_entries');
    for (final row in rows) {
      identity[row['id'] as int] = vocabularyKey(
        row['word'] as String,
        row['reading'] as String,
      );
    }
  } catch (e) {
    if (_isMissingTable(e)) return identity;
    rethrow;
  }
  return identity;
}

/// What a remap did, so the caller can act on a result that looks wrong.
class VocabularyRemap {
  final Map<String, List<List<Object?>>> rows;
  final int translated;
  final int dropped;

  const VocabularyRemap({
    required this.rows,
    required this.translated,
    required this.dropped,
  });

  int get total => translated + dropped;
}

/// Thrown when almost no vocabulary card could be translated.
///
/// A handful of drops is ordinary: a word left the list, so there is nothing
/// left to review. Nearly all of them failing means the two sides disagree
/// about what identifies a word, and carrying on would wipe the history this
/// module exists to protect.
class VocabularyRemapException implements Exception {
  final int translated;
  final int dropped;

  const VocabularyRemapException(this.translated, this.dropped);

  @override
  String toString() =>
      'Only $translated of ${translated + dropped} vocabulary cards could be '
      'matched to the new content. Refusing to refresh, because that would '
      'discard the rest of the review history.';
}

/// Rewrites vocabulary `item_id`s from the old database's numbering to the
/// new one's, matching on `(word, reading)`.
///
/// A row whose word is no longer taught is dropped, which is correct — there
/// is nothing left to review. Rows for other item types pass through
/// untouched.
VocabularyRemap remapVocabularyIds(
  Map<String, List<List<Object?>>> saved,
  Map<int, String> oldIdentity,
  Map<int, String> newIdentity,
) {
  final Map<String, int> newIdByKey = {
    for (final entry in newIdentity.entries) entry.value: entry.key,
  };

  final Map<String, List<List<Object?>>> out = {};
  int translated = 0;
  int dropped = 0;

  for (final table in preservedTables) {
    final rows = saved[table.name];
    if (rows == null) continue;

    final typeAt = table.columns.indexOf('item_type');
    final idAt = table.columns.indexOf('item_id');
    if (typeAt < 0 || idAt < 0) {
      out[table.name] = rows;
      continue;
    }

    final List<List<Object?>> kept = [];
    for (final row in rows) {
      if (row[typeAt] != vocabularyItemType) {
        kept.add(row);
        continue;
      }
      final key = oldIdentity[row[idAt] as int];
      final newId = key == null ? null : newIdByKey[key];
      if (newId == null) {
        dropped++;
        continue;
      }
      final translatedRow = List<Object?>.from(row);
      translatedRow[idAt] = newId;
      kept.add(translatedRow);
      translated++;
    }
    out[table.name] = kept;
  }

  // Half is a deliberately loose floor. It is here to catch a wholesale
  // mismatch, not to judge ordinary churn in the word list.
  if (translated + dropped > 0 && translated * 2 < translated + dropped) {
    throw VocabularyRemapException(translated, dropped);
  }

  return VocabularyRemap(rows: out, translated: translated, dropped: dropped);
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
