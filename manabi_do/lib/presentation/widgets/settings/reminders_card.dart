import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import 'settings_card.dart';
import 'settings_tile.dart';
import 'settings_toggle.dart';

/// The daily reminder in Settings: a switch, the time once it is on, and a
/// way to the system settings when notifications were blocked afterwards.
class RemindersCard extends StatelessWidget {
  /// The user wants reminders.
  final bool enabled;

  /// The user wants reminders, but the system no longer lets the app post
  /// them, so none arrive.
  final bool blocked;

  /// The reminder time, already formatted.
  final String time;

  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onPickTime;
  final VoidCallback onOpenSystemSettings;

  const RemindersCard({
    super.key,
    required this.enabled,
    required this.blocked,
    required this.time,
    required this.onEnabledChanged,
    required this.onPickTime,
    required this.onOpenSystemSettings,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final bool on = enabled && !blocked;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsCard(
          children: [
            SettingsToggle(
              leading: Icon(
                Icons.notifications_outlined,
                size: 20,
                color: t.onSurfaceVariant,
              ),
              label: l.settingsDailyReminder,
              value: on,
              onChanged: onEnabledChanged,
            ),
            if (on)
              SettingsTile(
                leading: Icon(
                  Icons.schedule_rounded,
                  size: 20,
                  color: t.onSurfaceVariant,
                ),
                label: l.settingsReminderTime,
                value: time,
                onTap: onPickTime,
              ),
            if (blocked)
              SettingsTile(
                leading: Icon(
                  Icons.notifications_off_outlined,
                  size: 20,
                  color: t.error,
                ),
                label: l.remindersOpenSystemSettings,
                onTap: onOpenSystemSettings,
              ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceSm),
        Text(
          blocked ? l.remindersBlocked : l.settingsRemindersNote,
          style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
        ),
      ],
    );
  }
}
