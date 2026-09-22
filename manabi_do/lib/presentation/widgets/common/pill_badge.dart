import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';

class PillBadge extends StatelessWidget {
  /// The pill's own padding.
  ///
  /// Public, unlike most widget-local dimensions, because a caller sizing a row
  /// of pills to one common width has to measure its text and add this back on.
  /// See [minWidth] and `deck_row.dart`.
  static const double paddingH = 10;
  static const double paddingV = 3;

  final String label;
  final Color color;
  final Color background;
  final TextStyle? textStyle;

  /// Optional leading icon, drawn in [color] at the label's size.
  final IconData? icon;

  /// Floor for the pill's width, so a row of pills with different labels still
  /// lines up. Content stays centred.
  final double? minWidth;

  const PillBadge({
    super.key,
    required this.label,
    required this.color,
    required this.background,
    this.textStyle,
    this.icon,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    final style =
        (textStyle ??
                AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w700))
            .copyWith(color: color);

    return Container(
      alignment: minWidth == null ? null : Alignment.center,
      constraints: minWidth == null
          ? null
          : BoxConstraints(minWidth: minWidth!),
      padding: const EdgeInsets.symmetric(
        horizontal: paddingH,
        vertical: paddingV,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: (style.fontSize ?? 12) + 2, color: color),
            const SizedBox(width: AppDimens.spaceXxs),
          ],
          Text(label, style: style),
        ],
      ),
    );
  }
}
