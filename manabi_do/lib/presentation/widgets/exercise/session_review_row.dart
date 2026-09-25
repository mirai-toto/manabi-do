import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card, Rating;

import '../../../core/models/practice_answer.dart';
import '../../../core/srs/srs_level.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/pill_badge.dart';
import '../common/review_progress_info.dart';
import 'flashcard.dart';

/// Glosses beyond this many are folded away behind "show all".
///
/// Meanings are stored as one `;`-separated string and 44% of the vocabulary
/// runs past a row's worth; the longest has 77 glosses. Four lines is enough to
/// recognise the word without the panel swallowing the list.
const int _kGlossesBeforeFold = 4;

/// One answered item in the session review: what was asked, what was answered,
/// how well it is known, and the grade it was given.
///
/// Expansion is driven from outside so the list can keep one row open at a
/// time; only the fold-out of a long meaning is this widget's own business.
class SessionReviewRow extends StatefulWidget {
  final PracticeSummary summary;
  final Rating rating;

  /// What the user picked. Null for a self-assessed exercise.
  final String? given;

  /// Wrong strokes, for a writing item.
  final int? mistakes;

  /// The card as it stood before the session, which is what the mastery block
  /// and the interval previews are read from.
  final Card? card;

  final bool isExpanded;
  final VoidCallback onToggle;

  /// Null where a grade cannot be changed — free practice writes nothing back,
  /// so the panel shows what happened without offering to re-score it.
  final void Function(Rating)? onRegrade;

  /// Opens the item's own screen. Null when the item has no detail screen,
  /// which today is everything except kanji.
  final VoidCallback? onDetailTap;

  const SessionReviewRow({
    super.key,
    required this.summary,
    required this.rating,
    required this.card,
    required this.isExpanded,
    required this.onToggle,
    this.onRegrade,
    this.given,
    this.mistakes,
    this.onDetailTap,
  });

  @override
  State<SessionReviewRow> createState() => _SessionReviewRowState();
}

class _SessionReviewRowState extends State<SessionReviewRow> {
  bool _showAllGlosses = false;

  bool get _isCorrect => widget.rating != Rating.again;

  List<String> get _glosses => widget.summary.answer
      .split(RegExp(r'\s*;\s*'))
      .where((g) => g.isNotEmpty)
      .toList();

