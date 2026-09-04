import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../presentation/widgets/settings/settings_card.dart';
import '../presentation/widgets/settings/settings_tile.dart';

// ── SettingsCard ──────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: SettingsCard, path: 'Settings')
Widget buildSettingsCard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SettingsCard(
      children: [
        SettingsTile(
          leading: const Icon(Icons.language),
          label: 'Language',
          onTap: () {},
        ),
        SettingsTile(
          leading: const Icon(Icons.delete_outline),
          label: 'Reset progress',
          labelColor: Colors.red,
          onTap: () {},
        ),
      ],
    ),
  );
}

// ── SettingsTile ──────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: SettingsTile, path: 'Settings')
Widget buildSettingsTile(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SettingsCard(
      children: [
        SettingsTile(
          leading: const Icon(Icons.language),
          label: 'Language',
          onTap: () {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Danger', type: SettingsTile, path: 'Settings')
Widget buildSettingsTileDanger(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SettingsCard(
      children: [
        SettingsTile(
          leading: const Icon(Icons.delete_outline, color: Colors.red),
          label: 'Reset progress',
          labelColor: Colors.red,
          onTap: () {},
        ),
      ],
    ),
  );
}

// ── SettingsToggle ────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'On', type: SettingsToggle, path: 'Settings')
Widget buildSettingsToggleOn(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SettingsCard(
      children: [
        SettingsToggle(
          leading: const Icon(Icons.notifications_outlined, size: 20),
          label: 'Daily reminders',
          value: true,
          onChanged: (_) {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Off', type: SettingsToggle, path: 'Settings')
Widget buildSettingsToggleOff(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SettingsCard(
      children: [
        SettingsToggle(
          leading: const Icon(Icons.notifications_outlined, size: 20),
          label: 'Daily reminders',
          value: false,
          onChanged: (_) {},
        ),
      ],
    ),
  );
}

// ── SettingsInfo ──────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: SettingsInfo, path: 'Settings')
Widget buildSettingsInfo(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SettingsCard(
      children: [
        const SettingsInfo(icon: Icons.info_outline, label: 'Version 1.0.0'),
      ],
    ),
  );
}

// ── SettingsStepper ───────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: SettingsStepper, path: 'Settings')
Widget buildSettingsStepper(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SettingsCard(
      children: [
        SettingsStepper(
          icon: Icons.layers_outlined,
          label: 'New cards per day',
          value: 10,
          onDecrement: () {},
          onIncrement: () {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'At minimum', type: SettingsStepper, path: 'Settings')
Widget buildSettingsStepperMin(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SettingsCard(
      children: [
        const SettingsStepper(
          icon: Icons.layers_outlined,
          label: 'New cards per day',
          value: 1,
        ),
      ],
    ),
  );
}
