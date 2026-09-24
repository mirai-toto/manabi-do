import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

/// Guards the data behind the daily-queue dedupe.
///
/// 57 vocabulary rows are exact duplicates — same word, reading and meaning,
/// differing only by `id` and the JLPT level they were filed under. Each is its
/// own SRS card, so both fall due together and daily training, which merges
/// every level, asked the identical question twice.
///
/// If a content rebuild ever removes them, `_dropRepeatedPrompts` becomes dead
/// weight and this test says so rather than leaving it there forever.
void main() {
  late Database db;

  setUpAll(
    () => db = sqlite3.open(
      'assets/manabi_do_content.db',
      mode: OpenMode.readOnly,
    ),
  );
  tearDownAll(() => db.close());

  int count(String sql) => db.select(sql).first.values.first! as int;

  test('exact duplicate vocabulary rows still exist', () {
    final exact = count('''
      SELECT COUNT(*) FROM (
        SELECT word FROM vocabulary_entries
        GROUP BY word, reading, meaning HAVING COUNT(*) > 1
      )
    ''');

    expect(
      exact,
      greaterThan(0),
      reason: 'No duplicates left — _dropRepeatedPrompts can be removed.',
    );
  });

  test('words sharing a spelling but not a reading are left alone', () {
    // いい / よい and けれど / けれども are different words that happen to share a
    // spelling. The dedupe keys on the answer too, so it must not collapse
    // these — losing one would hide real vocabulary.
    final sameWordDifferentReading = count('''
      SELECT COUNT(*) FROM (
        SELECT word FROM vocabulary_entries
        GROUP BY word HAVING COUNT(DISTINCT reading) > 1
      )
    ''');

    expect(sameWordDifferentReading, greaterThan(0));
  });
}
