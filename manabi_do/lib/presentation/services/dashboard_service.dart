import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/srs/dashboard_stats.dart';
import '../../core/srs/srs_queue.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';

/// Kana share one budget and one set of counters, as they do in a session.
const Set<String> _kanaTypes = {'hiragana', 'katakana'};

/// The home screen's counters.
///
/// What counts as due, what counts as known, and how many new items today
/// still allows are teaching decisions, so they live here. The database only
/// supplies due dates, cards and totals.
class DashboardService {
  final AppDatabase _db;

  const DashboardService(this._db);

  Stream<int> kanaDueCount() => _dueCount(_kanaTypes);

  Stream<int> kanjiDueCount() => _dueCount(const {'kanji'});

  Stream<int> vocabularyDueCount() => _dueCount(const {'vocabulary'});

  Stream<({int known, int seen})> kanaProgress() => _progress(_kanaTypes);

  Stream<({int known, int seen})> kanjiProgress() => _progress(const {'kanji'});

  Stream<({int known, int seen})> vocabularyProgress() =>
      _progress(const {'vocabulary'});

  /// Hiragana and katakana draw on one budget, so finishing hiragana does not
  /// hand out a second allowance of katakana the same day.
  Stream<int> kanaNewCount({required int newCardLimit}) => _newCount(
    (remaining) async {
      final total =
          await _db.countKanaOfType('hiragana') +
          await _db.countKanaOfType('katakana');
      final seen =
          await _db.countSrsCardsOfType('hiragana') +
          await _db.countSrsCardsOfType('katakana');
      return newCardsAvailable(
        total: total,
        seen: seen,
        remainingNew: remaining,
      );
    },
    newCardLimit: newCardLimit,
    itemTypes: _kanaTypes,
  );

  /// New kanji come from the easiest level that still has unseen ones, the
  /// same rule a session follows.
  Stream<int> kanjiNewCount({required int newCardLimit}) => _newCount(
    (remaining) async => newCardsFromEasiestLevel(
      await _db.unseenKanjiByLevel(),
      remainingNew: remaining,
    ).length,
    newCardLimit: newCardLimit,
    itemTypes: const {'kanji'},
  );

  Stream<int> vocabularyNewCount({required int newCardLimit}) => _newCount(
    (remaining) async => newCardsAvailable(
      total: await _db.countVocabularyEntries(),
      seen: await _db.countSrsCardsOfType('vocabulary'),
      remainingNew: remaining,
    ),
    newCardLimit: newCardLimit,
    itemTypes: const {'vocabulary'},
  );

  Stream<int> streakDays() =>
      _db.watchReviewDates().map((dates) => countStreak(dates));

  Stream<List<bool>> weekActivity() =>
      _db.watchReviewDates().map((dates) => weekActivityFlags(dates));

  Stream<int> _dueCount(Set<String> itemTypes) => _db.watchSrsDueDates().map(
    (rows) => countDue(
      rows.where((row) => itemTypes.contains(row.itemType)).map((r) => r.due),
    ),
  );

  Stream<({int known, int seen})> _progress(Set<String> itemTypes) =>
      _db.watchSrsCardsByType().map(
        (byType) => progressCounts(
          itemTypes.expand((type) => byType[type] ?? const []),
        ),
      );

  /// Recounts whenever a card changes, and only asks the database for totals
  /// once today's budget is known to have something left in it.
  Stream<int> _newCount(
    Future<int> Function(int remaining) count, {
    required int newCardLimit,
    required Set<String> itemTypes,
  }) => _db.watchSrsDueDates().asyncMap((_) async {
    var seenToday = 0;
    for (final type in itemTypes) {
      seenToday += await _db.countSeenToday(type);
    }
    final remaining = remainingNewCards(
      dailyLimit: newCardLimit,
      seenToday: seenToday,
    );
    return remaining == 0 ? 0 : count(remaining);
  });
}

final dashboardServiceProvider = Provider(
  (ref) => DashboardService(ref.read(databaseProvider)),
);
