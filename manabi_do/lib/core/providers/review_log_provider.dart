import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_provider.dart';

const _keyReviewLog = 'review_log_daily';

/// How many days of counts are kept. The streak widget shows 20 weeks, so a
/// year leaves room without the map growing forever.
const _keepDays = 366;

/// Local date as `yyyy-mm-dd`, the key [ReviewLogNotifier] counts under.
String reviewDayKey(DateTime at) {
  final String month = at.month.toString().padLeft(2, '0');
  final String day = at.day.toString().padLeft(2, '0');
  return '${at.year}-$month-$day';
}

/// Reviews answered per local day.
///
/// Kept in preferences rather than the database: card rows only remember
/// their latest review, so they cannot answer "how much on that day", and a
/// new table would need a matching content database release. Preferences
/// also survive content refreshes untouched.
class ReviewLogNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return readJsonSetting<Map<String, int>>(
      prefs,
      _keyReviewLog,
      (json) => json.map((key, value) => MapEntry(key, value as int)),
      const {},
    );
  }

  Future<void> record({DateTime? at}) async {
    final DateTime now = at ?? DateTime.now();
    final String today = reviewDayKey(now);
    final String oldest = reviewDayKey(
      DateTime(now.year, now.month, now.day - _keepDays),
    );
    final Map<String, int> next = {
      for (final entry in state.entries)
        if (entry.key.compareTo(oldest) > 0) entry.key: entry.value,
    };
    next[today] = (next[today] ?? 0) + 1;
    await writeJsonSetting(
      ref.read(sharedPreferencesProvider),
      _keyReviewLog,
      next,
    );
    state = next;
  }

  Future<void> clear() async {
    await ref.read(sharedPreferencesProvider).remove(_keyReviewLog);
    state = const {};
  }
}

final reviewLogProvider = NotifierProvider<ReviewLogNotifier, Map<String, int>>(
  ReviewLogNotifier.new,
);
