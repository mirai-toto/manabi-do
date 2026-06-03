import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../providers/database_provider.dart';
import '../../providers/kanji_provider.dart';
import '../../widgets/widgets.dart';
import 'kanji_detail/kanji_example_words.dart';
import 'kanji_detail/kanji_hero.dart';
import 'kanji_detail/kanji_readings_card.dart';
import 'kanji_detail/stroke_order_section.dart';

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
    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KanjiReadingsCard(kanji: kanji),
          const SizedBox(height: AppDimens.spaceLg),
          StrokeOrderSection(kanji: kanji),
          const SizedBox(height: AppDimens.spaceLg),
          KanjiExampleWords(kanji: kanji),
          const SizedBox(height: AppDimens.spaceLg),
          KnownToggle(isKnown: isKnown, onTap: onToggle, fullWidth: true),
        ],
      ),
    );
  }
}
