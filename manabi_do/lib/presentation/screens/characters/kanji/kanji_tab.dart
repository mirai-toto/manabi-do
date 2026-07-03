import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/home_provider.dart';
import 'kanji_group_selector.dart';
import 'kanji_group_view.dart';
import 'kanji_level_selector.dart';

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
      return KanjiGroupSelector(level: selectedLevel);
    }

    return KanjiGroupView(level: selectedLevel, groupIndex: selectedGroup);
  }
}
