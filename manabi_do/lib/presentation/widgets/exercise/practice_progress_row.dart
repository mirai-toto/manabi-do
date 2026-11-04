import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

/// Thin progress bar + `"N / total"` counter shown at the top of every exercise
/// screen. The bar fills proportionally to `index / total` using the session's
/// accent colour; the text label counts from 1. Handles `total == 0` without
/// dividing by zero.
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
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: t.outlineVariant,
            color: color,
            borderRadius: BorderRadius.circular(AppDimens.radiusXs),
          ),
        ),
        const SizedBox(width: AppDimens.spaceXs),
        Text(
          '${index + 1} / $total',
          style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
        ),
      ],
    );
  }
}
