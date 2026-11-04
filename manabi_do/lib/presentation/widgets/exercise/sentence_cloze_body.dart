import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card;

import '../../../core/models/practice_answer.dart';
import '../../../core/models/sentence_settings.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import 'flashcard.dart';
import 'choice_answer.dart';
import 'mcq_card.dart';
import 'practice_progress_row.dart';
import 'sentence_cloze_card.dart';

/// Sentence-level cloze exercise. Fetches per-card SRS state, renders
/// `SentenceClozeCard`, and handles rating.
class SentenceClozeBody extends StatefulWidget {
  final Sentence sentence;
  final String? translation;
  final String? translationMissingLanguage;
  final String? targetReading;
  final List<McqOption> options;
  final int correctIndex;
  final Card? card;
  final bool fourPointGrading;
  final Color? gradeAccent;
  final int index;
  final int total;
  final Color color;
  final AnswerCallback onAnswer;

  /// Move on once the answer is in, deriving the rating from it, instead of
  /// stopping for a self-assessment. The caller decides which setting feeds
  /// this: free practice has one per exercise, a review has one per session.
  final bool autoAdvance;
  final TranslationMode translationMode;
  final bool showSentenceFurigana;
  final bool showChoiceFurigana;

  const SentenceClozeBody({
    super.key,
    required this.sentence,
    required this.options,
    required this.correctIndex,
    required this.card,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
    required this.autoAdvance,
    required this.translationMode,
    required this.showSentenceFurigana,
    required this.showChoiceFurigana,
    required this.fourPointGrading,
    this.gradeAccent,
    this.translation,
    this.translationMissingLanguage,
    this.targetReading,
  });

  @override
  State<SentenceClozeBody> createState() => _SentenceClozeBodyState();
}

class _SentenceClozeBodyState extends State<SentenceClozeBody>
    with ChoiceAnswer<SentenceClozeBody> {
  bool _showTranslation = false;

  void _onTap(int i) => answerChoice(
    i,
    options: widget.options,
    correctIndex: widget.correctIndex,
    autoAdvance: widget.autoAdvance,
    onAnswer: widget.onAnswer,
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final options = withAnswerStates(widget.options);

    final bool effectiveShowTranslation = switch (widget.translationMode) {
      TranslationMode.always => true,
      TranslationMode.onDemand => _showTranslation,
      TranslationMode.never => false,
    };
    final VoidCallback? toggleCallback =
        (widget.translationMode == TranslationMode.onDemand &&
            widget.translation != null)
        ? () => setState(() => _showTranslation = !_showTranslation)
        : null;
    final String? effectiveTranslation =
        widget.translationMode == TranslationMode.never
        ? null
        : widget.translation;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PracticeProgressRow(
            index: widget.index,
            total: widget.total,
            color: widget.color,
          ),
          const SizedBox(height: AppDimens.spaceLg),
          SentenceClozeCard(
            sentence: widget.sentence,
            translation: effectiveTranslation,
            translationMissingLanguage: widget.translationMissingLanguage,
            showTranslation: effectiveShowTranslation,
            onToggleTranslation: toggleCallback,
            showSentenceFurigana: widget.showSentenceFurigana,
            showChoiceFurigana: widget.showChoiceFurigana,
            targetReading: widget.targetReading,
            options: options,
            answered: answered,
            color: widget.color,
            onOptionTap: answered ? null : _onTap,
          ),
          if (answered && !autoAdvancing) ...[
            const SizedBox(height: AppDimens.spaceMd),
            FlashcardActions(
              card: widget.card,
              fourPointGrading: widget.fourPointGrading,
              gradeAccent: widget.gradeAccent,
              question: l.selfAssessQuestion,
              onRate: (rating) => widget.onAnswer(rating, given: given),
            ),
          ],
        ],
      ),
    );
  }
}
