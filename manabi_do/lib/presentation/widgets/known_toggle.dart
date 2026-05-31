import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class KnownToggle extends StatelessWidget {
  final bool isKnown;
  final VoidCallback? onTap;
  final bool fullWidth;

  const KnownToggle({
    super.key,
    required this.isKnown,
    this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isKnown ? AppColors.successContainer : AppColors.surfaceContainer,
          border: Border.all(
            color: isKnown ? AppColors.success : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isKnown ? AppColors.success : AppColors.outlineVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Text(
              isKnown ? 'Known ✓' : 'Mark as known',
              style: AppTextStyles.labelLarge.copyWith(
                color: isKnown ? AppColors.success : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
