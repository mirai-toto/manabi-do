import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/progress_bar.dart';

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
    final t = context.tokens;
    final l = context.l10n;
    final chapterLabel = l.chapterN(chapterNumber.toString().padLeft(2, '0'));

    return Semantics(
      label: '$chapterLabel: $title',
      button: onTap != null,
      excludeSemantics: true,
      child: Container(
        width: width,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          boxShadow: [
            BoxShadow(color: t.onSurface.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chapterLabel,
                        style: AppTextStyles.label.copyWith(
                          color: t.primary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.badgePaddingH,
                          vertical: AppDimens.badgePaddingV,
                        ),
                        decoration: BoxDecoration(
                          color: t.primaryContainer,
                          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                        ),
                        child: Text(
                          l.nLessons(totalLessons),
                          style: AppTextStyles.label.copyWith(color: t.onPrimaryContainer),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceMd),
                  Text(title, style: AppTextStyles.title),
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppDimens.spaceMd),
                  AppProgressBar(progress: _progress),
                  const SizedBox(height: AppDimens.spaceSm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$completedLessons / ${l.nLessons(totalLessons)}',
                        style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant),
                      ),
                      Text(
                        _progress > 0 ? '${(_progress * 100).round()}%' : '—',
                        style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
