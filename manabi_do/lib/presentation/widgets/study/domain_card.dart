import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/progress_bar.dart';
import '../common/tappable_surface.dart';

class DomainCard extends StatelessWidget {
  final String title;
  final String icon;
  final List<Color> gradientColors;
  final Color progressColor;
  final String statLabel;
  final double progress;
  final int dueCount;
  final int newCount;
  final VoidCallback? onTap;
  final VoidCallback? onPractice;
  final bool stackActivity;

  const DomainCard({
    super.key,
    required this.title,
    required this.icon,
    required this.gradientColors,
    required this.progressColor,
    required this.statLabel,
    required this.progress,
    this.dueCount = 0,
    this.newCount = 0,
    this.onTap,
    this.onPractice,
    this.stackActivity = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final hasDue = dueCount > 0;
    final hasNew = newCount > 0;
    final hasActivity = hasDue || hasNew;
    final hasPractice = onPractice != null;

    final dueText = hasDue ? l.reviewsDue(dueCount) : null;
    final newText = hasNew ? l.nNew(newCount) : null;
    final statusText = hasActivity
        ? [if (hasDue) dueText!, if (hasNew) newText!].join(' · ')
        : statLabel;

    return Semantics(
      label: hasActivity ? '$title. $statusText' : '$title. $statLabel',
      button: true,
      excludeSemantics: true,
      child: TappableSurface(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        ),
        onTap: hasPractice ? onPractice : onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: gradientColors,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLg,
                vertical: AppDimens.spaceLg,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    icon,
                    style: AppTextStyles.jpDisplay.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: t.cardBackground,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLg,
                vertical: AppDimens.spaceMd,
              ),
              child: hasPractice
                  ? _buildStatus(
                      t,
                      stackActivity && hasDue && hasNew,
                      hasActivity,
                      statusText,
                      dueText,
                      newText,
                      progressColor,
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Text(
                            statLabel,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: t.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimens.spaceMd),
                        Expanded(
                          child: AppProgressBar(
                            progress: progress,
                            color: progressColor,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(
    AppTokens t,
    bool stacked,
    bool hasActivity,
    String statusText,
    String? dueText,
    String? newText,
    Color progressColor,
  ) {
    final style = AppTextStyles.bodySmall.copyWith(
      color: hasActivity ? progressColor : t.onSurfaceVariant,
      fontWeight: hasActivity ? FontWeight.w600 : FontWeight.normal,
    );
    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dueText!, style: style),
          Text(newText!, style: style),
        ],
      );
    }
    return Text(statusText, style: style);
  }
}
