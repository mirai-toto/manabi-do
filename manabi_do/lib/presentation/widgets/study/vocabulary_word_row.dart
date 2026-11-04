import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../common/label/translation_fallback_info.dart';

/// Compact vocabulary row: a mastery spine, the word with its reading, and the
/// meaning on one line.
///
/// The dense counterpart of [VocabularyWordTile], which expands to show the
/// full meaning and speak the word. This one is for a list long enough that
/// knowing *where you stand* matters more than reading every gloss — thirty
/// words in a group, grouped by what to do about them.
///
/// Both read the localized meaning from the same provider, so there is no
/// duplicated lookup between them; only the layout differs.
///
/// [accent] is the spine, and the caller picks it from the word's SRS state.
/// A spine rather than a tint behind the row, because a row has to stay
/// readable and a wash behind text does not survive six states.
class VocabularyWordRow extends StatelessWidget {
  final VocabularyEntry entry;

  /// The meaning to show, already in the reader's language where possible.
  final String meaning;

  /// The reader's language, named, when [meaning] fell back to English.
  final String? missingLanguage;
  final Color accent;
  final VoidCallback? onOpen;

  const VocabularyWordRow({
    super.key,
    required this.entry,
    required this.meaning,
    this.missingLanguage,
    required this.accent,
    this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return InkWell(
      onTap: onOpen,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceCozy,
          vertical: AppDimens.spaceSnug,
        ),
        child: Row(
          children: [
            Container(
              width: 3,
              height: 30,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppDimens.spaceCozy),
            // Fixed width, so the meanings line up down the list instead of
            // stepping in and out with the length of each word.
            SizedBox(
              width: 78,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (entry.reading != entry.word)
                    Text(
                      entry.reading,
                      style: AppTextStyles.jpFurigana.copyWith(
                        color: t.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    entry.word,
                    style: AppTextStyles.jpBody.copyWith(color: t.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.spaceSm),
            Expanded(
              child: TranslatedText(
                meaning,
                missingLanguage: missingLanguage,
                style: AppTextStyles.bodySmall.copyWith(
                  color: t.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
