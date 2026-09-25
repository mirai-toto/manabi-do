import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

/// The outlined and text variants sit tighter than the filled ones, so they
/// carry their own padding. Only this button uses these numbers.
abstract final class _Dimens {
  static const double compactPaddingV = 10;
  static const double compactPaddingH = 22;
}

enum AppButtonVariant { filled, tonal, outlined, text, danger }

enum AppButtonSize { regular, small }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool fullWidth;
  final Widget? icon;

  // Overrides. The variant and size below cover the common cases; a caller
  // that wants a different look states it here rather than growing a variant.
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? side;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

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
    this.radius,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    final bgColor =
        backgroundColor ??
        switch (variant) {
          AppButtonVariant.filled => t.primary,
          AppButtonVariant.tonal => t.primaryContainer,
          AppButtonVariant.outlined => Colors.transparent,
          AppButtonVariant.text => Colors.transparent,
          AppButtonVariant.danger => t.error,
        };

    final fgColor =
        foregroundColor ??
        switch (variant) {
          AppButtonVariant.filled => t.onPrimary,
          AppButtonVariant.tonal => t.onPrimaryContainer,
          AppButtonVariant.outlined => t.primary,
          AppButtonVariant.text => t.primary,
          AppButtonVariant.danger => t.cardBackground,
        };

    final borderSide =
        side ??
        switch (variant) {
          AppButtonVariant.outlined => BorderSide(
            color: t.primary,
            width: AppDimens.borderWidthStrong,
          ),
          _ => BorderSide.none,
        };

    final resolvedPadding =
        padding ??
        switch (size) {
          AppButtonSize.small => const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceSm,
          ),
          AppButtonSize.regular =>
            (variant == AppButtonVariant.outlined ||
                    variant == AppButtonVariant.text)
                ? const EdgeInsets.symmetric(
                    horizontal: _Dimens.compactPaddingH,
                    vertical: _Dimens.compactPaddingV,
                  )
                : const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceLg,
                    vertical: AppDimens.buttonPaddingV,
                  ),
        };

    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        overlayColor:
            (variant == AppButtonVariant.outlined ||
                variant == AppButtonVariant.text)
            ? t.primary.withValues(alpha: 0.08)
            : null,
        elevation: 0,
        padding: resolvedPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? AppDimens.radiusPill),
          side: borderSide,
        ),
        textStyle:
            textStyle ??
            AppTextStyles.labelLarge.copyWith(
              fontSize: size == AppButtonSize.small
                  ? AppTextStyles.labelSmall.fontSize
                  : AppTextStyles.labelLarge.fontSize,
            ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: AppDimens.spaceSm),
          ],
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );

    if (fullWidth) return SizedBox(width: double.infinity, child: button);
    return button;
  }
}
