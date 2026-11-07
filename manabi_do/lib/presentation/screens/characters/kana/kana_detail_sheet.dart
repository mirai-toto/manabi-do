import 'package:flutter/material.dart' hide Card, State;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../domain/data/kana_data.dart';
import '../../../../l10n/l10n.dart';
import '../../../providers/srs_cards_provider.dart';
import '../reset_progress_button.dart';
import '../../../widgets/widgets.dart';

class KanaDetailSheet extends ConsumerWidget {
  final KanaEntry entry;
  final String rowLabel;
  final String type; // 'hiragana' | 'katakana'

  const KanaDetailSheet({
    super.key,
    required this.entry,
    required this.rowLabel,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final srsCardsAsync = ref.watch(srsCardsProvider(type));
    final bool loaded = srsCardsAsync.asData != null;
    final Card? srsCard = srsCardsAsync.asData?.value[entry.id];
    final t = context.tokens;
    final l = context.l10n;
    final color = levelColor('kana');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.spaceMd,
          AppDimens.spaceSm,
          AppDimens.spaceMd,
          AppDimens.spaceMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SheetDragHandle(),

            // Character hero
            Row(
              children: [
                CharacterHeroBox(
                  character: entry.kana,
                  size: 88,
                  accentColor: color,
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.romaji,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: t.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXs),
                      Text(
                        rowLabel,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: t.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXs),
                      Text(
                        type == 'hiragana' ? l.tabHiragana : l.tabKatakana,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: t.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSm),
                // Beside the character rather than on it, where a white icon
                // was hard to see on the lighter level colours.
                SpeakButton(
                  text: entry.kana,
                  color: onAccentContainer(color, Theme.of(context).brightness),
                  background: accentContainer(
                    color,
                    Theme.of(context).brightness,
                  ),
                  size: 22,
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceLg),

            // Progress row
            SrsProgressCard(isLoaded: loaded, srsCard: srsCard),

            if (loaded && srsCard != null) ...[
              const SizedBox(height: AppDimens.spaceMd),
              ResetProgressButton(
                srsType: type,
                id: entry.id,
                confirmTitle: context.l10n.resetKanaTitle,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
