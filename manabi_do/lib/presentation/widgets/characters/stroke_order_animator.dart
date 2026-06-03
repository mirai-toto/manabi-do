import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';

class StrokeOrderAnimator extends StatefulWidget {
  final int kanjiId;
  const StrokeOrderAnimator({super.key, required this.kanjiId});

  @override
  State<StrokeOrderAnimator> createState() => _StrokeOrderAnimatorState();
}

class _StrokeOrderAnimatorState extends State<StrokeOrderAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Path>? _strokes;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _loadAndPlay();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadAndPlay() async {
    final hexCode = widget.kanjiId.toRadixString(16).padLeft(5, '0');
    try {
      final svgString = await rootBundle.loadString('assets/kanji_svg/$hexCode.svg');
      final strokes = _parseStrokes(svgString);
      if (!mounted) return;
      setState(() => _strokes = strokes);
      _play();
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

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

  void _play() {
    final strokes = _strokes;
    if (strokes == null || strokes.isEmpty) return;
    _controller
      ..duration = Duration(milliseconds: strokes.length * 500)
      ..forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return const SizedBox(
        width: 160,
        height: 160,
        child: Center(child: Text('—', style: TextStyle(color: Colors.grey, fontSize: 32))),
      );
    }
    final strokes = _strokes;
    if (strokes == null) {
      return const SizedBox(
        width: 160,
        height: 160,
        child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }
    return GestureDetector(
      onTap: _play,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(160, 160),
              painter: _StrokeOrderPainter(
                strokes: strokes,
                progress: _controller.value * strokes.length,
              ),
            ),
            if (_controller.isCompleted)
              const Positioned(
                bottom: 6,
                right: 6,
                child: Icon(Icons.replay_rounded, size: 16, color: Colors.grey),
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

  _StrokeOrderPainter({required this.strokes, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // KanjiVG viewBox is 0 0 109 109
    canvas.scale(size.width / 109, size.height / 109);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFF1C1B1F);

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
      old.progress != progress || old.strokes != strokes;
}
