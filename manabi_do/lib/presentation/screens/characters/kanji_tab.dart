import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/level_label.dart';
import '../../providers/kanji_provider.dart';
import '../../widgets/widgets.dart';
import 'kanji_practice_screen.dart';
import 'kanji_tab/kanji_grid.dart';
import 'kanji_tab/level_header.dart';
import 'kanji_tab/level_selector.dart';

class KanjiTabView extends ConsumerStatefulWidget {
  const KanjiTabView({super.key});

  @override
  ConsumerState<KanjiTabView> createState() => _KanjiTabViewState();
}

class _KanjiTabViewState extends ConsumerState<KanjiTabView> {
  String? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    if (_selectedLevel == null) {
      return KanjiLevelSelector(
        onSelect: (level) => setState(() => _selectedLevel = level),
      );
    }

    final kanjiAsync = ref.watch(kanjiListProvider(_selectedLevel!));
    final knownIds = ref.watch(knownKanjiIdsProvider).asData?.value ?? {};
    final srsCards = ref.watch(kanjiSrsCardsProvider).asData?.value ?? {};

    if (kanjiAsync is AsyncLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final data = kanjiAsync.asData?.value;
    final kanjiList = data?.kanji ?? [];
    final levelIdSet = kanjiList.map((k) => k.id).toSet();
    final knownCount = knownIds.intersection(levelIdSet).length;
    final color = levelColor(_selectedLevel!);

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      children: [
        KanjiLevelHeader(
          level: _selectedLevel!,
          label: levelLabel(_selectedLevel!, context),
          color: color,
          onBack: () => setState(() => _selectedLevel = null),
        ),
        ProgressRow(known: knownCount, total: kanjiList.length, color: color),
        PracticeButton(
          color: color,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => KanjiPracticeScreen(level: _selectedLevel!),
            ),
          ),
        ),
        KanjiGrid(kanjis: kanjiList, skippedIds: knownIds, srsCards: srsCards),
      ],
    );
  }
}
