import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../common/tappable_surface.dart';

class PracticeModeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? subtitle;
  final String? countLabel;
  final bool isCountLoading;
  final Color color;
  final VoidCallback onTap;

  const PracticeModeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.subtitle,
    this.countLabel,
    this.isCountLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return TappableSurface(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      color: t.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppDimens.spaceXxs),
                    Text(
                      subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (isCountLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: AppDimens.spaceXxs),
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else if (countLabel != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppDimens.spaceXxs),
                      child: Text(
                        countLabel!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: t.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
