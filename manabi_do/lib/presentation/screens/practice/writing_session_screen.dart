import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/practice_answer.dart';
import '../../../core/srs/drawing_rating.dart';
import '../../../core/theme/accent_theme.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../providers/drawing_settings_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/writing_session_provider.dart';
import '../../providers/kanji_strokes_provider.dart';
import '../../widgets/widgets.dart';
import '../characters/kanji/kanji_detail_screen.dart';
import 'practice_settings_sheet.dart';
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

class _WritingSessionScreenState extends ConsumerState<WritingSessionScreen> {
  int _index = 0;
  DateTime _startedAt = DateTime.now();

  /// Every kanji drawn so far. Free practice writes nothing back to the SRS, so
  /// these are kept here rather than in `practiceSessionProvider`, and the
  /// review shows them without offering to re-grade.
  final List<SessionAnswer> _answers = [];
  late final PracticeActiveNotifier _practiceNotifier;

  @override
  void initState() {
    super.initState();
    _practiceNotifier = ref.read(practiceActiveProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _practiceNotifier.setActive(true);
    });
  }

  @override
  void dispose() {
    Future(() => _practiceNotifier.setActive(false));
    super.dispose();
  }

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
          selfAssessed: true,
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

  String _elapsed() {
    final diff = DateTime.now().difference(_startedAt);
    final m = diff.inMinutes;
    final s = diff.inSeconds % 60;
    return m > 0 ? '${m}m ${s}s' : '${s}s';
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
          ? _DoneScreen(
              color: widget.color,
              count: queue.length,
              elapsed: _elapsed(),
              onRestart: _restart,
              onExit: () => Navigator.of(context).pop(),
            )
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
            IconButton(
              iconSize: 20,
              tooltip: context.l10n.sessionReview,
              icon: Badge.count(
                count: answers.length,
                backgroundColor: color,
                textColor: onAccentFor(color),
                child: Icon(Icons.history_rounded, color: t.onSurfaceVariant),
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      SessionReviewScreen(answers: answers, total: total),
                ),
              ),
            ),
          IconButton(
            iconSize: 18,
            icon: Icon(Icons.tune_rounded, color: t.onSurfaceVariant),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => const PracticeSettingsSheet(
                contexts: {SettingsContext.writing},
                showAutoAdvance: true,
              ),
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

// ── Done screen ───────────────────────────────────────────────────────────────

class _DoneScreen extends StatelessWidget {
  final Color color;
  final int count;
  final String elapsed;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const _DoneScreen({
    required this.color,
    required this.count,
    required this.elapsed,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    return Scaffold(
      backgroundColor: t.surface,
      appBar: AppBar(backgroundColor: t.surface),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: t.success, size: 72),
              const SizedBox(height: AppDimens.spaceLg),
              Text(
                l.sessionComplete,
                style: AppTextStyles.headline.copyWith(color: t.onSurface),
              ),
              const SizedBox(height: AppDimens.spaceXs),
              Text(
                l.kanjiPracticed(count),
                style: AppTextStyles.body.copyWith(color: t.onSurfaceVariant),
              ),
              const SizedBox(height: AppDimens.spaceXs),
              Text(
                elapsed,
                style: AppTextStyles.bodySmall.copyWith(
                  color: t.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimens.spaceLg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onRestart,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimens.spaceMd,
                        ),
                        side: BorderSide(
                          color: color,
                          width: AppDimens.borderWidth,
                        ),
                        foregroundColor: color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusMd,
                          ),
                        ),
                      ),
                      child: Text(
                        l.retry,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceSm),
                  Expanded(
                    child: FilledButton(
                      onPressed: onExit,
                      style: FilledButton.styleFrom(
                        backgroundColor: color,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimens.spaceMd,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusMd,
                          ),
                        ),
                      ),
                      child: Text(
                        l.next,
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
