import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';

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
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceSm,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: t.onSurfaceVariant),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(color: t.onSurface),
            ),
          ),
          IconButton(
            tooltip: context.l10n.decreaseSetting(label),
            onPressed: onDecrement,
            icon: Icon(
              Icons.remove_rounded,
              size: 18,
              color: onDecrement != null ? t.onSurface : t.outlineVariant,
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: t.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            tooltip: context.l10n.increaseSetting(label),
            onPressed: onIncrement,
            icon: Icon(
              Icons.add_rounded,
              size: 18,
              color: onIncrement != null ? t.onSurface : t.outlineVariant,
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}
