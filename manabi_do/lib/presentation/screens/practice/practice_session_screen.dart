import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Rating;

import '../../../core/providers/srs_settings_provider.dart';
import '../../../core/theme/accent_theme.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/flashcard_settings_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/mcq_settings_provider.dart';
import '../../providers/practice_session_provider.dart';
import '../../providers/sentence_settings_provider.dart';
import '../../widgets/widgets.dart';
import 'practice_item.dart';
import 'practice_settings_sheet.dart';

export 'practice_item.dart';
export '../../widgets/exercise/practice_flashcard_body.dart';
export '../../widgets/exercise/practice_mcq_body.dart';
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
              ? const Center(child: CircularProgressIndicator())
              : session.done
              ? _buildSummary(session, notifier)
              : KeyedSubtree(
                  key: ValueKey(session.index),
                  child: session.currentItem!.buildBody(
                    session.index,
                    session.queue!.length,
                    (Rating rating) =>
                        notifier.answer(rating, persistSrs: widget.persistSrs),
                    bodySettings,
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
