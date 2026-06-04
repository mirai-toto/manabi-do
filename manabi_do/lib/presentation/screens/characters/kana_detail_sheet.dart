import 'package:flutter/material.dart' hide Card, State;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../domain/data/kana_data.dart';
import '../../../l10n/l10n.dart';
import '../../providers/database_provider.dart';

class KanaDetailSheet extends ConsumerStatefulWidget {
  final KanaEntry entry;
  final String rowLabel;
  final String type; // 'hiragana' | 'katakana'
  final bool isKnown;

  const KanaDetailSheet({
    super.key,
    required this.entry,
    required this.rowLabel,
    required this.type,
    required this.isKnown,
  });

  @override
  ConsumerState<KanaDetailSheet> createState() => _KanaDetailSheetState();
}

class _KanaDetailSheetState extends ConsumerState<KanaDetailSheet> {
  Card? _srsCard;
  bool _loaded = false;
  late bool _isKnown;

  @override
  void initState() {
    super.initState();
    _isKnown = widget.isKnown;
    _loadCard();
  }

  Future<void> _loadCard() async {
    final card = await ref.read(databaseProvider).getSrsCard(widget.type, widget.entry.id);
    if (mounted) setState(() { _srsCard = card; _loaded = true; });
  }

  Future<void> _toggleKnown() async {
    final next = !_isKnown;
    await ref.read(databaseProvider).setKanaKnown(widget.type, widget.entry.id, isKnown: next);
    if (mounted) setState(() => _isKnown = next);
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
                  ? _ProgressInfo(srsCard: _srsCard)
                  : const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            ),

            const SizedBox(height: AppDimens.spaceMd),

            // Known toggle
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _toggleKnown,
                icon: Icon(
                  _isKnown ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: _isKnown ? t.success : t.onSurfaceVariant,
                ),
                label: Text(
                  _isKnown ? l.knownCheck : l.markAsKnown,
                  style: AppTextStyles.body.copyWith(
                    color: _isKnown ? t.success : t.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
                  side: BorderSide(color: _isKnown ? t.success : t.outlineVariant),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressInfo extends StatelessWidget {
  final Card? srsCard;
  const _ProgressInfo({required this.srsCard});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    final (stateLabel, stateColor) = switch (srsCard?.state) {
      null           => (l.srsStateNew,      t.onSurfaceVariant),
      State.review   => (l.srsStateMastered, t.success),
      _              => (l.srsStateLearning,  t.warning),
    };

    final dueText = _dueText(srsCard, l);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: stateColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            stateLabel,
            style: AppTextStyles.labelSmall.copyWith(
              color: stateColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (dueText != null) ...[
          const SizedBox(width: AppDimens.spaceSm),
          Text(
            dueText,
            style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
          ),
        ],
      ],
    );
  }

  String? _dueText(Card? card, AppLocalizations l) {
    if (card == null) return null;
    final now = DateTime.now();
    final due = card.due.toLocal();
    final diff = due.difference(now).inDays;
    if (diff <= 0) return l.srsDueToday;
    return l.srsDueIn(diff);
  }
}
