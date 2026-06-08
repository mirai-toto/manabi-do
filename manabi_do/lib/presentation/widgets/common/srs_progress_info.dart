import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card;

import '../../../core/srs/srs_level.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import 'pill_badge.dart';

class SrsProgressInfo extends StatelessWidget {
  final Card? srsCard;
  const SrsProgressInfo({super.key, required this.srsCard});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    final stability = srsCard?.stability ?? 0.0;
    final level = srsLevel(srsCard);

    final stateLabel = switch (level) {
      SrsLevel.newCard    => l.srsStateNew,
      SrsLevel.learning   => l.srsStateLearning,
      SrsLevel.apprentice => l.srsStateApprentice,
      SrsLevel.familiar   => l.srsStateFamiliar,
      SrsLevel.mastered   => l.srsStateMastered,
      SrsLevel.expert     => l.srsStateExpert,
    };
    final stateColor = level == SrsLevel.newCard ? t.onSurfaceVariant : level.accent(t);
    final progress = (stability / 21.0).clamp(0.0, 1.0);
    final dueText = _dueText(srsCard, l);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PillBadge(
              label: stateLabel,
              color: stateColor,
              background: stateColor.withValues(alpha: 0.12),
            ),
            if (dueText != null) ...[
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                dueText,
                style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
              ),
            ],
            if (srsCard != null) ...[
              const Spacer(),
              Text(
                '${stability.toStringAsFixed(1)}d',
                style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant),
              ),
            ],
          ],
        ),
        if (srsCard != null) ...[
          const SizedBox(height: AppDimens.spaceSm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusXs),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: t.outlineVariant,
              color: stateColor,
              minHeight: 6,
            ),
          ),
        ],
      ],
    );
  }

  String? _dueText(Card? card, AppLocalizations l) {
    if (card == null) return null;
    final now = DateTime.now();
    final due = card.due.toLocal();
    final diff = due.difference(now).inDays;
    if (diff <= 0) return l.srsDueToday;
    return l.srsDueIn(diff);
  }
}
