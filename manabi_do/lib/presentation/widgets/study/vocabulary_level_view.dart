import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../providers/vocabulary_list_provider.dart';
import '../widgets.dart';

class VocabularyLevelView extends ConsumerWidget {
  final String level;
  final int groupIndex;
  final VoidCallback onBack;
  final void Function(Set<int> vocabularyIds) onPractice;

  const VocabularyLevelView({
    super.key,
    required this.level,
    required this.groupIndex,
    required this.onBack,
    required this.onPractice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabularyAsync = ref.watch(vocabularyByLevelProvider(level));
    final color = levelColor(level);

    return switch (vocabularyAsync) {
      AsyncLoading() => const Center(child: AppSpinner.page()),
      AsyncError() => const SizedBox.shrink(),
      AsyncData(:final value) => _LevelContent(
        level: level,
        groupIndex: groupIndex,
        color: color,
        entries: value
            .skip(groupIndex * kVocabularyGroupSize)
            .take(kVocabularyGroupSize)
            .toList(),
        onBack: onBack,
        onPractice: onPractice,
      ),
    };
  }
}

class _LevelContent extends ConsumerWidget {
  final String level;
  final int groupIndex;
  final Color color;
  final List<VocabularyEntry> entries;
  final VoidCallback onBack;
  final void Function(Set<int> vocabularyIds) onPractice;

  const _LevelContent({
    required this.level,
    required this.groupIndex,
    required this.color,
    required this.entries,
    required this.onBack,
    required this.onPractice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;

    final learnedCount = ref.watch(
      vocabularyGroupLearnedCountProvider((
        level: level,
        groupIndex: groupIndex,
      )),
    );

    final groupIds = entries.map((e) => e.id).toSet();
    final start = groupIndex * kVocabularyGroupSize;

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
                        '$level · ${l.groupN(groupIndex + 1)}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        '${start + 1}–${start + entries.length}',
                        style: AppTextStyles.title.copyWith(color: t.onSurface),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ProgressRow(known: learnedCount, total: entries.length, color: color),
          PracticeButton(color: color, onTap: () => onPractice(groupIds)),
          for (int i = 0; i < entries.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                color: t.outlineVariant,
                indent: AppDimens.spaceMd,
                endIndent: AppDimens.spaceMd,
              ),
            VocabularyWordTile(entry: entries[i]),
          ],
        ],
      ),
    );
  }
}
