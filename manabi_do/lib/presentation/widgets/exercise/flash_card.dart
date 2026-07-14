import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating, Scheduler;
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/speak_button.dart';

class FlashCard extends ConsumerWidget {
  final String prompt;
  final String? promptSub;
  final String? reveal;
  final String? revealSub;
  final String speakText;
  final bool isRevealed;
  final VoidCallback? onTap;

  const FlashCard({
    super.key,
    required this.prompt,
    required this.speakText,
    this.promptSub,
    this.reveal,
    this.revealSub,
    this.isRevealed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final content = isRevealed ? (reveal ?? '') : prompt;
    final contentSub = isRevealed ? revealSub : promptSub;
    final isJapanese = isRevealed
        ? (revealSub != null || _looksJapanese(reveal ?? ''))
        : _looksJapanese(prompt);

    return Semantics(
      label: isRevealed ? '$prompt: ${reveal ?? ""}' : prompt,
      button: true,
      excludeSemantics: true,
      child: Container(
        height: 220,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [context.tokens.primary, context.tokens.primaryLight],
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
          boxShadow: [
            BoxShadow(
              color: context.tokens.primary.withValues(alpha: 0.35),
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.spaceLg,
                      AppDimens.spaceMd,
                      AppDimens.spaceLg,
                      AppDimens.spaceLg,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (contentSub != null) ...[
                          Text(
                            contentSub,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppDimens.spaceXs),
                        ],
                        Text(
                          content,
                          style: isJapanese
                              ? AppTextStyles.jpFlash.copyWith(
                                  color: Colors.white,
                                )
                              : AppTextStyles.titleLarge.copyWith(
                                  color: Colors.white,
                                ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: AppDimens.spaceSm,
                  right: AppDimens.spaceSm,
                  child: SpeakButton(
                    text: speakText,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                Positioned(
                  bottom: AppDimens.spaceMd,
                  left: 0,
                  right: 0,
                  child: Text(
                    isRevealed ? l.tapToHide : l.tapToReveal,
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

bool _looksJapanese(String text) => text.runes.any(
  (r) => (r >= 0x3040 && r <= 0x9FFF) || (r >= 0xF900 && r <= 0xFAFF),
);

class FlashCardActions extends StatelessWidget {
  final Card? card;
  final bool isFreeMode;
  final String? question;
  final void Function(Rating) onRate;

  const FlashCardActions({
    super.key,
    required this.card,
    required this.onRate,
    this.isFreeMode = false,
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

    String? interval(Rating rating) {
      if (card == null) return null;
      final s = Scheduler();
      return _fmt(s.reviewCard(card!, rating).card);
    }

    Widget btn(String label, Rating rating, Color bg, Color fg) => Expanded(
      child: _RatingButton(
        label: label,
        interval: interval(rating),
        bgColor: bg,
        fgColor: fg,
        onTap: () => onRate(rating),
      ),
    );

    if (isFreeMode) {
      return Row(
        children: [
          btn(l.flashcardNotYet, Rating.again, t.errorContainer, t.error),
          const SizedBox(width: AppDimens.spaceSm),
          btn(l.flashcardGotIt, Rating.good, t.successContainer, t.success),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (question != null) ...[
          Text(
            question!,
            style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spaceXs),
        ],
        Row(
          children: [
            btn(l.ratingAgain, Rating.again, t.errorContainer, t.error),
            const SizedBox(width: AppDimens.spaceSm),
            btn(l.ratingHard, Rating.hard, t.warningContainer, t.warning),
          ],
        ),
        const SizedBox(height: AppDimens.spaceSm),
        Row(
          children: [
            btn(l.ratingGood, Rating.good, t.successContainer, t.success),
            const SizedBox(width: AppDimens.spaceSm),
            btn(l.ratingEasy, Rating.easy, t.primaryContainer, t.primary),
          ],
        ),
      ],
    );
  }
}

class _RatingButton extends StatelessWidget {
  final String label;
  final String? interval;
  final Color bgColor;
  final Color fgColor;
  final VoidCallback? onTap;

  const _RatingButton({
    required this.label,
    required this.bgColor,
    required this.fgColor,
    this.interval,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Semantics(
    label: interval != null ? '$label $interval' : label,
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
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelLarge.copyWith(color: fgColor),
                ),
                if (interval != null)
                  Text(
                    interval!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: fgColor.withValues(alpha: 0.75),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
