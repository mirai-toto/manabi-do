import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card, Rating, Scheduler;
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/app_button.dart';
import '../common/speak_button.dart';

class Flashcard extends StatelessWidget {
  final String prompt;
  final String? promptSub;
  final String? reveal;
  final String? revealSub;
  final String speakText;
  final bool isRevealed;
  final VoidCallback? onTap;

  const Flashcard({
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
  Widget build(BuildContext context) {
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

bool _looksJapanese(String text) {
  final runes = text.runes.where((r) => r > 0x20).toList();
  if (runes.isEmpty) return false;
  final jpCount = runes
      .where(
        (r) => (r >= 0x3040 && r <= 0x9FFF) || (r >= 0xF900 && r <= 0xFAFF),
      )
      .length;
  return jpCount / runes.length > 0.5;
}

class FlashcardActions extends StatelessWidget {
  final Card? card;
  final bool isFreeMode;
  final String? question;
  final void Function(Rating) onRate;

  const FlashcardActions({
    super.key,
    required this.card,
    required this.onRate,
    this.isFreeMode = false,
    this.question,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    Widget btn(String label, Rating rating, Color bg, Color fg) => Expanded(
      child: AppButton(
        label: label,
        subtitle: srsIntervalPreview(card, rating),
        backgroundColor: bg,
        foregroundColor: fg,
        radius: AppDimens.radiusLg,
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
        visualDensity: VisualDensity.standard,
        onPressed: () => onRate(rating),
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
            // Ratings are a semantic scale, not an accent. Again/Hard/Good
            // take error/warning/success; Easy needs a fourth that reads as
            // positive without being another green, hence `info`.
            btn(l.ratingEasy, Rating.easy, t.infoContainer, t.info),
          ],
        ),
      ],
    );
  }
}

/// How far out [rating] would push [card], as a short label.
///
/// Null for a card that has never been reviewed, where there is no interval to
/// preview yet.
String? srsIntervalPreview(Card? card, Rating rating) {
  if (card == null) return null;
  final preview = Scheduler().reviewCard(card, rating).card;
  final diff = preview.due.difference(DateTime.now());
  if (diff.inMinutes < 60) return '${diff.inMinutes.clamp(1, 59)}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  if (diff.inDays < 30) return '${diff.inDays}d';
  return '${(diff.inDays / 30).round()}mo';
}
