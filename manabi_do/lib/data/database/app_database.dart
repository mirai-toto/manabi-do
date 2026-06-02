import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'n5_kanji_seed.dart';
import 'tables/exercises_table.dart';
import 'tables/grammar_lessons_table.dart';
import 'tables/kanas_table.dart';
import 'tables/kanjis_table.dart';
import 'tables/progress_table.dart';
import 'tables/vocabulary_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Kanjis, Kanas, VocabularyEntries, GrammarLessons, Exercises, ProgressEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'manabi_do'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedN5Kanji();
    },
    onUpgrade: (m, from, to) async {
      for (final table in allTables) {
        await m.deleteTable(table.actualTableName);
      }
      await m.createAll();
      await _seedN5Kanji();
    },
  );

  Future<void> _seedN5Kanji() async {
    final companions = n5KanjiData.map((e) => KanjisCompanion(
      id: Value(e.$1),
      character: Value(e.$2),
      meaning: Value(e.$3),
      onReading: Value(e.$4),
      kunReading: Value(e.$5),
      jlptLevel: const Value('N5'),
    )).toList();
    await batch((b) => b.insertAll(kanjis, companions));
  }

  // ── Kanji queries ────────────────────────────────────────────────────────

  Stream<List<Kanji>> watchKanjiByLevel(String level) =>
      (select(kanjis)..where((k) => k.jlptLevel.equals(level))).watch();

  // ── Progress queries ─────────────────────────────────────────────────────

  Stream<Set<int>> watchKnownKanjiIds() =>
      (select(progressEntries)
        ..where((p) => p.itemType.equals('kanji') & p.isKnown.equals(true)))
      .watch()
      .map((rows) => rows.map((r) => r.itemId).toSet());

  Future<void> setKanjiKnown(int kanjiId, {required bool isKnown}) =>
      into(progressEntries).insertOnConflictUpdate(
        ProgressEntriesCompanion.insert(
          itemType: 'kanji',
          itemId: kanjiId,
          isKnown: isKnown,
          toggledAt: DateTime.now(),
        ),
      );
}
