part of '../app_database.dart';

Card _decodeCard(String json) =>
    Card.fromMap(jsonDecode(json) as Map<String, dynamic>);

/// Reading and writing individual SRS cards.
extension SrsCardQueries on AppDatabase {
  Future<Map<int, Card>> getAllSrsCardsForType(String itemType) async {
    final rows = await (select(
      srsCards,
    )..where((s) => s.itemType.equals(itemType))).get();
    return {for (final r in rows) r.itemId: _decodeCard(r.cardJson)};
  }

  Stream<Map<int, Card>> watchAllSrsCardsForType(String itemType) =>
      (select(srsCards)..where((s) => s.itemType.equals(itemType))).watch().map(
        (rows) => {for (final r in rows) r.itemId: _decodeCard(r.cardJson)},
      );

  /// Item type and due date for every card, without parsing the card JSON.
  /// The home screen's due counters need nothing else.
  Stream<List<({String itemType, DateTime due})>> watchSrsDueDates() {
    final query = selectOnly(srsCards)
      ..addColumns([srsCards.itemType, srsCards.due]);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          (
            itemType: row.read(srsCards.itemType)!,
            due: row.read(srsCards.due)!,
          ),
      ],
    );
  }

  /// Every card, grouped by the kind of item it belongs to.
  Stream<Map<String, List<Card>>> watchSrsCardsByType() =>
      select(srsCards).watch().map((rows) {
        final byType = <String, List<Card>>{};
        for (final r in rows) {
          (byType[r.itemType] ??= []).add(_decodeCard(r.cardJson));
        }
        return byType;
      });

  Future<int> countSrsCardsOfType(String itemType) =>
      (select(srsCards)..where((s) => s.itemType.equals(itemType))).get().then(
        (rows) => rows.length,
      );

  /// Local dates (at midnight) on which at least one card was reviewed.
  ///
  /// Derived from each card's last review, so only the most recent pass per
  /// card is visible.
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

  Future<void> resetAllProgress() async {
    await delete(srsCards).go();
    await delete(progressEntries).go();
    await delete(grammarLessonProgress).go();
    await delete(grammarLessonStarts).go();
    await delete(grammarChapterUnlocks).go();
  }

  Future<void> resetSrsCard(String type, int itemId) async {
    await (delete(
      srsCards,
    )..where((s) => s.itemType.equals(type) & s.itemId.equals(itemId))).go();
    await (delete(
      progressEntries,
    )..where((p) => p.itemType.equals(type) & p.itemId.equals(itemId))).go();
  }

  /// Cards of [itemType] first seen today, which the daily new-card budget
  /// is measured against.
  Future<int> countSeenToday(String itemType) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final count = srsCards.itemId.count();
    return (selectOnly(srsCards)
          ..addColumns([count])
          ..where(
            srsCards.itemType.equals(itemType) &
                srsCards.firstSeenAt.isBiggerOrEqualValue(todayStart),
          ))
        .map((r) => r.read(count)!)
        .getSingle();
  }
}
