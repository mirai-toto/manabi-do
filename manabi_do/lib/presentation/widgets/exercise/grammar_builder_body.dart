import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Rating;

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import 'flash_card.dart';
import 'practice_progress_row.dart';

class GrammarBuilderBody extends StatefulWidget {
  final List<String> parts;
  final String translation;
  final int index;
  final int total;
  final Color color;
  final bool autoAdvance;
  final void Function(Rating) onAnswer;

  const GrammarBuilderBody({
    super.key,
    required this.parts,
    required this.translation,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
    this.autoAdvance = false,
  });

  @override
  State<GrammarBuilderBody> createState() => _GrammarBuilderBodyState();
}

class _GrammarBuilderBodyState extends State<GrammarBuilderBody> {
  late List<int> _shuffled;
  final List<int> _placed = [];
  bool _answered = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _shuffled = List.generate(widget.parts.length, (i) => i)..shuffle(Random());
    // Ensure the shuffled order differs from the correct order when >1 parts
    if (widget.parts.length > 1) {
      while (_listEquals(
        _shuffled,
        List.generate(widget.parts.length, (i) => i),
      )) {
        _shuffled.shuffle(Random());
      }
    }
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  List<int> get _available =>
      _shuffled.where((i) => !_placed.contains(i)).toList();

  void _place(int partIndex) {
    if (_answered) return;
    setState(() => _placed.add(partIndex));
    if (_placed.length == widget.parts.length) _evaluate();
  }

  void _unplace(int placedPos) {
    if (_answered) return;
    setState(() => _placed.removeAt(placedPos));
  }

  void _evaluate() {
    final isCorrect = _listEquals(
      _placed,
      List.generate(widget.parts.length, (i) => i),
    );
    setState(() {
      _answered = true;
      _isCorrect = isCorrect;
    });
    if (widget.autoAdvance) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) widget.onAnswer(isCorrect ? Rating.good : Rating.again);
      });
    }
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
            l.grammarBuilderPrompt,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: t.onSurface,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            widget.translation,
            style: AppTextStyles.body.copyWith(color: t.onSurfaceVariant),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          _TargetArea(
            parts: widget.parts,
            placed: _placed,
            answered: _answered,
            isCorrect: _isCorrect,
            onUnplace: _unplace,
          ),
          const SizedBox(height: AppDimens.spaceLg),
          _SourceChips(
            parts: widget.parts,
            available: _available,
            answered: _answered,
            onPlace: _place,
            color: widget.color,
          ),
          if (_answered && !widget.autoAdvance) ...[
            const SizedBox(height: AppDimens.spaceMd),
            FlashCardActions(
              card: null,
              isFreeMode: true,
              question: l.selfAssessQuestion,
              onRate: widget.onAnswer,
            ),
          ],
        ],
      ),
    );
  }
}

class _TargetArea extends StatelessWidget {
  final List<String> parts;
  final List<int> placed;
  final bool answered;
  final bool isCorrect;
  final void Function(int placedPos) onUnplace;

  const _TargetArea({
    required this.parts,
    required this.placed,
    required this.answered,
    required this.isCorrect,
    required this.onUnplace,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final borderColor = answered
        ? (isCorrect ? t.success : t.error)
        : t.outlineVariant;
    final bgColor = answered
        ? (isCorrect ? t.successContainer : t.errorContainer)
        : t.surfaceContainer;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      constraints: const BoxConstraints(minHeight: 56),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: borderColor, width: answered ? 2 : 1),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceSm,
      ),
      child: placed.isEmpty
          ? Center(
              child: Text(
                '…',
                style: AppTextStyles.jpBody.copyWith(color: t.onSurfaceVariant),
              ),
            )
          : Wrap(
              spacing: AppDimens.spaceXs,
              runSpacing: AppDimens.spaceXs,
              children: List.generate(placed.length, (pos) {
                return _Chip(
                  label: parts[placed[pos]],
                  onTap: answered ? null : () => onUnplace(pos),
                  selected: true,
                  enabled: !answered,
                );
              }),
            ),
    );
  }
}

class _SourceChips extends StatelessWidget {
  final List<String> parts;
  final List<int> available;
  final bool answered;
  final void Function(int partIndex) onPlace;
  final Color color;

  const _SourceChips({
    required this.parts,
    required this.available,
    required this.answered,
    required this.onPlace,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (available.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: AppDimens.spaceXs,
      runSpacing: AppDimens.spaceXs,
      children: available.map((i) {
        return _Chip(
          label: parts[i],
          onTap: () => onPlace(i),
          selected: false,
          enabled: !answered,
        );
      }).toList(),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final bool enabled;

  const _Chip({
    required this.label,
    required this.onTap,
    required this.selected,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.chipPaddingH,
          vertical: AppDimens.chipPaddingV,
        ),
        decoration: BoxDecoration(
          color: selected ? t.primaryContainer : t.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
          border: Border.all(color: selected ? t.primary : t.outlineVariant),
        ),
        child: Text(
          label,
          style: AppTextStyles.jpBody.copyWith(
            color: selected ? t.onPrimaryContainer : t.onSurface,
          ),
        ),
      ),
    );
  }
}
