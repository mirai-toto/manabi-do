import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Rating;

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/exercise/flash_card.dart';
import '../../widgets/exercise/mcq_card.dart';

class GrammarClozeBody extends StatefulWidget {
  /// Sentence text with "___" marking the blank.
  final String sentence;
  final List<McqOption> options;
  final int correctIndex;
  final int index;
  final int total;
  final Color color;
  final bool autoAdvance;
  final void Function(Rating) onAnswer;

  const GrammarClozeBody({
    super.key,
    required this.sentence,
    required this.options,
    required this.correctIndex,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
    this.autoAdvance = false,
  });

  @override
  State<GrammarClozeBody> createState() => _GrammarClozeBodyState();
}

class _GrammarClozeBodyState extends State<GrammarClozeBody> {
  late List<McqOptionState> _states;
  bool _answered = false;
  bool _autoAdvancing = false;

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
    if (widget.autoAdvance) {
      setState(() => _autoAdvancing = true);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) widget.onAnswer(isCorrect ? Rating.good : Rating.again);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final options = List.generate(
      widget.options.length,
      (i) => widget.options[i].copyWith(state: _states[i]),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: widget.index / widget.total,
                  backgroundColor: t.outlineVariant,
                  color: widget.color,
                  borderRadius: BorderRadius.circular(AppDimens.radiusXs),
                ),
              ),
              const SizedBox(width: AppDimens.spaceXs),
              Text(
                '${widget.index + 1} / ${widget.total}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: t.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceLg),
          _ClozeSentence(
            sentence: widget.sentence,
            color: widget.color,
            answered: _answered,
            correctAnswer: widget.options[widget.correctIndex].text,
          ),
          const SizedBox(height: AppDimens.spaceLg),
          McqCard(
            question: context.l10n.sentenceFillInPrompt,
            options: options,
            onOptionTap: _answered ? null : _onTap,
          ),
          if (_answered && !_autoAdvancing) ...[
            const SizedBox(height: AppDimens.spaceMd),
            FlashCardActions(
              card: null,
              isFreeMode: true,
              question: context.l10n.selfAssessQuestion,
              onRate: widget.onAnswer,
            ),
          ],
        ],
      ),
    );
  }
}

class _ClozeSentence extends StatelessWidget {
  final String sentence;
  final Color color;
  final bool answered;
  final String correctAnswer;

  const _ClozeSentence({
    required this.sentence,
    required this.color,
    required this.answered,
    required this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final parts = sentence.split('___');
    final before = parts.isNotEmpty ? parts[0] : '';
    final after = parts.length > 1 ? parts[1] : '';

    final baseStyle = AppTextStyles.jpMedium.copyWith(
      color: t.onSurface,
      height: 1.6,
    );

    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: t.surfaceContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: before, style: baseStyle),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: answered
                      ? color.withValues(alpha: 0.15)
                      : t.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                  border: Border.all(color: color, width: answered ? 1.5 : 1),
                ),
                child: Text(
                  answered ? correctAnswer : '　　',
                  style: baseStyle.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            TextSpan(text: after, style: baseStyle),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
