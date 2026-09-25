import 'package:fsrs/fsrs.dart' show Card;

import 'srs_level.dart';

/// The counters behind the home screen, as plain functions over already-loaded
/// data. Nothing here touches the database or the clock unless asked to.

/// How many of [dueDates] have come round at [now].
int countDue(Iterable<DateTime> dueDates, {DateTime? now}) {
  final at = now ?? DateTime.now();
  return dueDates.where((due) => !due.isAfter(at)).length;
}

/// Known cards (stability holds a week or more) against cards seen at all.
({int known, int seen}) progressCounts(Iterable<Card> cards) {
  var known = 0;
  var seen = 0;
  for (final card in cards) {
    seen++;
    if (isSrsKnown(card)) known++;
  }
  return (known: known, seen: seen);
}

/// How many unseen items today's budget still allows, never more than are
/// actually left to learn.
int newCardsAvailable({
  required int total,
  required int seen,
  required int remainingNew,
}) => (total - seen).clamp(0, remainingNew);

/// Consecutive days ending today on which at least one card was reviewed.
///
/// A gap yesterday ends the streak, even when the day before it has reviews.
/// [reviewDates] must be local dates at midnight, as [weekActivityFlags] also
/// expects.
int countStreak(Set<DateTime> reviewDates, {DateTime? today}) {
  final now = today ?? DateTime.now();
  var day = DateTime(now.year, now.month, now.day);
  var streak = 0;
  while (reviewDates.contains(day)) {
    streak++;
    day = DateTime(day.year, day.month, day.day - 1);
  }
  return streak;
}

/// Which days of the current week had reviews: seven entries, Monday first.
List<bool> weekActivityFlags(Set<DateTime> reviewDates, {DateTime? now}) {
  final at = now ?? DateTime.now();
  final monday = DateTime(at.year, at.month, at.day - (at.weekday - 1));
  return List.generate(
    7,
    (i) => reviewDates.contains(
      DateTime(monday.year, monday.month, monday.day + i),
    ),
  );
}
