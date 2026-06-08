import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/pos_label.dart';
import '../../providers/database_provider.dart';
import '../../widgets/widgets.dart';

final _localizedVocabMeaningProvider =
    FutureProvider.family<String, int>((ref, vocabId) async {
  final locale = ref.watch(localeProvider).languageCode;
  if (locale == 'en') return '';
  final db = ref.watch(databaseProvider);
  final tr = await db.getVocabTranslations([vocabId], locale);
  return tr[vocabId] ?? '';
});

class VocabWordTile extends ConsumerStatefulWidget {
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
  ConsumerState<VocabWordTile> createState() => _VocabWordTileState();
}

class _VocabWordTileState extends ConsumerState<VocabWordTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final localized = ref.watch(_localizedVocabMeaningProvider(widget.entry.id));
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
                    child: FuriganaText(
                      word: widget.entry.word,
                      reading: widget.entry.reading,
                      wordStyle: AppTextStyles.jpMedium.copyWith(color: t.onSurface),
                      rubyStyle: AppTextStyles.jpBody.copyWith(
                        fontSize: 11,
                        color: t.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SpeakButton(text: widget.entry.word, color: t.onSurfaceVariant),
                  KnownToggle(isKnown: widget.isKnown, onTap: widget.onToggleKnown),
                ],
              ),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: overflows ? () => setState(() => _expanded = !_expanded) : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meaning,
                      style: meaningStyle,
                      maxLines: _expanded ? null : 2,
                      overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimens.spaceXs),
                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          PillBadge(
                            label: posLabel(widget.entry.partOfSpeech, context),
                            color: posColor,
                            background: posColor.withValues(alpha: 0.1),
                            textStyle: AppTextStyles.labelSmall,
                          ),
                          if (overflows)
                            Align(
                              alignment: Alignment.center,
                              child: Icon(
                                _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                                size: 16,
                                color: t.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
