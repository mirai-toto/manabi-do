import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';

import '../../../presentation/providers/database_provider.dart';

const double kanjiVgViewBox = 109;

List<Path> _parseStrokes(String svgString) {
  final doc = XmlDocument.parse(svgString);
  final strokePathsGroup = doc.descendants.whereType<XmlElement>().firstWhere(
    (e) =>
        e.name.local == 'g' &&
        (e.getAttribute('id') ?? '').startsWith('kvg:StrokePaths_'),
  );
  return strokePathsGroup.descendants
      .whereType<XmlElement>()
      .where((e) => e.name.local == 'path')
      .map((e) => parseSvgPathData(e.getAttribute('d') ?? ''))
      .toList();
}

final kanjiStrokesProvider = FutureProvider.family<List<Path>, int>((
  ref,
  kanjiId,
) async {
  final db = ref.read(databaseProvider);
  final svg = await db.getKanjiSvg(kanjiId);
  if (svg == null) return [];
  return _parseStrokes(svg);
});
