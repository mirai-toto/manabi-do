import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../common/action/app_button.dart';

/// The full-width "practice this" button at the top of a level or group view,
/// tinted with the level's [color]. A preset of `AppButton`, not a second
/// button engine.
class PracticeButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const PracticeButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      icon: Icon(Icons.school_rounded, color: color, size: 20),
      onPressed: onPressed,
      fullWidth: true,
      backgroundColor: color.withValues(alpha: 0.08),
      foregroundColor: color,
      side: BorderSide(
        color: color.withValues(alpha: 0.35),
        width: AppDimens.borderWidthContainer,
      ),
      radius: AppDimens.radiusMd,
      visualDensity: VisualDensity.standard,
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      textStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
