import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card, Rating;

import '../../../core/srs/stroke_dtw.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../characters/kanji_drawing_canvas.dart';
import '../characters/stroke_order_animator.dart';
import '../characters/user_stroke_animator.dart';
import 'flash_card.dart';

/// A self-contained drawing exercise.
///
/// Pre-check: full-size canvas with undo/clear/check controls.
/// Post-check: split view (reference animation | user strokes) + result text.
///
/// If [onRate] is provided the post-check action is a [FlashCardActions] grid.
/// If [onRate] is null a "Retry" button is shown instead (standalone practice).
class DrawingExercise extends StatefulWidget {
  final List<ui.Path> referenceStrokes;
  final int kanjiId;
  final String label;
  final Color color;
  final Card? card;
  final void Function(Rating)? onRate;
  final String? question;

  const DrawingExercise({
    super.key,
    required this.referenceStrokes,
    required this.kanjiId,
    required this.label,
    required this.color,
    this.card,
    this.onRate,
    this.question,
  });

  @override
  State<DrawingExercise> createState() => _DrawingExerciseState();
}

class _DrawingExerciseState extends State<DrawingExercise> {
  List<List<Offset>> _strokes = [];
  List<bool>? _strokeResults;
  final _canvasKey = GlobalKey<KanjiDrawingCanvasState>();

  void _check() {
    setState(() => _strokeResults = evaluateStrokes(_strokes, widget.referenceStrokes));
  }

  void _reset() {
    setState(() {
      _strokes = [];
      _strokeResults = null;
    });
    _canvasKey.currentState?.clear();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final refStrokes = widget.referenceStrokes;
    final checked = _strokeResults != null;
    final correctCount = _strokeResults?.where((b) => b).length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.titleLarge.copyWith(color: t.onSurface),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Text(
          l.drawingStrokeCount(refStrokes.length),
          style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimens.spaceMd),
        if (!checked) ...[
          Center(
            child: KanjiDrawingCanvas(
              key: _canvasKey,
              onStrokesChanged: (s) => setState(() => _strokes = s),
              strokeResults: null,
              referenceStrokes: null,
              enabled: true,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () => _canvasKey.currentState?.undo(),
                icon: const Icon(Icons.undo_rounded, size: 16),
                label: Text(l.drawingUndo),
              ),
              const SizedBox(width: AppDimens.spaceSm),
              TextButton.icon(
                onPressed: () => _canvasKey.currentState?.clear(),
                icon: const Icon(Icons.delete_outline_rounded, size: 16),
                label: Text(l.drawingClear),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceSm),
          FilledButton(
            onPressed: _strokes.isEmpty ? null : _check,
            style: FilledButton.styleFrom(
              backgroundColor: widget.color,
              disabledBackgroundColor: t.outlineVariant,
              padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusMd)),
            ),
            child: Text(
              l.drawingCheck,
              style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ] else ...[
          LayoutBuilder(builder: (_, constraints) {
            final cardSize = (constraints.maxWidth - AppDimens.spaceMd) / 2;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(children: [
                    Text(l.drawingReference,
                        style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant)),
                    const SizedBox(height: AppDimens.spaceXs),
                    StrokeOrderAnimator(kanjiId: widget.kanjiId, size: cardSize),
                  ]),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: Column(children: [
                    Text(l.drawingYourAnswer,
                        style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant)),
                    const SizedBox(height: AppDimens.spaceXs),
                    UserStrokeAnimator(
                      strokes: _strokes,
                      strokeResults: _strokeResults,
                      size: cardSize,
                    ),
                  ]),
                ),
              ],
            );
          }),
          const SizedBox(height: AppDimens.spaceSm),
          Text(
            l.drawingStrokeResult(correctCount, refStrokes.length),
            style: AppTextStyles.body.copyWith(
              color: correctCount == refStrokes.length ? t.success : t.error,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spaceSm),
          if (widget.onRate != null)
            FlashCardActions(
              card: widget.card,
              question: widget.question,
              onRate: widget.onRate!,
            )
          else
            FilledButton(
              onPressed: _reset,
              style: FilledButton.styleFrom(
                backgroundColor: widget.color,
                padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusMd)),
              ),
              child: Text(
                l.retry,
                style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ],
    );
  }
}
