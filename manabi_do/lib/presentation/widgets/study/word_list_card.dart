import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/vocabulary_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/pos_label.dart';
import '../widgets.dart';

/// One word in a [WordListCard]: its meaning in the reader's language where
/// there is one, and, for a word found in a sentence, the form the sentence
/// writes it in.
typedef WordListItem = ({
  VocabularyEntry entry,
  String meaning,
  bool translated,
  String? surface,
});

/// A card of word rows, each opening the word: a kanji's example words, the
/// words in a sentence.
class WordListCard extends StatelessWidget {
  final List<WordListItem> words;

  /// The reader's language, named, for the rows whose meaning fell back to
  /// English.
  final String? missingLanguage;
  final ValueChanged<VocabularyEntry> onOpen;

  const WordListCard({
    super.key,
    required this.words,
    required this.onOpen,
    this.missingLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return CardContainer(
      child: Column(
        children: [
          for (int i = 0; i < words.length; i++) ...[
            if (i > 0)
              Divider(height: 1, thickness: 1, color: t.outlineVariant),
            _WordRow(
              word: words[i],
              missingLanguage: missingLanguage,
              onOpen: onOpen,
            ),
          ],
        ],
      ),
    );
  }
}

class _WordRow extends StatelessWidget {
  final WordListItem word;

  /// The reader's language, named. The mark is drawn on the rows that are
  /// actually missing it, not on all of them — a list is usually mixed, and a
  /// mark on a French row would be a lie.
  final String? missingLanguage;
  final ValueChanged<VocabularyEntry> onOpen;

  const _WordRow({
    required this.word,
    required this.onOpen,
    this.missingLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final entry = word.entry;
    final Color levelColour = vocabularyLevelColor(entry.vocabularyLevel, t);
    // Only an inflected form is worth showing: 戻ります under 戻る, not 戻る twice.
    final String? surface = word.surface == entry.word ? null : word.surface;

    return Semantics(
      label: '${entry.word}, ${word.meaning}',
      button: true,
      excludeSemantics: true,
      child: InkWell(
        // Opens the word's own screen, which already holds its senses, the
        // kanji it is written with and its example sentences.
        onTap: () => onOpen(entry),
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
                child: _WordLabel(
                  word: entry.word,
                  reading: entry.reading,
                  surface: surface,
                ),
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
                filled: vocabularyLevelDifficulty(entry.vocabularyLevel),
                color: levelColour,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WordLabel extends StatelessWidget {
  final String word;
  final String reading;

  /// The form a sentence writes the word in, when it differs.
  final String? surface;

  const _WordLabel({required this.word, required this.reading, this.surface});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final String? surface = this.surface;
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
        if (surface != null && surface.isNotEmpty) ...[
          const SizedBox(height: AppDimens.spaceXxs),
          Text(
            context.l10n.writtenAs(surface),
            style: AppTextStyles.labelSmall.copyWith(color: t.primary),
          ),
        ],
      ],
    );
  }
}
