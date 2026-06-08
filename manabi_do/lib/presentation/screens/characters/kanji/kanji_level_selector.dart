import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../l10n/l10n.dart';
import '../../../providers/kanji_provider.dart';
import '../../../widgets/widgets.dart';

const _kanjiLevels = ['N5', 'N4', 'N3', 'N2', 'N1'];

class KanjiLevelSelector extends ConsumerWidget {
  final void Function(String) onSelect;
  const KanjiLevelSelector({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      children: [
        SectionLabel(context.l10n.selectLevel),
        const SizedBox(height: AppDimens.spaceSm),
        for (final code in _kanjiLevels)
          JlptLevelCard(
            code: code,
            subtitle: _subtitle(context, ref, code),
            onTap: () => onSelect(code),
          ),
      ],
    );
  }

  String? _subtitle(BuildContext context, WidgetRef ref, String code) {
    final data = ref.watch(kanjiListProvider(code)).asData?.value;
    return data != null ? context.l10n.nKanji(data.total) : '—';
  }
}
