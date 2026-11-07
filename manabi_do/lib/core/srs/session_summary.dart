import 'package:fsrs/fsrs.dart' show Rating;

/// The end-of-session numbers, as plain functions over what the session
/// already holds. Nothing here touches the database or the clock unless asked.

/// How many answers got each grade, every grade present even at zero.
Map<Rating, int> gradeCounts(Iterable<Rating> ratings) {
  final Map<Rating, int> counts = {for (final r in Rating.values) r: 0};
  for (final r in ratings) {
    counts[r] = counts[r]! + 1;
  }
  return counts;
}

/// Whether an answer belongs in the summary's "look again" list.
///
/// With four grades, Hard counts too: the user said it was a struggle. With
/// two, only a miss does, since Hard is never offered.
bool needsAnotherLook(Rating rating, {required bool fourPointGrading}) =>
    rating == Rating.again || (fourPointGrading && rating == Rating.hard);

/// When the session's cards come back, in the three spans the summary shows,
/// plus the first of them.
typedef ComingBack = ({
  int laterToday,
  int tomorrow,
  int later,
  DateTime? next,
});

/// Buckets [dues] by local calendar day relative to [now].
ComingBack comingBack(Iterable<DateTime> dues, {required DateTime now}) {
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime tomorrow = DateTime(today.year, today.month, today.day + 1);
  final DateTime dayAfter = DateTime(today.year, today.month, today.day + 2);
  var laterToday = 0;
  var onTomorrow = 0;
  var later = 0;
  DateTime? next;
  for (final DateTime utc in dues) {
    final DateTime due = utc.toLocal();
    if (due.isBefore(tomorrow)) {
      laterToday++;
    } else if (due.isBefore(dayAfter)) {
      onTomorrow++;
    } else {
      later++;
    }
    if (next == null || due.isBefore(next)) next = due;
  }
  return (
    laterToday: laterToday,
    tomorrow: onTomorrow,
    later: later,
    next: next,
  );
}
