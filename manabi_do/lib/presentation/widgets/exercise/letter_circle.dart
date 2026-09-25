import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';

/// The A / B / C / D badge in front of an answer option.
///
/// Shared by multiple choice and sentence fill-in-the-blank, so the two stay
/// in step. [color] tints the border and the letter together.
class LetterCircle extends StatelessWidget {
  final String letter;
  final Color color;
  final bool _compact;

  const LetterCircle({super.key, required this.letter, required this.color})
    : _compact = false;

  /// The smaller badge for the two-column answer grid, where the option's own
  /// text is the focus and the letter sits in the corner.
  const LetterCircle.compact({
    super.key,
    required this.letter,
    required this.color,
  }) : _compact = true;

  @override
  Widget build(BuildContext context) {
    final double size = _compact ? 20 : 28;
    final TextStyle style = _compact
        ? AppTextStyles.labelXs
        : AppTextStyles.label;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: AppDimens.borderWidthInteractive,
        ),
      ),
      child: Center(
        child: Text(
          letter,
          style: style.copyWith(fontWeight: FontWeight.w700, color: color),
        ),
      ),
    );
  }
}
