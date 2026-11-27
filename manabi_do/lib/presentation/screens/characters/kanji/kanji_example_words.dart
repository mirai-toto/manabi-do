import '../../../../core/text/sentence_language.dart';
import '../../../../core/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/database/app_database.dart';
import '../../../../l10n/l10n.dart';
import '../../../widgets/widgets.dart';
import '../../../providers/vocabulary_provider.dart';
import '../../detail_navigation.dart';

/// `SectionLabel` + list of example vocabulary words for a kanji. Fetches
/// localized vocabulary via provider; shows a loading indicator, empty state,
/// or word list with `PillBadge` JLPT tags.
class KanjiExampleWords extends ConsumerWidget {
  final Kanji kanji;
  const KanjiExampleWords({super.key, required this.kanji});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(
      localizedKanjiVocabularyProvider((kanjiId: kanji.id)),
    );

    // Named once here and handed down; each row decides whether it is the
    // one that needs the mark.
    final String? missingLanguage = readerLanguageName(
      ref.watch(localeProvider).languageCode,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(context.l10n.exampleWords),
        const SizedBox(height: AppDimens.spaceSm),
        async.when(
          loading: () => const _Loading(),
          error: (_, _) => const SizedBox.shrink(),
          data: (words) => words.isEmpty
              ? const _EmptyState()
              : WordListCard(
                  words: [
                    for (final w in words)
                      (
                        entry: w.entry,
                        meaning: w.meaning,
                        translated: w.translated,
                        surface: null,
                      ),
                  ],
                  missingLanguage: missingLanguage,
                  onOpen: (entry) => openWordDetail(context, entry),
                ),
        ),
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
      child: AppSpinner(),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
      child: Text(
        context.l10n.noExampleWordsFound,
        style: AppTextStyles.bodySmall.copyWith(
          color: context.tokens.onSurfaceVariant,
        ),
      ),
    ),
  );
}
