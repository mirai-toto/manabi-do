import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card, Rating;
import '../common/decoration/slide_in.dart';
import '../../../core/theme/srs_level_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/srs/interval_preview.dart';
import '../../../l10n/interval_label.dart';
import '../../../l10n/l10n.dart';
import '../common/action/app_button.dart';
import '../common/action/speak_button.dart';

/// Large gradient card showing a prompt and, when revealed, an answer. Includes
/// a `SpeakButton` and a tap-to-reveal/hide label.
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

/// The grade buttons: Again / Hard / Good / Easy, or a pass/fail pair when
/// [fourPointGrading] is off. Each previews the interval it would schedule for
/// [card]. Shown after a flashcard is revealed and when regrading an answer in
/// the session review.
class FlashcardActions extends StatelessWidget {
  final Card? card;
  final bool fourPointGrading;

  /// Paint every grade this colour instead of reading the rating ramp.
  /// Free practice passes the level's colour: it keeps the session of a
  /// piece, and a grade that is not the ramp's colour is a quiet reminder
  /// that nothing is being recorded. Null uses the ramp.
  final Color? gradeAccent;
  final String? question;

  /// The grade already given, ringed so it can be seen before changing it.
  final Rating? selected;

  /// Labels for the pass/fail pair. Null uses "Not yet" / "Got it".
  final ({String fail, String pass})? passFailLabels;
  final void Function(Rating) onRate;

  const FlashcardActions({
    super.key,
    required this.card,
    required this.onRate,
    required this.fourPointGrading,
    this.gradeAccent,
    this.question,
    this.selected,
    this.passFailLabels,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final brightness = Theme.of(context).brightness;
    final failLabel = passFailLabels?.fail ?? l.flashcardNotYet;
    final passLabel = passFailLabels?.pass ?? l.flashcardGotIt;

    Widget btn(
      String label,
      Rating rating, {
      required Color background,
      required Color foreground,
      BorderSide side = BorderSide.none,
    }) => Expanded(
      child: AppButton(
        label: label,
        subtitle: switch (srsIntervalPreview(card, rating)) {
          final Duration interval => intervalLabel(interval, l),
          null => null,
        },
        backgroundColor: background,
        foregroundColor: foreground,
        // Null when nothing was given yet, so the buttons are not announced
        // as unselected toggles.
        selected: selected == null ? null : selected == rating,
        side: selected == rating
            ? BorderSide(
                color: foreground,
                width: AppDimens.borderWidthSelected,
              )
            : side,
        radius: AppDimens.radiusLg,
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
        visualDensity: VisualDensity.standard,
        onPressed: () => onRate(rating),
      ),
    );

    // A recorded grade takes its colour from the JLPT ramp, so the scale reads
    // red-to-green like every other difficulty in the app.
    Widget rampBtn(String label, Rating rating, Color accent) => btn(
      label,
      rating,
      background: accentContainer(accent, brightness),
      foreground: onAccentContainer(accent, brightness),
    );

    if (!fourPointGrading) {
      final accent = gradeAccent;
      if (accent != null) {
        // Free practice: one level colour, split outlined and filled the way
        // the confirm dialog splits Cancel from its action. Same hue keeps the
        // session of a piece; the fill still marks which one is the pass.
        return Row(
          children: [
            btn(
              failLabel,
              Rating.again,
              background: Colors.transparent,
              foreground: accent,
              side: BorderSide(
                color: accent,
                width: AppDimens.borderWidthInteractive,
              ),
            ),
            const SizedBox(width: AppDimens.spaceSm),
            btn(
              passLabel,
              Rating.good,
              background: accent,
              foreground: onAccentFor(accent),
            ),
          ],
        );
      }
      return Row(
        children: [
          rampBtn(failLabel, Rating.again, twoPointRatingAccent(Rating.again)),
          const SizedBox(width: AppDimens.spaceSm),
          rampBtn(passLabel, Rating.good, twoPointRatingAccent(Rating.good)),
        ],
      );
    }

    // Rises into place when an answer brings it up, instead of popping in.
    return SlideIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (question != null) ...[
            Text(
              question!,
              style: AppTextStyles.labelSmall.copyWith(
                color: t.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceXs),
          ],
          Row(
            children: [
              rampBtn(l.ratingAgain, Rating.again, ratingAccent(Rating.again)),
              const SizedBox(width: AppDimens.spaceSm),
              rampBtn(l.ratingHard, Rating.hard, ratingAccent(Rating.hard)),
            ],
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Row(
            children: [
              rampBtn(l.ratingGood, Rating.good, ratingAccent(Rating.good)),
              const SizedBox(width: AppDimens.spaceSm),
              rampBtn(l.ratingEasy, Rating.easy, ratingAccent(Rating.easy)),
            ],
          ),
        ],
      ),
    );
  }
}
