import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

/// A read-only info row (no interaction).
class SettingsInfo extends StatelessWidget {
  final IconData icon;
  final String label;

  const SettingsInfo({super.key, required this.icon, required this.label});

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
        ],
      ),
    );
  }
}
