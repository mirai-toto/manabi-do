import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/vocab_list_provider.dart';
import '../../widgets/common/jlpt_level_card.dart';
import '../../widgets/common/section_label.dart';

const _levels = ['N5', 'N4', 'N3', 'N2', 'N1'];

class VocabLevelSelector extends ConsumerWidget {
  final void Function(String) onSelect;
  const VocabLevelSelector({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      children: [
        SectionLabel(context.l10n.selectLevel),
        const SizedBox(height: AppDimens.spaceSm),
        for (final code in _levels)
          JlptLevelCard(
            code: code,
            subtitle: _subtitle(context, ref, code),
            onTap: () => onSelect(code),
          ),
      ],
    );
  }

  String? _subtitle(BuildContext context, WidgetRef ref, String code) {
    final count = ref.watch(vocabByLevelProvider(code)).asData?.value.length;
    return count != null ? context.l10n.nWords(count) : '—';
  }
}
