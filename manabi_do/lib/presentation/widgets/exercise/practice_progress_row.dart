import '../common/indicator/progress_bar.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

/// Thin progress bar + `"N / total"` counter shown at the top of every exercise
/// screen. The bar fills proportionally to `index / total` using the session's
/// accent colour, and the label counts answered questions to match it: the
/// last question reads 8 / 9, since 9 / 9 would claim the session is done.
/// Handles `total == 0` without dividing by zero.
class PracticeProgressRow extends StatelessWidget {
  final int index;
  final int total;
  final Color color;

  const PracticeProgressRow({
    super.key,
    required this.index,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final progress = total == 0 ? 0.0 : index / total;
    return Row(
      children: [
        Expanded(
          child: AppProgressBar(
            progress: progress,
            from: total == 0 ? 0 : (index - 1).clamp(0, total) / total,
            color: color,
            trackColor: t.outlineVariant,
            radius: AppDimens.radiusXs,
            height: 4,
          ),
        ),
        const SizedBox(width: AppDimens.spaceXs),
        Text(
          '$index / $total',
          style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
        ),
      ],
    );
  }
}
