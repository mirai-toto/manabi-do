import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/tappable_surface.dart';

/// "Keep learning" entry on the home screen: the next grammar lesson to
/// read, with progress through its chapter.
class ContinueLessonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int lessonIndex;
  final int lessonCount;
  final Color color;
  final VoidCallback onTap;

  const ContinueLessonCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.lessonIndex,
    required this.lessonCount,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    return Semantics(
      label: '$title, $subtitle',
      button: true,
      excludeSemantics: true,
      child: TappableSurface(
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(color: t.outlineVariant),
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                ),
                child: Center(
                  child: Text(
                    '文',
                    style: AppTextStyles.jpBodyLarge.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.iconTextGap),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      subtitle,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: t.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                l.lessonOfTotal(lessonIndex + 1, lessonCount),
                style: AppTextStyles.labelSmall.copyWith(color: color),
              ),
              const SizedBox(width: AppDimens.spaceXs),
              Icon(Icons.chevron_right_rounded, color: t.outlineVariant),
            ],
          ),
        ),
      ),
    );
  }
}
