import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating, Scheduler;

import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/database/app_database.dart';
import '../../l10n/l10n.dart';
import '../providers/database_provider.dart';
import '../widgets/exercise/flash_card.dart';
import '../widgets/exercise/mcq_card.dart';
import '../widgets/exercise/session_summary.dart';

// ── Practice item ─────────────────────────────────────────────────────────────

class PracticeItem {
  final int id;
  final String srsType;
  final Card? card;
  final Widget Function(int index, int total, void Function(Rating) onAnswer) buildBody;

  const PracticeItem({
    required this.id,
    required this.srsType,
    required this.card,
    required this.buildBody,
  });
}

// ── Session screen ────────────────────────────────────────────────────────────

class PracticeSessionScreen extends ConsumerStatefulWidget {
  final String title;
  final Color color;
  final Future<List<PracticeItem>> Function(AppDatabase db, WidgetRef ref) loadQueue;

  const PracticeSessionScreen({
    super.key,
    required this.title,
    required this.color,
    required this.loadQueue,
  });

  @override
  ConsumerState<PracticeSessionScreen> createState() => _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends ConsumerState<PracticeSessionScreen> {
  final _scheduler = Scheduler();
  List<PracticeItem>? _queue;
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
    final items = await widget.loadQueue(db, ref);
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
    await ref.read(databaseProvider).upsertSrsCard(item.srsType, item.id, result.card);
    setState(() {
      if (rating == Rating.again) { _notYet++; } else { _gotIt++; }
      if (_index + 1 >= _queue!.length) { _done = true; } else { _index++; }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Scaffold(
      backgroundColor: t.surface,
      appBar: AppBar(
        backgroundColor: t.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: t.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title, style: AppTextStyles.title.copyWith(color: t.onSurface)),
      ),
      body: _queue == null
          ? const Center(child: CircularProgressIndicator())
          : _done
              ? SessionSummary(
                  gotIt: _gotIt,
                  notYet: _notYet,
                  color: widget.color,
                  onDone: () => Navigator.of(context).pop(),
                )
              : KeyedSubtree(
                  key: ValueKey(_index),
                  child: _queue![_index].buildBody(_index, _queue!.length, _answer),
                ),
    );
  }
}

// ── Shared flashcard body ─────────────────────────────────────────────────────

class PracticeFlashcardBody extends StatefulWidget {
  final String japanese;
  final String? label;
  final String answer;
  final bool isReversed;
  final Card? card;
  final int index;
  final int total;
  final Color color;
  final void Function(Rating) onAnswer;
  final VoidCallback? onDetailTap;

  const PracticeFlashcardBody({
    super.key,
    required this.japanese,
    required this.answer,
    required this.card,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
    this.label,
    this.isReversed = false,
    this.onDetailTap,
  });

  @override
  State<PracticeFlashcardBody> createState() => _PracticeFlashcardBodyState();
}

class _PracticeFlashcardBodyState extends State<PracticeFlashcardBody> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: widget.index / widget.total,
            backgroundColor: t.outlineVariant,
            color: widget.color,
            borderRadius: BorderRadius.circular(AppDimens.radiusXs),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          FlashCard(
            japanese: widget.japanese,
            label: widget.label,
            answer: widget.answer,
            isRevealed: _revealed,
            isReversed: widget.isReversed,
            onTap: _revealed ? null : () => setState(() => _revealed = true),
          ),
          if (_revealed) ...[
            const SizedBox(height: AppDimens.spaceMd),
            FlashCardActions(
              card: widget.card,
              question: context.l10n.selfAssessQuestion,
              onRate: widget.onAnswer,
            ),
            if (widget.onDetailTap != null) ...[
              const SizedBox(height: AppDimens.spaceSm),
              TextButton.icon(
                onPressed: widget.onDetailTap,
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: Text(context.l10n.viewDetail),
                style: TextButton.styleFrom(
                  foregroundColor: context.tokens.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

// ── Shared MCQ body ───────────────────────────────────────────────────────────

class PracticeMcqBody extends StatefulWidget {
  final String question;
  final String? japanesePrompt;
  final List<McqOption> options;
  final int correctIndex;
  final Card? card;
  final int index;
  final int total;
  final Color color;
  final void Function(Rating) onAnswer;
  final VoidCallback? onDetailTap;

  const PracticeMcqBody({
    super.key,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.card,
    required this.index,
    required this.total,
    required this.color,
    required this.onAnswer,
    this.japanesePrompt,
    this.onDetailTap,
  });

  @override
  State<PracticeMcqBody> createState() => _PracticeMcqBodyState();
}

class _PracticeMcqBodyState extends State<PracticeMcqBody> {
  late List<McqOptionState> _states;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _states = List.filled(widget.options.length, McqOptionState.idle);
  }

  void _onTap(int i) {
    if (_answered) return;
    final isCorrect = i == widget.correctIndex;
    setState(() {
      _answered = true;
      _states = List.generate(widget.options.length, (j) {
        if (j == i) return isCorrect ? McqOptionState.correct : McqOptionState.wrong;
        if (!isCorrect && j == widget.correctIndex) return McqOptionState.correct;
        return McqOptionState.idle;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final options = List.generate(
      widget.options.length,
      (i) => widget.options[i].copyWith(state: _states[i]),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: widget.index / widget.total,
            backgroundColor: t.outlineVariant,
            color: widget.color,
            borderRadius: BorderRadius.circular(AppDimens.radiusXs),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          McqCard(
            question: widget.question,
            japanesePrompt: widget.japanesePrompt,
            options: options,
            onOptionTap: _answered ? null : _onTap,
          ),
          if (_answered) ...[
            const SizedBox(height: AppDimens.spaceMd),
            FlashCardActions(
              card: widget.card,
              question: context.l10n.selfAssessQuestion,
              onRate: widget.onAnswer,
            ),
            if (widget.onDetailTap != null) ...[
              const SizedBox(height: AppDimens.spaceSm),
              TextButton.icon(
                onPressed: widget.onDetailTap,
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: Text(context.l10n.viewDetail),
                style: TextButton.styleFrom(
                  foregroundColor: context.tokens.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
