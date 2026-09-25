import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/pos_label.dart';
import '../../providers/vocabulary_provider.dart';
import '../widgets.dart';

class VocabularyWordTile extends ConsumerStatefulWidget {
  final VocabularyEntry entry;

  /// Shows a JLPT badge next to the part of speech. Search results mix levels,
  /// so they need it; a group already knows which level it belongs to.
  final bool showLevel;

  const VocabularyWordTile({
    super.key,
    required this.entry,
    this.showLevel = false,
  });

  @override
  ConsumerState<VocabularyWordTile> createState() => _VocabularyWordTileState();
}

class _VocabularyWordTileState extends ConsumerState<VocabularyWordTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final localized = ref.watch(
      localizedVocabularyMeaningProvider(widget.entry.id),
    );
    final meaning = localized.asData?.value.isNotEmpty == true
        ? localized.asData!.value
        : widget.entry.meaning;
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
                      Text(
                        meaning,
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
                                  label: widget.entry.jlptLevel,
                                  color: levelColor(widget.entry.jlptLevel),
                                  background: levelColor(
                                    widget.entry.jlptLevel,
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
