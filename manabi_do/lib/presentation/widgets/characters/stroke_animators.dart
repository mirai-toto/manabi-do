import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import 'kanji_strokes_provider.dart';

const double _kCanvasSize = 260.0;

// ── Shared shell ─────────────────────────────────────────────────────────────

class _AnimatorShell extends StatelessWidget {
  final double size;
  final AnimationController controller;
  final VoidCallback onReplay;
  final CustomPainter Function(double value) buildPainter;

  const _AnimatorShell({
    required this.size,
    required this.controller,
    required this.onReplay,
    required this.buildPainter,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final s = size;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onReplay,
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, _) => Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(width: s, height: s),
              Container(
                width: s,
                height: s,
                decoration: BoxDecoration(
                  color: t.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                ),
                clipBehavior: Clip.antiAlias,
                child: CustomPaint(
                  size: Size(s, s),
                  painter: buildPainter(controller.value),
                ),
              ),
              if (controller.isCompleted)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: t.onSurfaceVariant.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.replay_rounded,
                      size: 18,
                      color: t.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── StrokeOrderAnimator ───────────────────────────────────────────────────────

class StrokeOrderAnimator extends ConsumerStatefulWidget {
  final int kanjiId;
  final double size;
  const StrokeOrderAnimator({
    super.key,
    required this.kanjiId,
    this.size = 160,
  });

  @override
  ConsumerState<StrokeOrderAnimator> createState() =>
      _StrokeOrderAnimatorState();
}

class _StrokeOrderAnimatorState extends ConsumerState<StrokeOrderAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _didAutoPlay = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _play(List<ui.Path> strokes) {
    _controller
      ..duration = Duration(milliseconds: strokes.length * 500)
      ..forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final strokesAsync = ref.watch(kanjiStrokesProvider(widget.kanjiId));
    final strokes = strokesAsync.asData?.value;

    if (strokes != null && !_didAutoPlay) {
      _didAutoPlay = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _play(strokes);
      });
    }

    if (strokesAsync is AsyncError) {
      final t = context.tokens;
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: Center(
          child: Text(
            '',
            style: TextStyle(color: t.onSurfaceVariant, fontSize: 32),
          ),
        ),
      );
    }

    if (strokes == null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final t = context.tokens;
    return _AnimatorShell(
      size: widget.size,
      controller: _controller,
      onReplay: () => _play(strokes),
      buildPainter: (v) => _StrokeOrderPainter(
        strokes: strokes,
        progress: v * strokes.length,
        strokeColor: t.onSurface,
      ),
    );
  }
}

class _StrokeOrderPainter extends CustomPainter {
  final List<ui.Path> strokes;
  final double progress;
  final Color strokeColor;

  _StrokeOrderPainter({
    required this.strokes,
    required this.progress,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / kanjiVgViewBox, size.height / kanjiVgViewBox);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = strokeColor;

    for (int i = 0; i < strokes.length; i++) {
      final strokeProgress = (progress - i).clamp(0.0, 1.0);
      if (strokeProgress == 0) break;

      if (strokeProgress < 1.0) {
        for (final metric in strokes[i].computeMetrics()) {
          canvas.drawPath(
            metric.extractPath(0, metric.length * strokeProgress),
            paint,
          );
        }
      } else {
        canvas.drawPath(strokes[i], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_StrokeOrderPainter old) =>
      old.progress != progress ||
      old.strokes != strokes ||
      old.strokeColor != strokeColor;
}

// ── UserStrokeAnimator ────────────────────────────────────────────────────────

class UserStrokeAnimator extends StatefulWidget {
  final List<List<Offset>> strokes;
  final List<bool>? strokeResults;
  final double size;

  const UserStrokeAnimator({
    super.key,
    required this.strokes,
    required this.strokeResults,
    this.size = 160,
  });

  @override
  State<UserStrokeAnimator> createState() => _UserStrokeAnimatorState();
}

class _UserStrokeAnimatorState extends State<UserStrokeAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.strokes.length * 500),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return _AnimatorShell(
      size: widget.size,
      controller: _controller,
      onReplay: () => _controller.forward(from: 0),
      buildPainter: (v) => _UserStrokePainter(
        strokes: widget.strokes,
        strokeResults: widget.strokeResults,
        progress: v * widget.strokes.length,
        strokeColor: t.onSurface,
        correctColor: t.success,
        wrongColor: t.error,
        guideColor: t.outlineVariant,
      ),
    );
  }
}

class _UserStrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<bool>? strokeResults;
  final double progress;
  final Color strokeColor;
  final Color correctColor;
  final Color wrongColor;
  final Color guideColor;

  _UserStrokePainter({
    required this.strokes,
    required this.strokeResults,
    required this.progress,
    required this.strokeColor,
    required this.correctColor,
    required this.wrongColor,
    required this.guideColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawGuides(canvas, size);

    final scale = size.width / _kCanvasSize;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < strokes.length; i++) {
      final strokeProgress = (progress - i).clamp(0.0, 1.0);
      if (strokeProgress == 0) break;

      final points = strokes[i];
      if (points.length < 2) continue;

      final isCorrect = strokeResults != null && i < strokeResults!.length
          ? strokeResults![i]
          : null;
      paint.color = isCorrect == null
          ? strokeColor
          : isCorrect
          ? correctColor
          : wrongColor;

      final path = Path()..moveTo(points[0].dx * scale, points[0].dy * scale);
      for (int j = 1; j < points.length; j++) {
        path.lineTo(points[j].dx * scale, points[j].dy * scale);
      }

      if (strokeProgress < 1.0) {
        for (final metric in path.computeMetrics()) {
          canvas.drawPath(
            metric.extractPath(0, metric.length * strokeProgress),
            paint,
          );
        }
      } else {
        canvas.drawPath(path, paint);
      }
    }
  }

  void _drawGuides(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 0.5;
    paint.color = guideColor.withValues(alpha: 0.4);
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
    paint.color = guideColor.withValues(alpha: 0.15);
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(_UserStrokePainter old) =>
      old.progress != progress ||
      old.strokes != strokes ||
      old.strokeResults != strokeResults;
}
