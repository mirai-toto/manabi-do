import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../common/progress_bar.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final String icon;
  final List<Color> gradientColors;
  final Color progressColor;
  final String subtitle;
  final String statLabel;
  final double progress;
  final VoidCallback? onTap;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.gradientColors,
    required this.progressColor,
    required this.subtitle,
    required this.statLabel,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Semantics(
      label: '$title. $statLabel',
      button: onTap != null,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
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
                            style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
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
                      style: AppTextStyles.jpDisplay.copyWith(color: Colors.white),
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
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        statLabel,
                        style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceMd),
                    Expanded(
                      child: AppProgressBar(progress: progress, color: progressColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
