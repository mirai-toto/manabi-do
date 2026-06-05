import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const _assetDbVersion = '7.1';

QueryExecutor openDbConnection() {
  return LazyDatabase(() async {
    final dir    = await getApplicationDocumentsDirectory();
    final file   = File(p.join(dir.path, 'manabi_do.db'));
    final marker = File(p.join(dir.path, 'manabi_do.db.version'));

    final currentVersion = marker.existsSync() ? marker.readAsStringSync().trim() : '';
    final needsCopy = !file.existsSync() || currentVersion != _assetDbVersion;

    if (needsCopy) {
      // Remove stale WAL/SHM files so SQLite doesn't try to replay old frames.
      for (final suffix in ['-wal', '-shm']) {
        final side = File('${file.path}$suffix');
        if (side.existsSync()) side.deleteSync();
      }

      final blob = await rootBundle.load('assets/manabi_do_content.db');
      await file.writeAsBytes(
        blob.buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
      );
      await marker.writeAsString(_assetDbVersion);
    }

    return NativeDatabase(file);
  });
}
