import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../l10n/l10n.dart';
import '../../../../l10n/level_label.dart';
import '../../../../core/srs/srs_level.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/kanji_provider.dart';
import '../../../widgets/widgets.dart';
import '../../practice/practice_selection_screen.dart';
import '../../practice/writing_session_screen.dart';
import 'kanji_grid.dart';
import 'kanji_level_header.dart';
import 'kanji_level_selector.dart';
import 'kanji_practice_screen.dart';

const _kGroupSize = 20;

class KanjiTabView extends ConsumerWidget {
  const KanjiTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(kanjiSelectedLevelProvider);
    final selectedGroup = ref.watch(kanjiSelectedGroupProvider);

    if (selectedLevel == null) {
      return KanjiLevelSelector(
        onSelect: (level) {
          ref.read(kanjiSelectedGroupProvider.notifier).clear();
          ref.read(kanjiSelectedLevelProvider.notifier).select(level);
        },
      );
    }

    if (selectedGroup == null) {
      return _KanjiGroupSelector(level: selectedLevel);
    }

    return _KanjiGroupView(level: selectedLevel, groupIndex: selectedGroup);
  }
}

// ── Group selector ────────────────────────────────────────────────────────────

class _KanjiGroupSelector extends ConsumerWidget {
  final String level;
  const _KanjiGroupSelector({required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiAsync = ref.watch(kanjiListProvider(level));
    final srsCards = ref.watch(kanjiSrsCardsProvider).asData?.value ?? {};
    final color = levelColor(level);
    final t = context.tokens;

    final kanjiList = kanjiAsync.asData?.value.kanji ?? [];
    final groupCount = (kanjiList.length / _kGroupSize).ceil();

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      children: [
        KanjiLevelHeader(
          level: level,
          label: levelLabel(level, context),
          color: color,
          onBack: () {
            ref.read(kanjiSelectedGroupProvider.notifier).clear();
            ref.read(kanjiSelectedLevelProvider.notifier).clear();
          },
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
                      icon: Icons.edit_rounded,
                      title: l.writingPractice,
                      onTap: () async => Navigator.of(ctx).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              WritingSessionScreen(level: level, color: color),
                        ),
                      ),
                    ),
                    PracticeMode(
                      icon: Icons.style_rounded,
                      title: l.flashcardPractice,
                      onTap: () async => Navigator.of(ctx).push(
                        MaterialPageRoute<void>(
                          builder: (_) => KanjiPracticeScreen(
                            level: level,
                            exerciseFilter: ExerciseFilter.flashcardOnly,
                            freeMode: true,
                          ),
                        ),
                      ),
                    ),
                    PracticeMode(
                      icon: Icons.quiz_rounded,
                      title: l.mcqPractice,
                      onTap: () async => Navigator.of(ctx).push(
                        MaterialPageRoute<void>(
                          builder: (_) => KanjiPracticeScreen(
                            level: level,
                            exerciseFilter: ExerciseFilter.mcqOnly,
                            freeMode: true,
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
        if (kanjiAsync is AsyncLoading)
          const Center(child: CircularProgressIndicator())
        else
          Padding(
            padding: const EdgeInsets.all(AppDimens.spaceMd),
            child: Column(
              children: List.generate(groupCount, (i) {
                final start = i * _kGroupSize;
                final end = (start + _kGroupSize).clamp(0, kanjiList.length);
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
                  child: TappableSurface(
                    decoration: BoxDecoration(
                      color: t.cardBackground,
                      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                      border: Border.all(color: color.withValues(alpha: 0.2)),
                    ),
                    onTap: () =>
                        ref.read(kanjiSelectedGroupProvider.notifier).select(i),
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
                                  '${start + 1}–$end · $learnedCount / ${groupKanji.length}',
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

// ── Group view ────────────────────────────────────────────────────────────────

class _KanjiGroupView extends ConsumerWidget {
  final String level;
  final int groupIndex;
  const _KanjiGroupView({required this.level, required this.groupIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiAsync = ref.watch(kanjiListProvider(level));
    final srsCards = ref.watch(kanjiSrsCardsProvider).asData?.value ?? {};

    if (kanjiAsync is AsyncLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final allKanji = kanjiAsync.asData?.value.kanji ?? [];
    final start = groupIndex * _kGroupSize;
    final groupKanji = allKanji.skip(start).take(_kGroupSize).toList();
    final groupIds = groupKanji.map((k) => k.id).toSet();
    final learnedCount = groupKanji.where((k) {
      final level = srsLevel(srsCards[k.id]);
      return level != SrsLevel.newCard && level != SrsLevel.learning;
    }).length;
    final color = levelColor(level);

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      children: [
        KanjiLevelHeader(
          level: level,
          label:
              '${context.l10n.groupN(groupIndex + 1)} · ${start + 1}–${start + groupKanji.length}',
          color: color,
          onBack: () => ref.read(kanjiSelectedGroupProvider.notifier).clear(),
        ),
        ProgressRow(
          known: learnedCount,
          total: groupKanji.length,
          color: color,
        ),
        PracticeButton(
          color: color,
          onTap: () {
            final l = context.l10n;
            final groupTitle = l.groupN(groupIndex + 1);
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (ctx) => PracticeSelectionScreen(
                  title: groupTitle,
                  color: color,
                  modes: [
                    PracticeMode(
                      icon: Icons.edit_rounded,
                      title: l.writingPractice,
                      onTap: () async => Navigator.of(ctx).push(
                        MaterialPageRoute<void>(
                          builder: (_) => WritingSessionScreen(
                            level: level,
                            color: color,
                            kanjiIds: groupIds,
                          ),
                        ),
                      ),
                    ),
                    PracticeMode(
                      icon: Icons.style_rounded,
                      title: l.flashcardPractice,
                      onTap: () async => Navigator.of(ctx).push(
                        MaterialPageRoute<void>(
                          builder: (_) => KanjiPracticeScreen(
                            level: level,
                            allowedIds: groupIds,
                            exerciseFilter: ExerciseFilter.flashcardOnly,
                            freeMode: true,
                          ),
                        ),
                      ),
                    ),
                    PracticeMode(
                      icon: Icons.quiz_rounded,
                      title: l.mcqPractice,
                      onTap: () async => Navigator.of(ctx).push(
                        MaterialPageRoute<void>(
                          builder: (_) => KanjiPracticeScreen(
                            level: level,
                            allowedIds: groupIds,
                            exerciseFilter: ExerciseFilter.mcqOnly,
                            freeMode: true,
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
        KanjiGrid(kanjis: groupKanji, srsCards: srsCards),
      ],
    );
  }
}
