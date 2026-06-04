import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';

const double _kCanvasSize = 260.0;

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
    final s = widget.size;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _controller.forward(from: 0),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(width: s, height: s),
              Container(
                width: s,
                height: s,
                decoration: BoxDecoration(
                  color: t.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: CustomPaint(
                  size: Size(s, s),
                  painter: _UserStrokePainter(
                    strokes: widget.strokes,
                    strokeResults: widget.strokeResults,
                    progress: _controller.value * widget.strokes.length,
                    strokeColor: t.onSurface,
                    correctColor: t.success,
                    wrongColor: t.error,
                    guideColor: t.outlineVariant,
                  ),
                ),
              ),
              if (_controller.isCompleted)
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
                    child: Icon(Icons.replay_rounded, size: 18, color: t.onSurfaceVariant),
                  ),
                ),
            ],
          ),
        ),
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

      final path = Path()
        ..moveTo(points[0].dx * scale, points[0].dy * scale);
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
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
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
