import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum LessonStatus { done, notStarted }

class LessonRow extends StatelessWidget {
  final String title;
  final int difficulty; // 1–3
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
    final isDone = status == LessonStatus.done;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant, width: 1.5),
        ),
        child: Row(
          children: [
            _LeadingIcon(isDone: isDone, lessonNumber: lessonNumber),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _DifficultyPips(difficulty: difficulty),
                      const SizedBox(width: 8),
                      Text(
                        'Difficulty $difficulty',
                        style: AppTextStyles.label.copyWith(color: AppColors.onSurfaceVariant),
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
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final bool isDone;
  final int? lessonNumber;

  const _LeadingIcon({required this.isDone, this.lessonNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDone ? AppColors.successContainer : AppColors.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isDone
            ? const Icon(Icons.check, size: 18, color: AppColors.success)
            : Text(
                '${lessonNumber ?? ''}',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}

class _DifficultyPips extends StatelessWidget {
  final int difficulty;

  const _DifficultyPips({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) => Padding(
        padding: const EdgeInsets.only(right: 3),
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: i < difficulty ? AppColors.primary : AppColors.outlineVariant,
            shape: BoxShape.circle,
          ),
        ),
      )),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isDone;

  const _StatusChip({required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isDone ? AppColors.successContainer : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        isDone ? 'Known' : 'Not started',
        style: AppTextStyles.label.copyWith(
          fontSize: 11,
          color: isDone ? AppColors.success : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
