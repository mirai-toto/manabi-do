import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import 'kanji_strokes_provider.dart';

class KanjiDrawingCanvas extends StatefulWidget {
  final void Function(List<List<Offset>>) onStrokesChanged;
  final List<bool>? strokeResults;     // null = not checked; drives stroke colors
  final List<ui.Path>? referenceStrokes; // shown as ghost after check
  final bool enabled;

  const KanjiDrawingCanvas({
    super.key,
    required this.onStrokesChanged,
    this.strokeResults,
    this.referenceStrokes,
    this.enabled = true,
  });

  @override
  State<KanjiDrawingCanvas> createState() => KanjiDrawingCanvasState();
}

class KanjiDrawingCanvasState extends State<KanjiDrawingCanvas> {
  final List<List<Offset>> _strokes = [];
  List<Offset>? _current;

  void undo() {
    if (_strokes.isNotEmpty) {
      setState(() => _strokes.removeLast());
      widget.onStrokesChanged(List.of(_strokes));
    }
  }

  void clear() {
    setState(() => _strokes.clear());
    widget.onStrokesChanged([]);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final painter = _CanvasPainter(
      strokes: _strokes,
      current: _current,
      strokeResults: widget.strokeResults,
      referenceStrokes: widget.referenceStrokes,
      strokeColor: t.onSurface,
      guideColor: t.outlineVariant,
      correctColor: t.success,
      wrongColor: t.error,
      referenceColor: t.primary,
    );

    final canvas = CustomPaint(painter: painter, size: const Size(260, 260));

    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: t.outlineVariant, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusMd - 1),
        child: widget.enabled
            ? GestureDetector(
                onPanStart: (d) =>
                    setState(() => _current = [d.localPosition]),
                onPanUpdate: (d) =>
                    setState(() => _current?.add(d.localPosition)),
                onPanEnd: (_) {
                  if (_current != null && _current!.isNotEmpty) {
                    setState(() {
                      _strokes.add(List.of(_current!));
                      _current = null;
                    });
                    widget.onStrokesChanged(List.of(_strokes));
                  }
                },
                child: canvas,
              )
            : canvas,
      ),
    );
  }
}

class _CanvasPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset>? current;
  final List<bool>? strokeResults;
  final List<ui.Path>? referenceStrokes;
  final Color strokeColor;
  final Color guideColor;
  final Color correctColor;
  final Color wrongColor;
  final Color referenceColor;

  const _CanvasPainter({
    required this.strokes,
    required this.current,
    required this.strokeResults,
    required this.referenceStrokes,
    required this.strokeColor,
    required this.guideColor,
    required this.correctColor,
    required this.wrongColor,
    required this.referenceColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawGuides(canvas, size);
    _drawReferenceGhost(canvas, size);
    _drawStrokes(canvas, size);
  }

  void _drawGuides(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = guideColor.withValues(alpha: 0.4)
      ..strokeWidth = 0.5;
    // cross-hair lines
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    // diagonal guides
    paint.color = guideColor.withValues(alpha: 0.15);
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  void _drawReferenceGhost(Canvas canvas, Size size) {
    if (referenceStrokes == null) return;
    final paint = Paint()
      ..color = referenceColor.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.save();
    canvas.scale(size.width / kanjiVgViewBox, size.height / kanjiVgViewBox);
    for (final path in referenceStrokes!) {
      canvas.drawPath(path, paint);
    }
    canvas.restore();
  }

  void _drawStrokes(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < strokes.length; i++) {
      final Color color;
      if (strokeResults == null) {
        color = strokeColor;
      } else if (i < strokeResults!.length) {
        color = strokeResults![i] ? correctColor : wrongColor;
      } else {
        color = wrongColor;
      }
      _drawPolyline(canvas, strokes[i], basePaint..color = color);
    }

    if (current != null) {
      _drawPolyline(canvas, current!, basePaint..color = strokeColor);
    }
  }

  void _drawPolyline(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.length < 2) return;
    final path = ui.Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CanvasPainter old) => true;
}
