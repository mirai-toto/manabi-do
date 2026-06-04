import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:fsrs/fsrs.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/data/kana_data.dart';
import 'tables/exercises_table.dart';
import 'tables/grammar_lessons_table.dart';
import 'tables/kanas_table.dart';
import 'tables/kanjis_table.dart';
import 'tables/progress_table.dart';
import 'tables/srs_cards_table.dart';
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
  SrsCards,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 8) await m.createTable(srsCards);
    },
  );

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
          .map((k) => k == null ? null : KanaEntry(id: k.id, kana: k.character, romaji: k.romaji))
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

  Future<List<Kana>> getKanaByType(String type) =>
      (select(kanas)
        ..where((k) => k.type.equals(type))
        ..orderBy([(k) => OrderingTerm.asc(k.id)]))
      .get();

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
      _upsertProgress('kanji', kanjiId, isKnown: isKnown);

  // itemType is 'hiragana' or 'katakana'
  Stream<Set<int>> watchKnownKanaIds(String itemType) =>
      (select(progressEntries)
        ..where((p) => p.itemType.equals(itemType) & p.isKnown.equals(true)))
      .watch()
      .map((rows) => rows.map((r) => r.itemId).toSet());

  Future<void> setKanaKnown(String itemType, int kanaId, {required bool isKnown}) =>
      _upsertProgress(itemType, kanaId, isKnown: isKnown);

  Future<void> _upsertProgress(String itemType, int itemId, {required bool isKnown}) {
    final companion = ProgressEntriesCompanion.insert(
      itemType: itemType,
      itemId: itemId,
      isKnown: isKnown,
      toggledAt: DateTime.now(),
    );
    return into(progressEntries).insert(
      companion,
      onConflict: DoUpdate(
        (old) => ProgressEntriesCompanion.custom(
          isKnown: Variable(isKnown),
          toggledAt: Variable(DateTime.now()),
        ),
        target: [progressEntries.itemType, progressEntries.itemId],
      ),
    );
  }

  // ── SRS queries ──────────────────────────────────────────────────────────

  Future<Map<int, Card>> getAllSrsCardsForType(String itemType) async {
    final rows = await (select(srsCards)
      ..where((s) => s.itemType.equals(itemType)))
      .get();
    return {
      for (final r in rows)
        r.itemId: Card.fromMap(jsonDecode(r.cardJson) as Map<String, dynamic>)
    };
  }

  Stream<Map<int, Card>> watchAllSrsCardsForType(String itemType) =>
      (select(srsCards)..where((s) => s.itemType.equals(itemType)))
          .watch()
          .map((rows) => {
            for (final r in rows)
              r.itemId: Card.fromMap(jsonDecode(r.cardJson) as Map<String, dynamic>)
          });

  Future<Card?> getSrsCard(String itemType, int itemId) async {
    final row = await (select(srsCards)
      ..where((s) => s.itemType.equals(itemType) & s.itemId.equals(itemId)))
      .getSingleOrNull();
    if (row == null) return null;
    return Card.fromMap(jsonDecode(row.cardJson) as Map<String, dynamic>);
  }

  Future<void> upsertSrsCard(String itemType, int itemId, Card card) =>
      into(srsCards).insertOnConflictUpdate(
        SrsCardsCompanion.insert(
          itemType: itemType,
          itemId: itemId,
          due: card.due,
          cardJson: jsonEncode(card.toMap()),
        ),
      );

  Future<void> resetAllProgress() async {
    await delete(srsCards).go();
    await delete(progressEntries).go();
  }

  Future<void> resetKanaCard(String type, int kanaId) async {
    await (delete(srsCards)
      ..where((s) => s.itemType.equals(type) & s.itemId.equals(kanaId)))
      .go();
    await (delete(progressEntries)
      ..where((p) => p.itemType.equals(type) & p.itemId.equals(kanaId)))
      .go();
  }

  Future<List<(Kana, Card?)>> getKanaSrsSession(String type) async {
    final kanaList = await getKanaByType(type);
    final now = DateTime.now();

    final cards = await Future.wait(
      kanaList.map((k) => getSrsCard(type, k.id)),
    );

    final pairs = List.generate(kanaList.length, (i) => (kanaList[i], cards[i]));

    final due    = pairs.where((p) => p.$2 != null && !p.$2!.due.isAfter(now)).toList();
    final newOnes = pairs.where((p) => p.$2 == null).take(20).toList();

    return [...due, ...newOnes];
  }
}

// Bump this string whenever a new assets/manabi_do_content.db is shipped.
// Using a separate marker file so Drift's automatic user_version bumping
// doesn't fool the detection logic.
const _assetDbVersion = '7.1';

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
