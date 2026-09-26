import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/srs/srs_level.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/kanji_provider.dart';
import '../widgets.dart';

const kKanjiGroupSize = 20;

class KanjiGroupSelector extends ConsumerWidget {
  final String level;
  final VoidCallback onBack;
  final VoidCallback onPractice;
  final void Function(int groupIndex) onSelectGroup;
  const KanjiGroupSelector({
    super.key,
    required this.level,
    required this.onBack,
    required this.onPractice,
    required this.onSelectGroup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiAsync = ref.watch(kanjiListProvider(level));
    final srsCards = ref.watch(kanjiSrsCardsProvider).asData?.value ?? {};
    final color = levelColor(level);

    final kanjiList = kanjiAsync.asData?.value.kanji ?? [];
    final groupCount = (kanjiList.length / kKanjiGroupSize).ceil();

    return ScrollFade(
      builder: (controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
        children: [
          KanjiLevelHeader(
            level: level,
            label: levelLabel(level, context),
            color: color,
            onBack: onBack,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: AppDimens.spaceSm,
            ),
            child: AppButton(
              label: context.l10n.freePractice,
              icon: Icon(Icons.school_rounded, color: color, size: 20),
              onPressed: onPractice,
              fullWidth: true,
              backgroundColor: color.withValues(alpha: 0.08),
              foregroundColor: color,
              side: BorderSide(
                color: color.withValues(alpha: 0.35),
                width: AppDimens.borderWidthContainer,
              ),
              radius: AppDimens.radiusMd,
              visualDensity: VisualDensity.standard,
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              textStyle: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (kanjiAsync is AsyncLoading)
            const Center(child: AppSpinner.page())
          else
            Padding(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              child: Column(
                children: List.generate(groupCount, (i) {
                  final start = i * kKanjiGroupSize;
                  final end = (start + kKanjiGroupSize).clamp(
                    0,
                    kanjiList.length,
                  );
                  final groupKanji = kanjiList.sublist(start, end);
                  final learnedCount = groupKanji.where((k) {
                    final level = srsLevel(srsCards[k.id]);
                    return level != SrsLevel.newCard &&
                        level != SrsLevel.learning;
                  }).length;
                  final progress = groupKanji.isEmpty
                      ? 0.0
                      : learnedCount / groupKanji.length;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: i < groupCount - 1 ? AppDimens.spaceSm : 0,
                    ),
                    child: StudyGroupCard(
                      title: context.l10n.groupN(i + 1),
                      rangeLabel:
                          '${start + 1}–$end · $learnedCount / ${groupKanji.length}',
                      progress: progress,
                      color: color,
                      onTap: () => onSelectGroup(i),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
