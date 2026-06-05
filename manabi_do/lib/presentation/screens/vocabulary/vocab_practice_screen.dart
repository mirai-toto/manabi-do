import 'dart:math';

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating, Scheduler;

import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/srs_settings_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/database_provider.dart';
import '../../widgets/exercise/flash_card.dart';
import '../../widgets/exercise/mcq_card.dart';
import '../../widgets/exercise/session_summary.dart';

// ── Data model ────────────────────────────────────────────────────────────────

enum _QuizType { flashcard, mcq }

class _QueueItem {
  final VocabularyEntry entry;
  final Card? card;
  final _QuizType quizType;
  final List<String> mcqOptions; // 4 meanings, shuffled
  final int correctIndex;

  const _QueueItem({
    required this.entry,
    required this.card,
    required this.quizType,
    this.mcqOptions = const [],
    this.correctIndex = 0,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────

class VocabPracticeScreen extends ConsumerStatefulWidget {
  final String level;
  const VocabPracticeScreen({super.key, required this.level});

  @override
  ConsumerState<VocabPracticeScreen> createState() => _VocabPracticeScreenState();
}

class _VocabPracticeScreenState extends ConsumerState<VocabPracticeScreen> {
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
    final locale = ref.read(localeProvider).languageCode;
    final pairs = await db.getVocabSrsSession(
      widget.level,
      newCardLimit: settings.newCardsPerSession,
    );

    // Fetch localized meanings for distractor pool
    final pool = await db.getVocabByLevel(widget.level);
    final poolIds = pool.map((v) => v.id).toList();
    final translations = locale != 'en'
        ? await db.getVocabTranslations(poolIds, locale)
        : <int, String>{};

    String meaningOf(VocabularyEntry v) =>
        translations[v.id]?.isNotEmpty == true ? translations[v.id]! : v.meaning;

    final items = pairs.map((pair) {
      final (entry, card) = pair;
      final type = _rng.nextBool() ? _QuizType.flashcard : _QuizType.mcq;

      if (type == _QuizType.flashcard) {
        return _QueueItem(entry: entry, card: card, quizType: type);
      }

      final distractors = pool.where((v) => v.id != entry.id).toList()..shuffle(_rng);
      final optionEntries = [entry, ...distractors.take(3)]..shuffle(_rng);
      final options = optionEntries.map(meaningOf).toList();
      return _QueueItem(
        entry: entry,
        card: card,
        quizType: type,
        mcqOptions: options,
        correctIndex: optionEntries.indexWhere((v) => v.id == entry.id),
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

    await ref.read(databaseProvider).upsertSrsCard('vocabulary', item.entry.id, result.card);

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
      _QuizType.mcq => _McqBody(
          key: ValueKey(_index),
          item: item,
          index: _index,
          total: _queue!.length,
          color: color,
          onAnswer: _answer,
        ),
      _QuizType.flashcard => _FlashcardBody(
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
    final item = widget.item;

    return SingleChildScrollView(
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
            japanese: item.entry.word,
            label: item.entry.reading,
            answer: item.entry.meaning,
            isRevealed: _revealed,
            onTap: _revealed ? null : () => setState(() => _revealed = true),
          ),
          if (_revealed) ...[
            const SizedBox(height: AppDimens.spaceMd),
            FlashCardActions(
              card: item.card,
              question: context.l10n.selfAssessQuestion,
              onRate: widget.onAnswer,
            ),
          ],
        ],
      ),
    );
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
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final item = widget.item;

    final options = List.generate(4, (i) => McqOption(
      letter: String.fromCharCode(65 + i),
      text: item.mcqOptions[i],
      state: _states[i],
    ));

    return SingleChildScrollView(
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
            question: context.l10n.mcqSelectWordMeaning,
            japanesePrompt: item.entry.word,
            options: options,
            onOptionTap: _answered ? null : _onTap,
          ),
          if (_answered) ...[
            const SizedBox(height: AppDimens.spaceMd),
            FlashCardActions(
              card: item.card,
              question: context.l10n.selfAssessQuestion,
              onRate: widget.onAnswer,
            ),
          ],
        ],
      ),
    );
  }
}
