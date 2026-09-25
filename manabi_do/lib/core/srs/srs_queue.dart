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
  final pairs = items.map((item) => (item, cards[idOf(item)])).toList();

  final due = pairs
      .where((pair) => pair.$2 != null && !pair.$2!.due.isAfter(at))
      .toList();
  final fresh = pairs
      .where((pair) => pair.$2 == null)
      .take(remainingNew)
      .toList();

  return [...due, ...fresh];
}

/// The first level in [kNewCardLevelOrder] that still has unseen items, and how
/// many of them the budget allows. Zero when every level is exhausted.
int newCardsFromEasiestLevel(
  Map<String, int> unseenByLevel, {
  required int remainingNew,
}) {
  if (remainingNew <= 0) return 0;
  for (final level in kNewCardLevelOrder) {
    final unseen = unseenByLevel[level] ?? 0;
    if (unseen > 0) return unseen.clamp(0, remainingNew);
  }
  return 0;
}
