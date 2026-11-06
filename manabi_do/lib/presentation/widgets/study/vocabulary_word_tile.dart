import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/vocabulary_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/pos_label.dart';
import '../../../l10n/vocabulary_level_label.dart';
import '../widgets.dart';

/// Expandable vocabulary list row. Shows word, reading, abbreviated meaning.
/// Tap expands to full meaning, part-of-speech chips, and `SpeakButton`.
/// The caller resolves the meaning. `showLevel` adds a vocabulary-level badge
/// on the right, for lists that mix levels.
class VocabularyWordTile extends StatefulWidget {
  final VocabularyEntry entry;

  /// The meaning to show, already in the reader's language where possible.
  final String meaning;

  /// The reader's language, named, when [meaning] fell back to English.
  final String? missingLanguage;

  /// Shows a JLPT badge next to the part of speech. Search results mix levels,
  /// so they need it; a group already knows which level it belongs to.
  final bool showLevel;

  /// Opens the word's own screen. The meaning keeps its own tap, which expands
  /// it, so only the word itself navigates.
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
  State<VocabularyWordTile> createState() => _VocabularyWordTileState();
}

class _VocabularyWordTileState extends State<VocabularyWordTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final String meaning = widget.meaning;
    final String? missingLanguage = widget.missingLanguage;
    final posColor = t.onSurfaceVariant;
    final meaningStyle = AppTextStyles.body.copyWith(color: t.onSurface);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceSm,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tp = TextPainter(
            text: TextSpan(text: meaning, style: meaningStyle),
            maxLines: 2,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth);
          final overflows = tp.didExceedMaxLines;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Semantics(
                      label: widget.entry.word,
                      button: true,
                      excludeSemantics: true,
                      child: GestureDetector(
                        onTap: widget.onOpen,
                        child: JapaneseText(
                          word: widget.entry.word,
                          reading: widget.entry.reading,
                          style: AppTextStyles.jpMedium.copyWith(
                            color: t.onSurface,
                          ),
                          rubyStyle: AppTextStyles.jpFurigana.copyWith(
                            color: t.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SpeakButton(
                    text: widget.entry.word,
                    color: t.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spaceXxs),
              Semantics(
                button: overflows,
                toggled: overflows ? _expanded : null,
                child: GestureDetector(
                  onTap: overflows
                      ? () => setState(() => _expanded = !_expanded)
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TranslatedText(
                        meaning,
                        missingLanguage: missingLanguage,
                        style: meaningStyle,
                        maxLines: _expanded ? null : 2,
                        overflow: _expanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimens.spaceXs),
                      SizedBox(
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            PillBadge(
                              label: posLabel(
                                widget.entry.partOfSpeech,
                                context,
                              ),
                              color: posColor,
                              background: posColor.withValues(alpha: 0.1),
                              textStyle: AppTextStyles.labelSmall,
                            ),
                            if (overflows)
                              Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  _expanded
                                      ? Icons.expand_less_rounded
                                      : Icons.expand_more_rounded,
                                  size: 16,
                                  color: t.onSurfaceVariant,
                                ),
                              ),
                            if (widget.showLevel)
                              Align(
                                alignment: Alignment.centerRight,
                                child: PillBadge(
                                  label: vocabularyLevelLabel(
                                    widget.entry.vocabularyLevel,
                                    context,
                                  ),
                                  color: vocabularyLevelColor(
                                    widget.entry.vocabularyLevel,
                                    context.tokens,
                                  ),
                                  background: vocabularyLevelColor(
                                    widget.entry.vocabularyLevel,
                                    context.tokens,
                                  ).withValues(alpha: 0.12),
                                  textStyle: AppTextStyles.labelSmall,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
