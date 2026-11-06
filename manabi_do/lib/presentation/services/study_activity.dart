import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/home_settings_provider.dart';
import '../../core/providers/review_log_provider.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';

/// What the home-screen widgets and the daily reminder both work from, read
/// once per sync. Neither can reach the database while the app is closed, so
/// they are handed due times and per-day counts rather than live queries.

/// Due times of the cards in the decks the home screen shows.
Future<List<DateTime>> loadDueDates(Ref ref) async {
  final settings = ref.read(homeSettingsProvider);
  final Set<String> types = {
    if (settings.showKana) ...{'hiragana', 'katakana'},
    if (settings.showKanji) 'kanji',
    if (settings.showVocabulary) 'vocabulary',
  };
  return [
    for (final row in await ref.read(databaseProvider).watchSrsDueDates().first)
      if (types.contains(row.itemType)) row.due,
  ];
}

/// Reviews per day, keyed by [reviewDayKey].
///
/// The review log only starts counting from the release that added it, so
/// days the cards remember a review on but the log does not are kept as one
/// review: the streak stays what the home screen shows.
Future<Map<String, int>> loadActivity(Ref ref) async {
  final Set<DateTime> reviewed = await ref
      .read(databaseProvider)
      .watchReviewDates()
      .first;
  return {
    for (final day in reviewed) reviewDayKey(day): 1,
    ...ref.read(reviewLogProvider),
  };
}

/// Consecutive days with reviews in [activity], ending on [day].
int streakEndingOn(Map<String, int> activity, DateTime day) {
  var at = DateTime(day.year, day.month, day.day);
  var count = 0;
  while ((activity[reviewDayKey(at)] ?? 0) > 0) {
    count++;
    at = DateTime(at.year, at.month, at.day - 1);
  }
  return count;
}
