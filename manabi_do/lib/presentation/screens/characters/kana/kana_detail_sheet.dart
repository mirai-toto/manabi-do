import 'package:flutter/material.dart' hide Card, State;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../domain/data/kana_data.dart';
import '../../../../l10n/l10n.dart';
import '../../../providers/database_provider.dart';
import '../../../widgets/common/confirm_dialog.dart';
import '../../../widgets/common/srs_progress_info.dart';

class KanaDetailSheet extends ConsumerStatefulWidget {
  final KanaEntry entry;
  final String rowLabel;
  final String type; // 'hiragana' | 'katakana'
  final bool isSkipped;

  const KanaDetailSheet({
    super.key,
    required this.entry,
    required this.rowLabel,
    required this.type,
    required this.isSkipped,
  });

  @override
  ConsumerState<KanaDetailSheet> createState() => _KanaDetailSheetState();
}

class _KanaDetailSheetState extends ConsumerState<KanaDetailSheet> {
  Card? _srsCard;
  bool _loaded = false;
  late bool _isSkipped;

  @override
  void initState() {
    super.initState();
    _isSkipped = widget.isSkipped;
    _loadCard();
  }

  Future<void> _loadCard() async {
    final card = await ref.read(databaseProvider).getSrsCard(widget.type, widget.entry.id);
    if (mounted) setState(() { _srsCard = card; _loaded = true; });
  }

  Future<void> _toggleSkip() async {
    final next = !_isSkipped;
    await ref.read(databaseProvider).setKanaKnown(widget.type, widget.entry.id, isKnown: next);
    if (mounted) setState(() => _isSkipped = next);
  }

  Future<void> _resetProgress() async {
    final l = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l.resetKanaTitle,
      body: l.resetKanaBody,
    );
    if (!confirmed) return;
    await ref.read(databaseProvider).resetSrsCard(widget.type, widget.entry.id);
    if (mounted) setState(() { _srsCard = null; _isSkipped = false; });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final color = levelColor('kana');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.spaceMd, AppDimens.spaceSm, AppDimens.spaceMd, AppDimens.spaceMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
              decoration: BoxDecoration(
                color: t.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Character hero
            Row(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.lerp(color, Colors.black, 0.25)!,
                        color,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  ),
                  child: Center(
                    child: Text(
                      widget.entry.kana,
                      style: AppTextStyles.jpKanji.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.entry.romaji,
                        style: AppTextStyles.titleLarge.copyWith(color: t.onSurface),
                      ),
                      const SizedBox(height: AppDimens.spaceXs),
                      Text(
                        widget.rowLabel,
                        style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppDimens.spaceXs),
                      Text(
                        widget.type == 'hiragana' ? l.tabHiragana : l.tabKatakana,
                        style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimens.spaceLg),

            // Progress row
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              decoration: BoxDecoration(
                color: t.surfaceContainer,
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              ),
              child: _loaded
                  ? SrsProgressInfo(srsCard: _srsCard)
                  : const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            ),

            const SizedBox(height: AppDimens.spaceMd),

            // Skip toggle
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _toggleSkip,
                icon: Icon(
                  Icons.not_interested_rounded,
                  color: _isSkipped ? t.error : t.onSurfaceVariant,
                ),
                label: Text(
                  _isSkipped ? l.skippedKana : l.skipKana,
                  style: AppTextStyles.body.copyWith(
                    color: _isSkipped ? t.error : t.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
                  side: BorderSide(color: _isSkipped ? t.error : t.outlineVariant),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  ),
                ),
              ),
            ),

            if (_loaded && (_srsCard != null || _isSkipped)) ...[
              const SizedBox(height: AppDimens.spaceSm),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: _resetProgress,
                  icon: Icon(Icons.restart_alt_rounded, size: 18, color: t.error),
                  label: Text(
                    l.settingsResetProgress,
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

