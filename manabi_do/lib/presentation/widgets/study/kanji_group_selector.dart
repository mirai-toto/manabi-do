import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/srs/srs_level.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/home_provider.dart';
import '../../providers/kanji_provider.dart';
import '../widgets.dart';
import '../../screens/practice/practice_selection_screen.dart';
import '../../screens/practice/writing_session_screen.dart';
import '../../screens/characters/kanji/kanji_practice_screen.dart';

const kKanjiGroupSize = 20;

class KanjiGroupSelector extends ConsumerWidget {
  final String level;
  const KanjiGroupSelector({super.key, required this.level});

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
                            builder: (_) => WritingSessionScreen(
                              level: level,
                              color: color,
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
                      onTap: () => ref
                          .read(kanjiSelectedGroupProvider.notifier)
                          .select(i),
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
