import 'package:flutter/material.dart' hide Card, State;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../domain/data/kana_data.dart';
import '../../../../l10n/l10n.dart';
import '../../../services/srs_service.dart';
import '../../../widgets/widgets.dart';

class KanaDetailSheet extends ConsumerStatefulWidget {
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
  ConsumerState<KanaDetailSheet> createState() => _KanaDetailSheetState();
}

class _KanaDetailSheetState extends ConsumerState<KanaDetailSheet> {
  Card? _srsCard;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadCard();
  }

  Future<void> _loadCard() async {
    final card = await srsService.getCard(ref, widget.type, widget.entry.id);
    if (mounted) {
      setState(() {
        _srsCard = card;
        _loaded = true;
      });
    }
  }

  Future<void> _resetProgress() async {
    final l = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l.resetKanaTitle,
      body: l.resetKanaBody,
    );
    if (!confirmed) return;
    await srsService.resetCard(ref, widget.type, widget.entry.id);
    if (mounted) setState(() => _srsCard = null);
  }

  @override
  Widget build(BuildContext context) {
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
                Stack(
                  children: [
                    CharacterHeroBox(
                      character: widget.entry.kana,
                      size: 88,
                      accentColor: color,
                    ),
                    Positioned(
                      top: AppDimens.spaceSm,
                      right: AppDimens.spaceSm,
                      child: SpeakButton(
                        text: widget.entry.kana,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.entry.romaji,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: t.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXs),
                      Text(
                        widget.rowLabel,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: t.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXs),
                      Text(
                        widget.type == 'hiragana'
                            ? l.tabHiragana
                            : l.tabKatakana,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: t.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceLg),

            // Progress row
            SrsProgressCard(isLoaded: _loaded, srsCard: _srsCard),

            if (_loaded && _srsCard != null) ...[
              const SizedBox(height: AppDimens.spaceMd),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: _resetProgress,
                  icon: Icon(
                    Icons.restart_alt_rounded,
                    size: 18,
                    color: t.error,
                  ),
                  label: Text(
                    l.resetCharacterProgress,
                    style: AppTextStyles.bodySmall.copyWith(color: t.error),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
