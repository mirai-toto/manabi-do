import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/coverage_band.dart';
import '../../../../l10n/band_label.dart';
import '../indicator/difficulty_dots.dart';
import '../surface/tappable_surface.dart';
import 'jlpt_level_card.dart';

/// One coverage band in the band list: how far into Japanese it takes you.
///
/// The twin of [JlptLevelCard], which does the same job for kanji. Separate
/// rather than shared, because the badge carries a different kind of fact: a
/// kanji card shows a level code, and this shows the share of running Japanese
/// a learner can read once the band is finished. That number is the reason the
/// screen exists, so it goes in the most prominent place on the row.
class CoverageBandCard extends StatelessWidget {
  final int band;

  /// Share of running Japanese reached once this band is done, 0 to 1. Null
  /// while the figures are still loading, which leaves the badge showing the
  /// band number instead of flashing a wrong percentage.
  final double? reached;

  final String? subtitle;
  final VoidCallback onTap;

  const CoverageBandCard({
    super.key,
    required this.band,
    required this.onTap,
    this.reached,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = bandColor(band, Theme.of(context).brightness);
    final share = reached;

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
              LevelBadge(
                code: share != null ? '${(share * 100).round()}%' : '$band',
                color: color,
                foreground: onBandColor(band, Theme.of(context).brightness),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bandLabel(band, context),
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
                          total: kBandCount,
                          filled: bandDifficulty(band),
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
