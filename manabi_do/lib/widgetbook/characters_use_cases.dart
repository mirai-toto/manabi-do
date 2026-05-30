import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../presentation/widgets/characters/character_cell.dart';
import '../presentation/widgets/characters/kanji_drawing_canvas.dart';
import '../presentation/widgets/characters/kanji_strokes_provider.dart';
import '../presentation/widgets/characters/stroke_animators.dart';
import '../presentation/widgets/characters/stroke_step_row.dart';

const int _water = 0x6c34; // 水

// ── CharacterCell ─────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Unknown', type: CharacterCell, path: 'Characters')
Widget buildCharacterCellUnknown(BuildContext context) {
  return CharacterCell(character: 'あ', subLabel: 'a', onTap: () {});
}

@widgetbook.UseCase(name: 'Known', type: CharacterCell, path: 'Characters')
Widget buildCharacterCellKnown(BuildContext context) {
  return CharacterCell(
    character: 'あ',
    subLabel: 'a',
    accentColor: Colors.green,
    onTap: () {},
  );
}

@widgetbook.UseCase(
  name: 'Accent color',
  type: CharacterCell,
  path: 'Characters',
)
Widget buildCharacterCellAccent(BuildContext context) {
  return CharacterCell(
    character: '水',
    subLabel: 'water',
    accentColor: Theme.of(context).colorScheme.tertiary,
    onTap: () {},
  );
}

// ── KanjiDrawingCanvas ────────────────────────────────────────────────────────

@widgetbook.UseCase(
  name: 'Default',
  type: KanjiDrawingCanvas,
  path: 'Characters',
)
Widget buildKanjiDrawingCanvas(BuildContext context) {
  return Center(child: KanjiDrawingCanvas(onStrokesChanged: (_) {}));
}

@widgetbook.UseCase(
  name: 'With reference ghost',
  type: KanjiDrawingCanvas,
  path: 'Characters',
)
Widget buildKanjiDrawingCanvasWithGhost(BuildContext context) {
  return Consumer(
    builder: (context, ref, _) {
      final strokes = ref.watch(kanjiStrokesProvider(_water)).asData?.value;
      return Center(
        child: KanjiDrawingCanvas(
          onStrokesChanged: (_) {},
          referenceStrokes: strokes,
        ),
      );
    },
  );
}

// ── StrokeOrderAnimator / UserStrokeAnimator ──────────────────────────────────

@widgetbook.UseCase(
  name: 'Default',
  type: StrokeOrderAnimator,
  path: 'Characters',
)
Widget buildStrokeOrderAnimator(BuildContext context) {
  return const Center(child: StrokeOrderAnimator(kanjiId: _water));
}

@widgetbook.UseCase(
  name: 'Large',
  type: StrokeOrderAnimator,
  path: 'Characters',
)
Widget buildStrokeOrderAnimatorLarge(BuildContext context) {
  return const Center(child: StrokeOrderAnimator(kanjiId: _water, size: 260));
}

@widgetbook.UseCase(
  name: 'Default',
  type: UserStrokeAnimator,
  path: 'Characters',
)
Widget buildUserStrokeAnimator(BuildContext context) {
  return Center(
    child: UserStrokeAnimator(
      strokes: const [
        [Offset(50, 130), Offset(210, 130)],
        [Offset(130, 50), Offset(130, 210)],
        [Offset(70, 80), Offset(130, 130), Offset(190, 80)],
      ],
      strokeResults: const [true, true, false],
    ),
  );
}

// ── StrokeStepRow ─────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: StrokeStepRow, path: 'Characters')
Widget buildStrokeStepRow(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: StrokeStepRow(kanjiId: _water),
  );
}
