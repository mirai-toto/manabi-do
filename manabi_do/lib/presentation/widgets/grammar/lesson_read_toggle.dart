import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';

class LessonReadToggle extends StatelessWidget {
  final bool isRead;
  final VoidCallback onTap;

  const LessonReadToggle({
    super.key,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceMd,
        ),
        decoration: BoxDecoration(
          color: isRead ? t.successContainer : t.surfaceContainer,
          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
          border: Border.all(
            color: isRead ? t.success : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isRead
                  ? Icons.check_circle_rounded
                  : Icons.check_circle_outline_rounded,
              color: isRead ? t.success : t.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: AppDimens.spaceSm),
            Text(
              isRead ? l.lessonMarkedRead : l.markLessonAsRead,
              style: AppTextStyles.labelLarge.copyWith(
                color: isRead ? t.success : t.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
