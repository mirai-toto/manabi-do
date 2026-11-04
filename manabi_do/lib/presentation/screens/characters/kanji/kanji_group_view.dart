import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/srs_cards_provider.dart';

import '../../../../core/srs/srs_level.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../l10n/l10n.dart';
import '../../../providers/kanji_provider.dart';
import '../../../widgets/widgets.dart';
import 'kanji_group_selector.dart';

/// Shows `KanjiLevelHeader`, `KanjiGrid`, and practice/writing-session
/// shortcuts for a single kanji group.
class KanjiGroupView extends ConsumerWidget {
  final String level;
  final int groupIndex;
  final VoidCallback onBack;
  final void Function(Set<int> kanjiIds) onPractice;
  final void Function(int kanjiId) onOpenKanji;
  const KanjiGroupView({
    super.key,
    required this.level,
    required this.groupIndex,
    required this.onBack,
    required this.onPractice,
    required this.onOpenKanji,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiAsync = ref.watch(kanjiListProvider(level));
    final srsCards = ref.watch(srsCardsProvider('kanji')).asData?.value ?? {};

    if (kanjiAsync is AsyncLoading) {
      return const Center(child: AppSpinner.page());
    }

    final allKanji = kanjiAsync.asData?.value.kanji ?? [];
    final start = groupIndex * kKanjiGroupSize;
    final groupKanji = allKanji.skip(start).take(kKanjiGroupSize).toList();
    final groupIds = groupKanji.map((k) => k.id).toSet();
    final learnedCount = groupKanji
        .where((k) => isSrsKnown(srsCards[k.id]))
        .length;
    final color = levelColor(level);

    return ScrollFade(
      builder: (controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
        children: [
          KanjiLevelHeader(
            level: level,
            label:
                '${context.l10n.groupN(groupIndex + 1)} · ${start + 1}–${start + groupKanji.length}',
            color: color,
            onBack: onBack,
          ),
          ProgressRow(
            known: learnedCount,
            total: groupKanji.length,
            color: color,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: AppDimens.spaceSm,
            ),
            child: PracticeButton(
              label: context.l10n.freePractice,
              color: color,
              onPressed: () => onPractice(groupIds),
            ),
          ),
          KanjiGrid(
            kanjis: groupKanji,
            srsCards: srsCards,
            onKanjiTap: onOpenKanji,
          ),
        ],
      ),
    );
  }
}
