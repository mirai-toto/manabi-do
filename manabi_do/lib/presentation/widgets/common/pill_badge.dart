import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';

class PillBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;
  final TextStyle? textStyle;

  const PillBadge({
    super.key,
    required this.label,
    required this.color,
    required this.background,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final style = (textStyle ?? AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w700))
        .copyWith(color: color);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.badgePaddingH,
        vertical: AppDimens.badgePaddingV,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      ),
      child: Text(label, style: style),
    );
  }
}
