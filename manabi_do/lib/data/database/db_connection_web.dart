import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';

QueryExecutor openDbConnection() {
  return driftDatabase(
    name: 'manabi_do',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
      initializeDatabase: () async {
        final blob = await rootBundle.load('assets/manabi_do_content.db');
        return blob.buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes);
      },
    ),
  );
}
