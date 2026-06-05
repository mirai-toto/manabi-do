import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating;

import '../../../core/providers/srs_settings_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../widgets/characters/kanji_strokes_provider.dart';
import '../../widgets/exercise/drawing_exercise.dart';
import '../../widgets/exercise/mcq_card.dart';
import '../../widgets/exercise/practice_session_screen.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

enum _QuizType { kanjiToMeaning, meaningToKanji, drawing, flashcard }

class KanjiPracticeScreen extends StatelessWidget {
  final String level;
  const KanjiPracticeScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return PracticeSessionScreen(
      title: levelLabel(level, context),
      color: levelColor(level),
      loadQueue: _buildQueue,
    );
  }

  Future<List<PracticeItem>> _buildQueue(AppDatabase db, WidgetRef ref) async {
    final settings = await ref.read(srsSettingsProvider.future);
    final color = levelColor(level);
    final rng = Random();
    final pairs = await db.getKanjiSrsSession(level, newCardLimit: settings.newCardsPerSession);
    final pool = await db.getKanjiByLevel(level);

    return pairs.map((pair) {
      final (kanji, card) = pair;
      final type = _QuizType.values[rng.nextInt(_QuizType.values.length)];

      if (type == _QuizType.flashcard) {
        return PracticeItem(
          id: kanji.id, srsType: 'kanji', card: card,
          buildBody: (index, total, onAnswer) => PracticeFlashcardBody(
            japanese: kanji.character,
            answer: kanji.meaning,
            card: card, index: index, total: total, color: color, onAnswer: onAnswer,
          ),
        );
      }

      if (type == _QuizType.drawing) {
        return PracticeItem(
          id: kanji.id, srsType: 'kanji', card: card,
          buildBody: (index, total, onAnswer) => _DrawingBody(
            kanji: kanji, card: card,
            index: index, total: total, color: color, onAnswer: onAnswer,
          ),
        );
      }

      // MCQ: kanjiToMeaning or meaningToKanji
      final isKanjiToMeaning = type == _QuizType.kanjiToMeaning;
      final distractors = pool.where((k) => k.id != kanji.id).toList()..shuffle(rng);
      final options = [kanji, ...distractors.take(3)]..shuffle(rng);
      final correctIndex = options.indexWhere((k) => k.id == kanji.id);
      final mcqOptions = List.generate(4, (i) => McqOption(
        letter: String.fromCharCode(65 + i),
        text: isKanjiToMeaning ? options[i].meaning : options[i].character,
        useJpFont: !isKanjiToMeaning,
      ));

      return PracticeItem(
        id: kanji.id, srsType: 'kanji', card: card,
        buildBody: (index, total, onAnswer) => _KanjiMcqBody(
          isKanjiToMeaning: isKanjiToMeaning,
          kanjiMeaning: kanji.meaning,
          kanjiCharacter: kanji.character,
          options: mcqOptions,
          correctIndex: correctIndex,
          card: card, index: index, total: total, color: color, onAnswer: onAnswer,
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
  final int index;
  final int total;
  final Color color;
  final void Function(Rating) onAnswer;

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
      card: card, index: index, total: total, color: color, onAnswer: onAnswer,
    );
  }
}

// ── Drawing body ──────────────────────────────────────────────────────────────

class _DrawingBody extends ConsumerWidget {
  final Kanji kanji;
  final Card? card;
  final int index;
  final int total;
  final Color color;
  final void Function(Rating) onAnswer;

  const _DrawingBody({
    required this.kanji,
    required this.card,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
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
          LinearProgressIndicator(
            value: index / total,
            backgroundColor: t.outlineVariant,
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: AppDimens.spaceMd),
          strokesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const SizedBox.shrink(),
            data: (refStrokes) => DrawingExercise(
              referenceStrokes: refStrokes,
              kanjiId: kanji.id,
              label: kanji.meaning,
              color: color,
              card: card,
              onRate: onAnswer,
              question: l.selfAssessQuestion,
            ),
          ),
        ],
      ),
    );
  }
}
