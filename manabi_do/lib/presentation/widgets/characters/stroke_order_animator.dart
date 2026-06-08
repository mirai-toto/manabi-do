import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import 'kanji_strokes_provider.dart';

class StrokeOrderAnimator extends ConsumerStatefulWidget {
  final int kanjiId;
  final double size;
  const StrokeOrderAnimator({super.key, required this.kanjiId, this.size = 160});

  @override
  ConsumerState<StrokeOrderAnimator> createState() => _StrokeOrderAnimatorState();
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

  void _play(List<Path> strokes) {
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
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(child: Text('—', style: TextStyle(color: Colors.grey, fontSize: 32))),
      );
    }

    if (strokes == null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }

    final s = widget.size;
    final t = context.tokens;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
      onTap: () => _play(strokes),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(height: s, width: s),
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
                painter: _StrokeOrderPainter(
                  strokes: strokes,
                  progress: _controller.value * strokes.length,
                  strokeColor: t.onSurface,
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

class _StrokeOrderPainter extends CustomPainter {
  final List<Path> strokes;
  final double progress;
  final Color strokeColor;

  _StrokeOrderPainter({required this.strokes, required this.progress, required this.strokeColor});

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
      old.progress != progress || old.strokes != strokes || old.strokeColor != strokeColor;
}
