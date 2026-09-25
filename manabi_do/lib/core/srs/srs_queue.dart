import 'package:fsrs/fsrs.dart' show Card;

/// The order new cards are introduced in: easiest level first, and nothing from
/// a harder level until the easier ones run out of unseen items.
const List<String> kNewCardLevelOrder = ['N5', 'N4', 'N3', 'N2', 'N1'];

/// How many new cards today's budget still allows.
///
/// The daily limit counts cards *first seen* today, so a session opened twice
/// in one day does not hand out the budget twice.
int remainingNewCards({required int dailyLimit, required int seenToday}) =>
    (dailyLimit - seenToday).clamp(0, dailyLimit);

/// The first [limit] items that have no SRS card yet, each paired with a null
/// card so they slot straight into a queue.
///
/// Order follows [items], so whatever order the database returned is the order
/// they are introduced in.
List<(T, Card?)> unseenItems<T>({
  required List<T> items,
  required Map<int, Card> cards,
  required int Function(T) idOf,
  required int limit,
}) {
  if (limit <= 0) return [];
  return items
      .where((item) => cards[idOf(item)] == null)
      .take(limit)
      .map((item) => (item, null as Card?))
      .toList();
}

/// A review queue: everything due now, then unseen items up to [remainingNew].
///
/// Items with a card that is not yet due are left out entirely — this is a
/// review queue, not a browse list.
List<(T, Card?)> buildSrsQueue<T>({
  required List<T> items,
  required Map<int, Card> cards,
  required int Function(T) idOf,
  required int remainingNew,
  DateTime? now,
}) {
  final at = now ?? DateTime.now();
  final due = items
      .map((item) => (item, cards[idOf(item)]))
      .where((pair) => pair.$2 != null && !pair.$2!.due.isAfter(at))
      .toList();

  return [
    ...due,
    ...unseenItems(items: items, cards: cards, idOf: idOf, limit: remainingNew),
  ];
}

/// The unseen items of the easiest level that still has any, capped at
/// [remainingNew]. Empty once every level is exhausted.
///
/// New cards come from one level at a time, so a learner with N5 left to finish
/// is never handed N1 items. The budget is deliberately not topped up from the
/// next level when the easiest one runs short.
List<T> newCardsFromEasiestLevel<T>(
  Map<String, List<T>> unseenByLevel, {
  required int remainingNew,
}) {
  if (remainingNew <= 0) return [];
  for (final level in kNewCardLevelOrder) {
    final pool = unseenByLevel[level];
    if (pool != null && pool.isNotEmpty) {
      return pool.take(remainingNew).toList();
    }
  }
  return [];
}
