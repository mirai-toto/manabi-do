import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum AppButtonVariant { filled, tonal, outlined, text, danger }

enum AppButtonSize { regular, small }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool fullWidth;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? side;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.regular,
    this.fullWidth = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.side,
  });

  Color get _backgroundColor => backgroundColor ?? switch (variant) {
    AppButtonVariant.filled   => AppColors.primary,
    AppButtonVariant.tonal    => AppColors.primaryContainer,
    AppButtonVariant.outlined => Colors.transparent,
    AppButtonVariant.text     => Colors.transparent,
    AppButtonVariant.danger   => AppColors.error,
  };

  Color get _foregroundColor => foregroundColor ?? switch (variant) {
    AppButtonVariant.filled   => AppColors.onPrimary,
    AppButtonVariant.tonal    => AppColors.onPrimaryContainer,
    AppButtonVariant.outlined => AppColors.primary,
    AppButtonVariant.text     => AppColors.primary,
    AppButtonVariant.danger   => Colors.white,
  };

  BorderSide get _borderSide => side ?? switch (variant) {
    AppButtonVariant.outlined => const BorderSide(color: AppColors.primary, width: 1.5),
    _ => BorderSide.none,
  };

  EdgeInsets get _padding => switch (size) {
    AppButtonSize.small   => const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    AppButtonSize.regular => (variant == AppButtonVariant.outlined || variant == AppButtonVariant.text)
        ? const EdgeInsets.symmetric(horizontal: 22, vertical: 10)
        : const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  };

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _backgroundColor,
        foregroundColor: _foregroundColor,
        overlayColor: (variant == AppButtonVariant.outlined || variant == AppButtonVariant.text)
            ? AppColors.primary.withOpacity(0.08)
            : null,
        elevation: 0,
        padding: _padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: _borderSide,
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(
          fontSize: size == AppButtonSize.small ? 12 : 14,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          Text(label),
        ],
      ),
    );

    if (fullWidth) return SizedBox(width: double.infinity, child: button);
    return button;
  }
}
