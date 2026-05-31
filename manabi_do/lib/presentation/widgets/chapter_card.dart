import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'progress_bar.dart';

class ChapterCard extends StatelessWidget {
  final int chapterNumber;
  final String title;
  final String description;
  final int totalLessons;
  final int completedLessons;
  final VoidCallback? onTap;
  final double? width;

  const ChapterCard({
    super.key,
    required this.chapterNumber,
    required this.title,
    required this.description,
    required this.totalLessons,
    required this.completedLessons,
    this.onTap,
    this.width,
  });

  double get _progress => totalLessons > 0 ? completedLessons / totalLessons : 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 320,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chapter ${chapterNumber.toString().padLeft(2, '0')}',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '$totalLessons lessons',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.onPrimaryContainer,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.title),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTextStyles.label.copyWith(
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w400,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            AppProgressBar(progress: _progress),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$completedLessons / $totalLessons lessons',
                  style: AppTextStyles.label.copyWith(fontSize: 11, color: AppColors.onSurfaceVariant),
                ),
                Text(
                  _progress > 0 ? '${(_progress * 100).round()}%' : '—',
                  style: AppTextStyles.label.copyWith(fontSize: 11, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
