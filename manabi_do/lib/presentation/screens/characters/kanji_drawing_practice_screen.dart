import 'dart:ui' as dart_ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/srs/stroke_dtw.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../providers/kanji_provider.dart';
import '../../widgets/characters/kanji_drawing_canvas.dart';
import '../../widgets/characters/kanji_strokes_provider.dart';
import '../../widgets/characters/stroke_order_animator.dart';

class KanjiDrawingPracticeScreen extends ConsumerStatefulWidget {
  final int kanjiId;
  const KanjiDrawingPracticeScreen({super.key, required this.kanjiId});

  @override
  ConsumerState<KanjiDrawingPracticeScreen> createState() =>
      _KanjiDrawingPracticeScreenState();
}

class _KanjiDrawingPracticeScreenState
    extends ConsumerState<KanjiDrawingPracticeScreen> {
  List<List<Offset>> _strokes = [];
  List<bool>? _strokeResults;
  final _canvasKey = GlobalKey<KanjiDrawingCanvasState>();

  void _check(List<dart_ui.Path> refStrokes) {
    setState(() => _strokeResults = evaluateStrokes(_strokes, refStrokes));
  }

  void _reset() {
    setState(() {
      _strokes = [];
      _strokeResults = null;
    });
    _canvasKey.currentState?.clear();
  }

  @override
  Widget build(BuildContext context) {
    final kanji = ref.watch(kanjiDetailProvider(widget.kanjiId)).asData?.value;
    if (kanji == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final t = context.tokens;
    final l = context.l10n;
    final color = levelColor(kanji.jlptLevel);
    final strokesAsync = ref.watch(kanjiStrokesProvider(widget.kanjiId));
    final checked = _strokeResults != null;

    return Scaffold(
      backgroundColor: t.surface,
      appBar: AppBar(
        backgroundColor: t.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: t.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          kanji.character,
          style: AppTextStyles.title.copyWith(color: color),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        child: strokesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const SizedBox.shrink(),
          data: (refStrokes) {
            final correctCount = _strokeResults?.where((b) => b).length ?? 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  kanji.meaning,
                  style: AppTextStyles.titleLarge.copyWith(color: t.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimens.spaceXs),
                Text(
                  l.drawingStrokeCount(refStrokes.length),
                  style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimens.spaceMd),
                if (!checked) ...[
                  Center(
                    child: KanjiDrawingCanvas(
                      key: _canvasKey,
                      onStrokesChanged: (s) => setState(() => _strokes = s),
                      strokeResults: null,
                      referenceStrokes: null,
                      enabled: true,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceSm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () => _canvasKey.currentState?.undo(),
                        icon: const Icon(Icons.undo_rounded, size: 16),
                        label: Text(l.drawingUndo),
                      ),
                      const SizedBox(width: AppDimens.spaceSm),
                      TextButton.icon(
                        onPressed: () => _canvasKey.currentState?.clear(),
                        icon: const Icon(Icons.delete_outline_rounded, size: 16),
                        label: Text(l.drawingClear),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceSm),
                  FilledButton(
                    onPressed: _strokes.isEmpty ? null : () => _check(refStrokes),
                    style: FilledButton.styleFrom(
                      backgroundColor: color,
                      disabledBackgroundColor: t.outlineVariant,
                      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                      ),
                    ),
                    child: Text(
                      l.drawingCheck,
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ] else ...[
                  LayoutBuilder(builder: (_, constraints) {
                    final cardSize = (constraints.maxWidth - AppDimens.spaceMd) / 2;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(l.drawingReference,
                                  style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant)),
                              const SizedBox(height: AppDimens.spaceXs),
                              StrokeOrderAnimator(kanjiId: widget.kanjiId, size: cardSize),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppDimens.spaceMd),
                        Expanded(
                          child: Column(
                            children: [
                              Text(l.drawingYourAnswer,
                                  style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant)),
                              const SizedBox(height: AppDimens.spaceXs),
                              SizedBox(
                                width: cardSize,
                                height: cardSize,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: KanjiDrawingCanvas(
                                    key: _canvasKey,
                                    onStrokesChanged: (_) {},
                                    strokeResults: _strokeResults,
                                    referenceStrokes: null,
                                    enabled: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: AppDimens.spaceSm),
                  Text(
                    l.drawingStrokeResult(correctCount, refStrokes.length),
                    style: AppTextStyles.body.copyWith(
                      color: correctCount == refStrokes.length ? t.success : t.error,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.spaceSm),
                  FilledButton(
                    onPressed: _reset,
                    style: FilledButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                      ),
                    ),
                    child: Text(
                      l.retry,
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
