import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

/// A tappable settings row with a leading widget, label, optional current
/// value, and chevron.
class SettingsTile extends StatelessWidget {
  final Widget leading;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;

  /// What the setting is currently set to, shown before the chevron. A row
  /// that hides its value behind a tap makes the reader open it to find out.
  final String? value;

  const SettingsTile({
    super.key,
    required this.leading,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Semantics(
      label: value == null ? label : '$label, $value',
      button: true,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceMd,
          ),
          child: Row(
            children: [
              leading,
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: labelColor ?? t.onSurface,
                  ),
                ),
              ),
              if (value != null) ...[
                Text(
                  value!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: t.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSm),
              ],
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: labelColor ?? t.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
