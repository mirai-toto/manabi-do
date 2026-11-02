import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../l10n/level_label.dart';
import '../indicator/difficulty_dots.dart';
import '../surface/tappable_surface.dart';

/// Compact badge showing a JLPT level (N1–N5) in brand colours.
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

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceSm),
      child: TappableSurface(
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(
            color: color.withValues(alpha: 0.35),
            width: AppDimens.borderWidthContainer,
          ),
        ),
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
                    const SizedBox(height: AppDimens.spaceXs),
                    Row(
                      children: [
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: t.onSurfaceVariant,
                            ),
                          ),
                        if (subtitle != null)
                          const SizedBox(width: AppDimens.spaceSm),
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
    );
  }
}

/// The square chip inside a JLPT level or vocabulary level card, filled with
/// that step's ramp
/// colour.
class LevelBadge extends StatelessWidget {
  final String code;
  final Color color;

  /// The readable ink on [color]. Defaults to `onAccentFor`, which is right for
  /// the JLPT ramp. The vocabulary-level ramp passes its own, because
  /// `estimateBrightnessForColor` lands on the wrong side of its mid-purples.
  final Color? foreground;

  const LevelBadge({
    super.key,
    required this.code,
    required this.color,
    this.foreground,
  });

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
          color: foreground ?? onAccentFor(color),
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
