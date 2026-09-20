import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:manabi_do/data/database/user_data_preservation.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

/// The real shipped asset, as it would be copied over an existing install.
final File _assetDb = File('assets/manabi_do_content.db');

/// Builds a stand-in for a user's on-device database: the shipped schema with
/// some progress written into it.
File _installWithProgress(Directory dir, {int srsCards = 3}) {
  final file = File('${dir.path}/manabi_do.db');
  file.writeAsBytesSync(_assetDb.readAsBytesSync());

  final db = raw.sqlite3.open(file.path);
  for (var i = 0; i < srsCards; i++) {
    db.execute(
      'INSERT INTO srs_cards (item_type, item_id, due, first_seen_at, card_json) '
      'VALUES (?, ?, ?, ?, ?)',
      ['kanji', i, 1700000000 + i, 1699000000 + i, '{"stability":$i}'],
    );
  }
  db.execute(
    'INSERT INTO progress_entries (item_type, item_id, is_known, toggled_at) '
    'VALUES (?, ?, ?, ?)',
    ['vocabulary', 42, 1, 1700000000],
  );
  db.execute(
    'INSERT INTO grammar_lesson_progress (lesson_path, read_at) VALUES (?, ?)',
    ['N5/verbs/verb-groups', 1700000000],
  );
  db.execute('INSERT INTO grammar_chapter_unlocks (chapter_key) VALUES (?)', [
    'N5/verbs',
  ]);
  db.close();
  return file;
}

void main() {
  late Directory tmp;

  setUp(() => tmp = Directory.systemTemp.createTempSync('manabi_pres'));
  tearDown(() => tmp.deleteSync(recursive: true));

  test('progress survives the content DB being replaced', () {
    final file = _installWithProgress(tmp);

    // 1. read the user's rows out of the old file
    final saved = readUserData(file);
    expect(saved['srs_cards'], hasLength(3));
    expect(saved['progress_entries'], hasLength(1));
    expect(saved['grammar_lesson_progress'], hasLength(1));
    expect(saved['grammar_chapter_unlocks'], hasLength(1));

    // 2. the refresh overwrites the file wholesale
    file.writeAsBytesSync(_assetDb.readAsBytesSync());

    // 3. write them back into the fresh copy
    final fresh = raw.sqlite3.open(file.path);
    writeUserData(fresh, saved);

    expect(fresh.select('SELECT * FROM srs_cards').length, 3);
    expect(
      fresh
          .select('SELECT card_json FROM srs_cards ORDER BY item_id')
          .first
          .values
          .first,
      '{"stability":0}',
    );
    expect(fresh.select('SELECT * FROM progress_entries').length, 1);
    expect(fresh.select('SELECT * FROM grammar_lesson_progress').length, 1);
    expect(fresh.select('SELECT * FROM grammar_chapter_unlocks').length, 1);

    // content came from the fresh asset, untouched
    expect(fresh.select('SELECT COUNT(*) c FROM kanjis').first['c'], 2211);
    fresh.close();
  });

  test('a first install has nothing to preserve', () {
    expect(readUserData(File('${tmp.path}/absent.db')), isEmpty);
  });

  test('a table missing from an older install is skipped, not fatal', () {
    final file = _installWithProgress(tmp);
    final db = raw.sqlite3.open(file.path);
    db.execute('DROP TABLE grammar_chapter_unlocks');
    db.close();

    final saved = readUserData(file);
    expect(saved['srs_cards'], hasLength(3));
    expect(saved.containsKey('grammar_chapter_unlocks'), isFalse);
  });

  test('a renamed column throws instead of silently dropping progress', () {
    final file = _installWithProgress(tmp);
    final db = raw.sqlite3.open(file.path);
    db.execute('ALTER TABLE srs_cards RENAME COLUMN card_json TO card_data');
    db.close();

    // The old behaviour swallowed this and returned {}, so the caller would
    // overwrite the file and every review card would be gone.
    expect(
      () => readUserData(file),
      throwsA(
        isA<UserDataReadException>().having(
          (e) => e.table,
          'table',
          'srs_cards',
        ),
      ),
    );
  });
}
