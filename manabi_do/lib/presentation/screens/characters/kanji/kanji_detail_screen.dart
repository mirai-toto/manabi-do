import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../data/database/app_database.dart';
import '../../../../l10n/l10n.dart';
import '../../../providers/kanji_provider.dart';
import '../../../services/srs_service.dart';
import '../../../widgets/widgets.dart';
import 'kanji_example_words.dart';
import 'kanji_hero.dart';
import 'kanji_readings_card.dart';
import 'stroke_order_section.dart';
import 'kanji_drawing_practice_screen.dart';

class KanjiDetailScreen extends ConsumerWidget {
  final int kanjiId;
  const KanjiDetailScreen({super.key, required this.kanjiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanji = ref.watch(kanjiDetailProvider(kanjiId)).asData?.value;

    if (kanji == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final color = levelColor(kanji.jlptLevel);

    return Scaffold(
      body: ScrollFade(
        builder: (controller) => ListView(
          controller: controller,
          padding: EdgeInsets.zero,
          children: [
            KanjiHero(
              kanji: kanji,
              color: color,
              onBack: () => Navigator.of(context).pop(),
            ),
            _KanjiBody(kanji: kanji),
          ],
        ),
      ),
    );
  }
}

class _KanjiBody extends StatelessWidget {
  final Kanji kanji;
  const _KanjiBody({required this.kanji});

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
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color),
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceMd,
                ),
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
        ],
      ),
    );
  }
}

class _KanjiSrsSection extends ConsumerWidget {
  final int kanjiId;
  const _KanjiSrsSection({required this.kanjiId});

  Future<void> _reset(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l.resetKanaTitle,
      body: l.resetKanaBody,
    );
    if (!confirmed) return;
    await srsService.resetCard(ref, 'kanji', kanjiId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;
    final srsCardsAsync = ref.watch(kanjiSrsCardsProvider);
    final loaded = srsCardsAsync.asData != null;
    final card = srsCardsAsync.asData?.value[kanjiId];

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          decoration: BoxDecoration(
            color: t.surfaceContainer,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
          child: loaded
              ? ReviewProgressInfo(srsCard: card)
              : const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
        ),
        if (loaded && card != null) ...[
          const SizedBox(height: AppDimens.spaceXs),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => _reset(context, ref),
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
