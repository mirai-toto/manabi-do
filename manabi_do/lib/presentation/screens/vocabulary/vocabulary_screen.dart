import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/home_provider.dart';
import '../../providers/vocab_list_provider.dart';
import '../../widgets/widgets.dart';
import 'vocab_group_selector.dart';
import 'vocab_level_selector.dart';
import 'vocab_level_view.dart';

class VocabularyScreen extends ConsumerWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;
    final selectedLevel = ref.watch(vocabSelectedLevelProvider);
    final selectedGroup = ref.watch(vocabSelectedGroupProvider);

    final total = ref.watch(vocabTotalCountProvider);
    final subtitle = total != null
        ? l.vocabSubtitle(total)
        : l.vocabSubtitleShort;

    Widget body;
    if (selectedLevel == null) {
      body = VocabLevelSelector(
        onSelect: (level) {
          ref.read(vocabSelectedGroupProvider.notifier).clear();
          ref.read(vocabSelectedLevelProvider.notifier).select(level);
        },
      );
    } else if (selectedGroup == null) {
      body = VocabGroupSelector(
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
