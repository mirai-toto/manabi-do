import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Rating;

import '../../../core/models/practice_item.dart';
import '../../../core/providers/srs_settings_provider.dart';
import '../../../core/theme/accent_theme.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/drawing_settings_provider.dart';
import '../../providers/flashcard_settings_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/mcq_settings_provider.dart';
import '../../providers/practice_session_provider.dart';
import '../../providers/sentence_settings_provider.dart';
import '../../widgets/widgets.dart';
import 'practice_question_body.dart';
import 'practice_settings_sheet.dart';
import 'session_review_screen.dart';

export '../../../core/models/practice_item.dart';
export 'practice_settings_sheet.dart' show SettingsContext;

class PracticeSessionScreen extends ConsumerStatefulWidget {
  final String title;
  final Color color;
  final LoadQueue loadQueue;
  final bool persistSrs;
  final Set<SettingsContext> settingsContexts;
  final bool hasExamples;

  const PracticeSessionScreen({
    super.key,
    required this.title,
    required this.color,
    required this.loadQueue,
    this.persistSrs = true,
    this.settingsContexts = const {SettingsContext.mcq},
    this.hasExamples = false,
  });

  @override
  ConsumerState<PracticeSessionScreen> createState() =>
      _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends ConsumerState<PracticeSessionScreen> {
  late final PracticeActiveNotifier _practiceNotifier;

  @override
  void initState() {
    super.initState();
    _practiceNotifier = ref.read(practiceActiveProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _practiceNotifier.setActive(true);
    });
    _initSession();
  }

  @override
  void dispose() {
    Future(() => _practiceNotifier.setActive(false));
    super.dispose();
  }

  Future<void> _initSession() async {
    final items = await widget.loadQueue(ref);
    if (mounted) {
      ref.read(practiceSessionProvider.notifier).init(items);
    }
  }

  void _onExit() => Navigator.of(context).pop();

  Future<void> _confirmExit() async {
    final l = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l.quitPracticeTitle,
      body: l.quitPracticeBody,
      confirmLabel: l.quit,
      isDestructive: false,
    );
    if (confirmed && mounted) _onExit();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final session = ref.watch(practiceSessionProvider);
    final notifier = ref.read(practiceSessionProvider.notifier);

    // Watched, not captured at queue-build time, so toggling a setting in the
    // in-session sheet re-renders the card currently on screen.
    final SrsSettings srs =
        ref.watch(srsSettingsProvider).asData?.value ?? const SrsSettings();
    final PracticeBodySettings bodySettings = PracticeBodySettings(
      mcq: ref.watch(mcqSettingsProvider),
      flashcard: ref.watch(flashcardSettingsProvider),
      sentence: ref.watch(sentenceSettingsProvider),
      drawing: ref.watch(drawingSettingsProvider),
      // Only a session that writes its results back has a grade to decide.
      autoAdvance: widget.persistSrs && srs.autoAdvance,
    );

    return PopScope(
      canPop: session.done,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        backgroundColor: t.surface,
        appBar: AppBar(
          backgroundColor: t.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close_rounded, color: t.onSurface),
            onPressed: session.done ? _onExit : _confirmExit,
          ),
          title: Text(
            widget.title,
            style: AppTextStyles.title.copyWith(color: t.onSurface),
          ),
          actions: [
            // Nothing to look back at until something has been answered.
            if (session.answers.isNotEmpty)
              IconButton(
                iconSize: 20,
                tooltip: context.l10n.sessionReview,
                icon: Badge.count(
                  count: session.answers.length,
                  backgroundColor: widget.color,
                  textColor: onAccentFor(widget.color),
                  child: Icon(Icons.history_rounded, color: t.onSurfaceVariant),
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    // Watched inside the route, not captured when it is pushed:
                    // re-grading rewrites the provider, and a captured list
                    // would leave the open review showing the old grade until
                    // it was closed and reopened.
                    builder: (_) => Consumer(
                      builder: (context, ref, _) {
                        final s = ref.watch(practiceSessionProvider);
                        return SessionReviewScreen(
                          answers: s.answers,
                          total: s.queue?.length ?? s.answers.length,
                          onRegrade: (i, rating) => ref
                              .read(practiceSessionProvider.notifier)
                              .regrade(
                                i,
                                rating,
                                persistSrs: widget.persistSrs,
                              ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            IconButton(
              iconSize: 18,
              icon: Icon(Icons.tune_rounded, color: t.onSurfaceVariant),
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => PracticeSettingsSheet(
                  contexts: widget.settingsContexts,
                  hasExamples: widget.hasExamples,
                  showAutoAdvance: !widget.persistSrs,
                  showSessionAutoAdvance: widget.persistSrs,
                ),
              ),
            ),
          ],
        ),
        body: AccentTheme(
          accent: widget.color,
          child: session.isLoading
              ? const Center(child: AppSpinner.page())
              : session.done
              ? _buildSummary(session, notifier)
              : KeyedSubtree(
                  key: ValueKey(session.index),
                  child: PracticeQuestionBody(
                    question: session.currentItem!.question,
                    card: session.currentItem!.card,
                    index: session.index,
                    total: session.queue!.length,
                    settings: bodySettings,
                    sessionColor: widget.color,
                    onAnswer: (Rating rating, {String? given, int? mistakes}) =>
                        notifier.answer(
                          rating,
                          persistSrs: widget.persistSrs,
                          given: given,
                          mistakes: mistakes,
                        ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSummary(
    PracticeSessionState session,
    PracticeSessionNotifier notifier,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: SummaryCard(
        score: session.gotIt,
        total: session.queue!.length,
        title: context.l10n.sessionComplete,
        subtitle: widget.title,
        correct: session.gotIt,
        missed: session.notYet,
        timeSpent: session.formattedDuration,
        onRetry: notifier.retry,
        onNext: _onExit,
      ),
    );
  }
}
