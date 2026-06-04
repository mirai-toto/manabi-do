import 'dart:math';
import 'dart:ui' as dart_ui;

import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating, Scheduler;

import '../../../core/providers/srs_settings_provider.dart';
import '../../../core/srs/stroke_dtw.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/database_provider.dart';
import '../../widgets/characters/kanji_drawing_canvas.dart';
import '../../widgets/characters/kanji_strokes_provider.dart';
import '../../widgets/characters/stroke_order_animator.dart';
import '../../widgets/common/app_emoji.dart';
import '../../widgets/exercise/flash_card.dart';
import '../../widgets/exercise/mcq_card.dart';

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
              ? _SessionSummary(
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
              notYetLabel: l.flashcardNotYet,
              gotItLabel: l.flashcardGotIt,
              question: l.selfAssessQuestion,
              onNotYet: () => widget.onAnswer(Rating.again),
              onGotIt: () => widget.onAnswer(Rating.good),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Drawing body ──────────────────────────────────────────────────────────────

class _DrawingBody extends ConsumerStatefulWidget {
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
  ConsumerState<_DrawingBody> createState() => _DrawingBodyState();
}

class _DrawingBodyState extends ConsumerState<_DrawingBody> {
  List<List<Offset>> _strokes = [];
  List<bool>? _strokeResults;
  final _canvasKey = GlobalKey<KanjiDrawingCanvasState>();

  void _check(List<dart_ui.Path> refStrokes) {
    setState(() => _strokeResults = evaluateStrokes(_strokes, refStrokes));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final strokesAsync = ref.watch(kanjiStrokesProvider(widget.item.kanji.id));
    final checked = _strokeResults != null;

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
          const SizedBox(height: AppDimens.spaceMd),
          strokesAsync.when(
            loading: () => const Expanded(child: Center(child: CircularProgressIndicator())),
            error: (_, _) => const SizedBox.shrink(),
            data: (refStrokes) {
              final correctCount = _strokeResults?.where((b) => b).length ?? 0;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.item.kanji.meaning,
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
                        backgroundColor: widget.color,
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
                                StrokeOrderAnimator(
                                    kanjiId: widget.item.kanji.id, size: cardSize),
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
                    FlashCardActions(
                      notYetLabel: l.flashcardNotYet,
                      gotItLabel: l.flashcardGotIt,
                      onNotYet: () => widget.onAnswer(Rating.again),
                      onGotIt: () => widget.onAnswer(Rating.good),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Session summary ───────────────────────────────────────────────────────────

class _SessionSummary extends StatelessWidget {
  final int gotIt;
  final int notYet;
  final Color color;
  final VoidCallback onDone;

  const _SessionSummary({
    required this.gotIt,
    required this.notYet,
    required this.color,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final total = gotIt + notYet;

    if (total == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppEmoji('🎉', size: 56),
              const SizedBox(height: AppDimens.spaceMd),
              Text(l.practiceEmpty,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(color: t.onSurfaceVariant)),
              const SizedBox(height: AppDimens.spaceLg),
              _DoneButton(onDone: onDone, color: color, label: l.practiceDone),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppEmoji('🎉', size: 56),
            const SizedBox(height: AppDimens.spaceMd),
            Text(l.practiceSessionDone, style: AppTextStyles.title.copyWith(color: t.onSurface)),
            const SizedBox(height: AppDimens.spaceLg),
            _StatRow(icon: Icons.check_circle_rounded, color: t.success, label: l.practiceGotIt(gotIt)),
            const SizedBox(height: AppDimens.spaceSm),
            _StatRow(icon: Icons.cancel_rounded, color: t.error, label: l.practiceNotYet(notYet)),
            const SizedBox(height: AppDimens.spaceLg),
            _DoneButton(onDone: onDone, color: color, label: l.practiceDone),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  const _StatRow({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(width: AppDimens.spaceSm),
      Text(label, style: AppTextStyles.body.copyWith(color: color, fontWeight: FontWeight.w600)),
    ],
  );
}

class _DoneButton extends StatelessWidget {
  final VoidCallback onDone;
  final Color color;
  final String label;
  const _DoneButton({required this.onDone, required this.color, required this.label});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: onDone,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusMd)),
      ),
      child: Text(
        label,
        style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
