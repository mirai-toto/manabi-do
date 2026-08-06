import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card, Rating;

import '../../../core/models/drawing_settings.dart';
import '../../../core/srs/stroke_dtw.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../characters/kanji_drawing_canvas.dart';
import '../characters/kanji_readings_card.dart';
import '../characters/stroke_animators.dart';
import 'flash_card.dart';

class DrawingExercise extends StatefulWidget {
  final List<ui.Path> referenceStrokes;
  final int kanjiId;
  final String label;
  final String onReading;
  final String kunReading;
  final Color color;
  final Card? card;
  final bool isFreeMode;
  final void Function(Rating)? onRate;
  final String? question;
  final VoidCallback? onDetailTap;
  final VoidCallback? onNext;
  final DrawingSettings settings;

  const DrawingExercise({
    super.key,
    required this.referenceStrokes,
    required this.kanjiId,
    required this.label,
    required this.color,
    required this.settings,
    this.onReading = '',
    this.kunReading = '',
    this.card,
    this.isFreeMode = false,
    this.onRate,
    this.question,
    this.onDetailTap,
    this.onNext,
  });

  @override
  State<DrawingExercise> createState() => _DrawingExerciseState();
}

class _DrawingExerciseState extends State<DrawingExercise>
    with SingleTickerProviderStateMixin {
  List<List<Offset>> _strokes = [];
  List<bool> _strokeResults = [];
  int _hintLevel = 0;
  int _mistakeCount = 0;
  bool _hintsUsed = false;
  bool _autoAdvanceDone = false;
  final _canvasKey = GlobalKey<KanjiDrawingCanvasState>();

  late final AnimationController _wrongFade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  )..addListener(() => setState(() {}));

  bool get _allCorrect => _done && _strokeResults.every((r) => r);

  bool get _done =>
      _strokeResults.length == widget.referenceStrokes.length &&
      widget.referenceStrokes.isNotEmpty;

  bool get _pendingWrong => _wrongFade.isAnimating;

  @override
  Widget build(BuildContext context) {
    final s = widget.settings;
    final t = context.tokens;
    final l = context.l10n;
    final refStrokes = widget.referenceStrokes;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLabel(context, s),
          if (s.showStrokeCount) ...[
            const SizedBox(height: AppDimens.spaceXs),
            Text(
              l.drawingStrokeCount(refStrokes.length),
              style: AppTextStyles.labelSmall.copyWith(
                color: t.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AppDimens.spaceMd),
          Center(
            child: KanjiDrawingCanvas(
              key: _canvasKey,
              onStrokesChanged: _onStrokeChanged,
              strokeResults: _strokeResults.isEmpty ? null : _strokeResults,
              referenceStrokes: refStrokes,
              ghostEnabled: s.ghostKanji,
              snapToReference: s.snapToReference,
              hintStrokes: _hintStrokes(s),
              enabled: !_done && !_pendingWrong,
              pendingWrong: _pendingWrong,
              wrongStrokeOpacity: _pendingWrong ? 1.0 - _wrongFade.value : 1.0,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          if (!_done)
            _buildActiveControls(context, s)
          else
            _buildDoneArea(context, s),
        ],
      ),
    );
  }

  Widget _buildActiveControls(BuildContext context, DrawingSettings s) {
    final l = context.l10n;
    final t = context.tokens;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          onPressed: _strokes.isEmpty
              ? null
              : () => _canvasKey.currentState?.undo(),
          icon: const Icon(Icons.undo_rounded, size: 16),
          label: Text(l.drawingUndo),
        ),
        const SizedBox(width: AppDimens.spaceSm),
        TextButton.icon(
          onPressed: _strokes.isEmpty
              ? null
              : () => _canvasKey.currentState?.clear(),
          icon: const Icon(Icons.delete_outline_rounded, size: 16),
          label: Text(l.drawingClear),
        ),
        if (!s.ghostKanji) ...[
          const SizedBox(width: AppDimens.spaceSm),
          TextButton.icon(
            onPressed: _onHint,
            icon: const Icon(Icons.help_outline_rounded, size: 16),
            label: Text(_hintLevel == 0 ? '?' : '??'),
            style: _hintsUsed
                ? TextButton.styleFrom(foregroundColor: t.hintStroke)
                : null,
          ),
        ],
      ],
    );
  }

  Widget _buildDoneArea(BuildContext context, DrawingSettings s) {
    final l = context.l10n;
    final t = context.tokens;
    final refStrokes = widget.referenceStrokes;
    final showSrsActions =
        widget.onRate != null &&
        !_hintsUsed &&
        !(widget.isFreeMode && widget.settings.autoAdvance && _done);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_hintsUsed)
          Text(
            l.hintUsedFeedback,
            style: AppTextStyles.body.copyWith(
              color: t.error,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          )
        else ...[
          Text(
            l.drawingStrokeResult(_mistakeCount, refStrokes.length),
            style: AppTextStyles.body.copyWith(
              color: _allCorrect ? t.success : t.error,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (!_allCorrect) ...[
            const SizedBox(height: AppDimens.spaceSm),
            Center(
              child: StrokeOrderAnimator(kanjiId: widget.kanjiId, size: 120),
            ),
          ],
        ],
        const SizedBox(height: AppDimens.spaceSm),
        if (showSrsActions) ...[
          FlashCardActions(
            card: widget.card,
            question: widget.question,
            onRate: widget.onRate!,
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.replay_rounded, size: 16),
                label: Text(l.retry),
                style: TextButton.styleFrom(
                  foregroundColor: t.onSurfaceVariant,
                ),
              ),
              if (widget.onDetailTap != null) ...[
                const SizedBox(width: AppDimens.spaceSm),
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
          ),
        ] else if (widget.onRate == null)
          _buildWritingModeActions(context),
      ],
    );
  }

  Widget _buildWritingModeActions(BuildContext context) {
    final l = context.l10n;
    final retryStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
      side: BorderSide(color: widget.color),
      foregroundColor: widget.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
    );
    final nextStyle = FilledButton.styleFrom(
      backgroundColor: widget.color,
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
    );

    if (widget.onNext != null) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _reset,
              style: retryStyle,
              child: Text(
                l.retry,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceSm),
          Expanded(
            child: FilledButton(
              onPressed: widget.onNext,
              style: nextStyle,
              child: Text(
                l.next,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return FilledButton(
      onPressed: _reset,
      style: nextStyle,
      child: Text(
        l.retry,
        style: AppTextStyles.body.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _wrongFade.dispose();
    super.dispose();
  }

  Widget _buildLabel(BuildContext context, DrawingSettings s) {
    final t = context.tokens;
    final onChips = parseKanjiReadings(widget.onReading)
        .take(kMaxReadingsPerType)
        .map((r) => KanjiReadingChip(reading: r, isKun: false))
        .toList();
    final kunChips = parseKanjiReadings(widget.kunReading)
        .take(kMaxReadingsPerType)
        .map((r) => KanjiReadingChip(reading: r, isKun: true))
        .toList();

    Widget readingPills() => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onChips.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: onChips,
          ),
        if (kunChips.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: kunChips,
          ),
      ],
    );

    return switch (s.hintMode) {
      KanjiHintMode.meaningOnly => Text(
        widget.label,
        style: AppTextStyles.titleLarge.copyWith(color: t.onSurface),
        textAlign: TextAlign.center,
      ),
      KanjiHintMode.readingsOnly => readingPills(),
      KanjiHintMode.both => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: AppTextStyles.titleLarge.copyWith(color: t.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spaceXs),
          readingPills(),
        ],
      ),
    };
  }

  List<ui.Path>? _hintStrokes(DrawingSettings s) {
    if (_hintLevel == 0 || _done || s.ghostKanji) return null;
    final from = _strokes.length;
    if (from >= widget.referenceStrokes.length) return null;
    return _hintLevel == 1
        ? [widget.referenceStrokes[from]]
        : widget.referenceStrokes.sublist(from);
  }

  void _onAllStrokesDone() {
    if (widget.onRate == null) return;
    if (_hintsUsed) {
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) widget.onRate!(Rating.again);
      });
      return;
    }

    if (widget.isFreeMode && widget.settings.autoAdvance && !_autoAdvanceDone) {
      _autoAdvanceDone = true;
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) widget.onRate!(_allCorrect ? Rating.good : Rating.again);
      });
    }
  }

  void _onHint() {
    setState(() {
      _hintLevel = (_hintLevel + 1).clamp(0, 2);
      _hintsUsed = true;
    });
  }

  void _onStrokeChanged(List<List<Offset>> strokes) {
    if (_pendingWrong) return;

    if (strokes.length <= _strokeResults.length) {
      // Undo or clear: trim results to match (runs even when _done to unblock wrong last stroke)
      setState(() {
        _strokes = strokes;
        _strokeResults = _strokeResults.take(strokes.length).toList();
        if (strokes.isEmpty) _hintLevel = 0;
      });
      return;
    }

    if (_done) return;

    // New stroke committed
    final newIdx = strokes.length - 1;
    setState(() {
      _strokes = strokes;
      _hintLevel = 0; // reset hint for next stroke
    });

    if (newIdx >= widget.referenceStrokes.length) return;

    final result = evaluateSingleStroke(
      strokes[newIdx],
      widget.referenceStrokes[newIdx],
      threshold: widget.settings.toleranceThreshold,
    );

    if (!result) {
      // Don't commit false to _strokeResults: avoids _done flipping true prematurely
      setState(() => _mistakeCount++);
      _wrongFade.forward(from: 0).then((_) {
        if (mounted) _canvasKey.currentState?.undo();
      });
      return;
    }

    setState(() => _strokeResults = [..._strokeResults, result]);

    if (_strokeResults.length == widget.referenceStrokes.length) {
      _onAllStrokesDone();
    }
  }

  void _reset() {
    setState(() {
      _strokes = [];
      _strokeResults = [];
      _hintLevel = 0;
      _mistakeCount = 0;
      _hintsUsed = false;
      _autoAdvanceDone = false;
    });
    _canvasKey.currentState?.clear();
  }
}
