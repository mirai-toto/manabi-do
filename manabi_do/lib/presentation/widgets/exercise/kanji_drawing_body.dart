import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card;

import '../../../core/models/practice_answer.dart';
import '../../../core/srs/drawing_rating.dart';
import '../../../core/text/short_meaning.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../providers/drawing_settings_provider.dart';
import '../../providers/kanji_strokes_provider.dart';
import 'drawing_exercise.dart';
import 'practice_progress_row.dart';

/// Write the kanji from its meaning, then grade the attempt.
class KanjiDrawingBody extends ConsumerWidget {
  final Kanji kanji;
  final Card? card;
  final bool isFreeMode;

  /// The review session's switch. Ignored in free mode, which has its own
  /// inside the drawing settings.
  final bool autoAdvance;
  final int index;
  final int total;
  final Color color;
  final AnswerCallback onAnswer;
  final VoidCallback? onDetailTap;

  final String? meaning;

  const KanjiDrawingBody({
    super.key,
    required this.kanji,
    required this.card,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
    this.meaning,
    this.isFreeMode = false,
    this.autoAdvance = false,
    this.onDetailTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final strokesAsync = ref.watch(kanjiStrokesProvider(kanji.id));
    final drawingSettings = ref.watch(drawingSettingsProvider);
    final bool advances = isFreeMode
        ? drawingSettings.autoAdvance
        : autoAdvance;

    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PracticeProgressRow(index: index, total: total, color: color),
          const SizedBox(height: AppDimens.spaceMd),
          Expanded(
            child: strokesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
              data: (refStrokes) => DrawingExercise(
                referenceStrokes: refStrokes,
                kanjiId: kanji.id,
                label: meaning ?? shortMeaning(kanji.meaning),
                onReading: kanji.onReading,
                kunReading: kanji.kunReading,
                color: color,
                card: card,
                isFreeMode: isFreeMode,
                autoAdvance: advances,
                onRate: onAnswer,
                onAutoAdvance: ({required hintsUsed, required mistakes}) =>
                    onAnswer(
                      drawingRating(hintsUsed: hintsUsed, mistakes: mistakes),
                      mistakes: mistakes,
                    ),
                question: l.selfAssessQuestion,
                onDetailTap: onDetailTap,
                settings: drawingSettings,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
