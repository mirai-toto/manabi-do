import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';

class DifficultyDots extends StatelessWidget {
  final int total;
  final int filled;
  final Color color;
  final Color? emptyColor;

  const DifficultyDots({
    super.key,
    required this.total,
    required this.filled,
    required this.color,
    this.emptyColor,
  });

  @override
  Widget build(BuildContext context) {
    final empty = emptyColor ?? color.withValues(alpha: 0.2);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) => Container(
        margin: EdgeInsets.only(left: i > 0 ? AppDimens.pipGap : 0),
        width: AppDimens.pipSize,
        height: AppDimens.pipSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: i < filled ? color : empty,
        ),
      )),
    );
  }
}
