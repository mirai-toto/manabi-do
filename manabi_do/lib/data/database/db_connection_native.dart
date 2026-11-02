import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

import 'user_data_preservation.dart';

/// Which content build the bundled asset is, read from the pin that ships
/// beside it.
///
/// This used to be a hand-written constant. It was wrong for exactly as long as
/// anybody failed to notice: a new asset shipped with schema 25 while the
/// constant still said `9.0`, so every install kept its old content, ran the
/// migration over it, and showed all 8,406 words in the last coverage band with
/// no group figures at all. Nothing in the build could catch that, because the
/// constant was true of nothing.
///
/// `content.lock` already is the record of which build the app ships, and
/// `scripts/content/fetch_content.sh` rewrites it whenever the asset is
/// replaced. Reading it here means the two cannot drift apart.
Future<String> _assetContentVersion() async {
  final String lock = await rootBundle.loadString('content.lock');
  for (final String line in lock.split('\n')) {
    final String trimmed = line.trim();
    if (trimmed.startsWith('tag')) {
      final int at = trimmed.indexOf('=');
      if (at != -1) return trimmed.substring(at + 1).trim();
    }
  }
  throw StateError(
    'content.lock names no tag, so the content build is unknown',
  );
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

    final String assetVersion = await _assetContentVersion();
    final currentVersion = marker.existsSync()
        ? marker.readAsStringSync().trim()
        : '';
    final needsCopy = !file.existsSync() || currentVersion != assetVersion;

    if (needsCopy) {
      // Save user data so it survives the content DB refresh.
      //
      // This must stay ahead of the overwrite below. If it throws, the old
      // file is still intact and the marker is still unwritten, so the next
      // launch retries rather than the user losing their review history to a
      // half-finished refresh.
      final Map<String, List<List<Object?>>> savedUserData = readUserData(file);

      // Vocabulary row ids move whenever the word list changes, and review
      // history keys on them, so the old numbering is captured here and
      // translated below. Read before the overwrite, because the file about to
      // be replaced is the only place it exists.
      Map<int, String> oldIdentity = const {};
      if (file.existsSync()) {
        final raw.Database old = raw.sqlite3.open(file.path);
        try {
          oldIdentity = readVocabularyIdentity(old);
        } finally {
          old.close();
        }
      }

      final blob = await rootBundle.load('assets/manabi_do_content.db');

      // Staged beside the real file rather than written over it. The remap
      // below can refuse, and refusing is only safe while the old database is
      // still intact: the marker stays unwritten, so the next launch retries.
      final File staged = File('${file.path}.new');
      await staged.writeAsBytes(
        blob.buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
      );

      // The asset DB is built from the same `schema.drift` drift generates
      // from, so it already contains every table and is stamped with the
      // current schemaVersion. Drift therefore opens it with nothing to
      // migrate — no version rewriting needed here.
      try {
        final raw.Database setup = raw.sqlite3.open(staged.path);
        try {
          final VocabularyRemap remap = remapVocabularyIds(
            savedUserData,
            oldIdentity,
            readVocabularyIdentity(setup),
          );
          writeUserData(setup, remap.rows);
        } finally {
          setup.close();
        }
      } catch (_) {
        if (staged.existsSync()) staged.deleteSync();
        rethrow;
      }

      // Remove stale WAL/SHM files so SQLite doesn't try to replay old frames
      // against the replacement.
      for (final suffix in ['-wal', '-shm']) {
        final side = File('${file.path}$suffix');
        if (side.existsSync()) side.deleteSync();
      }

      // Same directory, so this is atomic: the file is either the old content
      // or the new one with the history carried over, never a half-written mix.
      await staged.rename(file.path);

      // Write the marker only after the move succeeds so a crash here retries next launch.
      await marker.writeAsString(assetVersion);
    }

    return NativeDatabase(file);
  });
}
