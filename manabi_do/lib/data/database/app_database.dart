import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'n1_kanji_seed.dart';
import 'n1_vocab_seed.dart';
import 'n2_kanji_seed.dart';
import 'n2_vocab_seed.dart';
import 'n3_kanji_seed.dart';
import 'n3_vocab_seed.dart';
import 'n4_kanji_seed.dart';
import 'n4_vocab_seed.dart';
import 'n5_kanji_seed.dart';
import 'n5_vocab_seed.dart';
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
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedAllKanji();
      await _seedAllVocab();
    },
    // WARNING: drop-and-recreate wipes all user progress on every schema bump.
    // Replace with column-level migrations before shipping to real users.
    onUpgrade: (m, from, to) async {
      for (final table in allTables) {
        await m.deleteTable(table.actualTableName);
      }
      await m.createAll();
      await _seedAllKanji();
      await _seedAllVocab();
    },
  );

  Future<void> _seedAllKanji() async {
    final levels = [
      (n5KanjiData, 'N5'),
      (n4KanjiData, 'N4'),
      (n3KanjiData, 'N3'),
      (n2KanjiData, 'N2'),
      (n1KanjiData, 'N1'),
    ];
    for (final (data, level) in levels) {
      final companions = data.map((e) => KanjisCompanion(
        id: Value(e.$1),
        character: Value(e.$2),
        meaning: Value(e.$3),
        onReading: Value(e.$4),
        kunReading: Value(e.$5),
        jlptLevel: Value(level),
      )).toList();
      await batch((b) => b.insertAll(kanjis, companions));
    }
  }

  Future<void> _seedAllVocab() async {
    final datasets = [
      (n5VocabData, 'N5'),
      (n4VocabData, 'N4'),
      (n3VocabData, 'N3'),
      (n2VocabData, 'N2'),
      (n1VocabData, 'N1'),
    ];
    for (final (data, level) in datasets) {
      final companions = data.map((e) => VocabularyEntriesCompanion(
        word: Value(e.$1),
        reading: Value(e.$2),
        meaning: Value(e.$3),
        partOfSpeech: Value(e.$4),
        jlptLevel: Value(level),
        kanjiId: Value(e.$5),
      )).toList();
      await batch((b) => b.insertAll(vocabularyEntries, companions));
    }
  }

  // ── Vocabulary queries ───────────────────────────────────────────────────

  Future<List<VocabularyEntry>> getVocabForKanji(int kanjiId, String character) =>
      (select(vocabularyEntries)
        ..where((v) => v.kanjiId.equals(kanjiId) | v.word.like('%$character%'))
        ..orderBy([(v) => OrderingTerm.desc(v.jlptLevel), (v) => OrderingTerm.asc(v.word)])
        ..limit(30))
      .get();

  // ── Kanji queries ────────────────────────────────────────────────────────

  Stream<List<Kanji>> watchKanjiByLevel(String level) =>
      (select(kanjis)..where((k) => k.jlptLevel.equals(level))).watch();

  Stream<Kanji?> watchKanjiById(int id) =>
      (select(kanjis)..where((k) => k.id.equals(id))).watchSingleOrNull();

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
