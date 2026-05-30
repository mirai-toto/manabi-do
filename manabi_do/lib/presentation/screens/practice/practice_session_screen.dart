import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating, Scheduler;

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/database_provider.dart';
import '../../providers/home_provider.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/exercise/summary_card.dart';
import 'practice_item.dart';
import 'practice_settings_sheet.dart';

export 'practice_item.dart';
export 'practice_flashcard_body.dart';
export 'practice_mcq_body.dart';
export 'practice_settings_sheet.dart' show SettingsContext;

class PracticeSessionScreen extends ConsumerStatefulWidget {
  final String title;
  final Color color;
  final LoadQueue loadQueue;
  final bool persistSrs;
  final Set<SettingsContext> settingsContexts;

  const PracticeSessionScreen({
    super.key,
    required this.title,
    required this.color,
    required this.loadQueue,
    this.persistSrs = true,
    this.settingsContexts = const {SettingsContext.mcq},
  });

  @override
  ConsumerState<PracticeSessionScreen> createState() =>
      _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends ConsumerState<PracticeSessionScreen> {
  final _scheduler = Scheduler();
  List<PracticeItem>? _queue;
  List<PracticeItem>? _completedQueue;
  int _index = 0;
  int _gotIt = 0;
  int _notYet = 0;
  bool _done = false;
  bool _isRetry = false;
  late DateTime _startedAt;
  late final PracticeActiveNotifier _practiceNotifier;

  @override
  void initState() {
    super.initState();
    _practiceNotifier = ref.read(practiceActiveProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _practiceNotifier.setActive(true);
    });
    _loadSession();
  }

  @override
  void dispose() {
    Future(() => _practiceNotifier.setActive(false));
    super.dispose();
  }

  Future<void> _loadSession() async {
    final db = ref.read(databaseProvider);
    final items = await widget.loadQueue(db, ref);
    setState(() {
      _queue = items;
      _completedQueue = null;
      _index = 0;
      _gotIt = 0;
      _notYet = 0;
      _done = items.isEmpty;
      _isRetry = false;
      _startedAt = DateTime.now();
    });
  }

  void _retrySession() {
    setState(() {
      _queue = List.from(_completedQueue!);
      _index = 0;
      _gotIt = 0;
      _notYet = 0;
      _done = false;
      _isRetry = true;
      _startedAt = DateTime.now();
    });
  }

  Future<void> _answer(Rating rating) async {
    final item = _queue![_index];
    if (widget.persistSrs && !_isRetry) {
      final fsrsCard =
          item.card ??
          Card(
            cardId: DateTime.now().millisecondsSinceEpoch,
            due: DateTime.now(),
          );
      final result = _scheduler.reviewCard(fsrsCard, rating);
      await ref
          .read(databaseProvider)
          .upsertSrsCard(item.srsType, item.id, result.card);
    }
    setState(() {
      if (rating == Rating.again) {
        _notYet++;
      } else {
        _gotIt++;
      }
      if (_index + 1 >= _queue!.length) {
        _completedQueue = List.from(_queue!);
        _done = true;
      } else {
        _index++;
      }
    });
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

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return m > 0 ? '${m}m ${s}s' : '${s}s';
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
          onPressed: _done ? _onExit : _confirmExit,
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
                showAutoAdvance: !widget.persistSrs,
              ),
            ),
          ),
        ],
      ),
      body: _queue == null
          ? const Center(child: CircularProgressIndicator())
          : _done
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              child: SummaryCard(
                score: _gotIt,
                total: _queue!.length,
                title: context.l10n.sessionComplete,
                subtitle: widget.title,
                correct: _gotIt,
                missed: _notYet,
                timeSpent: _formatDuration(
                  DateTime.now().difference(_startedAt),
                ),
                onRetry: _retrySession,
                onNext: _onExit,
              ),
            )
          : KeyedSubtree(
              key: ValueKey(_index),
              child: _queue![_index].buildBody(_index, _queue!.length, _answer),
            ),
    );
  }
}
