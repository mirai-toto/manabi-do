import 'dart:math';
import 'dart:ui';

/// Sample [count] evenly-spaced points along a Flutter [Path].
List<Offset> samplePath(Path path, {int count = 32}) {
  final metrics = path.computeMetrics().toList();
  if (metrics.isEmpty) return [];
  final metric = metrics.first;
  if (metric.length == 0) return [];
  final step = metric.length / count;
  final points = <Offset>[];
  for (double t = 0; t <= metric.length; t += step) {
    final tangent = metric.getTangentForOffset(t.clamp(0.0, metric.length));
    if (tangent != null) points.add(tangent.position);
  }
  return points;
}

/// Normalize [points] to fit within a [0, targetSize] square, preserving aspect ratio.
List<Offset> normalizeStroke(List<Offset> points, double targetSize) {
  if (points.length < 2) return points;
  var minX = points[0].dx, maxX = points[0].dx;
  var minY = points[0].dy, maxY = points[0].dy;
  for (final p in points) {
    if (p.dx < minX) minX = p.dx;
    if (p.dx > maxX) maxX = p.dx;
    if (p.dy < minY) minY = p.dy;
    if (p.dy > maxY) maxY = p.dy;
  }
  final range = max(maxX - minX, maxY - minY);
  if (range == 0) return points;
  return points
      .map((p) => Offset(
            (p.dx - minX) / range * targetSize,
            (p.dy - minY) / range * targetSize,
          ))
      .toList();
}

/// Dynamic Time Warping distance between two point sequences.
double dtw(List<Offset> a, List<Offset> b) {
  final n = a.length, m = b.length;
  final d = List.generate(n + 1, (_) => List.filled(m + 1, double.infinity));
  d[0][0] = 0;
  for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= m; j++) {
      final cost = (a[i - 1] - b[j - 1]).distance;
      d[i][j] = cost + min(d[i - 1][j], min(d[i][j - 1], d[i - 1][j - 1]));
    }
  }
  return d[n][m];
}

/// Compare [userStrokes] (screen [Offset] lists) against [referenceStrokes] (KanjiVG [Path]s).
///
/// Returns one bool per reference stroke (true = within [threshold]).
/// If stroke counts differ, all are false.
List<bool> evaluateStrokes(
  List<List<Offset>> userStrokes,
  List<Path> referenceStrokes, {
  double threshold = 15.0,
}) {
  if (userStrokes.length != referenceStrokes.length) {
    return List.filled(referenceStrokes.length, false);
  }
  return List.generate(referenceStrokes.length, (i) {
    final ref = normalizeStroke(samplePath(referenceStrokes[i]), 100);
    final user = normalizeStroke(userStrokes[i], 100);
    if (ref.isEmpty || user.isEmpty) return false;
    return dtw(ref, user) / ref.length < threshold;
  });
}
