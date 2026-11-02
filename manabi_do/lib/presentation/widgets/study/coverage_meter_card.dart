import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../common/indicator/progress_bar.dart';
import '../common/surface/card_container.dart';
import '../common/label/section_label.dart';

/// How much of written Japanese a learner can read, as the headline of a screen.
///
/// The twin of `TodaysSessionCard`: a label, one number large enough to be the
/// point of the screen, a bar, and a footer of two facts. Built from
/// [CardContainer], [SectionLabel] and [AppProgressBar] rather than drawing its
/// own box.
///
/// All strings arrive pre-formatted. The widget does not know what a corpus is;
/// the caller has already turned shares into text.
class CoverageMeterCard extends StatelessWidget {
  /// Small caps label above the number, e.g. "You can read".
  final String label;

  /// Share of running Japanese, 0 to 1. This is the big number.
  final double share;

  /// What the bar shows, 0 to 1, when that is not [share].
  ///
  /// On the vocabulary home the two are the same thing: the number is how much
  /// the learner can read and the bar fills with it. On a band screen they are
  /// different facts — the number is what finishing the band would buy, the bar
  /// is how far through the band they are — and drawing the band's share as a
  /// progress bar would claim they had already read it.
  final double? progress;

  /// Sits beside the number, e.g. "of everything written in Japanese".
  final String caption;

  /// Bottom-left: what the learner has done, e.g. "612 words".
  final String? progressLabel;

  /// Bottom-right: what finishing the next step would buy, e.g.
  /// "667 more reaches 60%".
  final String? nextLabel;

  /// Defaults to `AppTokens.primary`. A band screen passes that band's colour.
  final Color? color;

  const CoverageMeterCard({
    super.key,
    required this.label,
    required this.share,
    required this.caption,
    this.progress,
    this.progressLabel,
    this.nextLabel,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final accent = color ?? t.primary;
    final hasFooter = progressLabel != null || nextLabel != null;

    return CardContainer(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(label),
          const SizedBox(height: AppDimens.spaceSm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${(share * 100).round()}%',
                style: AppTextStyles.display.copyWith(color: accent),
              ),
              const SizedBox(width: AppDimens.spaceSm),
              Expanded(
                child: Text(
                  caption,
                  style: AppTextStyles.body.copyWith(color: t.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceSm),
          AppProgressBar(progress: progress ?? share, color: accent),
          if (hasFooter) ...[
            const SizedBox(height: AppDimens.spaceSm),
            Row(
              children: [
                if (progressLabel != null)
                  Text(
                    progressLabel!,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: t.onSurface,
                    ),
                  ),
                const Spacer(),
                if (nextLabel != null)
                  Text(
                    nextLabel!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: t.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
