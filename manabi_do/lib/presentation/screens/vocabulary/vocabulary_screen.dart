import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/vocabulary_level.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/vocabulary_level_label.dart';
import '../../providers/home_provider.dart';
import '../../providers/vocabulary_list_provider.dart';
import '../../widgets/widgets.dart';
import '../practice/practice_launcher.dart';

class VocabularyScreen extends ConsumerWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;
    final selectedLevel = ref.watch(vocabularySelectedLevelProvider);
    final selectedGroup = ref.watch(vocabularySelectedGroupProvider);

    final total = ref.watch(vocabularyTotalCountProvider);
    final subtitle = total != null
        ? l.vocabularySubtitle(total)
        : l.vocabularySubtitleShort;

    final brightness = Theme.of(context).brightness;

    Widget body;
    if (selectedLevel == null) {
      body = VocabularyLevelSelector(
        onSelect: (level) {
          ref.read(vocabularySelectedGroupProvider.notifier).clear();
          ref.read(vocabularySelectedLevelProvider.notifier).select(level);
        },
      );
    } else if (selectedGroup == null) {
      body = VocabularyGroupSelector(
        level: selectedLevel,
        onBack: () {
          ref.read(vocabularySelectedGroupProvider.notifier).clear();
          ref.read(vocabularySelectedLevelProvider.notifier).clear();
        },
        onPractice: () => openVocabularyPractice(
          context,
          title: vocabularyLevelLabel(selectedLevel, context),
          level: selectedLevel,
          color: vocabularyLevelColor(selectedLevel, brightness),
        ),
        onSelect: (i) =>
            ref.read(vocabularySelectedGroupProvider.notifier).select(i),
      );
    } else {
      body = VocabularyLevelView(
        level: selectedLevel,
        groupIndex: selectedGroup,
        onBack: () =>
            ref.read(vocabularySelectedGroupProvider.notifier).clear(),
        onPractice: (vocabularyIds) => openVocabularyPractice(
          context,
          title: l.groupN(selectedGroup + 1),
          level: selectedLevel,
          color: vocabularyLevelColor(selectedLevel, brightness),
          vocabularyIds: vocabularyIds,
        ),
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
              color: t.primary,
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
