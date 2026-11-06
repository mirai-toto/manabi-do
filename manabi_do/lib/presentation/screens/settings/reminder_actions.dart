import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/reminder_settings_provider.dart';
import '../../../l10n/l10n.dart';
import '../../services/reminder_service.dart';

/// What Settings and onboarding both do with the daily reminder.

/// The reminder time in the reader's clock format.
String reminderTimeLabel(BuildContext context, ReminderSettings settings) =>
    MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay(hour: settings.hour, minute: settings.minute),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );

Future<void> pickReminderTime(BuildContext context, WidgetRef ref) async {
  final ReminderSettings settings = ref.read(reminderSettingsProvider);
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: settings.hour, minute: settings.minute),
  );
  if (picked == null) return;
  await ref
      .read(reminderSettingsProvider.notifier)
      .setTime(picked.hour, picked.minute);
}

/// Turns the reminder on, or explains why it could not: once refused,
/// Android stops asking, so the only way back is the system settings.
Future<void> turnOnReminders(BuildContext context, WidgetRef ref) async {
  final ReminderService service = ref.read(reminderServiceProvider);
  if (await service.enable() || !context.mounted) return;
  final l = context.l10n;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(l.remindersBlocked),
      action: SnackBarAction(
        label: l.remindersOpenSystemSettings,
        onPressed: service.openSystemSettings,
      ),
    ),
  );
}
