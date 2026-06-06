import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fsrs/fsrs.dart';

import 'db_connection_native.dart'
    if (dart.library.js_interop) 'db_connection_web.dart';

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
  AppDatabase() : super(openDbConnection());

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 8) await m.createTable(srsCards);
      if (from < 9) {
        // The asset DB may already have this column despite reporting version 8
        try {
          await m.addColumn(srsCards, srsCards.firstSeenAt);
        } catch (_) {}
      }
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

  Future<List<VocabularyEntry>> getVocabByLevel(String level) =>
      (select(vocabularyEntries)
        ..where((v) => v.jlptLevel.equals(level))
        ..orderBy([(v) => OrderingTerm.asc(v.word)]))
      .get();

  Future<int> countTotalKanji() => (select(kanjis)).get().then((r) => r.length);

  Future<int> countTotalVocab() => (select(vocabularyEntries)).get().then((r) => r.length);

  Stream<int> watchDueTodayCount() => (select(srsCards)).watch().map(
        (rows) => rows.where((r) => !r.due.isAfter(DateTime.now())).length,
      );

  Stream<int> watchCharactersDueCount() => (select(srsCards)).watch().map(
        (rows) => rows
            .where((r) =>
                (r.itemType == 'hiragana' ||
                    r.itemType == 'katakana' ||
                    r.itemType == 'kanji') &&
                !r.due.isAfter(DateTime.now()))
            .length,
      );

  Stream<int> watchVocabDueCount() => (select(srsCards)).watch().map(
        (rows) => rows
            .where((r) => r.itemType == 'vocabulary' && !r.due.isAfter(DateTime.now()))
            .length,
      );

  /// All due kana (hiragana + katakana) — no new cards, for home screen review.
  Future<List<(Kana, Card?)>> getAllDueKanaSrsSession() async {
    final hiragana = await getKanaByType('hiragana');
    final katakana = await getKanaByType('katakana');
    final h = await _buildSrsSession('hiragana', hiragana, (k) => k.id, newCardLimit: 0);
    final k = await _buildSrsSession('katakana', katakana, (k) => k.id, newCardLimit: 0);
    return [...h, ...k];
  }

  /// All due kanji across every JLPT level — no new cards, for home screen review.
  /// 3 queries total regardless of kanji table size.
  Future<List<(Kanji, Card?)>> getAllDueKanjiSrsSession() async {
    final now = DateTime.now();

    final knownIds = await (select(progressEntries)
      ..where((p) => p.itemType.equals('kanji') & p.isKnown.equals(true)))
      .get()
      .then((rows) => rows.map((r) => r.itemId).toSet());

    final dueRows = await (select(srsCards)
      ..where((s) => s.itemType.equals('kanji')))
      .get()
      .then((rows) => rows
          .where((r) => !r.due.isAfter(now) && !knownIds.contains(r.itemId))
          .toList());

    if (dueRows.isEmpty) return [];

    final dueIds = dueRows.map((r) => r.itemId).toList();
    final kanjiList = await (select(kanjis)..where((k) => k.id.isIn(dueIds))).get();
    final kanjiById  = {for (final k in kanjiList) k.id: k};
    final cardByItemId = {for (final r in dueRows) r.itemId: r};

    return dueIds
        .where(kanjiById.containsKey)
        .map((id) {
          final card = Card.fromMap(
              jsonDecode(cardByItemId[id]!.cardJson) as Map<String, dynamic>);
          return (kanjiById[id]!, card as Card?);
        })
        .toList();
  }

  /// All due vocabulary across every JLPT level — no new cards, for home screen review.
  /// 3 queries total regardless of vocab table size.
  Future<List<(VocabularyEntry, Card?)>> getAllDueVocabSrsSession() async {
    final now = DateTime.now();

    final knownIds = await (select(progressEntries)
      ..where((p) => p.itemType.equals('vocabulary') & p.isKnown.equals(true)))
      .get()
      .then((rows) => rows.map((r) => r.itemId).toSet());

    final dueRows = await (select(srsCards)
      ..where((s) => s.itemType.equals('vocabulary')))
      .get()
      .then((rows) => rows
          .where((r) => !r.due.isAfter(now) && !knownIds.contains(r.itemId))
          .toList());

    if (dueRows.isEmpty) return [];

    final dueIds = dueRows.map((r) => r.itemId).toList();
    final vocabList = await (select(vocabularyEntries)..where((v) => v.id.isIn(dueIds))).get();
    final vocabById    = {for (final v in vocabList) v.id: v};
    final cardByItemId = {for (final r in dueRows) r.itemId: r};

    return dueIds
        .where(vocabById.containsKey)
        .map((id) {
          final card = Card.fromMap(
              jsonDecode(cardByItemId[id]!.cardJson) as Map<String, dynamic>);
          return (vocabById[id]!, card as Card?);
        })
        .toList();
  }

  Stream<Set<int>> watchKnownVocabIds() =>
      (select(progressEntries)
        ..where((p) => p.itemType.equals('vocabulary') & p.isKnown.equals(true)))
      .watch()
      .map((rows) => rows.map((r) => r.itemId).toSet());

  Future<void> setVocabKnown(int vocabId, {required bool isKnown}) =>
      _upsertProgress('vocabulary', vocabId, isKnown: isKnown);

  Future<List<(VocabularyEntry, Card?)>> getVocabSrsSession(
      String level, {int newCardLimit = 10}) async {
    final items = await getVocabByLevel(level);
    return _buildSrsSession('vocabulary', items, (v) => v.id, newCardLimit: newCardLimit);
  }

  // ── Kanji queries ────────────────────────────────────────────────────────

  Future<List<Kanji>> getKanjiByLevel(String level) =>
      (select(kanjis)..where((k) => k.jlptLevel.equals(level))).get();

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
      into(srsCards).insert(
        SrsCardsCompanion.insert(
          itemType: itemType,
          itemId: itemId,
          due: card.due,
          firstSeenAt: Value(DateTime.now()),
          cardJson: jsonEncode(card.toMap()),
        ),
        onConflict: DoUpdate(
          (old) => SrsCardsCompanion.custom(
            due: Variable(card.due),
            cardJson: Variable(jsonEncode(card.toMap())),
            // firstSeenAt intentionally omitted — never overwrite the original date
          ),
          target: [srsCards.itemType, srsCards.itemId],
        ),
      );

  /// Debug only — inserts past-due SRS cards for a sample of items.
  Future<void> seedFakeReviews() async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    final hiragana = await (select(kanas)
      ..where((k) => k.type.equals('hiragana'))
      ..limit(20)).get();
    for (final k in hiragana) {
      await upsertSrsCard('hiragana', k.id,
          Card(cardId: k.id, due: yesterday));
    }

    final kanji = await (select(kanjis)
      ..where((k) => k.jlptLevel.equals('N5'))
      ..limit(20)).get();
    for (final k in kanji) {
      await upsertSrsCard('kanji', k.id,
          Card(cardId: k.id, due: yesterday));
    }

    final vocab = await (select(vocabularyEntries)
      ..where((v) => v.jlptLevel.equals('N5'))
      ..limit(20)).get();
    for (final v in vocab) {
      await upsertSrsCard('vocabulary', v.id,
          Card(cardId: v.id, due: yesterday));
    }
  }

  Future<void> resetAllProgress() async {
    await delete(srsCards).go();
    await delete(progressEntries).go();
  }

  Future<void> resetSrsCard(String type, int itemId) async {
    await (delete(srsCards)
      ..where((s) => s.itemType.equals(type) & s.itemId.equals(itemId)))
      .go();
    await (delete(progressEntries)
      ..where((p) => p.itemType.equals(type) & p.itemId.equals(itemId)))
      .go();
  }

  Future<List<(Kanji, Card?)>> getKanjiSrsSession(String level, {int newCardLimit = 10}) async {
    final items = await (select(kanjis)..where((k) => k.jlptLevel.equals(level))).get();
    return _buildSrsSession('kanji', items, (k) => k.id, newCardLimit: newCardLimit);
  }

  Future<List<(Kana, Card?)>> getKanaSrsSession(String type, {int newCardLimit = 10}) async {
    final items = await getKanaByType(type);
    return _buildSrsSession(type, items, (k) => k.id, newCardLimit: newCardLimit);
  }

  Future<List<(T, Card?)>> _buildSrsSession<T>(
    String itemType,
    List<T> items,
    int Function(T) getId, {
    required int newCardLimit,
  }) async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    final skippedIds = await (select(progressEntries)
      ..where((p) => p.itemType.equals(itemType) & p.isKnown.equals(true)))
      .get()
      .then((rows) => rows.map((r) => r.itemId).toSet());

    final seenToday = await (select(srsCards)
      ..where((s) =>
          s.itemType.equals(itemType) &
          s.firstSeenAt.isBiggerOrEqualValue(todayStart)))
      .get()
      .then((rows) => rows.length);

    final remainingNew = (newCardLimit - seenToday).clamp(0, newCardLimit);

    final cards = await Future.wait(
      items.map((item) => getSrsCard(itemType, getId(item))),
    );

    final pairs = List.generate(items.length, (i) => (items[i], cards[i]))
        .where((p) => !skippedIds.contains(getId(p.$1)))
        .toList();

    final due     = pairs.where((p) => p.$2 != null && !p.$2!.due.isAfter(now)).toList();
    final newOnes = pairs.where((p) => p.$2 == null).take(remainingNew).toList();

    return [...due, ...newOnes];
  }
}
