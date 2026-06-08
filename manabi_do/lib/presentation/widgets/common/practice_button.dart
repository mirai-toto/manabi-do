import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/l10n.dart';
import 'tappable_card.dart';

class PracticeButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onTap;
  const PracticeButton({super.key, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd, vertical: AppDimens.spaceSm,
      ),
      child: TappableCard(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school_rounded, color: color, size: 20),
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                context.l10n.practice,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
