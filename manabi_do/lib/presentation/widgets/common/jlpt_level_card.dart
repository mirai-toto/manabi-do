import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/level_label.dart';
import 'difficulty_dots.dart';

class JlptLevelCard extends StatelessWidget {
  final String code;
  final String? subtitle;
  final VoidCallback onTap;

  const JlptLevelCard({
    super.key,
    required this.code,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = levelColor(code);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceSm),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spaceMd),
            child: Row(
              children: [
                LevelBadge(code: code, color: color),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        levelLabel(code, context),
                        style: AppTextStyles.body.copyWith(
                          color: t.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
                            ),
                          if (subtitle != null) const SizedBox(width: AppDimens.spaceSm),
                          DifficultyDots(
                            total: 5,
                            filled: levelDifficulty(code),
                            color: color,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: t.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LevelBadge extends StatelessWidget {
  final String code;
  final Color color;

  const LevelBadge({super.key, required this.code, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
        child: Center(
          child: Text(
            code,
            style: AppTextStyles.labelLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
}
