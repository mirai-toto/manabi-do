import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating;

import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/srs_settings_provider.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../data/database/app_database.dart';
import '../../../../l10n/l10n.dart';
import '../../../../l10n/level_label.dart';
import '../../../providers/flashcard_settings_provider.dart';
import '../../../providers/mcq_settings_provider.dart';
import '../../../widgets/characters/kanji_strokes_provider.dart';
import '../../../widgets/exercise/drawing_exercise.dart';
import '../../../widgets/exercise/mcq_card.dart';
import '../../practice/practice_session_screen.dart';
import 'kanji_detail_screen.dart';
import '../../practice/practice_settings_sheet.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

enum _QuizType { kanjiToMeaning, meaningToKanji, drawing, flashcard }

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
    final builder = _KanjiQueueBuilder(
      level: level,
      allowedIds: allowedIds,
      exerciseFilter: exerciseFilter,
      freeMode: freeMode,
    );
    return PracticeSessionScreen(
      title: levelLabel(level, context),
      color: levelColor(level),
      loadQueue: (db, ref) => builder.build(db: db, ref: ref),
      persistSrs: !freeMode,
      settingsContexts: _contexts,
    );
  }
}

// ── Queue builder ─────────────────────────────────────────────────────────────

class _KanjiQueueBuilder {
  final String level;
  final Set<int>? allowedIds;
  final ExerciseFilter exerciseFilter;
  final bool freeMode;

  const _KanjiQueueBuilder({
    required this.level,
    required this.allowedIds,
    required this.exerciseFilter,
    required this.freeMode,
  });

