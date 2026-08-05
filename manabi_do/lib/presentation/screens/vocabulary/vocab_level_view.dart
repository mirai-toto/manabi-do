import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../providers/vocab_list_provider.dart';
import '../../widgets/widgets.dart';
import '../practice/practice_selection_screen.dart';
import 'vocab_practice_screen.dart';
import 'vocab_word_tile.dart';

class VocabLevelView extends ConsumerWidget {
  final String level;
  final int groupIndex;
  final VoidCallback onBack;

  const VocabLevelView({
    super.key,
    required this.level,
    required this.groupIndex,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabAsync = ref.watch(vocabByLevelProvider(level));
    final color = levelColor(level);

    return switch (vocabAsync) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError() => const SizedBox.shrink(),
      AsyncData(:final value) => _LevelContent(
        level: level,
        groupIndex: groupIndex,
        color: color,
        entries: value
            .skip(groupIndex * kVocabGroupSize)
            .take(kVocabGroupSize)
            .toList(),
        onBack: onBack,
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

  const _LevelContent({
    required this.level,
    required this.groupIndex,
    required this.color,
    required this.entries,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;

    final learnedCount = ref.watch(
      vocabGroupLearnedCountProvider((level: level, groupIndex: groupIndex)),
    );

    final groupIds = entries.map((e) => e.id).toSet();
    final start = groupIndex * kVocabGroupSize;

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
          PracticeButton(
            color: color,
            onTap: () {
              final groupTitle = l.groupN(groupIndex + 1);
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (ctx) => PracticeSelectionScreen(
                    title: groupTitle,
                    color: color,
                    modes: [
                      PracticeMode(
                        icon: Icons.shuffle_rounded,
                        title: l.freePractice,
                        onTap: () async => Navigator.of(ctx).push(
                          MaterialPageRoute<void>(
                            builder: (_) => VocabPracticeScreen(
                              level: level,
                              allowedIds: groupIds,
                              freeMode: true,
                            ),
                          ),
                        ),
                      ),
                      PracticeMode(
                        icon: Icons.style_rounded,
                        title: l.flashcardPractice,
                        onTap: () async => Navigator.of(ctx).push(
                          MaterialPageRoute<void>(
                            builder: (_) => VocabPracticeScreen(
                              level: level,
                              allowedIds: groupIds,
                              flashcardOnly: true,
                            ),
                          ),
                        ),
                      ),
                      PracticeMode(
                        icon: Icons.quiz_rounded,
                        title: l.mcqPractice,
                        onTap: () async => Navigator.of(ctx).push(
                          MaterialPageRoute<void>(
                            builder: (_) => VocabPracticeScreen(
                              level: level,
                              allowedIds: groupIds,
                              mcqOnly: true,
                            ),
                          ),
                        ),
                      ),
                      PracticeMode(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: l.sentencePractice,
                        onTap: () async => Navigator.of(ctx).push(
                          MaterialPageRoute<void>(
                            builder: (_) => VocabPracticeScreen(
                              level: level,
                              allowedIds: groupIds,
                              sentenceOnly: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          for (int i = 0; i < entries.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                color: t.outlineVariant,
                indent: AppDimens.spaceMd,
                endIndent: AppDimens.spaceMd,
              ),
            VocabWordTile(entry: entries[i]),
          ],
        ],
      ),
    );
  }
}
