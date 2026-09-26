part of '../app_database.dart';

/// Reading and writing individual SRS cards.
extension SrsCardQueries on AppDatabase {
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
          (byType[r.itemType] ??= []).add(
            Card.fromMap(jsonDecode(r.cardJson) as Map<String, dynamic>),
          );
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

    final vocabulary =
        await (select(vocabularyEntries)
              ..where((v) => v.jlptLevel.equals('N5'))
              ..limit(5))
            .get();
    for (final v in vocabulary) {
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
}
