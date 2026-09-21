import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

import 'user_data_preservation.dart';

const _assetDbVersion = '9.0';

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
      //
      // This must stay ahead of the overwrite below. If it throws, the old
      // file is still intact and the marker is still unwritten, so the next
      // launch retries rather than the user losing their review history to a
      // half-finished refresh.
      final Map<String, List<List<Object?>>> savedUserData = readUserData(file);

      // Remove stale WAL/SHM files so SQLite doesn't try to replay old frames.
      for (final suffix in ['-wal', '-shm']) {
        final side = File('${file.path}$suffix');
        if (side.existsSync()) side.deleteSync();
      }

      final blob = await rootBundle.load('assets/manabi_do_content.db');
      await file.writeAsBytes(
        blob.buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
      );

      // The asset DB is built from the same `schema.drift` drift generates
      // from, so it already contains every table and is stamped with the
      // current schemaVersion. Drift therefore opens it with nothing to
      // migrate — no version rewriting needed here.
      final setup = raw.sqlite3.open(file.path);

      // Restore user data into the fresh DB before drift opens it.
      writeUserData(setup, savedUserData);
      setup.close();

      // Write the marker only after setup succeeds so a crash here retries next launch.
      await marker.writeAsString(_assetDbVersion);
    }

    return NativeDatabase(file);
  });
}
