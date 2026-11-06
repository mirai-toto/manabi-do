import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../core/providers/locale_provider.dart';
import '../../core/providers/reminder_settings_provider.dart';
import '../../core/providers/review_log_provider.dart';
import '../../core/srs/dashboard_stats.dart';
import '../../l10n/app_localizations.dart';
import 'study_activity.dart';

/// Whether this platform gets the daily reminder. Android only until the iOS
/// build exists.
bool get remindersSupported => !kIsWeb && Platform.isAndroid;

/// Where a tapped reminder opens, routed like a home-screen widget tap.
const String reminderLink = 'manabido://review';

/// Days of reminders scheduled ahead, so they keep coming for a while when the
/// app is not opened. Each later sync replaces them.
const int _daysAhead = 7;

/// Notification ids, one per scheduled day.
const int _firstId = 100;

const String _channelId = 'reminders';

const MethodChannel _systemSettings = MethodChannel(
  'manabido/notification_settings',
);

/// Schedules the daily study reminder.
///
/// Notifications are local: the app has no server, and the phone already
/// knows everything a reminder says. Like the widgets, each sync works from
/// the cards' due times, so a reminder scheduled days ahead still carries the
/// right count. A day is skipped when nothing would be due and no streak is at
/// stake, and today is skipped once the user has studied.
class ReminderService {
  final Ref _ref;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  Future<void>? _ready;

  ReminderService(this._ref);

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  /// Sets up the plugin and the local time zone, once. [onOpen] receives the
  /// link of a reminder tapped while the app runs.
  Future<void> initialize({required void Function(Uri) onOpen}) =>
      _ready ??= _initialize(onOpen);

  Future<void> _initialize(void Function(Uri) onOpen) async {
    tz_data.initializeTimeZones();
    final TimezoneInfo zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
      ),
      onDidReceiveNotificationResponse: (response) {
        final Uri? link = Uri.tryParse(response.payload ?? '');
        if (link != null) onOpen(link);
      },
    );
  }

  /// The link of the reminder that launched the app, if one did.
  Future<Uri?> launchLink() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) return null;
    return Uri.tryParse(details.notificationResponse?.payload ?? '');
  }

  /// Asks for notification permission (Android 13 and later). True when the
  /// app may notify, including on versions that never ask.
  Future<bool> requestPermission() async =>
      await _android?.requestNotificationsPermission() ?? false;

  Future<bool> permissionGranted() async =>
      await _android?.areNotificationsEnabled() ?? false;

  /// Turns the reminder on, asking for permission first. False when the user
  /// refused, or refused before and Android no longer asks: the reminder then
  /// stays off.
  Future<bool> enable() async {
    final bool granted = await requestPermission();
    _ref.invalidate(reminderPermissionProvider);
    if (granted) {
      await _ref.read(reminderSettingsProvider.notifier).setEnabled(true);
    }
    return granted;
  }

  /// This app's page in the system notification settings, for a user who
  /// blocked notifications earlier.
  Future<void> openSystemSettings() => _systemSettings.invokeMethod('open');

  Future<void> sync() async {
    if (_ready == null) return;
    await _ready;
    for (var i = 0; i < _daysAhead; i++) {
      await _plugin.cancel(id: _firstId + i);
    }

    final ReminderSettings settings = _ref.read(reminderSettingsProvider);
    if (!settings.enabled || !await permissionGranted()) return;

    final AppLocalizations l = lookupAppLocalizations(
      _ref.read(localeProvider),
    );
    final DateTime now = DateTime.now();
    final List<DateTime> dues = await loadDueDates(_ref);
    final Map<String, int> activity = await loadActivity(_ref);
    final bool studiedToday = (activity[reviewDayKey(now)] ?? 0) > 0;

    for (var i = 0; i < _daysAhead; i++) {
      final DateTime at = DateTime(
        now.year,
        now.month,
        now.day + i,
        settings.hour,
        settings.minute,
      );
      if (!at.isAfter(now) || (i == 0 && studiedToday)) continue;

      final int due = countDue(dues, now: at);
      // The streak that ends unless the user studies on that day: yesterday's
      // for today, today's for tomorrow. Any later day it is already gone.
      final int streak = i > 1
          ? 0
          : streakEndingOn(activity, DateTime(at.year, at.month, at.day - 1));
      if (due == 0 && streak == 0) continue;

      await _plugin.zonedSchedule(
        id: _firstId + i,
        scheduledDate: tz.TZDateTime.from(at, tz.local),
        title: due > 0
            ? l.reminderDueTitle(due)
            : l.reminderStreakTitle(streak),
        body: due == 0
            ? l.reminderStreakOnlyBody
            : streak > 0
            ? l.reminderStreakBody(streak)
            : l.reminderDueBody,
        payload: reminderLink,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            l.reminderChannelName,
            channelDescription: l.reminderChannelDescription,
          ),
        ),
        // A few minutes late is fine for a reminder, and exact alarms need a
        // permission the store reviews.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }
}

final reminderServiceProvider = Provider<ReminderService>(
  (ref) => ReminderService(ref),
);

/// Whether the app may post notifications right now. Re-read when the app
/// comes back, since the user can change it in system settings meanwhile.
final reminderPermissionProvider = FutureProvider.autoDispose<bool>((ref) {
  final AppLifecycleListener lifecycle = AppLifecycleListener(
    onResume: ref.invalidateSelf,
  );
  ref.onDispose(lifecycle.dispose);
  return ref.read(reminderServiceProvider).permissionGranted();
});
