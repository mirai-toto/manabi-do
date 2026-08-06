import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating;

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/mcq_settings_provider.dart';
import 'flash_card.dart';
import 'mcq_card.dart';
import 'practice_progress_row.dart';

class PracticeMcqBody extends ConsumerStatefulWidget {
  final String question;
  final String? japanesePrompt;
  final String? japaneseReading;
  final List<McqOption> options;
  final int correctIndex;
  final Card? card;
  final bool isFreeMode;
  final int index;
  final int total;
  final Color color;
  final void Function(Rating) onAnswer;
  final VoidCallback? onDetailTap;
  final bool compactGrid;

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
    this.isFreeMode = false,
    this.japanesePrompt,
    this.japaneseReading,
    this.onDetailTap,
    this.compactGrid = false,
  });

  @override
  ConsumerState<PracticeMcqBody> createState() => _PracticeMcqBodyState();
}

class _PracticeMcqBodyState extends ConsumerState<PracticeMcqBody> {
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
    if (widget.isFreeMode && ref.read(mcqSettingsProvider).autoAdvance) {
      setState(() => _autoAdvancing = true);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) widget.onAnswer(isCorrect ? Rating.good : Rating.again);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = List.generate(
      widget.options.length,
      (i) => widget.options[i].copyWith(state: _states[i]),
    );

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
            question: widget.question,
            japanesePrompt: widget.japanesePrompt,
            japaneseReading: widget.japaneseReading,
            options: options,
            onOptionTap: _answered ? null : _onTap,
            compactGrid: widget.compactGrid,
            showFurigana: ref.watch(
              mcqSettingsProvider.select((s) => s.showPromptFurigana),
            ),
          ),
          if (_answered && !_autoAdvancing) ...[
            const SizedBox(height: AppDimens.spaceMd),
            FlashCardActions(
              card: widget.card,
              isFreeMode: widget.isFreeMode,
              question: context.l10n.selfAssessQuestion,
              onRate: widget.onAnswer,
            ),
            if (widget.onDetailTap != null) ...[
              const SizedBox(height: AppDimens.spaceSm),
              TextButton.icon(
                onPressed: widget.onDetailTap,
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: Text(context.l10n.viewDetail),
                style: TextButton.styleFrom(
                  foregroundColor: context.tokens.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
