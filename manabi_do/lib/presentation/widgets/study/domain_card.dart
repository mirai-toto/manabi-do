import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/progress_bar.dart';
import '../common/tappable_surface.dart';

class DomainCard extends StatelessWidget {
  final String title;
  final String icon;
  final List<Color> gradientColors;
  final Color progressColor;
  final String subtitle;
  final String statLabel;
  final double progress;
  final int dueCount;
  final int newCount;
  final VoidCallback? onTap;
  final VoidCallback? onPractice;

  const DomainCard({
    super.key,
    required this.title,
    required this.icon,
    required this.gradientColors,
    required this.progressColor,
    required this.subtitle,
    required this.statLabel,
    required this.progress,
    this.dueCount = 0,
    this.newCount = 0,
    this.onTap,
    this.onPractice,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final hasDue = dueCount > 0;
    final hasNew = newCount > 0;
    final hasActivity = hasDue || hasNew;
    final hasPractice = onPractice != null;

    final activityParts = [
      if (hasDue) l.reviewsDue(dueCount),
      if (hasNew) l.nNew(newCount),
    ];
    final statusText = hasActivity ? activityParts.join(' · ') : statLabel;

    return Semantics(
      label: hasActivity ? '$title. $statusText' : '$title. $statLabel',
      button: true,
      excludeSemantics: true,
      child: TappableSurface(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        ),
        onTap: hasPractice ? onPractice : onTap,
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: gradientColors,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLg,
                vertical: AppDimens.spaceLg,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.titleLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceXxs),
                        Text(
                          subtitle,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    icon,
                    style: AppTextStyles.jpDisplay.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: t.cardBackground,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLg,
                vertical: AppDimens.spaceMd,
              ),
              child: hasPractice
                  ? Row(
                      children: [
                        Expanded(
                          child: Text(
                            statusText,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: hasActivity
                                  ? progressColor
                                  : t.onSurfaceVariant,
                              fontWeight: hasActivity
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          hasDue && hasNew
                              ? l.reviewAndStudy
                              : hasDue
                              ? l.reviewNow
                              : hasNew
                              ? l.studyNow
                              : l.practice,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: hasActivity
                                ? progressColor
                                : t.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (hasActivity) ...[
                          const SizedBox(width: AppDimens.spaceXxs),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: progressColor,
                            size: 14,
                          ),
                        ],
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Text(
                            statLabel,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: t.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimens.spaceMd),
                        Expanded(
                          child: AppProgressBar(
                            progress: progress,
                            color: progressColor,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
