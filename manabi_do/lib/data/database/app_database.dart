import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/data/kana_data.dart';
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
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  // No onCreate/onUpgrade needed — the DB is pre-built and copied from assets.
  // Schema migrations will be handled in a future release before production.

  // ── Kana queries ─────────────────────────────────────────────────────────

  Future<KanaData> getKanaData() async {
    final rows = await (select(kanas)..orderBy([(k) => OrderingTerm.asc(k.id)])).get();

    final hiraganaRowOrder = <String>[];
    final katakanaRowOrder = <String>[];
    final hiraganaGroup = <String, String>{};
    final katakanaGroup = <String, String>{};
    final hiraganaSlots = <String, List<Kana?>>{};
    final katakanaSlots = <String, List<Kana?>>{};

    for (final k in rows) {
      final isHiragana = k.type == 'hiragana';
      final slotMap = isHiragana ? hiraganaSlots : katakanaSlots;
      final order = isHiragana ? hiraganaRowOrder : katakanaRowOrder;
      final groupMap = isHiragana ? hiraganaGroup : katakanaGroup;

      if (!slotMap.containsKey(k.row)) {
        slotMap[k.row] = List.filled(5, null);
        order.add(k.row);
        groupMap[k.row] = k.kanaGroup;
      }
      slotMap[k.row]![k.slot] = k;
    }

    KanaRow buildRow(String label, List<Kana?> slots, String group) => KanaRow(
      label: label,
      group: group,
      entries: slots
          .map((k) => k == null ? null : KanaEntry(k.character, k.romaji))
          .toList(),
    );

    final hiragana = hiraganaRowOrder
        .map((l) => buildRow(l, hiraganaSlots[l]!, hiraganaGroup[l]!))
        .toList();
    final katakana = katakanaRowOrder
        .map((l) => buildRow(l, katakanaSlots[l]!, katakanaGroup[l]!))
        .toList();
    final hiraganaCount = hiragana.expand((r) => r.kana).length;
    final katakanaCount = katakana.expand((r) => r.kana).length;

    return KanaData(
      hiraganaCount: hiraganaCount,
      katakanaCount: katakanaCount,
      total: hiraganaCount + katakanaCount,
      groups: const [
        KanaGroup(id: 'gojuuon', label: 'Gojuuon'),
        KanaGroup(id: 'dakuten', label: 'Dakuten'),
      ],
      hiragana: hiragana,
      katakana: katakana,
    );
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

// Bump this string whenever a new assets/manabi_do_content.db is shipped.
// Using a separate marker file so Drift's automatic user_version bumping
// doesn't fool the detection logic.
const _assetDbVersion = '7';

LazyDatabase _openConnection() {
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
