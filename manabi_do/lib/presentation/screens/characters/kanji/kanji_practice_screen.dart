import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating;

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../data/database/app_database.dart';
import '../../../../l10n/l10n.dart';
import '../../../../l10n/level_label.dart';
import '../../../providers/drawing_settings_provider.dart';
import '../../../services/kanji_session_service.dart';
import '../../../widgets/characters/kanji_strokes_provider.dart';
import '../../../widgets/exercise/drawing_exercise.dart';
import '../../practice/practice_session_screen.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

enum ExerciseFilter { mixed, flashcardOnly, mcqOnly }

class KanjiPracticeScreen extends StatelessWidget {
  final String level;
  final Set<int>? allowedIds;
  final ExerciseFilter exerciseFilter;
  final bool freeMode;

  const KanjiPracticeScreen({
    super.key,
    required this.level,
    this.allowedIds,
    this.exerciseFilter = ExerciseFilter.mixed,
    this.freeMode = false,
  });

  Set<SettingsContext> get _contexts => switch (exerciseFilter) {
    ExerciseFilter.flashcardOnly => const {SettingsContext.flashcard},
    ExerciseFilter.mcqOnly => const {SettingsContext.mcq},
    ExerciseFilter.mixed => const {
      SettingsContext.flashcard,
      SettingsContext.mcq,
    },
  };

  @override
  Widget build(BuildContext context) {
    return PracticeSessionScreen(
      title: levelLabel(level, context),
      color: levelColor(level),
      loadQueue: (ref) => kanjiSessionService.buildQueue(
        ref: ref,
        level: level,
        allowedIds: allowedIds,
        exerciseFilter: exerciseFilter,
        freeMode: freeMode,
      ),
      persistSrs: !freeMode,
      settingsContexts: _contexts,
    );
  }
}

// ── Drawing body ──────────────────────────────────────────────────────────────

class KanjiDrawingBody extends ConsumerWidget {
  final Kanji kanji;
  final Card? card;
  final bool isFreeMode;
  final int index;
  final int total;
  final Color color;
  final void Function(Rating) onAnswer;
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
    this.onDetailTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;
    final strokesAsync = ref.watch(kanjiStrokesProvider(kanji.id));
    final drawingSettings = ref.watch(drawingSettingsProvider);

    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: index / total,
                  backgroundColor: t.outlineVariant,
                  color: color,
                  borderRadius: BorderRadius.circular(AppDimens.radiusXs),
                ),
              ),
              const SizedBox(width: AppDimens.spaceXs),
              Text(
                '${index + 1} / $total',
                style: AppTextStyles.bodySmall.copyWith(
                  color: t.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Expanded(
            child: strokesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
              data: (refStrokes) => DrawingExercise(
                referenceStrokes: refStrokes,
                kanjiId: kanji.id,
                label: meaning ?? kanji.meaning,
                onReading: kanji.onReading,
                kunReading: kanji.kunReading,
                color: color,
                card: card,
                isFreeMode: isFreeMode,
                onRate: onAnswer,
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
