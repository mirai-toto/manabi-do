import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/srs/srs_level.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/vocabulary_list_provider.dart';
import '../widgets.dart';

const kVocabularyGroupSize = 30;

class VocabularyGroupSelector extends ConsumerWidget {
  final String level;
  final VoidCallback onBack;
  final VoidCallback onPractice;
  final void Function(int) onSelect;

  const VocabularyGroupSelector({
    super.key,
    required this.level,
    required this.onBack,
    required this.onPractice,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabularyAsync = ref.watch(vocabularyByLevelProvider(level));
    final srsCards = ref.watch(vocabularySrsCardsProvider).asData?.value ?? {};
    final color = levelColor(level);
    final t = context.tokens;

    final entries = vocabularyAsync.asData?.value ?? [];
    final groupCount = (entries.length / kVocabularyGroupSize).ceil();

    return ScrollFade(
      builder: (controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spaceSm,
              AppDimens.spaceSm,
              AppDimens.spaceMd,
              0,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: onBack,
                  color: t.onSurface,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        levelLabel(level, context),
                        style: AppTextStyles.title.copyWith(color: t.onSurface),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          PracticeButton(color: color, onTap: onPractice),
          if (vocabularyAsync is AsyncLoading)
            const Center(child: AppSpinner.page())
          else
            Padding(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              child: Column(
                children: List.generate(groupCount, (i) {
                  final start = i * kVocabularyGroupSize;
                  final groupEntries = entries
                      .skip(start)
                      .take(kVocabularyGroupSize)
                      .toList();
                  final learnedCount = groupEntries.where((e) {
                    final level = srsLevel(srsCards[e.id]);
                    return level != SrsLevel.newCard &&
                        level != SrsLevel.learning;
                  }).length;
                  final progress = groupEntries.isEmpty
                      ? 0.0
                      : learnedCount / groupEntries.length;
                  final end = start + groupEntries.length;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: i < groupCount - 1 ? AppDimens.spaceSm : 0,
                    ),
                    child: StudyGroupCard(
                      title: context.l10n.groupN(i + 1),
                      rangeLabel:
                          '${start + 1}–$end · $learnedCount / ${groupEntries.length}',
                      progress: progress,
                      color: color,
                      onTap: () => onSelect(i),
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
