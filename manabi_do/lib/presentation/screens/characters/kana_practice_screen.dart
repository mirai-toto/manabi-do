import 'package:flutter/material.dart' hide Card, State;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../providers/database_provider.dart';
import '../../widgets/exercise/flash_card.dart';

class KanaPracticeScreen extends ConsumerStatefulWidget {
  final String type; // 'hiragana' | 'katakana'
  const KanaPracticeScreen({super.key, required this.type});

  @override
  ConsumerState<KanaPracticeScreen> createState() => _KanaPracticeScreenState();
}

class _KanaPracticeScreenState extends ConsumerState<KanaPracticeScreen> {
  final _scheduler = Scheduler();
  List<(Kana, Card?)>? _queue;
  int _index = 0;
  bool _revealed = false;
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
    final queue = await db.getKanaSrsSession(widget.type);
    setState(() => _queue = queue);
    if (queue.isEmpty) setState(() => _done = true);
  }

  Future<void> _answer(Rating rating) async {
    final queue = _queue!;
    final (kana, existingCard) = queue[_index];
    final fsrsCard = existingCard ??
        Card(cardId: DateTime.now().millisecondsSinceEpoch, due: DateTime.now());

    final result = _scheduler.reviewCard(fsrsCard, rating);

    final db = ref.read(databaseProvider);
    await db.upsertSrsCard(widget.type, kana.id, result.card);

    // Mark as known once stability reaches 21 days (Anki "mature" threshold)
    final stability = result.card.stability ?? 0;
    final wasKnown = (existingCard?.stability ?? 0) >= 21;
    if (stability >= 21 && !wasKnown) {
      await db.setKanaKnown(widget.type, kana.id, isKnown: true);
    }

    setState(() {
      if (rating == Rating.again) {
        _notYet++;
      } else {
        _gotIt++;
      }
      if (_index + 1 >= queue.length) {
        _done = true;
      } else {
        _index++;
        _revealed = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final color = levelColor('kana');

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
          widget.type == 'hiragana' ? l.tabHiragana : l.tabKatakana,
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
              : _SessionBody(
                  entry: _queue![_index],
                  index: _index,
                  total: _queue!.length,
                  revealed: _revealed,
                  color: color,
                  onReveal: () => setState(() => _revealed = true),
                  onAnswer: _answer,
                ),
    );
  }
}

class _SessionBody extends StatelessWidget {
  final (Kana, Card?) entry;
  final int index;
  final int total;
  final bool revealed;
  final Color color;
  final VoidCallback onReveal;
  final void Function(Rating) onAnswer;

  const _SessionBody({
    required this.entry,
    required this.index,
    required this.total,
    required this.revealed,
    required this.color,
    required this.onReveal,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final kana = entry.$1;

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
          const SizedBox(height: AppDimens.spaceLg),
          FlashCard(
            japanese: kana.character,
            answer: kana.romaji,
            isRevealed: revealed,
            onTap: revealed ? null : onReveal,
          ),
          const SizedBox(height: AppDimens.spaceMd),
          if (revealed)
            FlashCardActions(
              notYetLabel: l.flashcardNotYet,
              gotItLabel: l.flashcardGotIt,
              onNotYet: () => onAnswer(Rating.again),
              onGotIt: () => onAnswer(Rating.good),
            )
          else
            const SizedBox(height: 56),
        ],
      ),
    );
  }
}

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
              Text('🎉', style: const TextStyle(fontSize: 56)),
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
            Text('🎉', style: const TextStyle(fontSize: 56)),
            const SizedBox(height: AppDimens.spaceMd),
            Text(
              l.practiceSessionDone,
              style: AppTextStyles.title.copyWith(color: t.onSurface),
            ),
            const SizedBox(height: AppDimens.spaceLg),
            _StatRow(
              icon: Icons.check_circle_rounded,
              color: t.success,
              label: l.practiceGotIt(gotIt),
            ),
            const SizedBox(height: AppDimens.spaceSm),
            _StatRow(
              icon: Icons.cancel_rounded,
              color: t.error,
              label: l.practiceNotYet(notYet),
            ),
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
      child: Text(label, style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
    ),
  );
}
