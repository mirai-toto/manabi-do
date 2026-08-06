import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

class LockedFeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const LockedFeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceLg,
        ),
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline_rounded, size: 40, color: t.primary),
            const SizedBox(height: AppDimens.spaceMd),
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(color: t.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceSm),
            Text(
              subtitle,
              style: AppTextStyles.body.copyWith(color: t.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
