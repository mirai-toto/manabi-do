import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../providers/kanji_provider.dart';
import '../../../widgets/widgets.dart';
import 'level_card.dart';

const _kanjiLevels = ['N5', 'N4', 'N3', 'N2', 'N1'];

class KanjiLevelSelector extends ConsumerWidget {
  final void Function(String) onSelect;
  const KanjiLevelSelector({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      children: [
        const SectionLabel('Select a Level'),
        const SizedBox(height: AppDimens.spaceSm),
        for (final code in _kanjiLevels)
          KanjiLevelCard(
            code: code,
            data: ref.watch(kanjiListProvider(code)).asData?.value,
            onTap: () => onSelect(code),
          ),
      ],
    );
  }
}
