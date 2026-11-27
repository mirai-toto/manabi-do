import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/vocabulary_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/pos_label.dart';
import '../../../l10n/vocabulary_level_label.dart';
import '../widgets.dart';

/// A search result as a card: the word with its reading, two lines of meaning,
/// its part of speech and, for lists that mix levels, its vocabulary level.
///
/// The whole card opens the word. It used to open only from the word itself,
/// while a tap on the meaning expanded it and the rest of the row did nothing,
/// so most taps on a result went nowhere. The speaker stays its own button,
/// above the card's tap area. The caller resolves the meaning.
class VocabularyWordTile extends StatelessWidget {
  final VocabularyEntry entry;

  /// The meaning to show, already in the reader's language where possible.
  final String meaning;

  /// The reader's language, named, when [meaning] fell back to English.
  final String? missingLanguage;

  /// Shows a level badge next to the part of speech. Search results mix
  /// levels, so they need it; a group already knows which level it belongs to.
  final bool showLevel;

  /// Opens the word's own screen.
  final VoidCallback? onOpen;

  const VocabularyWordTile({
    super.key,
    required this.entry,
    required this.meaning,
    this.missingLanguage,
    this.showLevel = false,
    this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final posColor = t.onSurfaceVariant;
    final levelColor = vocabularyLevelColor(entry.vocabularyLevel, t);
    final radius = BorderRadius.circular(AppDimens.radiusLg);

    return Container(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: radius,
        border: Border.all(
          color: t.outlineVariant,
          width: AppDimens.borderWidthContainer,
        ),
      ),
      child: Stack(
        children: [
          Material(
            type: MaterialType.transparency,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: Semantics(
              button: true,
              label: entry.word,
              child: InkWell(
                onTap: onOpen,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.spaceMd,
                    AppDimens.spaceCozy,
                    _kSpeakerGutter,
                    AppDimens.spaceCozy,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppDimens.spaceXs,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        spacing: AppDimens.spaceSm,
                        children: [
                          Text(
                            entry.word,
                            style: AppTextStyles.jpMedium.copyWith(
                              color: t.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (entry.reading != entry.word)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppDimens.spaceXxs,
                              ),
                              child: Text(
                                entry.reading,
                                style: AppTextStyles.jpFurigana.copyWith(
                                  color: t.onSurfaceVariant,
                                ),
                              ),
                            ),
                        ],
                      ),
                      TranslatedText(
                        meaning,
                        missingLanguage: missingLanguage,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: t.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        spacing: AppDimens.spaceXs,
                        children: [
                          PillBadge(
                            label: posLabel(entry.partOfSpeech, context),
                            color: posColor,
                            background: posColor.withValues(alpha: 0.1),
                            textStyle: AppTextStyles.labelSmall,
                          ),
                          if (showLevel)
                            PillBadge(
                              label: vocabularyLevelLabel(
                                entry.vocabularyLevel,
                                context,
                              ),
                              color: levelColor,
                              background: levelColor.withValues(alpha: 0.12),
                              textStyle: AppTextStyles.labelSmall,
                            ),
                          const Spacer(),
                          ExcludeSemantics(
                            child: Row(
                              children: [
                                Text(
                                  l.openWord,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: t.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: _kChevronSize,
                                  color: t.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: AppDimens.spaceXs,
            right: AppDimens.spaceXs,
            child: SpeakButton(text: entry.word, color: t.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Room on the right of the card's text for the speaker button above it.
const double _kSpeakerGutter = 56;

const double _kChevronSize = 16;
