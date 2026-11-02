import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/coverage_band.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/band_label.dart';
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
    final selectedBand = ref.watch(vocabularySelectedBandProvider);
    final selectedGroup = ref.watch(vocabularySelectedGroupProvider);

    final total = ref.watch(vocabularyTotalCountProvider);
    final subtitle = total != null
        ? l.vocabularySubtitle(total)
        : l.vocabularySubtitleShort;

    final brightness = Theme.of(context).brightness;

    Widget body;
    if (selectedBand == null) {
      body = VocabularyBandSelector(
        onSelect: (band) {
          ref.read(vocabularySelectedGroupProvider.notifier).clear();
          ref.read(vocabularySelectedBandProvider.notifier).select(band);
        },
      );
    } else if (selectedGroup == null) {
      body = VocabularyGroupSelector(
        band: selectedBand,
        onBack: () {
          ref.read(vocabularySelectedGroupProvider.notifier).clear();
          ref.read(vocabularySelectedBandProvider.notifier).clear();
        },
        onPractice: () => openVocabularyPractice(
          context,
          title: bandLabel(selectedBand, context),
          band: selectedBand,
          color: bandColor(selectedBand, brightness),
        ),
        onSelect: (i) =>
            ref.read(vocabularySelectedGroupProvider.notifier).select(i),
      );
    } else {
      body = VocabularyBandView(
        band: selectedBand,
        groupIndex: selectedGroup,
        onBack: () =>
            ref.read(vocabularySelectedGroupProvider.notifier).clear(),
        onPractice: (vocabularyIds) => openVocabularyPractice(
          context,
          title: l.groupN(selectedGroup + 1),
          band: selectedBand,
          color: bandColor(selectedBand, brightness),
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
