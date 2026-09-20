import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/jlpt_level.dart';
import '../../../../l10n/l10n.dart';
import '../../../../l10n/level_label.dart';
import '../../../providers/home_provider.dart';
import '../../../widgets/widgets.dart';
import '../../practice/practice_launcher.dart';
import 'kanji_detail_screen.dart';

class KanjiTabView extends ConsumerWidget {
  const KanjiTabView({super.key});

  void _openKanji(BuildContext context, int kanjiId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => KanjiDetailScreen(kanjiId: kanjiId),
      ),
    );
  }

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
        onOpenKanji: (kanjiId) => _openKanji(context, kanjiId),
      );
    }

    if (selectedGroup == null) {
      return KanjiGroupSelector(
        level: selectedLevel,
        onBack: () {
          ref.read(kanjiSelectedGroupProvider.notifier).clear();
          ref.read(kanjiSelectedLevelProvider.notifier).clear();
        },
        onPractice: () => openKanjiPractice(
          context,
          title: levelLabel(selectedLevel, context),
          level: selectedLevel,
          color: levelColor(selectedLevel),
        ),
        onSelectGroup: (index) =>
            ref.read(kanjiSelectedGroupProvider.notifier).select(index),
      );
    }

    return KanjiGroupView(
      level: selectedLevel,
      groupIndex: selectedGroup,
      onBack: () => ref.read(kanjiSelectedGroupProvider.notifier).clear(),
      onPractice: (kanjiIds) => openKanjiPractice(
        context,
        title: context.l10n.groupN(selectedGroup + 1),
        level: selectedLevel,
        color: levelColor(selectedLevel),
        kanjiIds: kanjiIds,
      ),
      onOpenKanji: (kanjiId) => _openKanji(context, kanjiId),
    );
  }
}
