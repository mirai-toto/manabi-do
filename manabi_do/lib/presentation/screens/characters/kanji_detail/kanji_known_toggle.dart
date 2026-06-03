import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';

class KanjiKnownToggle extends StatelessWidget {
  final bool isKnown;
  final VoidCallback onTap;
  const KanjiKnownToggle({super.key, required this.isKnown, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: isKnown ? t.successContainer : t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(
            color: isKnown ? t.success : t.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isKnown ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: isKnown ? t.success : t.onSurfaceVariant,
            ),
            const SizedBox(width: AppDimens.spaceSm),
            Text(
              isKnown ? 'Known' : 'Mark as Known',
              style: AppTextStyles.body.copyWith(
                color: isKnown ? t.success : t.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
