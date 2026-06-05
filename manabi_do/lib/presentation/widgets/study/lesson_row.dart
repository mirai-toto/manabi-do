import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../common/difficulty_dots.dart';
import '../../../domain/entities/lesson_status.dart';
import '../../../l10n/l10n.dart';

class LessonRow extends StatelessWidget {
  final String title;
  final int difficulty;
  final LessonStatus status;
  final int? lessonNumber;
  final VoidCallback? onTap;

  const LessonRow({
    super.key,
    required this.title,
    this.difficulty = 1,
    this.status = LessonStatus.notStarted,
    this.lessonNumber,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final isDone = status == LessonStatus.done;

    return Semantics(
      label: '$title, ${l.difficultyLevel(difficulty)}, ${isDone ? l.known : l.statusNotStarted}',
      button: onTap != null,
      excludeSemantics: true,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(color: t.outlineVariant, width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.buttonPaddingV,
              ),
              child: Row(
                children: [
                  _LeadingIcon(isDone: isDone, lessonNumber: lessonNumber),
                  const SizedBox(width: AppDimens.iconTextGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: AppDimens.spaceXs),
                        Row(
                          children: [
                            DifficultyDots(total: 3, filled: difficulty, color: t.primary, emptyColor: t.outlineVariant),
                            const SizedBox(width: AppDimens.spaceSm),
                            Text(
                              l.difficultyLevel(difficulty),
                              style: AppTextStyles.label.copyWith(color: t.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _StatusChip(isDone: isDone),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final bool isDone;
  final int? lessonNumber;

  const _LeadingIcon({required this.isDone, this.lessonNumber});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDone ? t.successContainer : t.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isDone
            ? Icon(Icons.check, size: 18, color: t.success)
            : Text(
                '${lessonNumber ?? ''}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: t.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}


class _StatusChip extends StatelessWidget {
  final bool isDone;

  const _StatusChip({required this.isDone});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.badgePaddingH,
        vertical: AppDimens.badgePaddingV,
      ),
      decoration: BoxDecoration(
        color: isDone ? t.successContainer : t.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      ),
      child: Text(
        isDone ? l.known : l.statusNotStarted,
        style: AppTextStyles.label.copyWith(
          color: isDone ? t.success : t.onSurfaceVariant,
        ),
      ),
    );
  }
}
