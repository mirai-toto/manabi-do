import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/kanji_strokes_provider.dart';
import '../common/app_spinner.dart';

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
        child: const Center(child: AppSpinner()),
      );
    }

    final t = context.tokens;
    return _AnimatorShell(
      size: widget.size,
      controller: _controller,
      onReplay: () => _play(strokes),
      replayLabel: context.l10n.replayStrokeOrder,
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
