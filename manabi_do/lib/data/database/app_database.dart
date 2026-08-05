import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:fsrs/fsrs.dart';

import 'db_connection_native.dart'
    if (dart.library.js_interop) 'db_connection_web.dart';

import '../../domain/data/kana_data.dart';
import 'tables/exercises_table.dart';
import 'tables/grammar_exercises_table.dart';
import 'tables/grammar_lesson_progress_table.dart';
import 'tables/grammar_lesson_starts_table.dart';
import 'tables/grammar_lessons_table.dart';
import 'tables/kanas_table.dart';
import 'tables/kanjis_table.dart';
import 'tables/progress_table.dart';
import 'tables/sentences_table.dart';
import 'tables/srs_cards_table.dart';
import 'tables/translations_table.dart';
import 'tables/vocabulary_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Kanjis,
    Kanas,
    VocabularyEntries,
    Exercises,
    GrammarLessons,
    GrammarExercises,
    GrammarLessonProgress,
    GrammarLessonStarts,
    ProgressEntries,
    KanjiTranslations,
    VocabTranslations,
    SrsCards,
    Sentences,
    SentenceTranslations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openDbConnection());

  @override
  int get schemaVersion => 19;

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
      if (from < 10) await m.createTable(sentences);
      if (from < 11) {
        await m.createTable(sentenceTranslations);
        // Migrate english column only if it exists (old schema); the try/catch
        // also guards the table recreation so if english is absent (new asset DB
        // that already has furigana columns) we leave the table untouched.
        try {
          await customStatement(
            "INSERT INTO sentence_translations (sentence_id, locale, translation) "
            "SELECT id, 'eng', english FROM sentences "
            "WHERE english IS NOT NULL AND english != ''",
          );
          // english column confirmed present – recreate table without it but
          // keep the furigana columns so schema 12 addColumn is a no-op.
          await customStatement(
            "CREATE TABLE sentences_new ("
            "  id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "  japanese TEXT NOT NULL,"
            "  target_word TEXT NOT NULL,"
            "  vocab_id INTEGER NOT NULL REFERENCES vocabulary_entries(id),"
            "  furigana_before TEXT,"
            "  furigana_after TEXT"
            ")",
          );
          await customStatement(
            "INSERT INTO sentences_new (id, japanese, target_word, vocab_id) "
            "SELECT id, japanese, target_word, vocab_id FROM sentences",
          );
          await customStatement("DROP TABLE sentences");
          await customStatement(
            "ALTER TABLE sentences_new RENAME TO sentences",
          );
        } catch (_) {}
      }
      if (from < 12) {
        try {
          await m.addColumn(sentences, sentences.furiganaBefore);
        } catch (_) {}
        try {
          await m.addColumn(sentences, sentences.furiganaAfter);
        } catch (_) {}
      }
      if (from < 13) {
        try {
          await m.addColumn(sentences, sentences.furigana);
        } catch (_) {}
      }
      if (from < 14) {
        try {
          await m.addColumn(grammarLessons, grammarLessons.locale);
        } catch (_) {}
      }
      if (from < 15) await m.createTable(grammarExercises);
      if (from < 16) {
        try {
          await m.addColumn(grammarLessons, grammarLessons.themeDescription);
        } catch (_) {}
      }
      if (from < 17) await m.createTable(grammarLessonProgress);
      if (from < 18) {
        try {
          await m.addColumn(grammarLessons, grammarLessons.difficulty);
        } catch (_) {}
      }
      if (from < 19) await m.createTable(grammarLessonStarts);
    },
  );

  // ── Kana queries ─────────────────────────────────────────────────────────

  Future<KanaData> getKanaData() async {
    final rows = await (select(
      kanas,
    )..orderBy([(k) => OrderingTerm.asc(k.id)])).get();

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
          .map(
            (k) => k == null
                ? null
                : KanaEntry(id: k.id, kana: k.character, romaji: k.romaji),
          )
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

  Future<List<VocabularyEntry>> getVocabForKanji(
    int kanjiId,
    String character,
  ) =>
      (select(vocabularyEntries)
            ..where(
              (v) => v.kanjiId.equals(kanjiId) | v.word.like('%$character%'),
            )
            ..orderBy([
              (v) => OrderingTerm.desc(v.jlptLevel),
              (v) => OrderingTerm.asc(v.word),
            ])
            ..limit(30))
          .get();

  Future<List<VocabularyEntry>> getVocabByLevel(String level) =>
      (select(vocabularyEntries)
            ..where((v) => v.jlptLevel.equals(level))
            ..orderBy([(v) => OrderingTerm.asc(v.word)]))
          .get();

  Future<List<VocabularyEntry>> getAllVocab() =>
      (select(vocabularyEntries)).get();

  Future<int> countTotalKanji() => (select(kanjis)).get().then((r) => r.length);

  // ── Sentence queries ─────────────────────────────────────────────────────

  Future<List<Sentence>> getSentencesForVocab(int vocabId) =>
      (select(sentences)..where((s) => s.vocabId.equals(vocabId))).get();

  Future<Map<int, List<Sentence>>> getSentencesBatch(List<int> vocabIds) async {
    if (vocabIds.isEmpty) return {};
    final rows = await (select(
      sentences,
    )..where((s) => s.vocabId.isIn(vocabIds))).get();
    final result = <int, List<Sentence>>{};
    for (final row in rows) {
      result.putIfAbsent(row.vocabId, () => []).add(row);
    }
    return result;
  }

  // sentence_translations uses ISO 639-2 (3-letter) codes; map from 639-1.
  static const _iso1To2 = {
    'en': 'eng',
    'fr': 'fra',
    'de': 'deu',
    'es': 'spa',
    'pt': 'por',
    'it': 'ita',
    'ru': 'rus',
  };

  Future<Map<int, String>> getSentenceTranslations(
    List<int> sentenceIds,
    String locale, {
    bool nativeOnly = false,
  }) async {
    if (sentenceIds.isEmpty) return {};
    final locale3 = _iso1To2[locale] ?? locale;
    final rows =
        await (select(sentenceTranslations)..where(
              (t) =>
                  t.sentenceId.isIn(sentenceIds) &
                  (nativeOnly
                      ? t.locale.equals(locale3)
                      : (t.locale.equals(locale3) | t.locale.equals('eng'))),
            ))
            .get();
    final result = <int, String>{};
    for (final row in rows) {
      if (!result.containsKey(row.sentenceId) || row.locale == locale3) {
        result[row.sentenceId] = row.translation;
      }
    }
    return result;
  }

  Future<int> countTotalVocab() =>
      (select(vocabularyEntries)).get().then((r) => r.length);

  Future<String?> getKanjiSvg(int kanjiId) =>
      (select(kanjis)..where((k) => k.id.equals(kanjiId)))
          .getSingleOrNull()
          .then((row) => row?.svg);

  // ── Grammar queries ──────────────────────────────────────────────────────

  Future<List<GrammarLessonRow>> getGrammarLessonsForLevel(
    String level, {
    String locale = 'en',
  }) async {
    final rows =
        await (select(grammarLessons)
              ..where((g) => g.level.equals(level) & g.locale.equals(locale))
              ..orderBy([(g) => OrderingTerm.asc(g.orderIndex)]))
            .get();
    if (rows.isNotEmpty || locale == 'en') return rows;
    return (select(grammarLessons)
          ..where((g) => g.level.equals(level) & g.locale.equals('en'))
          ..orderBy([(g) => OrderingTerm.asc(g.orderIndex)]))
        .get();
  }

  Future<List<GrammarExerciseRow>> getGrammarExercisesForLesson(
    String lessonPath,
  ) =>
      (select(grammarExercises)
            ..where((e) => e.lessonPath.equals(lessonPath))
            ..orderBy([(e) => OrderingTerm.asc(e.orderIndex)]))
          .get();

  Stream<Set<String>> watchStartedGrammarLessons() => select(
    grammarLessonStarts,
  ).watch().map((rows) => rows.map((r) => r.lessonPath).toSet());

  Future<void> markGrammarLessonStarted(String lessonPath) =>
      into(grammarLessonStarts).insertOnConflictUpdate(
        GrammarLessonStartsCompanion.insert(lessonPath: lessonPath),
      );

  Stream<Set<String>> watchReadGrammarLessons() => select(
    grammarLessonProgress,
  ).watch().map((rows) => rows.map((r) => r.lessonPath).toSet());

  Future<void> markGrammarLessonRead(String lessonPath) =>
      into(grammarLessonProgress).insertOnConflictUpdate(
        GrammarLessonProgressCompanion.insert(
          lessonPath: lessonPath,
          readAt: DateTime.now(),
        ),
      );

  Future<void> unmarkGrammarLessonRead(String lessonPath) => (delete(
    grammarLessonProgress,
  )..where((r) => r.lessonPath.equals(lessonPath))).go();

  Future<List<GrammarExerciseRow>> getGrammarExercisesForLessons(
    List<String> lessonPaths,
  ) =>
      (select(grammarExercises)
            ..where((e) => e.lessonPath.isIn(lessonPaths))
            ..orderBy([(e) => OrderingTerm.asc(e.orderIndex)]))
          .get();

  Future<Map<String, int>> getGrammarExerciseCountsForLessons(
    List<String> lessonPaths,
  ) async {
    if (lessonPaths.isEmpty) return {};
    final rows = await (select(
      grammarExercises,
    )..where((e) => e.lessonPath.isIn(lessonPaths))).get();
    final counts = <String, int>{};
    for (final row in rows) {
      counts[row.lessonPath] = (counts[row.lessonPath] ?? 0) + 1;
    }
    return counts;
  }

  Stream<int> watchCharactersDueCount() => (select(srsCards)).watch().map(
    (rows) => rows
        .where(
          (r) =>
              (r.itemType == 'hiragana' ||
                  r.itemType == 'katakana' ||
                  r.itemType == 'kanji') &&
              !r.due.isAfter(DateTime.now()),
        )
        .length,
  );

  Stream<int> watchKanaDueCount() => (select(srsCards)).watch().map(
    (rows) => rows
        .where(
          (r) =>
              (r.itemType == 'hiragana' || r.itemType == 'katakana') &&
              !r.due.isAfter(DateTime.now()),
        )
        .length,
  );

  Stream<int> watchKanjiDueCount() => (select(srsCards)).watch().map(
    (rows) => rows
        .where((r) => r.itemType == 'kanji' && !r.due.isAfter(DateTime.now()))
        .length,
  );

  Stream<int> watchVocabDueCount() => (select(srsCards)).watch().map(
    (rows) => rows
        .where(
          (r) => r.itemType == 'vocabulary' && !r.due.isAfter(DateTime.now()),
        )
        .length,
  );

  Stream<int> watchCharactersNewCount({required int newCardLimit}) =>
      (select(srsCards)).watch().asyncMap((_) async {
        Future<int> kanaNew(String type) async {
          final remaining = (newCardLimit - await _countSeenToday(type)).clamp(
            0,
            newCardLimit,
          );
          if (remaining == 0) return 0;
          final total = await (select(
            kanas,
          )..where((k) => k.type.equals(type))).get().then((r) => r.length);
          final seen = await (select(
            srsCards,
          )..where((s) => s.itemType.equals(type))).get().then((r) => r.length);
          return (total - seen).clamp(0, remaining);
        }

        final hiraganaNew = await kanaNew('hiragana');
        final katakanaNew = await kanaNew('katakana');

        final kanjiRemaining = (newCardLimit - await _countSeenToday('kanji'))
            .clamp(0, newCardLimit);
        int kanjiNew = 0;
        if (kanjiRemaining > 0) {
          final seenIds =
              await (select(srsCards)..where((s) => s.itemType.equals('kanji')))
                  .get()
                  .then((rows) => {for (final r in rows) r.itemId});
          final allKanji = await select(kanjis).get();
          final unseenByLevel = <String, int>{};
          for (final k in allKanji) {
            if (!seenIds.contains(k.id)) {
              unseenByLevel[k.jlptLevel] =
                  (unseenByLevel[k.jlptLevel] ?? 0) + 1;
            }
          }
          for (final level in const ['N5', 'N4', 'N3', 'N2', 'N1']) {
            final n = unseenByLevel[level] ?? 0;
            if (n > 0) {
              kanjiNew = n.clamp(0, kanjiRemaining);
              break;
            }
          }
        }

        return hiraganaNew + katakanaNew + kanjiNew;
      });

  Stream<int> watchKanaNewCount({required int newCardLimit}) =>
      (select(srsCards)).watch().asyncMap((_) async {
        final seenH = await _countSeenToday('hiragana');
        final seenK = await _countSeenToday('katakana');
        final remaining = (newCardLimit - seenH - seenK).clamp(0, newCardLimit);
        if (remaining == 0) return 0;
        Future<int> countUnseen(String type) async {
          final total = await (select(
            kanas,
          )..where((k) => k.type.equals(type))).get().then((r) => r.length);
          final seen = await (select(
            srsCards,
          )..where((s) => s.itemType.equals(type))).get().then((r) => r.length);
          return (total - seen).clamp(0, total);
        }

        final unseenH = await countUnseen('hiragana');
        final unseenK = await countUnseen('katakana');
        return min(unseenH + unseenK, remaining);
      });

  Stream<int> watchKanjiNewCount({required int newCardLimit}) =>
      (select(srsCards)).watch().asyncMap((_) async {
        final kanjiRemaining = (newCardLimit - await _countSeenToday('kanji'))
            .clamp(0, newCardLimit);
        if (kanjiRemaining == 0) return 0;
        final seenIds =
            await (select(srsCards)..where((s) => s.itemType.equals('kanji')))
                .get()
                .then((rows) => {for (final r in rows) r.itemId});
        final allKanji = await select(kanjis).get();
        final unseenByLevel = <String, int>{};
        for (final k in allKanji) {
          if (!seenIds.contains(k.id)) {
            unseenByLevel[k.jlptLevel] = (unseenByLevel[k.jlptLevel] ?? 0) + 1;
          }
        }
        for (final level in const ['N5', 'N4', 'N3', 'N2', 'N1']) {
          final n = unseenByLevel[level] ?? 0;
          if (n > 0) return n.clamp(0, kanjiRemaining);
        }
        return 0;
      });

  Stream<int> watchVocabNewCount({required int newCardLimit}) =>
      (select(srsCards)).watch().asyncMap((_) async {
        final remaining = (newCardLimit - await _countSeenToday('vocabulary'))
            .clamp(0, newCardLimit);
        if (remaining == 0) return 0;
        final total = await (select(
          vocabularyEntries,
        )).get().then((r) => r.length);
        final seen =
            await (select(srsCards)
                  ..where((s) => s.itemType.equals('vocabulary')))
                .get()
                .then((r) => r.length);
        return (total - seen).clamp(0, remaining);
      });

  Stream<int> watchStreakDays() {
    const sql =
        "SELECT json_extract(card_json, '\$.lastReview') AS lr "
        "FROM srs_cards "
        "WHERE json_extract(card_json, '\$.lastReview') IS NOT NULL "
        "GROUP BY date(json_extract(card_json, '\$.lastReview'))";
    return customSelect(sql, readsFrom: {srsCards}).watch().map((rows) {
      final reviewDates = <String>{};
      for (final row in rows) {
        final dt = DateTime.parse(row.read<String>('lr')).toLocal();
        reviewDates.add(
          '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}',
        );
      }
      int streak = 0;
      var date = DateTime.now().toLocal();
      while (true) {
        final key =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        if (!reviewDates.contains(key)) break;
        streak++;
        date = date.subtract(const Duration(days: 1));
      }
      return streak;
    });
  }

  /// All due kana (hiragana + katakana), with a shared new-card budget.
  Future<List<(Kana, Card?)>> getAllDueKanaSrsSession({
    int newCardLimit = 0,
  }) async {
    final hiragana = await getKanaByType('hiragana');
    final katakana = await getKanaByType('katakana');
    // Due cards only (no new cards yet)
    final h = await _buildSrsSession(
      'hiragana',
      hiragana,
      (k) => k.id,
      newCardLimit: 0,
    );
    final k = await _buildSrsSession(
      'katakana',
      katakana,
      (k) => k.id,
      newCardLimit: 0,
    );
    if (newCardLimit <= 0) return [...h, ...k];
    // Shared budget across both kana types
    final seenH = await _countSeenToday('hiragana');
    final seenK = await _countSeenToday('katakana');
    final remaining = (newCardLimit - seenH - seenK).clamp(0, newCardLimit);
    if (remaining == 0) return [...h, ...k];
    final hCards = await getAllSrsCardsForType('hiragana');
    final kCards = await getAllSrsCardsForType('katakana');
    final newH = hiragana
        .where((item) => hCards[item.id] == null)
        .take(remaining)
        .map((item) => (item, null as Card?))
        .toList();
    final leftover = remaining - newH.length;
    final newK = leftover > 0
        ? katakana
              .where((item) => kCards[item.id] == null)
              .take(leftover)
              .map((item) => (item, null as Card?))
              .toList()
        : <(Kana, Card?)>[];
    return [...h, ...k, ...newH, ...newK];
  }

  /// Due kanji from all levels; new cards only from the lowest JLPT level
  /// that still has unseen kanji (N5 → N4 → N3 → N2 → N1).
  Future<List<(Kanji, Card?)>> getAllDueKanjiSrsSession({
    int newCardLimit = 0,
  }) async {
    final now = DateTime.now();

    final allKanji = await select(kanjis).get();
    final allCards = await getAllSrsCardsForType('kanji');

    final due = <(Kanji, Card?)>[];
    final unseenByLevel = <String, List<Kanji>>{};

    for (final k in allKanji) {
      final card = allCards[k.id];
      if (card != null) {
        if (!card.due.isAfter(now)) due.add((k, card));
      } else {
        (unseenByLevel[k.jlptLevel] ??= []).add(k);
      }
    }

    var newOnes = <(Kanji, Card?)>[];
    if (newCardLimit > 0) {
      final remainingNew = (newCardLimit - await _countSeenToday('kanji'))
          .clamp(0, newCardLimit);
      if (remainingNew > 0) {
        for (final level in const ['N5', 'N4', 'N3', 'N2', 'N1']) {
          final pool = unseenByLevel[level];
          if (pool != null && pool.isNotEmpty) {
            newOnes = pool
                .take(remainingNew)
                .map((k) => (k, null as Card?))
                .toList();
            break;
          }
        }
      }
    }

    return [...due, ...newOnes];
  }

  /// All due vocabulary across every JLPT level: no new cards, for home screen review.
  Future<List<(VocabularyEntry, Card?)>> getAllDueVocabSrsSession({
    int newCardLimit = 0,
  }) async {
    final allVocab = await select(vocabularyEntries).get();
    return _buildSrsSession(
      'vocabulary',
      allVocab,
      (v) => v.id,
      newCardLimit: newCardLimit,
    );
  }

  Future<List<(VocabularyEntry, Card?)>> getVocabSrsSession(
    String level, {
    int newCardLimit = 10,
  }) async {
    final items = await getVocabByLevel(level);
    return _buildSrsSession(
      'vocabulary',
      items,
      (v) => v.id,
      newCardLimit: newCardLimit,
    );
  }

  // ── Kanji queries ────────────────────────────────────────────────────────

  Future<List<Kanji>> getKanjiByLevel(String level) =>
      (select(kanjis)..where((k) => k.jlptLevel.equals(level))).get();

  Future<List<Kanji>> getAllKanji() => select(kanjis).get();

  Stream<List<Kanji>> watchKanjiByLevel(String level) =>
      (select(kanjis)..where((k) => k.jlptLevel.equals(level))).watch();

  Stream<Kanji?> watchKanjiById(int id) =>
      (select(kanjis)..where((k) => k.id.equals(id))).watchSingleOrNull();

  Future<List<Kanji>> searchKanji(String query) {
    final q = '%$query%';
    return (select(kanjis)
          ..where(
            (k) =>
                k.character.like(q) |
                k.meaning.like(q) |
                k.onReading.like(q) |
                k.kunReading.like(q),
          )
          ..orderBy([
            (k) => OrderingTerm.asc(k.jlptLevel),
            (k) => OrderingTerm.asc(k.id),
          ]))
        .get();
  }

  // ── SRS queries ──────────────────────────────────────────────────────────

  Future<Map<int, Card>> getAllSrsCardsForType(String itemType) async {
    final rows = await (select(
      srsCards,
    )..where((s) => s.itemType.equals(itemType))).get();
    return {
      for (final r in rows)
        r.itemId: Card.fromMap(jsonDecode(r.cardJson) as Map<String, dynamic>),
    };
  }

  Stream<Map<int, Card>> watchAllSrsCardsForType(String itemType) =>
      (select(srsCards)..where((s) => s.itemType.equals(itemType))).watch().map(
        (rows) => {
          for (final r in rows)
            r.itemId: Card.fromMap(
              jsonDecode(r.cardJson) as Map<String, dynamic>,
            ),
        },
      );

  Future<Card?> getSrsCard(String itemType, int itemId) async {
    final row =
        await (select(srsCards)..where(
              (s) => s.itemType.equals(itemType) & s.itemId.equals(itemId),
            ))
            .getSingleOrNull();
    if (row == null) return null;
    return Card.fromMap(jsonDecode(row.cardJson) as Map<String, dynamic>);
  }

  Future<void> upsertSrsCard(
    String itemType,
    int itemId,
    Card card,
  ) => into(srsCards).insert(
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
        // firstSeenAt intentionally omitted: never overwrite the original date
      ),
      target: [srsCards.itemType, srsCards.itemId],
    ),
  );

  /// Debug only: inserts past-due SRS cards for a sample of items.
  Future<void> seedFakeReviews() async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    final hiragana =
        await (select(kanas)
              ..where((k) => k.type.equals('hiragana'))
              ..limit(5))
            .get();
    for (final k in hiragana) {
      await upsertSrsCard('hiragana', k.id, Card(cardId: k.id, due: yesterday));
    }

    final kanji =
        await (select(kanjis)
              ..where((k) => k.jlptLevel.equals('N5'))
              ..limit(5))
            .get();
    for (final k in kanji) {
      await upsertSrsCard('kanji', k.id, Card(cardId: k.id, due: yesterday));
    }

    final vocab =
        await (select(vocabularyEntries)
              ..where((v) => v.jlptLevel.equals('N5'))
              ..limit(5))
            .get();
    for (final v in vocab) {
      await upsertSrsCard(
        'vocabulary',
        v.id,
        Card(cardId: v.id, due: yesterday),
      );
    }
  }

  Future<void> resetAllProgress() async {
    await delete(srsCards).go();
    await delete(progressEntries).go();
    await delete(grammarLessonProgress).go();
    await delete(grammarLessonStarts).go();
  }

  Future<void> resetSrsCard(String type, int itemId) async {
    await (delete(
      srsCards,
    )..where((s) => s.itemType.equals(type) & s.itemId.equals(itemId))).go();
    await (delete(
      progressEntries,
    )..where((p) => p.itemType.equals(type) & p.itemId.equals(itemId))).go();
  }

  Future<List<(Kanji, Card?)>> getKanjiSrsSession(
    String level, {
    int newCardLimit = 10,
  }) async {
    final items = await (select(
      kanjis,
    )..where((k) => k.jlptLevel.equals(level))).get();
    return _buildSrsSession(
      'kanji',
      items,
      (k) => k.id,
      newCardLimit: newCardLimit,
    );
  }

  Future<List<(Kana, Card?)>> getKanaSrsSession(
    String type, {
    int newCardLimit = 10,
  }) async {
    final items = await getKanaByType(type);
    return _buildSrsSession(
      type,
      items,
      (k) => k.id,
      newCardLimit: newCardLimit,
    );
  }

  Future<int> _countSeenToday(String itemType) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return (select(srsCards)..where(
          (s) =>
              s.itemType.equals(itemType) &
              s.firstSeenAt.isBiggerOrEqualValue(todayStart),
        ))
        .get()
        .then((rows) => rows.length);
  }

  Future<List<(T, Card?)>> _buildSrsSession<T>(
    String itemType,
    List<T> items,
    int Function(T) getId, {
    required int newCardLimit,
  }) async {
    final now = DateTime.now();
    final remainingNew = (newCardLimit - await _countSeenToday(itemType)).clamp(
      0,
      newCardLimit,
    );

    final allCards = await getAllSrsCardsForType(itemType);
    final pairs = items.map((item) => (item, allCards[getId(item)])).toList();

    final due = pairs
        .where((p) => p.$2 != null && !p.$2!.due.isAfter(now))
        .toList();
    final newOnes = pairs
        .where((p) => p.$2 == null)
        .take(remainingNew)
        .toList();

    return [...due, ...newOnes];
  }
}
