import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating, Scheduler;

import '../../../core/providers/srs_settings_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/database_provider.dart';
import '../../widgets/characters/kanji_strokes_provider.dart';
import '../../widgets/exercise/drawing_exercise.dart';
import '../../widgets/exercise/flash_card.dart';
import '../../widgets/exercise/mcq_card.dart';
import '../../widgets/exercise/session_summary.dart';

// ── Quiz types ────────────────────────────────────────────────────────────────

enum _QuizType { kanjiToMeaning, meaningToKanji, drawing, flashcard }

class _QueueItem {
  final Kanji kanji;
  final Card? card;
  final _QuizType quizType;
  final List<Kanji> mcqOptions; // 4 shuffled kanji
  final int correctIndex;

  const _QueueItem({
    required this.kanji,
    required this.card,
    required this.quizType,
    this.mcqOptions = const [],
    this.correctIndex = 0,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────

class KanjiPracticeScreen extends ConsumerStatefulWidget {
  final String level;
  const KanjiPracticeScreen({super.key, required this.level});

  @override
  ConsumerState<KanjiPracticeScreen> createState() => _KanjiPracticeScreenState();
}

class _KanjiPracticeScreenState extends ConsumerState<KanjiPracticeScreen> {
  final _scheduler = Scheduler();
  final _rng = Random();
  List<_QueueItem>? _queue;
  int _index = 0;
  int _gotIt = 0;
  int _notYet = 0;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final db = ref.read(databaseProvider);
    final settings = await ref.read(srsSettingsProvider.future);
    final pairs = await db.getKanjiSrsSession(widget.level, newCardLimit: settings.newCardsPerSession);
    final pool = await db.getKanjiByLevel(widget.level);

    final items = pairs.map((pair) {
      final (kanji, card) = pair;
      final type = _QuizType.values[_rng.nextInt(_QuizType.values.length)];

      if (type == _QuizType.drawing || type == _QuizType.flashcard) {
        return _QueueItem(kanji: kanji, card: card, quizType: type);
      }

      final distractors = pool.where((k) => k.id != kanji.id).toList()..shuffle(_rng);
      final options = [kanji, ...distractors.take(3)]..shuffle(_rng);
      return _QueueItem(
        kanji: kanji,
        card: card,
        quizType: type,
        mcqOptions: options,
        correctIndex: options.indexWhere((k) => k.id == kanji.id),
      );
    }).toList();

    setState(() {
      _queue = items;
      if (items.isEmpty) _done = true;
    });
  }

  Future<void> _answer(Rating rating) async {
    final item = _queue![_index];
    final fsrsCard = item.card ??
        Card(cardId: DateTime.now().millisecondsSinceEpoch, due: DateTime.now());

    final result = _scheduler.reviewCard(fsrsCard, rating);
    final db = ref.read(databaseProvider);
    await db.upsertSrsCard('kanji', item.kanji.id, result.card);

    setState(() {
      if (rating == Rating.again) {
        _notYet++;
      } else {
        _gotIt++;
      }
      if (_index + 1 >= _queue!.length) {
        _done = true;
      } else {
        _index++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = levelColor(widget.level);

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
          levelLabel(widget.level, context),
          style: AppTextStyles.title.copyWith(color: t.onSurface),
        ),
      ),
      body: _queue == null
          ? const Center(child: CircularProgressIndicator())
          : _done
              ? SessionSummary(
                  gotIt: _gotIt,
                  notYet: _notYet,
                  color: color,
                  onDone: () => Navigator.of(context).pop(),
                )
              : _buildBody(_queue![_index], color),
    );
  }

  Widget _buildBody(_QueueItem item, Color color) {
    return switch (item.quizType) {
      _QuizType.flashcard => _FlashcardBody(
        key: ValueKey(_index),
        item: item,
        index: _index,
        total: _queue!.length,
        color: color,
        onAnswer: _answer,
      ),
      _QuizType.drawing => _DrawingBody(
        key: ValueKey(_index),
        item: item,
        index: _index,
        total: _queue!.length,
        color: color,
        onAnswer: _answer,
      ),
      _ => _McqBody(
        key: ValueKey(_index),
        item: item,
        index: _index,
        total: _queue!.length,
        color: color,
        onAnswer: _answer,
      ),
    };
  }
}

// ── MCQ body ──────────────────────────────────────────────────────────────────

class _McqBody extends StatefulWidget {
  final _QueueItem item;
  final int index;
  final int total;
  final Color color;
  final void Function(Rating) onAnswer;

  const _McqBody({
    super.key,
    required this.item,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
  });

  @override
  State<_McqBody> createState() => _McqBodyState();
}

class _McqBodyState extends State<_McqBody> {
  var _states = List.filled(4, McqOptionState.idle);
  bool _answered = false;

  void _onTap(int i) {
    if (_answered) return;
    final isCorrect = i == widget.item.correctIndex;
    setState(() {
      _answered = true;
      _states = List.generate(4, (j) {
        if (j == i) return isCorrect ? McqOptionState.correct : McqOptionState.wrong;
        if (!isCorrect && j == widget.item.correctIndex) return McqOptionState.correct;
        return McqOptionState.idle;
      });
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      widget.onAnswer(isCorrect ? Rating.good : Rating.again);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final item = widget.item;
    final isKanjiToMeaning = item.quizType == _QuizType.kanjiToMeaning;

    final options = List.generate(4, (i) {
      final opt = item.mcqOptions[i];
      return McqOption(
        letter: String.fromCharCode(65 + i),
        text: isKanjiToMeaning ? opt.meaning : opt.character,
        state: _states[i],
        useJpFont: !isKanjiToMeaning,
      );
    });

    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: widget.index / widget.total,
            backgroundColor: t.outlineVariant,
            color: widget.color,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          McqCard(
            question: isKanjiToMeaning
                ? l.mcqSelectMeaning
                : l.mcqSelectKanji(item.kanji.meaning),
            japanesePrompt: isKanjiToMeaning ? item.kanji.character : null,
            options: options,
            onOptionTap: _onTap,
          ),
        ],
      ),
    );
  }
}

// ── Flashcard body ────────────────────────────────────────────────────────────

class _FlashcardBody extends StatefulWidget {
  final _QueueItem item;
  final int index;
  final int total;
  final Color color;
  final void Function(Rating) onAnswer;

