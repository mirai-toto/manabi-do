import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/pill_badge.dart';
import '../common/progress_bar.dart';
import '../common/tappable_surface.dart';

/// One study domain on the home screen: glyph, known/seen progress,
/// new-today count, and a due badge. Tapping starts the domain's
/// practice session; browsing the domain stays on the bottom nav.
class DeckRow extends StatelessWidget {
  final String title;
  final String glyph;
  final Color color;
  final int known;
  final int seen;
  final int newToday;
  final int due;
  final VoidCallback onTap;

  const DeckRow({
    super.key,
    required this.title,
    required this.glyph,
    required this.color,
    required this.known,
    required this.seen,
    required this.newToday,
    required this.due,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final counts = [
      if (seen > 0) '$known/$seen',
      if (newToday > 0) l.nNewToday(newToday),
    ].join(' · ');

    return Semantics(
      label: '$title, $counts, ${l.nDue(due)}',
      button: true,
      excludeSemantics: true,
      child: TappableSurface(
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(color: t.outlineVariant),
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                ),
                child: Center(
                  child: Text(
                    glyph,
                    style: AppTextStyles.jpBodyLarge.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.iconTextGap),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        color: t.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (counts.isNotEmpty) ...[
                      const SizedBox(height: AppDimens.spaceXxs),
                      Text(
                        counts,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: t.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppDimens.spaceSm),
                    AppProgressBar(
                      progress: seen > 0 ? known / seen : 0,
                      color: color,
                      height: 4,
                    ),
                  ],
                ),
              ),
              if (due > 0) ...[
                const SizedBox(width: AppDimens.spaceSm),
                PillBadge(
                  label: l.nDue(due),
                  color: color,
                  background: color.withValues(alpha: 0.15),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
