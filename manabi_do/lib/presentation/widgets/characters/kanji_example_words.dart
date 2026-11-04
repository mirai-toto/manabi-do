import '../../../core/text/sentence_language.dart';
import '../../../core/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/vocabulary_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/pos_label.dart';
import '../widgets.dart';
import '../../providers/vocabulary_provider.dart';
import '../../screens/vocabulary/vocabulary_detail_screen.dart';

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
              : _WordList(words: words, missingLanguage: missingLanguage),
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

class _WordList extends StatelessWidget {
  final List<LocalizedWord> words;

  /// The reader's language, named, when any word in the list is missing it.
  final String? missingLanguage;

  const _WordList({required this.words, this.missingLanguage});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return CardContainer(
      child: Column(
        children: [
          for (int i = 0; i < words.length; i++) ...[
            if (i > 0)
              Divider(height: 1, thickness: 1, color: t.outlineVariant),
            _WordRow(word: words[i], missingLanguage: missingLanguage),
          ],
        ],
      ),
    );
  }
}

class _WordRow extends StatelessWidget {
  final LocalizedWord word;

  /// The reader's language, named. The mark is drawn on the rows that are
  /// actually missing it, not on all of them — this list is usually mixed,
  /// and a mark on a French row would be a lie.
  final String? missingLanguage;

  const _WordRow({required this.word, this.missingLanguage});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final entry = word.entry;
    final Color levelColour = vocabularyLevelColor(
      entry.vocabularyLevel,
      Theme.of(context).brightness,
    );

    return InkWell(
      // Opens the word's own screen, which already holds its senses, the
      // kanji it is written with and its example sentences.
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => VocabularyDetailScreen(entry: entry),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceSnug,
        ),
        child: Row(
          children: [
            // Fixed, not flexible. The rarity used to be a word — "Les plus
            // courants" against "Courants" — and its width changed what was
            // left for everything else, so no two meanings began at the same
            // place down the list.
            SizedBox(
              width: 80,
              child: _WordLabel(word: entry.word, reading: entry.reading),
            ),
            const SizedBox(width: AppDimens.spaceSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(
                    word.meaning,
                    missingLanguage: word.translated ? null : missingLanguage,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: t.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimens.spaceXxs),
                  Text(
                    posLabel(entry.partOfSpeech, context),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: t.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.spaceSm),
            // Dots, not a label: the same rarity in a fixed width, and the
            // reader is here for the word rather than for its band.
            DifficultyDots(
              total: kVocabularyLevelCount,
              filled: kVocabularyLevelCount - entry.vocabularyLevel + 1,
              color: levelColour,
            ),
          ],
        ),
      ),
    );
  }
}

class _WordLabel extends StatelessWidget {
  final String word;
  final String reading;
  const _WordLabel({required this.word, required this.reading});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          word,
          style: AppTextStyles.jpBody.copyWith(
            color: t.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimens.spaceXxs),
        Text(
          reading,
          style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant),
        ),
      ],
    );
  }
}
