import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card;

import '../../../core/models/practice_answer.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../l10n/l10n.dart';
import 'view_detail_button.dart';
import 'flashcard.dart';
import 'choice_answer.dart';
import 'mcq_card.dart';
import 'practice_progress_row.dart';

/// Multiple-choice exercise body. Renders `McqCard` options and advances on
/// selection.
class PracticeMcqBody extends StatefulWidget {
  final String question;
  final String? japanesePrompt;
  final String? japaneseReading;
  final List<McqOption> options;
  final int correctIndex;
  final Card? card;
  final bool fourPointGrading;
  final Color? gradeAccent;
  final int index;
  final int total;
  final Color color;
  final AnswerCallback onAnswer;
  final VoidCallback? onDetailTap;
  final bool compactGrid;

  /// Move on once the answer is in, deriving the rating from it, instead of
  /// stopping for a self-assessment. The caller decides which setting feeds
  /// this: free practice has one per exercise, a review has one per session.
  final bool autoAdvance;
  final bool showPromptFurigana;

  const PracticeMcqBody({
    super.key,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.card,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
    required this.autoAdvance,
    required this.showPromptFurigana,
    required this.fourPointGrading,
    this.gradeAccent,
    this.japanesePrompt,
    this.japaneseReading,
    this.onDetailTap,
    this.compactGrid = false,
  });

  @override
  State<PracticeMcqBody> createState() => _PracticeMcqBodyState();
}

class _PracticeMcqBodyState extends State<PracticeMcqBody>
    with ChoiceAnswer<PracticeMcqBody> {
  void _onTap(int i) => answerChoice(
    i,
    options: widget.options,
    correctIndex: widget.correctIndex,
    autoAdvance: widget.autoAdvance,
    onAnswer: widget.onAnswer,
  );

  @override
  Widget build(BuildContext context) {
    final options = withAnswerStates(widget.options);

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
          McqCard(
            badgeLabel: context.l10n.multipleChoice,
            question: widget.question,
            japanesePrompt: widget.japanesePrompt,
            japaneseReading: widget.japaneseReading,
            options: options,
            onOptionTap: answered ? null : _onTap,
            compactGrid: widget.compactGrid,
            showFurigana: widget.showPromptFurigana,
          ),
          if (answered && !autoAdvancing) ...[
            const SizedBox(height: AppDimens.spaceMd),
            FlashcardActions(
              card: widget.card,
              fourPointGrading: widget.fourPointGrading,
              gradeAccent: widget.gradeAccent,
              question: context.l10n.selfAssessQuestion,
              onRate: (rating) => widget.onAnswer(rating, given: given),
            ),
            if (widget.onDetailTap != null) ...[
              const SizedBox(height: AppDimens.spaceSm),
              ViewDetailButton(
                label: context.l10n.viewDetail,
                onPressed: widget.onDetailTap,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