  Future<List<PracticeItem>> build({
    required AppDatabase db,
    required WidgetRef ref,
  }) async {
    final color = levelColor(level);
    final rng = Random();
    final locale = ref.read(localeProvider).languageCode;

    final mcqSettings = ref.read(mcqSettingsProvider);
    final flashcardSettings = ref.read(flashcardSettingsProvider);

    final int? sessionLimit = switch (exerciseFilter) {
      ExerciseFilter.flashcardOnly => flashcardSettings.sessionLength,
      _ => mcqSettings.sessionLength,
    };

    final List<(Kanji, Card?)> pairs;
    if (freeMode) {
      final all = await db.getKanjiByLevel(level);
      final filtered = allowedIds != null
          ? all.where((k) => allowedIds!.contains(k.id)).toList()
          : all;
      filtered.shuffle(rng);
      final limited = sessionLimit != null
          ? filtered.take(sessionLimit).toList()
          : filtered;
      pairs = limited.map((k) => (k, null)).toList();
    } else {
      final settings = await ref.read(srsSettingsProvider.future);
      final allPairs = await db.getKanjiSrsSession(
        level,
        newCardLimit: settings.newCharactersPerDay,
      );
      final filteredPairs = allowedIds != null
          ? allPairs.where((p) => allowedIds!.contains(p.$1.id)).toList()
          : allPairs;
      pairs = sessionLimit != null
          ? filteredPairs.take(sessionLimit).toList()
          : filteredPairs;
    }

    final allPool = await db.getKanjiByLevel(level);
    final pool = allowedIds != null
        ? allPool.where((k) => allowedIds!.contains(k.id)).toList()
        : allPool;

    final allIds = [...pairs.map((p) => p.$1.id), ...pool.map((k) => k.id)];
    final kanjiTranslations = locale != 'en'
        ? await db.getKanjiTranslations(allIds.toSet().toList(), locale)
        : <int, String>{};
    String meaningOf(Kanji k) => kanjiTranslations[k.id]?.isNotEmpty == true
        ? kanjiTranslations[k.id]!
        : k.meaning;

    final availableTypes = switch (exerciseFilter) {
      ExerciseFilter.flashcardOnly => [_QuizType.flashcard],
      ExerciseFilter.mcqOnly => [
        _QuizType.kanjiToMeaning,
        _QuizType.meaningToKanji,
      ],
      ExerciseFilter.mixed => _QuizType.values,
    };

    return pairs.map((pair) {
      final (kanji, card) = pair;
      final type = availableTypes[rng.nextInt(availableTypes.length)];

      if (type == _QuizType.flashcard) {
        return PracticeItem(
          id: kanji.id,
          srsType: 'kanji',
          card: card,
          buildBody: (index, total, onAnswer) => Builder(
            builder: (ctx) => PracticeFlashcardBody(
              japanese: kanji.character,
              answer: meaningOf(kanji),
              isFreeMode: freeMode,
              card: card,
              index: index,
              total: total,
              color: color,
              onAnswer: onAnswer,
              onDetailTap: () => Navigator.of(ctx).push(
                MaterialPageRoute(
                  builder: (_) => KanjiDetailScreen(kanjiId: kanji.id),
                ),
              ),
            ),
          ),
        );
      }

      if (type == _QuizType.drawing) {
        return PracticeItem(
          id: kanji.id,
          srsType: 'kanji',
          card: card,
          buildBody: (index, total, onAnswer) => Builder(
            builder: (ctx) => KanjiDrawingBody(
              kanji: kanji,
              meaning: meaningOf(kanji),
              card: card,
              isFreeMode: freeMode,
              index: index,
              total: total,
              color: color,
              onAnswer: onAnswer,
              onDetailTap: () => Navigator.of(ctx).push(
                MaterialPageRoute(
                  builder: (_) => KanjiDetailScreen(kanjiId: kanji.id),
                ),
              ),
            ),
          ),
        );
      }

      // MCQ: kanjiToMeaning or meaningToKanji
      final isKanjiToMeaning = type == _QuizType.kanjiToMeaning;
      final n = mcqSettings.mcqChoiceCount;
      final distractors = pool.where((k) => k.id != kanji.id).toList()
        ..shuffle(rng);
      final options = [kanji, ...distractors.take(n - 1)]..shuffle(rng);
      final correctIndex = options.indexWhere((k) => k.id == kanji.id);
      final mcqOptions = List.generate(
        options.length,
        (i) => McqOption(
          letter: String.fromCharCode(65 + i),
          text: isKanjiToMeaning ? meaningOf(options[i]) : options[i].character,
          useJpFont: !isKanjiToMeaning,
        ),
      );

      return PracticeItem(
        id: kanji.id,
        srsType: 'kanji',
        card: card,
        buildBody: (index, total, onAnswer) => Builder(
          builder: (ctx) => _KanjiMcqBody(
            isKanjiToMeaning: isKanjiToMeaning,
            kanjiMeaning: meaningOf(kanji),
            kanjiCharacter: kanji.character,
            options: mcqOptions,
            correctIndex: correctIndex,
            isFreeMode: freeMode,
            card: card,
            index: index,
            total: total,
            color: color,
            onAnswer: onAnswer,
            onDetailTap: () => Navigator.of(ctx).push(
              MaterialPageRoute(
                builder: (_) => KanjiDetailScreen(kanjiId: kanji.id),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

// ── Kanji MCQ body ────────────────────────────────────────────────────────────

class _KanjiMcqBody extends StatelessWidget {
  final bool isKanjiToMeaning;
  final String kanjiMeaning;
  final String kanjiCharacter;
  final List<McqOption> options;
  final int correctIndex;
  final Card? card;
  final bool isFreeMode;
  final int index;
  final int total;
  final Color color;
  final void Function(Rating) onAnswer;
  final VoidCallback? onDetailTap;

  const _KanjiMcqBody({
    required this.isKanjiToMeaning,
    required this.kanjiMeaning,
    required this.kanjiCharacter,
    required this.options,
    required this.correctIndex,
    required this.card,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
    this.isFreeMode = false,
    this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PracticeMcqBody(
      question: isKanjiToMeaning
          ? l.mcqSelectMeaning
          : l.mcqSelectKanji(kanjiMeaning),
      japanesePrompt: isKanjiToMeaning ? kanjiCharacter : null,
      options: options,
      correctIndex: correctIndex,
      isFreeMode: isFreeMode,
      card: card,
      index: index,
      total: total,
      color: color,
      onAnswer: onAnswer,
      onDetailTap: onDetailTap,
      compactGrid: !isKanjiToMeaning,
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
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 18,
                  icon: Icon(Icons.tune_rounded, color: t.onSurfaceVariant),
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => PracticeSettingsSheet(
                      contexts: const {SettingsContext.writing},
                      showAutoAdvance: isFreeMode,
                    ),
                  ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
