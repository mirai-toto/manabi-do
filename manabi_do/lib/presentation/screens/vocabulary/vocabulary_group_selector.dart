import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/srs_cards_provider.dart';

import '../../../core/srs/srs_level.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/vocabulary_level.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/vocabulary_level_label.dart';
import '../../providers/vocabulary_list_provider.dart';
import '../../widgets/widgets.dart';

/// Shows a `SectionLabel` header and a list of `StudyGroupCard` tiles for
/// pagination within a vocabulary level, in groups of `kVocabularyGroupSize`.
///
/// Each row carries what the group buys: the share of running Japanese those
/// thirty words account for. That number falls away sharply — the first group
/// of level 1 is 20.6% of everything written and the last groups are rounding
/// error — which is the whole point of ordering the app this way.
class VocabularyGroupSelector extends ConsumerWidget {
  final int level;
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
    final srsCards =
        ref.watch(srsCardsProvider('vocabulary')).asData?.value ?? {};
    final shares = ref.watch(groupShareProvider);
    final color = vocabularyLevelColor(level, Theme.of(context).brightness);

    final entries = vocabularyAsync.asData?.value ?? [];
    final groupCount = (entries.length / kVocabularyGroupSize).ceil();
    final bandShare = ref.watch(vocabularyLevelReachedProvider)?[level];
    final learnedInLevel = entries
        .where((e) => isSrsKnown(srsCards[e.id]))
        .length;

    return ScrollFade(
      builder: (controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
        children: [
          VocabularyGroupHeader(
            eyebrow: vocabularyLevelLabel(level, context),
            title: context.l10n.nWords(entries.length),
            color: color,
            onBack: onBack,
          ),
          if (bandShare != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.spaceSm,
              ),
              child: CoverageMeterCard(
                label: context.l10n.finishThisLevel,
                share: bandShare,
                caption: context.l10n.levelReaches(entries.length),
                progress: entries.isEmpty ? 0 : learnedInLevel / entries.length,
                progressLabel: '$learnedInLevel / ${entries.length}',
                color: color,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: AppDimens.spaceSm,
            ),
            child: PracticeButton(
              label: context.l10n.freePractice,
              color: color,
              onPressed: onPractice,
            ),
          ),
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
                  final learnedCount = groupEntries
                      .where((e) => isSrsKnown(srsCards[e.id]))
                      .length;
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
                      trailing: _ShareBadge(share: shares?[(level, i + 1)]),
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

/// What one group of thirty words adds to what a learner can read.
///
/// Absent rather than zero when the figure is missing, because a group can
/// genuinely add nothing measurable: UniDic counts お願いします in pieces, so the
/// corpus has no figure to attribute to it. Showing "+0.0%" would read as a
/// claim that the words are worthless.
class _ShareBadge extends StatelessWidget {
  final double? share;
  const _ShareBadge({this.share});

  @override
  Widget build(BuildContext context) {
    final value = share;
    if (value == null || value <= 0) return const SizedBox.shrink();
    final t = context.tokens;
    return PillBadge(
      label:
          '+${NumberFormat.decimalPercentPattern(locale: Localizations.localeOf(context).toString(), decimalDigits: 1).format(value)}',
      color: t.onPrimaryContainer,
      background: t.primaryContainer,
      textStyle: AppTextStyles.labelSmall,
    );
  }
}
