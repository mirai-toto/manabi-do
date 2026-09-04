import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/app_button.dart';

/// Hero card summarising everything due today, with one button to start a
/// combined review session. Shows a caught-up message when nothing is due.
class TodaysSessionCard extends StatelessWidget {
  final int kanaDue;
  final int kanjiDue;
  final int vocabDue;
  final int newTotal;
  final VoidCallback onStart;

  const TodaysSessionCard({
    super.key,
    required this.kanaDue,
    required this.kanjiDue,
    required this.vocabDue,
    required this.newTotal,
    required this.onStart,
  });

  int get _dueTotal => kanaDue + kanjiDue + vocabDue;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.tokens;
    final hasWork = _dueTotal > 0 || newTotal > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: t.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.todaysSession.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              color: t.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          if (hasWork) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$_dueTotal',
                  style: AppTextStyles.display.copyWith(
                    color: t.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSm),
                Expanded(
                  child: Text(
                    '${l.reviewsDueUnit(_dueTotal)} · ${l.nNew(newTotal)}',
                    style: AppTextStyles.body.copyWith(
                      color: t.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceSm),
            Row(
              children: [
                _DomainChip(glyph: 'か', count: kanaDue),
                const SizedBox(width: AppDimens.spaceSm),
                _DomainChip(glyph: '字', count: kanjiDue),
                const SizedBox(width: AppDimens.spaceSm),
                _DomainChip(glyph: '語', count: vocabDue),
              ],
            ),
            const SizedBox(height: AppDimens.spaceMd),
            AppButton(
              label: l.startReviews,
              fullWidth: true,
              onPressed: onStart,
            ),
          ] else ...[
            Text(
              l.allCaughtUp,
              style: AppTextStyles.headline.copyWith(color: t.onSurface),
            ),
            const SizedBox(height: AppDimens.spaceXxs),
            Text(
              l.allCaughtUpSubtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: t.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DomainChip extends StatelessWidget {
  final String glyph;
  final int count;

  const _DomainChip({required this.glyph, required this.count});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.badgePaddingH,
        vertical: AppDimens.badgePaddingV,
      ),
      decoration: BoxDecoration(
        color: t.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      ),
      child: Text(
        '$glyph $count',
        style: AppTextStyles.labelSmall.copyWith(
          color: t.primary,
          fontWeight: FontWeight.w600,
          fontFamilyFallback: const ['NotoSansJP'],
        ),
      ),
    );
  }
}
