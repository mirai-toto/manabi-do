import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card, Rating;

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/grammar/grammar_models.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/exercise/example_card.dart';
import '../../widgets/exercise/flash_card.dart';

class PracticeFlashcardBody extends StatefulWidget {
  final String japanese;
  final String? label;
  final String answer;
  final bool isReversed;
  final Card? card;
  final bool isFreeMode;
  final int index;
  final int total;
  final Color color;
  final void Function(Rating) onAnswer;
  final VoidCallback? onDetailTap;
  final GrammarExample? example;
  final String locale;
  final String? questionOverride;

  const PracticeFlashcardBody({
    super.key,
    required this.japanese,
    required this.answer,
    required this.card,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
    this.isFreeMode = false,
    this.label,
    this.isReversed = false,
    this.onDetailTap,
    this.example,
    this.locale = 'en',
    this.questionOverride,
  });

  @override
  State<PracticeFlashcardBody> createState() => _PracticeFlashcardBodyState();
}

class _PracticeFlashcardBodyState extends State<PracticeFlashcardBody> {
  bool _revealed = false;
  bool _everRevealed = false;

  void _onTap() {
    setState(() {
      _revealed = !_revealed;
      _everRevealed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    final String question;
    final String prompt;
    final String? promptSub;
    final String? reveal;
    final String? revealSub;

    if (widget.isReversed) {
      question = widget.questionOverride ?? l.flashcardJapaneseQuestion;
      prompt = widget.answer;
      promptSub = null;
      reveal = widget.japanese;
      revealSub = widget.label;
    } else {
      question = widget.questionOverride ?? l.flashcardDefaultPrompt;
      prompt = widget.japanese;
      promptSub = widget.label;
      reveal = widget.answer;
      revealSub = null;
    }

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
          Text(
            question,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: t.onSurface,
            ),
          ),
          const SizedBox(height: AppDimens.spaceMd),
          FlashCard(
            prompt: prompt,
            promptSub: promptSub,
            reveal: reveal,
            revealSub: revealSub,
            speakText: widget.japanese,
            isRevealed: _revealed,
            onTap: _onTap,
          ),
          if (widget.example != null) ...[
            const SizedBox(height: AppDimens.spaceMd),
            ExampleCard(
              example: widget.example!,
              locale: widget.locale,
              showTranslation: _revealed,
            ),
          ],
          if (_everRevealed) ...[
            const SizedBox(height: AppDimens.spaceMd),
            FlashCardActions(
              card: widget.card,
              isFreeMode: widget.isFreeMode,
              question: l.selfAssessQuestion,
              onRate: widget.onAnswer,
            ),
            if (widget.onDetailTap != null) ...[
              const SizedBox(height: AppDimens.spaceSm),
              TextButton.icon(
                onPressed: widget.onDetailTap,
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: Text(l.viewDetail),
                style: TextButton.styleFrom(
                  foregroundColor: t.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
