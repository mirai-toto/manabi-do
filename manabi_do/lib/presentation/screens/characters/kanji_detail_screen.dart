import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card;

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../providers/database_provider.dart';
import '../../providers/kanji_provider.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/common/srs_progress_info.dart';
import '../../widgets/widgets.dart';
import 'kanji_detail/kanji_example_words.dart';
import 'kanji_detail/kanji_hero.dart';
import 'kanji_detail/kanji_readings_card.dart';
import 'kanji_detail/stroke_order_section.dart';
import 'kanji_drawing_practice_screen.dart';

class KanjiDetailScreen extends ConsumerWidget {
  final int kanjiId;
  const KanjiDetailScreen({super.key, required this.kanjiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanji = ref.watch(kanjiDetailProvider(kanjiId)).asData?.value;
    final isKnown =
        ref.watch(knownKanjiIdsProvider).asData?.value.contains(kanjiId) ?? false;

    if (kanji == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final color = levelColor(kanji.jlptLevel);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          KanjiHero(kanji: kanji, color: color, onBack: () => Navigator.of(context).pop()),
          _KanjiBody(
            kanji: kanji,
            isKnown: isKnown,
            onToggle: () => ref
                .read(databaseProvider)
                .setKanjiKnown(kanjiId, isKnown: !isKnown),
          ),
        ],
      ),
    );
  }
}

class _KanjiBody extends StatelessWidget {
  final Kanji kanji;
  final bool isKnown;
  final VoidCallback onToggle;
  const _KanjiBody({required this.kanji, required this.isKnown, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final color = levelColor(kanji.jlptLevel);

    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KanjiReadingsCard(kanji: kanji),
          const SizedBox(height: AppDimens.spaceLg),
          StrokeOrderSection(kanji: kanji),
          const SizedBox(height: AppDimens.spaceSm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => KanjiDrawingPracticeScreen(kanjiId: kanji.id),
                ),
              ),
              icon: Icon(Icons.draw_rounded, size: 18, color: color),
              label: Text(
                l.drawingPractice,
                style: AppTextStyles.body.copyWith(color: color, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color),
                padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          KanjiExampleWords(kanji: kanji),
          const SizedBox(height: AppDimens.spaceLg),
          _KanjiSrsSection(kanjiId: kanji.id),
          const SizedBox(height: AppDimens.spaceMd),
          KnownToggle(isKnown: isKnown, onTap: onToggle, fullWidth: true),
        ],
      ),
    );
  }
}

class _KanjiSrsSection extends ConsumerStatefulWidget {
  final int kanjiId;
  const _KanjiSrsSection({required this.kanjiId});

  @override
  ConsumerState<_KanjiSrsSection> createState() => _KanjiSrsSectionState();
}

class _KanjiSrsSectionState extends ConsumerState<_KanjiSrsSection> {
  Card? _card;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final card = await ref.read(databaseProvider).getSrsCard('kanji', widget.kanjiId);
    if (mounted) setState(() { _card = card; _loaded = true; });
  }

  Future<void> _reset() async {
    final l = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l.resetKanaTitle,
      body: l.resetKanaBody,
    );
    if (!confirmed) return;
    await ref.read(databaseProvider).resetSrsCard('kanji', widget.kanjiId);
    if (mounted) setState(() => _card = null);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          decoration: BoxDecoration(
            color: t.surfaceContainer,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
          child: _loaded
              ? SrsProgressInfo(srsCard: _card)
              : const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
        ),
        if (_loaded && _card != null) ...[
          const SizedBox(height: AppDimens.spaceXs),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: _reset,
              icon: Icon(Icons.restart_alt_rounded, size: 18, color: t.error),
              label: Text(
                l.settingsResetProgress,
                style: AppTextStyles.bodySmall.copyWith(color: t.error),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
