import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../providers/kanji_provider.dart';
import '../../../widgets/characters/kanji_strokes_provider.dart';
import '../../../widgets/exercise/drawing_exercise.dart';

class KanjiDrawingPracticeScreen extends ConsumerWidget {
  final int kanjiId;
  const KanjiDrawingPracticeScreen({super.key, required this.kanjiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanji = ref.watch(kanjiDetailProvider(kanjiId)).asData?.value;
    if (kanji == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final t = context.tokens;
    final color = levelColor(kanji.jlptLevel);
    final strokesAsync = ref.watch(kanjiStrokesProvider(kanjiId));

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
          data: (refStrokes) => DrawingExercise(
            referenceStrokes: refStrokes,
            kanjiId: kanjiId,
            label: kanji.meaning,
            color: color,
          ),
        ),
      ),
    );
  }
}
