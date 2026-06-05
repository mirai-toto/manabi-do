import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/vocab_list_provider.dart';
import 'vocab_level_selector.dart';
import 'vocab_level_view.dart';

class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({super.key});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen> {
  String? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    // Count total words across all levels for the header
    const levels = ['N5', 'N4', 'N3', 'N2', 'N1'];
    int? total;
    var allLoaded = true;
    var sum = 0;
    for (final lvl in levels) {
      final data = ref.watch(vocabByLevelProvider(lvl)).asData?.value;
      if (data == null) { allLoaded = false; break; }
      sum += data.length;
    }
    if (allLoaded) total = sum;

    final subtitle = total != null
        ? l.vocabSubtitle(total)
        : l.vocabSubtitleShort;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimens.screenMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.spaceMd, AppDimens.spaceMd,
                AppDimens.spaceMd, AppDimens.spaceSm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.sectionVocabulary,
                          style: AppTextStyles.headline.copyWith(color: t.onSurface),
                        ),
                        Text(
                          subtitle,
                          style: AppTextStyles.bodySmall.copyWith(
                              color: t.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '語',
                    style: AppTextStyles.jpDisplay.copyWith(color: t.vocabulary),
                  ),
                ],
              ),
            ),
            // Body
            Expanded(
              child: _selectedLevel == null
                  ? VocabLevelSelector(
                      onSelect: (level) => setState(() => _selectedLevel = level),
                    )
                  : VocabLevelView(
                      level: _selectedLevel!,
                      onBack: () => setState(() => _selectedLevel = null),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
