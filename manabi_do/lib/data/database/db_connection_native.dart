import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

const _assetDbVersion = '8.1';

QueryExecutor openDbConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'manabi_do.db'));
    final marker = File(p.join(dir.path, 'manabi_do.db.version'));

    final currentVersion = marker.existsSync()
        ? marker.readAsStringSync().trim()
        : '';
    final needsCopy = !file.existsSync() || currentVersion != _assetDbVersion;

    if (needsCopy) {
      // Save SRS progress so it survives the content DB refresh.
      final List<List<Object?>> savedCards = [];
      if (file.existsSync()) {
        try {
          final old = raw.sqlite3.open(file.path);
          final result = old.select(
            'SELECT item_type, item_id, due, first_seen_at, card_json FROM srs_cards',
          );
          for (final row in result) {
            savedCards.add(List<Object?>.from(row.values));
          }
          old.close();
        } catch (_) {}
      }

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

      // Restore SRS progress into the fresh DB before drift opens it.
      if (savedCards.isNotEmpty) {
        setup.execute(
          'CREATE TABLE IF NOT EXISTS srs_cards ('
          '  item_type TEXT NOT NULL,'
          '  item_id INTEGER NOT NULL,'
          '  due INTEGER NOT NULL,'
          '  first_seen_at INTEGER,'
          '  card_json TEXT NOT NULL,'
          '  PRIMARY KEY (item_type, item_id)'
          ')',
        );
        final stmt = setup.prepare(
          'INSERT OR REPLACE INTO srs_cards (item_type, item_id, due, first_seen_at, card_json) VALUES (?, ?, ?, ?, ?)',
        );
        for (final row in savedCards) {
          stmt.execute(row);
        }
        stmt.close();
      }
      setup.close();

      // Write the marker only after setup succeeds so a crash here retries next launch.
      await marker.writeAsString(_assetDbVersion);
    }

    return NativeDatabase(file);
  });
}
