part of '../app_database.dart';

/// Building a review queue for a practice session.
extension SrsSessionQueries on AppDatabase {
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
  Future<List<(VocabularyEntry, Card?)>> getAllDueVocabularySrsSession({
    int newCardLimit = 0,
  }) async {
    final allVocabulary = await select(vocabularyEntries).get();
    return _buildSrsSession(
      'vocabulary',
      allVocabulary,
      (v) => v.id,
      newCardLimit: newCardLimit,
    );
  }

  Future<List<(VocabularyEntry, Card?)>> getVocabularySrsSession(
    String level, {
    int newCardLimit = 10,
  }) async {
    final items = await getVocabularyByLevel(level);
    return _buildSrsSession(
      'vocabulary',
      items,
      (v) => v.id,
      newCardLimit: newCardLimit,
    );
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
