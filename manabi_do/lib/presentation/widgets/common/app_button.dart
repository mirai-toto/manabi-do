import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

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

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    final bgColor = backgroundColor ?? switch (variant) {
      AppButtonVariant.filled   => t.primary,
      AppButtonVariant.tonal    => t.primaryContainer,
      AppButtonVariant.outlined => Colors.transparent,
      AppButtonVariant.text     => Colors.transparent,
      AppButtonVariant.danger   => t.error,
    };

    final fgColor = foregroundColor ?? switch (variant) {
      AppButtonVariant.filled   => t.onPrimary,
      AppButtonVariant.tonal    => t.onPrimaryContainer,
      AppButtonVariant.outlined => t.primary,
      AppButtonVariant.text     => t.primary,
      AppButtonVariant.danger   => t.cardBackground,
    };

    final borderSide = side ?? switch (variant) {
      AppButtonVariant.outlined => BorderSide(color: t.primary, width: 1.5),
      _ => BorderSide.none,
    };

    final padding = switch (size) {
      AppButtonSize.small   => const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd, vertical: AppDimens.spaceSm),
      AppButtonSize.regular => (variant == AppButtonVariant.outlined || variant == AppButtonVariant.text)
          ? const EdgeInsets.symmetric(horizontal: AppDimens.buttonPaddingHCompact, vertical: AppDimens.buttonPaddingVCompact)
          : const EdgeInsets.symmetric(horizontal: AppDimens.spaceLg, vertical: AppDimens.buttonPaddingV),
    };

    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        overlayColor: (variant == AppButtonVariant.outlined || variant == AppButtonVariant.text)
            ? t.primary.withValues(alpha: 0.08)
            : null,
        elevation: 0,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
          side: borderSide,
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(
          fontSize: size == AppButtonSize.small
              ? AppTextStyles.labelSmall.fontSize
              : AppTextStyles.labelLarge.fontSize,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: AppDimens.spaceSm)],
          Text(label),
        ],
      ),
    );

    if (fullWidth) return SizedBox(width: double.infinity, child: button);
    return button;
  }
}
