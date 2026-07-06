import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class NumberBadge extends StatelessWidget {
  final int number;
  final Color color;
  final double size;

  const NumberBadge({
    super.key,
    required this.number,
    required this.color,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: Center(
      child: Text(
        '$number',
        style: AppTextStyles.labelLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
