import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../providers/home_provider.dart';
import '../../providers/writing_session_provider.dart';
import '../../widgets/characters/kanji_strokes_provider.dart';
import '../../widgets/exercise/drawing_exercise.dart';
import 'practice_settings_sheet.dart';

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

  void _restart() {
    ref.invalidate(writingKanjiProvider(_args));
    setState(() {
      _index = 0;
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
        body: const Center(child: CircularProgressIndicator()),
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
              onAdvance: _advance,
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
  final VoidCallback onAdvance;

  const _ActiveScreen({
    required this.level,
    required this.color,
    required this.kanji,
    required this.meaning,
    required this.index,
    required this.total,
    required this.onAdvance,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final strokesAsync = ref.watch(kanjiStrokesProvider(kanji.id));

    return Scaffold(
      backgroundColor: t.surface,
      appBar: AppBar(
        backgroundColor: t.surface,
        title: Text(
          level,
          style: AppTextStyles.title.copyWith(color: t.onSurface),
        ),
        actions: [
          IconButton(
            iconSize: 18,
            icon: Icon(Icons.tune_rounded, color: t.onSurfaceVariant),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => const PracticeSettingsSheet(
                contexts: {SettingsContext.writing},
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : index / total,
                    backgroundColor: t.outlineVariant,
                    color: color,
                    borderRadius: BorderRadius.circular(AppDimens.radiusXs),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceXs),
                Text(
                  '${index + 1} / $total',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: t.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceMd),
            Expanded(
              child: strokesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => const SizedBox.shrink(),
                data: (refStrokes) => DrawingExercise(
                  referenceStrokes: refStrokes,
                  kanjiId: kanji.id,
                  label: meaning,
                  onReading: kanji.onReading,
                  kunReading: kanji.kunReading,
                  color: color,
                  onNext: onAdvance,
                ),
              ),
            ),
          ],
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
                        side: BorderSide(color: color),
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
