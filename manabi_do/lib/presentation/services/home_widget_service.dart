import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../core/providers/home_settings_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/review_log_provider.dart';
import '../../core/srs/dashboard_stats.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../providers/database_provider.dart';
import '../providers/grammar_provider.dart';

/// Package the widget receivers live in. `home_widget` resolves a bare
/// `androidName` against the application id, which misses this subpackage, so
/// every call passes the qualified name instead.
const String _receiverPackage = 'com.github.mirai_toto.manabi_do.widgets';

String _receiver(String name) => '$_receiverPackage.$name';

/// Android receivers the snapshot is pushed to, by class name. Each one is
/// declared in `android/app/src/main/AndroidManifest.xml`.
const List<String> _receivers = [
  'ReviewsWidgetReceiver',
  'KanjiWidgetReceiver',
  'GrammarWidgetReceiver',
  'StreakWidgetReceiver',
];

/// Upcoming due times handed to the reviews widget. Enough for a day of
/// reviews; anything later is picked up the next time the app runs.
const int _upcomingLimit = 500;

/// Days of kanji picked ahead, so the widget turns over at midnight without
/// the app running.
const int _kanjiDaysAhead = 7;

/// Days of activity the streak widget draws: 20 weeks.
const int _activityDays = 140;

/// Whether this platform has home-screen widgets the app provides.
bool get homeWidgetsSupported => !kIsWeb && Platform.isAndroid;

/// Today's kanji out of [ids], turning over once a day.
///
/// [ids] must be sorted, so the same day always lands on the same kanji.
int pickDailyKanji(List<int> ids, DateTime day) {
  final int epochDay = DateTime.utc(
    day.year,
    day.month,
    day.day,
  ).difference(DateTime.utc(1970)).inDays;
  return ids[epochDay % ids.length];
}

/// Writes what the home-screen widgets show.
///
/// The widgets cannot reach the database, so the app leaves them a snapshot
/// that stays right while it is closed: due times rather than a due count,
/// and a week of kanji rather than today's.
class HomeWidgetService {
  final Ref _ref;

  const HomeWidgetService(this._ref);

  AppDatabase get _db => _ref.read(databaseProvider);

  Future<void> sync() async {
    if (!homeWidgetsSupported) return;
    final AppLocalizations l = lookupAppLocalizations(
      _ref.read(localeProvider),
    );
    final DateTime now = DateTime.now();

    await _saveReviews(l, now);
    await _saveKanji(l, now);
    await _saveGrammar(l);
    await _saveActivity(l, now);

    for (final String receiver in _receivers) {
      await HomeWidget.updateWidget(qualifiedAndroidName: _receiver(receiver));
    }
  }

  Future<void> _saveReviews(AppLocalizations l, DateTime now) async {
    final settings = _ref.read(homeSettingsProvider);
    final Set<String> types = {
      if (settings.showKana) ...{'hiragana', 'katakana'},
      if (settings.showKanji) 'kanji',
      if (settings.showVocabulary) 'vocabulary',
    };
    final List<DateTime> dues = [
      for (final row in await _db.watchSrsDueDates().first)
        if (types.contains(row.itemType)) row.due,
    ];
    final List<int> upcoming =
        (dues.where((due) => due.isAfter(now)).toList()..sort())
            .take(_upcomingLimit)
            .map((due) => due.millisecondsSinceEpoch)
            .toList();

    await _save('reviews_due_base', countDue(dues, now: now));
    await _save('reviews_upcoming', jsonEncode(upcoming));
    await _save('reviews_unit_zero', l.reviewsDueUnit(0));
    await _save('reviews_unit_one', l.reviewsDueUnit(1));
    await _save('reviews_unit_other', l.reviewsDueUnit(2));
    await _save('reviews_next', l.widgetNextReview('{time}'));
    await _save('reviews_button', l.startReviews);
    await _save('reviews_caught_up', l.allCaughtUp);

    // The widget recounts on each update, so wake it as cards come due.
    final List<DateTime> wakeAt = {
      for (final millis in upcoming.take(24))
        DateTime.fromMillisecondsSinceEpoch(millis),
    }.toList();
    await HomeWidget.scheduleWidgetUpdates(
      wakeAt,
      qualifiedAndroidName: _receiver('ReviewsWidgetReceiver'),
    );
  }

