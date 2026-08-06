import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../common/tappable_surface.dart';

class ChapterCard extends StatelessWidget {
  final String chapterLabel;
  final String title;
  final String description;
  final String badge;
  final int doneCount;
  final int totalLessons;
  final String progressLabel;
  final Color accentColor;
  final bool isLocked;
  final VoidCallback onTap;

  const ChapterCard({
    super.key,
    required this.chapterLabel,
    required this.title,
    required this.description,
    required this.badge,
    required this.doneCount,
    required this.totalLessons,
    required this.progressLabel,
    required this.accentColor,
    required this.onTap,
    this.isLocked = false,
  });

  double get _progress => totalLessons > 0 ? doneCount / totalLessons : 0;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Semantics(
      label: '$chapterLabel: $title',
      button: true,
      excludeSemantics: true,
      child: Opacity(
        opacity: isLocked ? 0.55 : 1.0,
        child: TappableSurface(
          decoration: BoxDecoration(
            color: t.cardBackground,
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        chapterLabel,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    if (isLocked)
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 16,
                        color: t.onSurfaceVariant,
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.badgePaddingH,
                          vertical: AppDimens.badgePaddingV,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusPill,
                          ),
                        ),
                        child: Text(
                          badge,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceSm),
                Text(
                  title,
                  style: AppTextStyles.title.copyWith(color: t.onSurface),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: t.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: AppDimens.spaceMd),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 6,
                    backgroundColor: t.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXs),
                Text(
                  progressLabel,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: t.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
