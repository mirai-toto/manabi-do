import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/vocabulary_level.dart';
import '../../../../l10n/vocabulary_level_label.dart';
import '../indicator/difficulty_dots.dart';
import '../surface/tappable_surface.dart';
import 'jlpt_level_card.dart';

/// One vocabulary level in the level list: a set of words, named for how common
/// they are, with what learning them buys.
///
/// The twin of [JlptLevelCard], which does the same job for kanji. Separate
/// rather than shared, because the badge carries a different kind of fact: a
/// kanji card shows a level code, and this shows how many words are in the set.
///
/// The badge holds the level number and nothing else. A percentage there read
/// as a statistic, and the word count read as the level's name; the number is
/// the one thing the badge can say that the rest of the row does not. The count
/// sits after the dots, where it belongs with the other measures of size.
///
/// No percentage appears on the row at all: the screen's own meter already says
/// how much of Japanese the learner can read.
class VocabularyLevelCard extends StatelessWidget {
  final int level;

  /// How many words are in this level, already written out, e.g. "750 words".
  final String? wordCount;

  final VoidCallback onTap;

  const VocabularyLevelCard({
    super.key,
    required this.level,
    required this.onTap,
    this.wordCount,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = vocabularyLevelColor(level, context.tokens);
    final count = wordCount;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceSm),
      child: TappableSurface(
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(
            color: color.withValues(alpha: 0.35),
            width: AppDimens.borderWidthContainer,
          ),
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Row(
            children: [
              LevelBadge(
                code: '$level',
                color: color,
                foreground: onVocabularyLevelColor(level, context.tokens),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vocabularyLevelLabel(level, context),
                      style: AppTextStyles.body.copyWith(
                        color: t.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceXs),
                    Row(
                      children: [
                        DifficultyDots(
                          total: kVocabularyLevelCount,
                          filled: vocabularyLevelDifficulty(level),
                          color: color,
                        ),
                        if (count != null) ...[
                          const SizedBox(width: AppDimens.spaceSm),
                          Text(
                            count,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: t.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: t.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