  const _FlashcardBody({
    super.key,
    required this.item,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
  });

  @override
  State<_FlashcardBody> createState() => _FlashcardBodyState();
}

class _FlashcardBodyState extends State<_FlashcardBody> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final item = widget.item;

    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: widget.index / widget.total,
            backgroundColor: t.outlineVariant,
            color: widget.color,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          FlashCard(
            japanese: item.kanji.character,
            answer: item.kanji.meaning,
            isRevealed: _revealed,
            onTap: _revealed ? null : () => setState(() => _revealed = true),
          ),
          if (_revealed) ...[
            const SizedBox(height: AppDimens.spaceMd),
            FlashCardActions(
              card: widget.item.card,
              question: l.selfAssessQuestion,
              onRate: widget.onAnswer,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Drawing body ──────────────────────────────────────────────────────────────

class _DrawingBody extends ConsumerWidget {
  final _QueueItem item;
  final int index;
  final int total;
  final Color color;
  final void Function(Rating) onAnswer;

  const _DrawingBody({
    super.key,
    required this.item,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;
    final strokesAsync = ref.watch(kanjiStrokesProvider(item.kanji.id));

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
              kanjiId: item.kanji.id,
              label: item.kanji.meaning,
              color: color,
              card: item.card,
              onRate: onAnswer,
              question: l.selfAssessQuestion,
            ),
          ),
        ],
      ),
    );
  }
}