  @override
  void didUpdateWidget(SessionReviewRow old) {
    super.didUpdateWidget(old);
    // Closing the row forgets the fold-out, so reopening starts short again.
    if (old.isExpanded && !widget.isExpanded) _showAllGlosses = false;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(
          color: widget.isExpanded ? t.primary : t.outlineVariant,
          width: widget.isExpanded ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          if (widget.isExpanded) _buildPanel(context),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final level = srsLevel(widget.card);
    final levelColor = level == SrsLevel.newCard
        ? t.onSurfaceVariant
        : level.accent;

    return Semantics(
      label: '${widget.summary.item}, ${widget.summary.answer}',
      button: true,
      toggled: widget.isExpanded,
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onToggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spaceCozy,
              AppDimens.spaceSnug,
              AppDimens.spaceSm,
              AppDimens.spaceSnug,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // The item gets the full text column: the longest word in
                      // the database is 10 characters and still fits here.
                      Text(
                        widget.summary.item,
                        style: AppTextStyles.jpBodyLarge.copyWith(
                          color: t.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimens.spaceXxs),
                      Text(
                        widget.summary.answer,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: t.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimens.spaceXs),
                      Row(
                        children: [
                          PillBadge(
                            label: _levelLabel(level, l),
                            color: levelColor,
                            background: levelColor.withValues(alpha: 0.12),
                          ),
                          const SizedBox(width: AppDimens.spaceTight),
                          Flexible(
                            child: Text(
                              widget.summary.kindLabel(l),
                              style: AppTextStyles.labelSmall.copyWith(
                                color: t.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSm),
                PillBadge(
                  label: _ratingLabel(widget.rating, l),
                  icon: _isCorrect ? Icons.check_rounded : Icons.close_rounded,
                  color: _ratingColor(widget.rating, t),
                  background: _ratingBackground(widget.rating, t),
                ),
                AnimatedRotation(
                  turns: widget.isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: t.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Panel ──────────────────────────────────────────────────────────────────

  Widget _buildPanel(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final s = widget.summary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: t.surfaceContainerHigh,
        border: Border(
          top: BorderSide(
            color: t.outlineVariant,
            width: AppDimens.borderWidth,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceCozy,
        AppDimens.spaceMd,
        AppDimens.spaceCozy,
        AppDimens.spaceSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            s.question(l),
            style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
          ),
          if (s.reading != null) ...[
            const SizedBox(height: AppDimens.spaceXs),
            Text(
              s.reading!,
              style: AppTextStyles.jpBody.copyWith(color: t.onSurfaceVariant),
            ),
          ],
          if (s.sentence != null) ...[
            const SizedBox(height: AppDimens.spaceSm),
            Text(
              s.sentence!,
              style: AppTextStyles.jpBodyLarge.copyWith(color: t.onSurface),
            ),
            if (s.sentenceTranslation != null) ...[
              const SizedBox(height: AppDimens.spaceXs),
              Text(
                s.sentenceTranslation!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: t.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
          const SizedBox(height: AppDimens.spaceMd),
          ..._buildAnswers(context),
          const SizedBox(height: AppDimens.spaceMd),
          ReviewProgressInfo(srsCard: widget.card),
          if (widget.onRegrade != null) ...[
            const SizedBox(height: AppDimens.spaceMd),
            Text(
              l.sessionReviewChangeGrade,
              style: AppTextStyles.labelSmall.copyWith(
                color: t.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceXs),
            ..._buildGrades(context),
          ],
          if (widget.onDetailTap != null)
            Center(
              child: TextButton.icon(
                onPressed: widget.onDetailTap,
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: Text(l.viewDetail),
                style: TextButton.styleFrom(
                  foregroundColor: t.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// The answer blocks. A correct answer collapses to one: "what you picked"
  /// and "what was right" are the same text, and printing it twice reads as a
  /// mistake.
  List<Widget> _buildAnswers(BuildContext context) {
    final l = context.l10n;
    final s = widget.summary;

    if (widget.given == null) {
      // Self-assessed. There is no choice to show, only how the attempt went.
      return [
        if (widget.mistakes != null)
          Text(
            l.drawingMistakeCount(widget.mistakes!),
            style: AppTextStyles.body.copyWith(
              color: widget.mistakes == 0
                  ? context.tokens.success
                  : context.tokens.error,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        _AnswerBlock(
          label: l.sessionReviewCorrectAnswer,
          isCorrect: true,
          glosses: _glosses,
          showAll: _showAllGlosses,
          onToggleGlosses: _toggleGlosses,
        ),
      ];
    }

    if (widget.given == s.answer) {
      return [
        _AnswerBlock(
          label: l.sessionReviewYourAnswer,
          isCorrect: true,
          glosses: _glosses,
          showAll: _showAllGlosses,
          onToggleGlosses: _toggleGlosses,
        ),
      ];
    }

    return [
      _AnswerBlock(
        label: l.sessionReviewYourAnswer,
        isCorrect: false,
        glosses: [widget.given!],
        showAll: true,
        onToggleGlosses: null,
      ),
      const SizedBox(height: AppDimens.spaceSm),
      _AnswerBlock(
        label: l.sessionReviewCorrectAnswer,
        isCorrect: true,
        glosses: _glosses,
        showAll: _showAllGlosses,
        onToggleGlosses: _toggleGlosses,
      ),
    ];
  }

  VoidCallback? get _toggleGlosses => _glosses.length > _kGlossesBeforeFold
      ? () => setState(() => _showAllGlosses = !_showAllGlosses)
      : null;

  /// The grades on offer, mirroring what the exercise itself asked for: an
  /// exercise that marked its own answer gets correct and incorrect, one the
  /// user judged keeps the full scale.
  List<Widget> _buildGrades(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    Widget btn(String label, Rating rating, Color bg, Color fg) => Expanded(
      child: RatingButton(
        label: label,
        interval: srsIntervalPreview(widget.card, rating),
        bgColor: bg,
        fgColor: fg,
        selected: widget.rating == rating,
        onTap: () => widget.onRegrade!(rating),
      ),
    );

    if (!widget.summary.selfAssessed) {
      return [
        Row(
          children: [
            btn(l.ratingIncorrect, Rating.again, t.errorContainer, t.error),
            const SizedBox(width: AppDimens.spaceSm),
            btn(l.ratingCorrect, Rating.good, t.successContainer, t.success),
          ],
        ),
      ];
    }

    return [
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
          btn(l.ratingEasy, Rating.easy, t.infoContainer, t.info),
        ],
      ),
    ];
  }

  // ── Labels ─────────────────────────────────────────────────────────────────

  String _levelLabel(SrsLevel level, AppLocalizations l) => switch (level) {
    SrsLevel.newCard => l.srsStateNew,
    SrsLevel.learning => l.srsStateLearning,
    SrsLevel.apprentice => l.srsStateApprentice,
    SrsLevel.familiar => l.srsStateFamiliar,
    SrsLevel.mastered => l.srsStateMastered,
    SrsLevel.expert => l.srsStateExpert,
  };

  String _ratingLabel(Rating rating, AppLocalizations l) => switch (rating) {
    Rating.again => l.ratingAgain,
    Rating.hard => l.ratingHard,
    Rating.good => l.ratingGood,
    Rating.easy => l.ratingEasy,
  };

  Color _ratingColor(Rating rating, AppTokens t) => switch (rating) {
    Rating.again => t.error,
    Rating.hard => t.warning,
    Rating.good => t.success,
    Rating.easy => t.info,
  };

  Color _ratingBackground(Rating rating, AppTokens t) => switch (rating) {
    Rating.again => t.errorContainer,
    Rating.hard => t.warningContainer,
    Rating.good => t.successContainer,
    Rating.easy => t.infoContainer,
  };
}

/// A bordered answer, folded down to [_kGlossesBeforeFold] entries when there
/// are more than that.
class _AnswerBlock extends StatelessWidget {
  final String label;
  final bool isCorrect;
  final List<String> glosses;
  final bool showAll;

  /// Null when there is nothing folded away.
  final VoidCallback? onToggleGlosses;

  const _AnswerBlock({
    required this.label,
    required this.isCorrect,
    required this.glosses,
    required this.showAll,
    required this.onToggleGlosses,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final color = isCorrect ? t.success : t.error;
    final shown = showAll || onToggleGlosses == null
        ? glosses
        : glosses.take(_kGlossesBeforeFold).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelXs.copyWith(color: t.onSurfaceVariant),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Container(
          padding: const EdgeInsets.all(AppDimens.spaceSnug),
          decoration: BoxDecoration(
            color: isCorrect ? t.successContainer : t.errorContainer,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: Border.all(color: color, width: AppDimens.borderWidth),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isCorrect ? Icons.check_rounded : Icons.close_rounded,
                size: 18,
                color: color,
              ),
              const SizedBox(width: AppDimens.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      shown.join('; '),
                      style: AppTextStyles.body.copyWith(color: color),
                    ),
                    if (onToggleGlosses != null) ...[
                      const SizedBox(height: AppDimens.spaceXs),
                      GestureDetector(
                        onTap: onToggleGlosses,
                        child: Semantics(
                          button: true,
                          child: Text(
                            showAll
                                ? l.sessionReviewShowLess
                                : l.sessionReviewShowAll(glosses.length),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
