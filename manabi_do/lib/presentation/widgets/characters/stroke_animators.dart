import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/kanji_strokes_provider.dart';

// ── Shared shell ─────────────────────────────────────────────────────────────

class _AnimatorShell extends StatelessWidget {
  final double size;
  final AnimationController controller;
  final VoidCallback onReplay;
  final CustomPainter Function(double value) buildPainter;

  /// What tapping replays. Supplied by the caller — the shell animates strokes
  /// without knowing whose they are.
  final String replayLabel;

  const _AnimatorShell({
    required this.size,
    required this.controller,
    required this.onReplay,
    required this.buildPainter,
    required this.replayLabel,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final s = size;
    return Semantics(
      label: replayLabel,
      button: true,
      excludeSemantics: true,
      child: MouseRegion(
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
      ),
    );
  }
}

// ── StrokeOrderAnimator ───────────────────────────────────────────────────────

/// Plays back reference strokes sequentially. Auto-plays on load; tap to
/// replay.
class StrokeOrderAnimator extends StatefulWidget {
  final List<ui.Path> strokes;
  final double size;
  const StrokeOrderAnimator({
    super.key,
    required this.strokes,
    this.size = 160,
  });

  @override
  State<StrokeOrderAnimator> createState() => _StrokeOrderAnimatorState();
}

class _StrokeOrderAnimatorState extends State<StrokeOrderAnimator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _play() {
    _controller
      ..duration = Duration(milliseconds: widget.strokes.length * 500)
      ..forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return _AnimatorShell(
      size: widget.size,
      controller: _controller,
      onReplay: _play,
      replayLabel: context.l10n.replayStrokeOrder,
      buildPainter: (v) => _StrokeOrderPainter(
        strokes: widget.strokes,
        progress: v * widget.strokes.length,
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
