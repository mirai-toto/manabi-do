import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';
import '../../../core/theme/app_tokens.dart';

const double _kanjiVgViewBox = 109;

List<Path> _parseStrokes(String svgString) {
  final doc = XmlDocument.parse(svgString);
  final strokePathsGroup = doc.descendants
      .whereType<XmlElement>()
      .firstWhere((e) =>
          e.name.local == 'g' &&
          (e.getAttribute('id') ?? '').startsWith('kvg:StrokePaths_'));
  return strokePathsGroup.descendants
      .whereType<XmlElement>()
      .where((e) => e.name.local == 'path')
      .map((e) => parseSvgPathData(e.getAttribute('d') ?? ''))
      .toList();
}

final _kanjiStrokesProvider = FutureProvider.family<List<Path>, int>((ref, kanjiId) async {
  final hexCode = kanjiId.toRadixString(16).padLeft(5, '0');
  final svgString = await rootBundle.loadString('assets/kanji_svg/$hexCode.svg');
  return _parseStrokes(svgString);
});

// ── Animation ────────────────────────────────────────────────────────────────

class StrokeOrderAnimator extends ConsumerStatefulWidget {
  final int kanjiId;
  const StrokeOrderAnimator({super.key, required this.kanjiId});

  @override
  ConsumerState<StrokeOrderAnimator> createState() => _StrokeOrderAnimatorState();
}

class _StrokeOrderAnimatorState extends ConsumerState<StrokeOrderAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
    final strokesAsync = ref.watch(_kanjiStrokesProvider(widget.kanjiId));

    ref.listen<AsyncValue<List<Path>>>(_kanjiStrokesProvider(widget.kanjiId), (prev, next) {
      if (prev is! AsyncData && next is AsyncData<List<Path>>) {
        _play(next.value);
      }
    });

    if (strokesAsync is AsyncError) {
      return const SizedBox(
        width: 160,
        height: 160,
        child: Center(child: Text('—', style: TextStyle(color: Colors.grey, fontSize: 32))),
      );
    }

    final strokes = strokesAsync.asData?.value;
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
            // Expands the Stack to the full card width so the button
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

// ── Step-by-step row ─────────────────────────────────────────────────────────

class StrokeStepRow extends ConsumerStatefulWidget {
  final int kanjiId;
  const StrokeStepRow({super.key, required this.kanjiId});

  @override
  ConsumerState<StrokeStepRow> createState() => _StrokeStepRowState();
}

class _StrokeStepRowState extends ConsumerState<StrokeStepRow> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    _scrollController.jumpTo(
      (_scrollController.offset - details.delta.dx)
          .clamp(pos.minScrollExtent, pos.maxScrollExtent),
    );
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final target = (_scrollController.offset - details.velocity.pixelsPerSecond.dx * 0.12)
        .clamp(pos.minScrollExtent, pos.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.decelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strokes = ref.watch(_kanjiStrokesProvider(widget.kanjiId)).asData?.value;
    if (strokes == null) return const SizedBox.shrink();

    final t = context.tokens;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: SizedBox(
        height: 48,
        child: ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: strokes.length,
          separatorBuilder: (_, _) => const SizedBox(width: 6),
          itemBuilder: (context, i) => Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: t.cardBackground,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: t.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: CustomPaint(
              size: const Size(48, 48),
              painter: _StepPainter(
                strokes: strokes,
                step: i,
                prevColor: t.onSurfaceVariant,
                currColor: t.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Painters ─────────────────────────────────────────────────────────────────

class _StrokeOrderPainter extends CustomPainter {
  final List<Path> strokes;
  final double progress;
  final Color strokeColor;

  _StrokeOrderPainter({required this.strokes, required this.progress, required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / _kanjiVgViewBox, size.height / _kanjiVgViewBox);

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

class _StepPainter extends CustomPainter {
  final List<Path> strokes;
  final int step;
  final Color prevColor;
  final Color currColor;

  _StepPainter({required this.strokes, required this.step, required this.prevColor, required this.currColor});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / _kanjiVgViewBox, size.height / _kanjiVgViewBox);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (int i = 0; i <= step && i < strokes.length; i++) {
      canvas.drawPath(strokes[i], base..color = (i < step ? prevColor : currColor));
    }
  }

  @override
  bool shouldRepaint(_StepPainter old) =>
      old.step != step || old.strokes != strokes || old.prevColor != prevColor || old.currColor != currColor;
}
