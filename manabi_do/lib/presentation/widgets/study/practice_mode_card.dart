import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../common/surface/tappable_surface.dart';

/// Tappable card for a single practice mode or feature entry point. Left-side
/// tinted icon box (`color 12% opacity`, `radiusMd`), title, optional subtitle,
/// trailing chevron. Decoration: `cardBackground`, `radiusLg`, accent border at
/// 25% opacity. All display strings pre-formatted by the caller.
class PracticeModeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? subtitle;
  final Color color;
  final VoidCallback onTap;

  const PracticeModeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return TappableSurface(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: AppDimens.borderWidthContainer,
        ),
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
