import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  final Widget? leading;

  const AppFilterChip({
    super.key,
    required this.label,
    this.isActive = false,
    this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Semantics(
      label: label,
      selected: isActive,
      button: onTap != null,
      excludeSemantics: true,
      child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.chipPaddingH, vertical: AppDimens.chipPaddingV),
        decoration: BoxDecoration(
          color: isActive ? t.primaryContainer : Colors.transparent,
          border: Border.all(
            color: isActive ? t.primary : t.outlineVariant,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: AppDimens.spaceXs)],
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isActive ? t.onPrimaryContainer : t.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
