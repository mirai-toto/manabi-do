import 'dart:math' as math;

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
/// Width the due badge is sized to, so every deck row's pill matches.
///
/// Measured rather than hardcoded: the label is localised and respects the
/// user's text scale, so a fixed pixel value would clip in German or at large
/// font sizes. Sized for the widest thing the pill can show — a three-digit
/// due count, or the caught-up label plus its check.
double _pillWidth(BuildContext context, AppLocalizations l) {
  final style = AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w700);
  final scaler = MediaQuery.textScalerOf(context);
  final direction = Directionality.of(context);

  double textWidth(String value) {
    final painter = TextPainter(
      text: TextSpan(text: value, style: style),
      textDirection: direction,
      textScaler: scaler,
    )..layout();
    return painter.width;
  }

  final iconWidth =
      scaler.scale((style.fontSize ?? 12) + 2) + AppDimens.spaceXxs;
  final widest = [
    textWidth(l.nDue(999)),
    textWidth(l.deckCaughtUp) + iconWidth,
    textWidth(l.deckNotStarted) + iconWidth,
    textWidth(l.deckContinue) + iconWidth,
  ].reduce(math.max);
  return widest + PillBadge.paddingH * 2;
}

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
    final pillWidth = _pillWidth(context, l);
    final status = due > 0
        ? l.nDue(due)
        : newToday > 0
        ? (seen == 0 ? l.deckNotStarted : l.deckContinue)
        : l.deckCaughtUp;
    final counts = [
      if (seen > 0) '$known/$seen',
      if (newToday > 0) l.nNewToday(newToday),
    ].join(' · ');

    return Semantics(
      label: '$title, $counts, $status',
      button: true,
      excludeSemantics: true,
      child: TappableSurface(
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(
            color: t.outlineVariant,
            width: AppDimens.borderWidthContainer,
          ),
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
              const SizedBox(width: AppDimens.spaceSm),
              // Always a pill, so the row keeps its shape and the progress bar
              // gets the same width whether or not anything is due.
              //
              // What the pill answers is "is there anything to do here now?".
              // Reviews first, then new cards still available under today's
              // limit, and only then is "caught up" actually true — a deck with
              // eight cards you have never seen is not caught up.
              if (due > 0)
                PillBadge(
                  label: l.nDue(due),
                  color: color,
                  background: color.withValues(alpha: 0.15),
                  minWidth: pillWidth,
                )
              else if (newToday > 0)
                PillBadge(
                  label: seen == 0 ? l.deckNotStarted : l.deckContinue,
                  icon: Icons.play_arrow_rounded,
                  color: t.onPrimary,
                  background: t.primary,
                  minWidth: pillWidth,
                )
              else
                PillBadge(
                  label: l.deckCaughtUp,
                  icon: Icons.check_rounded,
                  color: t.onSurfaceVariant,
                  background: t.surfaceVariant,
                  minWidth: pillWidth,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
