import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';

import 'tables/exercises_table.dart';
import 'tables/grammar_lessons_table.dart';
import 'tables/kanas_table.dart';
import 'tables/kanjis_table.dart';
import 'tables/progress_table.dart';
import 'tables/translations_table.dart';
import 'tables/vocabulary_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Kanjis,
  Kanas,
  VocabularyEntries,
  GrammarLessons,
  Exercises,
  ProgressEntries,
  KanjiTranslations,
  VocabTranslations,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'manabi_do'));

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedFromJson();
    },
    // WARNING: drop-and-recreate wipes all user progress on every schema bump.
    // Replace with column-level migrations before shipping to real users.
    onUpgrade: (m, from, to) async {
      for (final table in allTables) {
        await m.deleteTable(table.actualTableName);
      }
      await m.createAll();
      await _seedFromJson();
    },
  );

  Future<void> _seedFromJson() async {
    for (final (slug, jlpt) in [('n5', 'N5'), ('n4', 'N4'), ('n3', 'N3'), ('n2', 'N2'), ('n1', 'N1')]) {
      await _seedKanjiLevel(slug, jlpt);
      await _seedVocabLevel(slug, jlpt);
    }
  }

  Future<void> _seedKanjiLevel(String slug, String jlpt) async {
    final raw = await rootBundle.loadString('assets/data/kanji_$slug.json');
    final list = jsonDecode(raw) as List<dynamic>;

    await batch((b) {
      b.insertAll(kanjis, list.map((k) {
        final on  = (k['on']  as List<dynamic>).join('、');
        final kun = (k['kun'] as List<dynamic>).join('、');
        final meanings = k['meanings'] as Map<String, dynamic>;
        return KanjisCompanion(
          id:         Value(k['id'] as int),
          character:  Value(k['character'] as String),
          meaning:    Value(meanings['en'] as String),
          onReading:  Value(on),
          kunReading: Value(kun),
          jlptLevel:  Value(jlpt),
        );
      }));
    });

    for (final k in list) {
      final kanjiId = k['id'] as int;
      final meanings = k['meanings'] as Map<String, dynamic>;
      await batch((b) {
        b.insertAll(
          kanjiTranslations,
          meanings.entries.map((e) => KanjiTranslationsCompanion(
            kanjiId: Value(kanjiId),
            locale:  Value(e.key),
            meaning: Value(e.value as String),
          )),
        );
      });
    }
  }

  Future<void> _seedVocabLevel(String slug, String jlpt) async {
    final raw = await rootBundle.loadString('assets/data/vocab_$slug.json');
    final list = jsonDecode(raw) as List<dynamic>;

    for (final v in list) {
      final meanings = v['meanings'] as Map<String, dynamic>;
      final vocabId = await into(vocabularyEntries).insert(
        VocabularyEntriesCompanion(
          word:         Value(v['word'] as String),
          reading:      Value(v['reading'] as String),
          meaning:      Value(meanings['en'] as String),
          partOfSpeech: Value(v['pos'] as String),
          jlptLevel:    Value(jlpt),
          kanjiId:      Value(v['kanjiId'] as int?),
        ),
      );
      if (meanings.length > 1) {
        await batch((b) {
          b.insertAll(
            vocabTranslations,
            meanings.entries.map((e) => VocabTranslationsCompanion(
              vocabId: Value(vocabId),
              locale:  Value(e.key),
              meaning: Value(e.value as String),
            )),
          );
        });
      }
    }
  }

  // ── Translation queries ──────────────────────────────────────────────────

  Future<Map<int, String>> getKanjiTranslations(List<int> ids, String locale) =>
      (select(kanjiTranslations)
        ..where((t) => t.kanjiId.isIn(ids) & t.locale.equals(locale)))
      .get()
      .then((rows) => {for (final r in rows) r.kanjiId: r.meaning});

  Future<Map<int, String>> getVocabTranslations(List<int> ids, String locale) =>
      (select(vocabTranslations)
        ..where((t) => t.vocabId.isIn(ids) & t.locale.equals(locale)))
      .get()
      .then((rows) => {for (final r in rows) r.vocabId: r.meaning});

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
