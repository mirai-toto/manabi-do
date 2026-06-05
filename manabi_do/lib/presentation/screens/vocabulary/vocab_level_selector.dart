import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/vocab_list_provider.dart';
import '../../widgets/common/difficulty_dots.dart';
import '../../widgets/common/section_label.dart';

const _levels = ['N5', 'N4', 'N3', 'N2', 'N1'];

class VocabLevelSelector extends ConsumerWidget {
  final void Function(String) onSelect;
  const VocabLevelSelector({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      children: [
        SectionLabel(context.l10n.selectLevel),
        const SizedBox(height: AppDimens.spaceSm),
        for (final code in _levels)
          _VocabLevelCard(
            code: code,
            count: ref.watch(vocabByLevelProvider(code)).asData?.value.length,
            onTap: () => onSelect(code),
          ),
      ],
    );
  }
}

class _VocabLevelCard extends StatelessWidget {
  final String code;
  final int? count;
  final VoidCallback onTap;
  const _VocabLevelCard({required this.code, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = levelColor(code);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceSm),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spaceMd),
            child: Row(
              children: [
                _LevelBadge(code: code, color: color),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        levelLabel(code, context),
                        style: AppTextStyles.body.copyWith(
                          color: t.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            count != null ? context.l10n.nWords(count!) : '—',
                            style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
                          ),
                          const SizedBox(width: AppDimens.spaceSm),
                          DifficultyDots(
                            total: 5,
                            filled: levelDifficulty(code),
                            color: color,
                          ),
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
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final String code;
  final Color color;
  const _LevelBadge({required this.code, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
    ),
    child: Center(
      child: Text(
        code,
        style: AppTextStyles.labelLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
