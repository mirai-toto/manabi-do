import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card, Rating, Scheduler;
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';

class FlashCard extends StatelessWidget {
  final String japanese;
  final String? label;
  final bool isRevealed;
  final String? answer;
  final VoidCallback? onTap;

  const FlashCard({
    super.key,
    required this.japanese,
    this.label,
    this.isRevealed = false,
    this.answer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final promptLabel = label ?? l.flashcardDefaultPrompt;

    return Semantics(
      label: isRevealed ? '$japanese: ${answer ?? ""}' : '$promptLabel $japanese',
      button: true,
      excludeSemantics: true,
      child: Container(
        height: 220,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [t.primary, t.primaryLight],
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
          boxShadow: [
            BoxShadow(
              color: t.primary.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white.withValues(alpha: 0.15),
            highlightColor: Colors.white.withValues(alpha: 0.08),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isRevealed) ...[
                        Text(
                          japanese,
                          style: AppTextStyles.jpFlash.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: AppDimens.spaceSm),
                        Text(
                          promptLabel,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ] else ...[
                        Text(
                          answer ?? '',
                          style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimens.spaceXs),
                        Text(
                          japanese,
                          style: AppTextStyles.jpBody.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!isRevealed)
                  Positioned(
                    bottom: AppDimens.spaceMd,
                    left: 0,
                    right: 0,
                    child: Text(
                      l.tapToReveal,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FlashCardActions extends StatelessWidget {
  final Card? card;
  final String? question;
  final void Function(Rating) onRate;

  const FlashCardActions({
    super.key,
    required this.card,
    required this.onRate,
    this.question,
  });

  String _fmt(Card preview) {
    final diff = preview.due.difference(DateTime.now());
    if (diff.inMinutes < 60) return '${diff.inMinutes.clamp(1, 59)}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 30) return '${diff.inDays}d';
    return '${(diff.inDays / 30).round()}mo';
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final fsrsCard = card ?? Card(cardId: DateTime.now().millisecondsSinceEpoch, due: DateTime.now());
    final s = Scheduler();
    final again = s.reviewCard(fsrsCard, Rating.again).card;
    final hard  = s.reviewCard(fsrsCard, Rating.hard).card;
    final good  = s.reviewCard(fsrsCard, Rating.good).card;
    final easy  = s.reviewCard(fsrsCard, Rating.easy).card;

    Widget btn(String label, String interval, Color bg, Color fg, Rating rating) => Expanded(
      child: _RatingButton(label: label, interval: interval, bgColor: bg, fgColor: fg, onTap: () => onRate(rating)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (question != null) ...[
          Text(question!, style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant), textAlign: TextAlign.center),
          const SizedBox(height: AppDimens.spaceXs),
        ],
        Row(children: [
          btn(l.ratingAgain, _fmt(again), t.errorContainer,   t.error,   Rating.again),
          const SizedBox(width: AppDimens.spaceSm),
          btn(l.ratingHard,  _fmt(hard),  t.warningContainer, t.warning, Rating.hard),
        ]),
        const SizedBox(height: AppDimens.spaceSm),
        Row(children: [
          btn(l.ratingGood, _fmt(good), t.successContainer, t.success, Rating.good),
          const SizedBox(width: AppDimens.spaceSm),
          btn(l.ratingEasy, _fmt(easy), t.primaryContainer, t.primary, Rating.easy),
        ]),
      ],
    );
  }
}

class _RatingButton extends StatelessWidget {
  final String label;
  final String interval;
  final Color bgColor;
  final Color fgColor;
  final VoidCallback? onTap;

  const _RatingButton({
    required this.label,
    required this.interval,
    required this.bgColor,
    required this.fgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label $interval',
    button: true,
    excludeSemantics: true,
    child: Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, textAlign: TextAlign.center, style: AppTextStyles.labelLarge.copyWith(color: fgColor)),
                Text(interval, textAlign: TextAlign.center, style: AppTextStyles.labelSmall.copyWith(color: fgColor.withValues(alpha: 0.75))),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
