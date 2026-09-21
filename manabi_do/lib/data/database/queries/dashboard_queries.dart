part of '../app_database.dart';

/// Counters and streaks powering the home screen.
extension DashboardQueries on AppDatabase {
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

  Stream<int> watchVocabularyDueCount() => (select(srsCards)).watch().map(
    (rows) => rows
        .where(
          (r) => r.itemType == 'vocabulary' && !r.due.isAfter(DateTime.now()),
        )
        .length,
  );

  /// Known cards (stability holds a week or more) vs cards seen at all.
  ({int known, int seen}) _progressCounts(Iterable<SrsCard> rows) {
    var known = 0;
    var seen = 0;
    for (final r in rows) {
      seen++;
      final card = Card.fromMap(jsonDecode(r.cardJson) as Map<String, dynamic>);
      if (isSrsKnown(card)) known++;
    }
    return (known: known, seen: seen);
  }

  Stream<({int known, int seen})> watchKanaProgress() =>
      (select(srsCards)).watch().map(
        (rows) => _progressCounts(
          rows.where(
            (r) => r.itemType == 'hiragana' || r.itemType == 'katakana',
          ),
        ),
      );

  Stream<({int known, int seen})> watchKanjiProgress() => (select(srsCards))
      .watch()
      .map((rows) => _progressCounts(rows.where((r) => r.itemType == 'kanji')));

  Stream<({int known, int seen})> watchVocabularyProgress() =>
      (select(srsCards)).watch().map(
        (rows) =>
            _progressCounts(rows.where((r) => r.itemType == 'vocabulary')),
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

  Stream<int> watchVocabularyNewCount({required int newCardLimit}) =>
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

  /// Local dates (at midnight) on which at least one card was reviewed.
  /// Derived from each card's last review, so only the most recent pass per
  /// card is visible — same source as [watchStreakDays].
  Stream<Set<DateTime>> watchReviewDates() {
    const sql =
        "SELECT json_extract(card_json, '\$.lastReview') AS lr "
        "FROM srs_cards "
        "WHERE json_extract(card_json, '\$.lastReview') IS NOT NULL "
        "GROUP BY date(json_extract(card_json, '\$.lastReview'))";
    return customSelect(sql, readsFrom: {srsCards}).watch().map((rows) {
      final dates = <DateTime>{};
      for (final row in rows) {
        final dt = DateTime.parse(row.read<String>('lr')).toLocal();
        dates.add(DateTime(dt.year, dt.month, dt.day));
      }
      return dates;
    });
  }
}
