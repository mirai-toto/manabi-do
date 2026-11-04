import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/practice_answer.dart';
import '../../../core/srs/drawing_rating.dart';
import '../../../core/theme/accent_theme.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/duration_label.dart';
import '../../../l10n/l10n.dart';
import '../../providers/drawing_settings_provider.dart';
import '../../providers/writing_session_provider.dart';
import '../../providers/kanji_strokes_provider.dart';
import '../../widgets/widgets.dart';
import '../characters/kanji/kanji_detail_screen.dart';
import 'practice_settings_sheet.dart';
import 'session_app_bar.dart';
import 'session_review_screen.dart';

class WritingSessionScreen extends ConsumerStatefulWidget {
  final String level;
  final Color color;
  final Set<int>? kanjiIds;

  const WritingSessionScreen({
    super.key,
    required this.level,
    required this.color,
    this.kanjiIds,
  });

  @override
  ConsumerState<WritingSessionScreen> createState() =>
      _WritingSessionScreenState();
}

class _WritingSessionScreenState extends ConsumerState<WritingSessionScreen>
    with MarksPracticeActive<WritingSessionScreen> {
  int _index = 0;
  DateTime _startedAt = DateTime.now();

  /// Every kanji drawn so far. Free practice writes nothing back to the SRS, so
  /// these are kept here rather than in `practiceSessionProvider`, and the
  /// review shows them without offering to re-grade.
  final List<SessionAnswer> _answers = [];

  WritingSessionArgs get _args =>
      WritingSessionArgs(level: widget.level, kanjiIds: widget.kanjiIds);

  void _advance() => setState(() => _index++);

  void _record(
    Kanji kanji,
    String meaning, {
    required bool hintsUsed,
    required int mistakes,
  }) {
    _answers.add(
      SessionAnswer(
        srsType: 'kanji',
        id: kanji.id,
        card: null,
        rating: drawingRating(hintsUsed: hintsUsed, mistakes: mistakes),
        mistakes: mistakes,
        summary: PracticeSummary(
          item: kanji.character,
          question: (l) => l.reviewDrawPrompt(meaning),
          answer: meaning,
          kindLabel: (l) => l.reviewKindKanjiWriting,
        ),
      ),
    );
    _advance();
  }

  void _restart() {
    ref.invalidate(writingKanjiProvider(_args));
    setState(() {
      _index = 0;
      _answers.clear();
      _startedAt = DateTime.now();
    });
  }

  Widget _buildSummary(int total) {
    final int correct = _answers.where((a) => a.isCorrect).length;
    return Scaffold(
      backgroundColor: context.tokens.surface,
      appBar: AppBar(backgroundColor: context.tokens.surface),
      body: AccentTheme(
        accent: widget.color,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: SummaryCard(
            score: correct,
            total: total,
            title: context.l10n.sessionComplete,
            subtitle: widget.level,
            correct: correct,
            missed: _answers.length - correct,
            timeSpent: durationLabel(
              DateTime.now().difference(_startedAt),
              context.l10n,
            ),
            onRetry: _restart,
            onNext: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final queueAsync = ref.watch(writingKanjiProvider(_args));

    return queueAsync.when(
      loading: () => Scaffold(
        backgroundColor: t.surface,
        body: const Center(child: AppSpinner.page()),
      ),
      error: (_, _) =>
          Scaffold(backgroundColor: t.surface, body: const SizedBox.shrink()),
      data: (queue) => _index >= queue.length
          ? _buildSummary(queue.length)
          : _ActiveScreen(
              level: widget.level,
              color: widget.color,
              kanji: queue[_index].$1,
              meaning: queue[_index].$2,
              index: _index,
              total: queue.length,
              answers: _answers,
              onDone: ({required hintsUsed, required mistakes}) => _record(
                queue[_index].$1,
                queue[_index].$2,
                hintsUsed: hintsUsed,
                mistakes: mistakes,
              ),
            ),
    );
  }
}

// ── Active screen ─────────────────────────────────────────────────────────────

class _ActiveScreen extends ConsumerWidget {
  final String level;
  final Color color;
  final Kanji kanji;
  final String meaning;
  final int index;
  final int total;
  final List<SessionAnswer> answers;
  final void Function({required bool hintsUsed, required int mistakes}) onDone;

  const _ActiveScreen({
    required this.level,
    required this.color,
    required this.kanji,
    required this.meaning,
    required this.index,
    required this.total,
    required this.answers,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final strokesAsync = ref.watch(kanjiStrokesProvider(kanji.id));
    final drawingSettings = ref.watch(drawingSettingsProvider);

    return Scaffold(
      backgroundColor: t.surface,
      appBar: AppBar(
        backgroundColor: t.surface,
        title: Text(
          level,
          style: AppTextStyles.title.copyWith(color: t.onSurface),
        ),
        actions: [
          // Nothing to look back at until something has been drawn.
          if (answers.isNotEmpty)
            SessionHistoryButton(
              count: answers.length,
              color: color,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      SessionReviewScreen(answers: answers, total: total),
                ),
              ),
            ),
          SessionSettingsButton(
            sheetBuilder: (_) => const PracticeSettingsSheet(
              contexts: {SettingsContext.writing},
              showAutoAdvance: true,
            ),
          ),
        ],
      ),
      body: AccentTheme(
        accent: color,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Column(
            children: [
              PracticeProgressRow(index: index, total: total, color: color),
              const SizedBox(height: AppDimens.spaceMd),
              Expanded(
                child: strokesAsync.when(
                  loading: () => const Center(child: AppSpinner.page()),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (refStrokes) => DrawingExercise(
                    referenceStrokes: refStrokes,
                    kanjiId: kanji.id,
                    label: meaning,
                    onReading: kanji.onReading,
                    kunReading: kanji.kunReading,
                    color: color,
                    settings: drawingSettings,
                    autoAdvance: drawingSettings.autoAdvance,
                    // Always machine-graded through `drawingRating`; this
                    // session never asks for a self-assessment.
                    fourPointGrading: false,
                    onNext: onDone,
                    onAutoAdvance: onDone,
                    onDetailTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => KanjiDetailScreen(kanjiId: kanji.id),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
