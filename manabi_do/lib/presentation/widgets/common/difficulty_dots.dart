import 'package:flutter/material.dart';

/// Nothing else in the app draws these dots, so their scale lives with them
/// rather than in `AppDimens`.
abstract final class _Dimens {
  static const double dotSize = 6;
  static const double dotGap = 3;
}

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
      children: List.generate(
        total,
        (i) => Container(
          margin: EdgeInsets.only(left: i > 0 ? _Dimens.dotGap : 0),
          width: _Dimens.dotSize,
          height: _Dimens.dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < filled ? color : empty,
          ),
        ),
      ),
    );
  }
}
