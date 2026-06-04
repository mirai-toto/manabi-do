import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

/// A tappable settings row with a leading widget, label, and chevron.
class SettingsTile extends StatelessWidget {
  final Widget leading;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;

  const SettingsTile({
    super.key,
    required this.leading,
    required this.label,
    required this.onTap,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd, vertical: AppDimens.spaceMd),
        child: Row(
          children: [
            leading,
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(child: Text(label, style: AppTextStyles.body.copyWith(color: labelColor ?? t.onSurface))),
            Icon(Icons.chevron_right_rounded, size: 20, color: labelColor ?? t.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

/// A toggle settings row (switch).
class SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggle({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd, vertical: AppDimens.spaceSm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: t.onSurfaceVariant),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(child: Text(label, style: AppTextStyles.body.copyWith(color: t.onSurface))),
          Switch(value: value, onChanged: onChanged, activeThumbColor: t.primary),
        ],
      ),
    );
  }
}

/// A read-only info row (no interaction).
class SettingsInfo extends StatelessWidget {
  final IconData icon;
  final String label;

  const SettingsInfo({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd, vertical: AppDimens.spaceSm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: t.onSurfaceVariant),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(child: Text(label, style: AppTextStyles.body.copyWith(color: t.onSurface))),
        ],
      ),
    );
  }
}

/// A stepper row with − value + controls.
class SettingsStepper extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const SettingsStepper({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onDecrement,
    this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd, vertical: AppDimens.spaceSm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: t.onSurfaceVariant),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(child: Text(label, style: AppTextStyles.body.copyWith(color: t.onSurface))),
          IconButton(
            onPressed: onDecrement,
            icon: Icon(Icons.remove_rounded, size: 18, color: onDecrement != null ? t.onSurface : t.outlineVariant),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: t.onSurface, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: Icon(Icons.add_rounded, size: 18, color: onIncrement != null ? t.onSurface : t.outlineVariant),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}
