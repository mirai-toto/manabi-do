import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/srs/srs_level.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../l10n/l10n.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/kanji_provider.dart';
import '../../../widgets/widgets.dart';
import '../../practice/practice_selection_screen.dart';
import '../../practice/writing_session_screen.dart';
import 'kanji_grid.dart';
import 'kanji_group_selector.dart';
import 'kanji_level_header.dart';
import 'kanji_practice_screen.dart';

class KanjiGroupView extends ConsumerWidget {
  final String level;
  final int groupIndex;
  const KanjiGroupView({
    super.key,
    required this.level,
    required this.groupIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiAsync = ref.watch(kanjiListProvider(level));
    final srsCards = ref.watch(kanjiSrsCardsProvider).asData?.value ?? {};

    if (kanjiAsync is AsyncLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final allKanji = kanjiAsync.asData?.value.kanji ?? [];
    final start = groupIndex * kKanjiGroupSize;
    final groupKanji = allKanji.skip(start).take(kKanjiGroupSize).toList();
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
