import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/srs/srs_level.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/home_provider.dart';
import '../../providers/vocab_list_provider.dart';
import '../../widgets/widgets.dart';
import 'vocab_level_selector.dart';
import 'vocab_level_view.dart';
import 'vocab_practice_screen.dart';
import '../practice/practice_selection_screen.dart';

const _kVocabGroupSize = 30;

class VocabularyScreen extends ConsumerWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;
    final selectedLevel = ref.watch(vocabSelectedLevelProvider);
    final selectedGroup = ref.watch(vocabSelectedGroupProvider);

    const levels = ['N5', 'N4', 'N3', 'N2', 'N1'];
    var allLoaded = true;
    var sum = 0;
    for (final lvl in levels) {
      final data = ref.watch(vocabByLevelProvider(lvl)).asData?.value;
      if (data == null) {
        allLoaded = false;
        break;
      }
      sum += data.length;
    }
    final subtitle = allLoaded ? l.vocabSubtitle(sum) : l.vocabSubtitleShort;

    Widget body;
    if (selectedLevel == null) {
      body = VocabLevelSelector(
        onSelect: (level) {
          ref.read(vocabSelectedGroupProvider.notifier).clear();
          ref.read(vocabSelectedLevelProvider.notifier).select(level);
        },
      );
    } else if (selectedGroup == null) {
      body = _VocabGroupSelector(
        level: selectedLevel,
        onBack: () {
          ref.read(vocabSelectedGroupProvider.notifier).clear();
          ref.read(vocabSelectedLevelProvider.notifier).clear();
        },
        onSelect: (i) =>
            ref.read(vocabSelectedGroupProvider.notifier).select(i),
      );
    } else {
      body = VocabLevelView(
        level: selectedLevel,
        groupIndex: selectedGroup,
        onBack: () => ref.read(vocabSelectedGroupProvider.notifier).clear(),
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimens.screenMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: l.sectionVocabulary,
              subtitle: subtitle,
              glyph: '語',
              color: t.vocabulary,
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class _VocabGroupSelector extends ConsumerWidget {
  final String level;
  final VoidCallback onBack;
  final void Function(int) onSelect;

  const _VocabGroupSelector({
    required this.level,
    required this.onBack,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabAsync = ref.watch(vocabByLevelProvider(level));
    final srsCards = ref.watch(vocabSrsCardsProvider).asData?.value ?? {};
    final color = levelColor(level);
    final t = context.tokens;

    final entries = vocabAsync.asData?.value ?? [];
    final groupCount = (entries.length / _kVocabGroupSize).ceil();

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      children: [
        // Header
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
        PracticeButton(
          color: color,
          onTap: () {
            final l = context.l10n;
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (ctx) => PracticeSelectionScreen(
                  title: levelLabel(level, ctx),
                  color: color,
                  modes: [
                    PracticeMode(
                      icon: Icons.style_rounded,
                      title: l.flashcardPractice,
                      onTap: () async => Navigator.of(ctx).push(
                        MaterialPageRoute<void>(
                          builder: (_) => VocabPracticeScreen(
                            level: level,
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
                          builder: (_) =>
                              VocabPracticeScreen(level: level, mcqOnly: true),
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
        if (vocabAsync is AsyncLoading)
          const Center(child: CircularProgressIndicator())
        else
          Padding(
            padding: const EdgeInsets.all(AppDimens.spaceMd),
            child: Column(
              children: List.generate(groupCount, (i) {
                final start = i * _kVocabGroupSize;
                final groupEntries = entries
                    .skip(start)
                    .take(_kVocabGroupSize)
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
                  child: TappableSurface(
                    decoration: BoxDecoration(
                      color: t.cardBackground,
                      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                      border: Border.all(color: color.withValues(alpha: 0.2)),
                    ),
                    onTap: () => onSelect(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceLg,
                        vertical: AppDimens.spaceMd,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.groupN(i + 1),
                                  style: AppTextStyles.body.copyWith(
                                    color: t.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: AppDimens.spaceXxs),
                                Text(
                                  '${start + 1}–$end · $learnedCount / ${groupEntries.length}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: t.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: AppDimens.spaceXs),
                                AppProgressBar(
                                  progress: progress,
                                  color: color,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppDimens.spaceMd),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: t.onSurfaceVariant,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