  /// Rotates through the kanji being learned, or N5 before any are.
  Future<void> _saveKanji(AppLocalizations l, DateTime now) async {
    final List<Kanji> pool;
    final Set<int> learning = (await _db.getAllSrsCardsForType(
      'kanji',
    )).keys.toSet();
    if (learning.isEmpty) {
      pool = await _db.getKanjiByLevel('N5');
    } else {
      pool = [
        for (final kanji in await _db.getAllKanji())
          if (learning.contains(kanji.id)) kanji,
      ];
    }
    if (pool.isEmpty) return;

    final Map<int, Kanji> byId = {for (final kanji in pool) kanji.id: kanji};
    final List<int> ids = byId.keys.toList()..sort();
    final List<DateTime> days = [
      for (var i = 0; i < _kanjiDaysAhead; i++)
        DateTime(now.year, now.month, now.day + i),
    ];
    final List<Kanji> picks = [
      for (final day in days) byId[pickDailyKanji(ids, day)]!,
    ];
    final Map<int, String> meanings = await _db.getKanjiTranslations(
      picks.map((kanji) => kanji.id).toList(),
      _ref.read(localeProvider).languageCode,
    );

    await _save(
      'kanji_days',
      jsonEncode([
        for (var i = 0; i < days.length; i++)
          {
            'day': reviewDayKey(days[i]),
            'id': picks[i].id,
            'character': picks[i].character,
            'meaning': meanings[picks[i].id] ?? picks[i].meaning,
            'on': picks[i].onReading,
            'kun': picks[i].kunReading,
            'level': picks[i].jlptLevel,
          },
      ]),
    );
    await _save('kanji_title', l.widgetKanjiOfTheDay);
    await _save('kanji_on', l.onyomi);
    await _save('kanji_kun', l.kunyomi);
    await HomeWidget.scheduleWidgetUpdates(
      days.skip(1).toList(),
      qualifiedAndroidName: _receiver('KanjiWidgetReceiver'),
    );
  }

  Future<void> _saveGrammar(AppLocalizations l) async {
    final target = await _ref.read(grammarContinueProvider.future);
    await _save('grammar_heading', l.keepLearning);
    await _save('grammar_button', l.widgetResume);
    await _save('grammar_done', l.widgetAllLessonsRead);
    await _save('grammar_title', target?.lesson.title ?? '');
    await _save('grammar_level', target?.level ?? '');
    await _save(
      'grammar_progress',
      target == null
          ? ''
          : l.lessonOfTotal(target.lessonIndex + 1, target.chapterLessonCount),
    );
    await _save('grammar_index', target?.lessonIndex ?? 0);
    await _save('grammar_total', target?.chapterLessonCount ?? 0);
  }

  /// Reviews per day for the heatmap and streak.
  ///
  /// The review log only starts counting from this release, so days the
  /// cards remember a review on but the log does not are kept as one review:
  /// the streak stays what the home screen shows.
  Future<void> _saveActivity(AppLocalizations l, DateTime now) async {
    final Map<String, int> log = _ref.read(reviewLogProvider);
    final Set<DateTime> reviewed = await _db.watchReviewDates().first;
    final String oldest = reviewDayKey(
      DateTime(now.year, now.month, now.day - _activityDays),
    );
    final Map<String, int> activity = {
      for (final day in reviewed) reviewDayKey(day): 1,
      ...log,
    }..removeWhere((day, _) => day.compareTo(oldest) <= 0);

    await _save('activity', jsonEncode(activity));
    await _save('streak_label', l.streakLabel);
    await _save('streak_range', l.widgetActivityRange);
    await _save('streak_less', l.widgetLess);
    await _save('streak_more', l.widgetMore);
    await HomeWidget.scheduleWidgetUpdates([
      DateTime(now.year, now.month, now.day + 1),
    ], qualifiedAndroidName: _receiver('StreakWidgetReceiver'));
  }

  Future<void> _save<T>(String key, T value) =>
      HomeWidget.saveWidgetData<T>(key, value);
}

final homeWidgetServiceProvider = Provider<HomeWidgetService>(
  (ref) => HomeWidgetService(ref),
);

/// Keeps the widgets in step with the app while it runs: after reviews,
/// lessons, a language or deck change, and whenever the app comes back.
///
/// Changes arrive in bursts (one card per answer), so a sync waits for a
/// quiet moment rather than running on every one.
final homeWidgetSyncProvider = Provider<void>((ref) {
  if (!homeWidgetsSupported) return;

  Timer? pending;
  void schedule() {
    pending?.cancel();
    pending = Timer(const Duration(seconds: 2), () {
      ref.read(homeWidgetServiceProvider).sync();
    });
  }

  final StreamSubscription<void> cards = ref
      .read(databaseProvider)
      .watchSrsDueDates()
      .listen((_) => schedule());
  ref.listen(reviewLogProvider, (_, _) => schedule());
  ref.listen(localeProvider, (_, _) => schedule());
  ref.listen(homeSettingsProvider, (_, _) => schedule());
  ref.listen(grammarContinueProvider, (_, _) => schedule());
  final AppLifecycleListener lifecycle = AppLifecycleListener(
    onResume: schedule,
  );

  ref.onDispose(() {
    pending?.cancel();
    cards.cancel();
    lifecycle.dispose();
  });
});
