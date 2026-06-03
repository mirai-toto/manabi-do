import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_tokens.dart';
import 'kanji_strokes_provider.dart';

class StrokeOrderAnimator extends ConsumerStatefulWidget {
  final int kanjiId;
  const StrokeOrderAnimator({super.key, required this.kanjiId});

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
      return const SizedBox(
        width: 160,
        height: 160,
        child: Center(child: Text('—', style: TextStyle(color: Colors.grey, fontSize: 32))),
      );
    }

    if (strokes == null) {
      return const SizedBox(
        width: 160,
        height: 160,
        child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }

    final t = context.tokens;
    return GestureDetector(
      onTap: () => _play(strokes),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Stack(
          alignment: Alignment.center,
          children: [
            // Expands the Stack to full card width so the replay button
            // can be positioned outside the 160×160 canvas.
            const SizedBox(height: 160, width: double.infinity),
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: t.cardBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: CustomPaint(
                size: const Size(160, 160),
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
