import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_provider.dart';

const _keyEnabled = 'reminder_enabled';
const _keyHour = 'reminder_hour';
const _keyMinute = 'reminder_minute';

/// The daily study reminder: whether it is on, and when it fires.
///
/// Off until the user turns it on, in onboarding or in Settings. The time is
/// kept as plain hour and minute so this file stays free of Flutter widgets.
class ReminderSettings {
  final bool enabled;
  final int hour;
  final int minute;

  const ReminderSettings({
    this.enabled = false,
    this.hour = 19,
    this.minute = 0,
  });

  ReminderSettings copyWith({bool? enabled, int? hour, int? minute}) =>
      ReminderSettings(
        enabled: enabled ?? this.enabled,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
      );
}

class ReminderSettingsNotifier extends Notifier<ReminderSettings> {
  @override
  ReminderSettings build() {
    final prefs = ref.read(sharedPreferencesProvider);
    const defaults = ReminderSettings();
    return ReminderSettings(
      enabled: prefs.getBool(_keyEnabled) ?? defaults.enabled,
      hour: prefs.getInt(_keyHour) ?? defaults.hour,
      minute: prefs.getInt(_keyMinute) ?? defaults.minute,
    );
  }

  Future<void> setEnabled(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyEnabled, value);
    state = state.copyWith(enabled: value);
  }

  Future<void> setTime(int hour, int minute) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_keyHour, hour);
    await prefs.setInt(_keyMinute, minute);
    state = state.copyWith(hour: hour, minute: minute);
  }
}

final reminderSettingsProvider =
    NotifierProvider<ReminderSettingsNotifier, ReminderSettings>(
      ReminderSettingsNotifier.new,
    );
