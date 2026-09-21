import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

/// A toggle settings row (switch).
class SettingsToggle extends StatelessWidget {
  final Widget leading;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggle({
    super.key,
    required this.leading,
    required this.label,
    required this.value,
    required this.onChanged,
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
          leading,
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(color: t.onSurface),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: t.primary,
          ),
        ],
      ),
    );
  }
}
