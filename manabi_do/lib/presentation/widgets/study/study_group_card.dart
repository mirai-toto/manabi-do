import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../common/progress_bar.dart';
import '../common/tappable_surface.dart';

class StudyGroupCard extends StatelessWidget {
  final String title;
  final String rangeLabel;
  final double progress;
  final Color color;
  final VoidCallback onTap;

  const StudyGroupCard({
    super.key,
    required this.title,
    required this.rangeLabel,
    required this.progress,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return TappableSurface(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceMd,
        ),
        child: Row(
          children: [
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
                  const SizedBox(height: AppDimens.spaceXxs),
                  Text(
                    rangeLabel,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: t.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXs),
                  AppProgressBar(progress: progress, color: color),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: t.onSurfaceVariant,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
