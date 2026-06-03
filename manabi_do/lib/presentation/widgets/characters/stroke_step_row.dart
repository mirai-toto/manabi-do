import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_tokens.dart';
import 'kanji_strokes_provider.dart';

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
    final strokes = ref.watch(kanjiStrokesProvider(widget.kanjiId)).asData?.value;
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

class _StepPainter extends CustomPainter {
  final List<Path> strokes;
  final int step;
  final Color prevColor;
  final Color currColor;

  _StepPainter({required this.strokes, required this.step, required this.prevColor, required this.currColor});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / kanjiVgViewBox, size.height / kanjiVgViewBox);
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
