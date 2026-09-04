import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/card_container.dart';
import '../common/section_label.dart';

/// Seven dots for the current week (Monday first): a check for days with
/// reviews, a ring around today.
class WeekStrip extends StatelessWidget {
  /// Whether each day of the week (Monday-first) had reviews.
  final List<bool> reviewedDays;

  /// Today's position in [reviewedDays] (0 = Monday).
  final int todayIndex;

  const WeekStrip({
    super.key,
    required this.reviewedDays,
    required this.todayIndex,
  }) : assert(reviewedDays.length == 7);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final monday = DateTime.now().subtract(
      Duration(days: DateTime.now().weekday - 1),
    );

    return CardContainer(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(l.thisWeek),
          const SizedBox(height: AppDimens.spaceSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < 7; i++)
                _DayDot(
                  label: DateFormat.E(
                    locale,
                  ).format(monday.add(Duration(days: i))),
                  reviewed: reviewedDays[i],
                  isToday: i == todayIndex,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  final String label;
  final bool reviewed;
  final bool isToday;

  const _DayDot({
    required this.label,
    required this.reviewed,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: reviewed
                ? t.success.withValues(alpha: 0.18)
                : t.surfaceContainerHigh,
            shape: BoxShape.circle,
            border: isToday ? Border.all(color: t.primary, width: 2) : null,
          ),
          child: reviewed
              ? Icon(Icons.check_rounded, size: 16, color: t.success)
              : null,
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Text(
          label,
          style: AppTextStyles.labelXs.copyWith(color: t.onSurfaceVariant),
        ),
      ],
    );
  }
}
