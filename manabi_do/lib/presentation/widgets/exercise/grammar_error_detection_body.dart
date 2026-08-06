import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Rating;

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../widgets.dart';

class GrammarErrorDetectionBody extends StatefulWidget {
  final String correct;
  final String wrong;
  final String explanation;
  final int index;
  final int total;
  final Color color;
  final void Function(Rating) onAnswer;

  const GrammarErrorDetectionBody({
    super.key,
    required this.correct,
    required this.wrong,
    required this.explanation,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
  });

  @override
  State<GrammarErrorDetectionBody> createState() =>
      _GrammarErrorDetectionBodyState();
}

class _GrammarErrorDetectionBodyState extends State<GrammarErrorDetectionBody> {
  // Index 0 or 1 in _options; randomized so correct isn't always first
  late final int _correctSlot;
  late final List<String> _options;
  int? _tapped;

  @override
  void initState() {
    super.initState();
    _correctSlot = Random().nextBool() ? 0 : 1;
    _options = _correctSlot == 0
        ? [widget.correct, widget.wrong]
        : [widget.wrong, widget.correct];
  }

  bool get _answered => _tapped != null;
  bool get _tappedCorrect => _tapped == _correctSlot;

  void _onTap(int slot) {
    if (_answered) return;
    setState(() => _tapped = slot);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

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
          Text(
            l.grammarErrorDetectionPrompt,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: t.onSurface,
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 500;
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _SentenceCard(
                        sentence: _options[0],
                        slot: 0,
                        state: _cardState(0),
                        onTap: _onTap,
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceMd),
                    Expanded(
                      child: _SentenceCard(
                        sentence: _options[1],
                        slot: 1,
                        state: _cardState(1),
                        onTap: _onTap,
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  _SentenceCard(
                    sentence: _options[0],
                    slot: 0,
                    state: _cardState(0),
                    onTap: _onTap,
                  ),
                  const SizedBox(height: AppDimens.spaceMd),
                  _SentenceCard(
                    sentence: _options[1],
                    slot: 1,
                    state: _cardState(1),
                    onTap: _onTap,
                  ),
                ],
              );
            },
          ),
          if (_answered) ...[
            const SizedBox(height: AppDimens.spaceLg),
            FeedbackPanel(text: widget.explanation, isCorrect: _tappedCorrect),
            const SizedBox(height: AppDimens.spaceMd),
            FilledButton(
              onPressed: () =>
                  widget.onAnswer(_tappedCorrect ? Rating.good : Rating.again),
              style: FilledButton.styleFrom(backgroundColor: widget.color),
              child: Text(l.next),
            ),
          ],
        ],
      ),
    );
  }

  _SentenceCardState _cardState(int slot) {
    if (!_answered) return _SentenceCardState.idle;
    if (slot == _correctSlot) return _SentenceCardState.correct;
    if (slot == _tapped) return _SentenceCardState.wrong;
    return _SentenceCardState.idle;
  }
}

enum _SentenceCardState { idle, correct, wrong }

class _SentenceCard extends StatelessWidget {
  final String sentence;
  final int slot;
  final _SentenceCardState state;
  final void Function(int) onTap;

  const _SentenceCard({
    required this.sentence,
    required this.slot,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    final Color borderColor;
    final Color bgColor;
    switch (state) {
      case _SentenceCardState.correct:
        borderColor = t.success;
        bgColor = t.successContainer;
      case _SentenceCardState.wrong:
        borderColor = t.error;
        bgColor = t.errorContainer;
      case _SentenceCardState.idle:
        borderColor = t.outlineVariant;
        bgColor = t.surfaceContainer;
    }

    return GestureDetector(
      onTap: state == _SentenceCardState.idle ? () => onTap(slot) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(
            color: borderColor,
            width: state != _SentenceCardState.idle ? 2 : 1,
          ),
        ),
        child: Text(
          sentence,
          style: AppTextStyles.jpMedium.copyWith(
            color: t.onSurface,
            decoration: state == _SentenceCardState.wrong
                ? TextDecoration.lineThrough
                : null,
            decorationColor: t.error,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
