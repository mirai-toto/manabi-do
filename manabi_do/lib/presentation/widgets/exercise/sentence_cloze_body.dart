import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card, Rating;

import '../../../core/models/sentence_settings.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import 'flashcard.dart';
import 'mcq_card.dart';
import 'practice_progress_row.dart';
import 'sentence_cloze_card.dart';

class SentenceClozeBody extends StatefulWidget {
  final Sentence sentence;
  final String? translation;
  final String? targetReading;
  final List<McqOption> options;
  final int correctIndex;
  final Card? card;
  final bool isFreeMode;
  final int index;
  final int total;
  final Color color;
  final void Function(Rating) onAnswer;

  /// Advance to the next sentence on its own after the answer is revealed.
  /// Only takes effect in free mode.
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
    this.isFreeMode = false,
    this.translation,
    this.targetReading,
  });

  @override
  State<SentenceClozeBody> createState() => _SentenceClozeBodyState();
}

class _SentenceClozeBodyState extends State<SentenceClozeBody> {
  late List<McqOptionState> _states;
  bool _answered = false;
  bool _autoAdvancing = false;
  bool _showTranslation = false;

  @override
  void initState() {
    super.initState();
    _states = List.filled(widget.options.length, McqOptionState.idle);
  }

  void _onTap(int i) {
    if (_answered) return;
    final isCorrect = i == widget.correctIndex;
    setState(() {
      _answered = true;
      _states = List.generate(widget.options.length, (j) {
        if (j == i) {
          return isCorrect ? McqOptionState.correct : McqOptionState.wrong;
        }
        if (!isCorrect && j == widget.correctIndex) {
          return McqOptionState.correct;
        }
        return McqOptionState.idle;
      });
    });
    if (widget.isFreeMode && widget.autoAdvance) {
      setState(() => _autoAdvancing = true);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) widget.onAnswer(isCorrect ? Rating.good : Rating.again);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final options = List.generate(
      widget.options.length,
      (i) => widget.options[i].copyWith(state: _states[i]),
    );

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
            showTranslation: effectiveShowTranslation,
            onToggleTranslation: toggleCallback,
            showSentenceFurigana: widget.showSentenceFurigana,
            showChoiceFurigana: widget.showChoiceFurigana,
            targetReading: widget.targetReading,
            options: options,
            answered: _answered,
            color: widget.color,
            onOptionTap: _answered ? null : _onTap,
          ),
          if (_answered && !_autoAdvancing) ...[
            const SizedBox(height: AppDimens.spaceMd),
            FlashcardActions(
              card: widget.card,
              isFreeMode: widget.isFreeMode,
              question: l.selfAssessQuestion,
              onRate: widget.onAnswer,
            ),
          ],
        ],
      ),
    );
  }
}
