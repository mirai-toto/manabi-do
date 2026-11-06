import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../core/providers/locale_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/review_log_provider.dart';
import '../../core/srs/dashboard_stats.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../providers/database_provider.dart';
import '../providers/grammar_provider.dart';
import 'study_activity.dart';

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
    await _saveColours();
    // Last, after everything above: an open widget redraws when this changes
    // (`WidgetContent` in WidgetCommon.kt), so it must see the whole snapshot.
    await _save('synced_at', now.millisecondsSinceEpoch);

    for (final String receiver in _receivers) {
      await HomeWidget.updateWidget(qualifiedAndroidName: _receiver(receiver));
    }
  }

  Future<void> _saveReviews(AppLocalizations l, DateTime now) async {
    final List<DateTime> dues = await loadDueDates(_ref);
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
  Future<void> _saveActivity(AppLocalizations l, DateTime now) async {
    final String oldest = reviewDayKey(
      DateTime(now.year, now.month, now.day - _activityDays),
    );
    final Map<String, int> activity = await loadActivity(_ref)
      ..removeWhere((day, _) => day.compareTo(oldest) <= 0);

    await _save('activity', jsonEncode(activity));
    await _save('streak_label', l.streakLabel);
    await _save('streak_range', l.widgetActivityRange);
    await _save('streak_less', l.widgetLess);
    await _save('streak_more', l.widgetMore);
    await HomeWidget.scheduleWidgetUpdates([
      DateTime(now.year, now.month, now.day + 1),
    ], qualifiedAndroidName: _receiver('StreakWidgetReceiver'));
  }

  /// The theme's colours, light and dark, so the widgets follow the colour
  /// theme picked in the app. Read by `WidgetColors.from` on the Kotlin side.
  Future<void> _saveColours() async {
    final AppPalette palette = _ref.read(paletteProvider);
    Map<String, Object> side(AppTokens t, {required bool dark}) => {
      // The widget card sits on the wallpaper, so in dark mode it takes the
      // container step: plain `surface` is near black and loses its edge.
      'surface': (dark ? t.surfaceContainer : t.surface).toARGB32(),
      'onSurface': t.onSurface.toARGB32(),
      'muted': t.onSurfaceVariant.toARGB32(),
      'primary': t.primary.toARGB32(),
      'onPrimary': t.onPrimary.toARGB32(),
      'primaryContainer': t.primaryContainer.toARGB32(),
      'onPrimaryContainer': t.onPrimaryContainer.toARGB32(),
      'track': t.surfaceVariant.toARGB32(),
      // The streak heatmap, empty to busiest: the level ramp read from its
      // faint end, as on the vocabulary screen.
      'heat': [
        t.surfaceContainerHigh,
        if (dark) ...[t.levelRamp[4], t.levelRamp[2], t.levelRamp[0]],
        if (!dark) ...[t.levelRamp[4], t.levelRamp[3], t.levelRamp[1]],
      ].map((c) => c.toARGB32()).toList(),
    };
    await _save(
      'theme_colours',
      jsonEncode({
        'day': side(palette.light, dark: false),
        'night': side(palette.dark, dark: true),
      }),
    );
  }

  Future<void> _save<T>(String key, T value) =>
      HomeWidget.saveWidgetData<T>(key, value);
}

final homeWidgetServiceProvider = Provider<HomeWidgetService>(
  (ref) => HomeWidgetService(ref),
);
