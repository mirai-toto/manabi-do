import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/pos_label.dart';
import '../../providers/database_provider.dart';
import '../../widgets/common/known_toggle.dart';
import '../../widgets/common/pill_badge.dart';

final _localizedVocabMeaningProvider =
    FutureProvider.family<String, int>((ref, vocabId) async {
  final locale = ref.watch(localeProvider).languageCode;
  if (locale == 'en') return '';
  final db = ref.watch(databaseProvider);
  final tr = await db.getVocabTranslations([vocabId], locale);
  return tr[vocabId] ?? '';
});

class VocabWordTile extends ConsumerWidget {
  final VocabularyEntry entry;
  final bool isKnown;
  final VoidCallback? onToggleKnown;

  const VocabWordTile({
    super.key,
    required this.entry,
    required this.isKnown,
    this.onToggleKnown,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final localized = ref.watch(_localizedVocabMeaningProvider(entry.id));
    final meaning = localized.asData?.value.isNotEmpty == true
        ? localized.asData!.value
        : entry.meaning;
    final posColor = t.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      entry.word,
                      style: AppTextStyles.jpMedium.copyWith(color: t.onSurface),
                    ),
                    const SizedBox(width: AppDimens.spaceSm),
                    Text(
                      entry.reading,
                      style: AppTextStyles.jpBody.copyWith(color: t.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  meaning,
                  style: AppTextStyles.body.copyWith(color: t.onSurface),
                ),
                const SizedBox(height: AppDimens.spaceXs),
                PillBadge(
                  label: posLabel(entry.partOfSpeech, context),
                  color: posColor,
                  background: posColor.withValues(alpha: 0.1),
                  textStyle: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.spaceSm),
          KnownToggle(isKnown: isKnown, onTap: onToggleKnown),
        ],
      ),
    );
  }
}
