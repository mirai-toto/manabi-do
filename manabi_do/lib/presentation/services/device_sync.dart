import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/home_settings_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/reminder_settings_provider.dart';
import '../../core/providers/review_log_provider.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';
import '../providers/grammar_provider.dart';
import 'home_widget_service.dart';
import 'reminder_service.dart';

/// Keeps what the system shows outside the app, the home-screen widgets and
/// the daily reminder, in step with the app while it runs: after reviews,
/// lessons, a language, deck or reminder change, and whenever the app comes
/// back.
///
/// Changes arrive in bursts (one card per answer), so a sync waits for a
/// quiet moment rather than running on every one.
final deviceSyncProvider = Provider<void>((ref) {
  if (!homeWidgetsSupported && !remindersSupported) return;

  Timer? pending;
  void schedule() {
    pending?.cancel();
    pending = Timer(const Duration(seconds: 2), () {
      if (homeWidgetsSupported) ref.read(homeWidgetServiceProvider).sync();
      if (remindersSupported) ref.read(reminderServiceProvider).sync();
    });
  }

  final StreamSubscription<void> cards = ref
      .read(databaseProvider)
      .watchSrsDueDates()
      .listen((_) => schedule());
  ref.listen(reviewLogProvider, (_, _) => schedule());
  ref.listen(localeProvider, (_, _) => schedule());
  ref.listen(homeSettingsProvider, (_, _) => schedule());
  ref.listen(reminderSettingsProvider, (_, _) => schedule());
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
