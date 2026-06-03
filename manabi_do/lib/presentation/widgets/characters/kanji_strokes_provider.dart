import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';

const double kanjiVgViewBox = 109;

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

final kanjiStrokesProvider = FutureProvider.family<List<Path>, int>((ref, kanjiId) async {
  final hexCode = kanjiId.toRadixString(16).padLeft(5, '0');
  final svgString = await rootBundle.loadString('assets/kanji_svg/$hexCode.svg');
  return _parseStrokes(svgString);
});
