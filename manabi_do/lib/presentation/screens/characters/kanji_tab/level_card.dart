import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../providers/kanji_provider.dart';

class KanjiLevelCard extends StatelessWidget {
  final String code;
  final KanjiLevelData? data;
  final VoidCallback onTap;
  const KanjiLevelCard({super.key, required this.code, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = levelColor(code);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimens.spaceSm),
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
        ),
        child: Row(
          children: [
            _LevelBadge(code: code, color: color),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(child: _LevelCardInfo(data: data, code: code, color: color)),
            Icon(Icons.chevron_right_rounded, color: t.onSurfaceVariant),
          ],
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
        style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

class _LevelCardInfo extends StatelessWidget {
  final KanjiLevelData? data;
  final String code;
  final Color color;
  const _LevelCardInfo({required this.data, required this.code, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data?.label ?? '—',
          style: AppTextStyles.body.copyWith(color: t.onSurface, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              data != null ? '${data!.total} kanji' : '— kanji',
              style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
            ),
            const SizedBox(width: AppDimens.spaceSm),
            _DifficultyDots(filled: levelDifficulty(code), color: color),
          ],
        ),
      ],
    );
  }
}

class _DifficultyDots extends StatelessWidget {
  final int filled;
  final Color color;
  const _DifficultyDots({required this.filled, required this.color});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      5,
      (i) => Container(
        margin: EdgeInsets.only(left: i > 0 ? 3 : 0),
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: i < filled ? color : color.withValues(alpha: 0.2),
        ),
      ),
    ),
  );
}
