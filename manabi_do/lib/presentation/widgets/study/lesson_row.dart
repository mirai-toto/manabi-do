import 'package:flutter/material.dart';

import '../../../core/models/learning_state.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/difficulty_dots.dart';
import '../common/pill_badge.dart';
import '../common/tappable_surface.dart';

class LessonRow extends StatelessWidget {
  final String title;
  final int index;
  final int difficulty;
  final LearningState state;
  final Color accentColor;
  final int exerciseCount;
  final VoidCallback onTap;

  const LessonRow({
    super.key,
    required this.title,
    required this.index,
    required this.difficulty,
    required this.state,
    required this.accentColor,
    required this.exerciseCount,
    required this.onTap,
  });

  Color _borderColor(AppTokens t) => switch (state) {
    LearningState.known => t.success,
    LearningState.started => accentColor.withValues(alpha: 0.5),
    LearningState.locked => t.outlineVariant.withValues(alpha: 0.4),
    _ => t.outlineVariant,
  };

  Color _iconBg(AppTokens t) => switch (state) {
    LearningState.known => t.successContainer,
    _ => accentColor.withValues(alpha: 0.12),
  };

  Widget _iconChild(AppTokens t) => switch (state) {
    LearningState.known => Icon(
      Icons.check_rounded,
      size: 18,
      color: t.success,
    ),
    LearningState.locked => Icon(
      Icons.lock_outline_rounded,
      size: 16,
      color: t.onSurfaceVariant,
    ),
    _ => Text(
      '${index + 1}',
      style: AppTextStyles.label.copyWith(
        color: accentColor,
        fontWeight: FontWeight.w700,
      ),
    ),
  };

  Color _chipBg(AppTokens t) => switch (state) {
    LearningState.known => t.successContainer,
    LearningState.started => accentColor.withValues(alpha: 0.12),
    _ => t.surfaceVariant,
  };

  Color _chipFg(AppTokens t) => switch (state) {
    LearningState.known => t.success,
    LearningState.started => accentColor,
    _ => t.onSurfaceVariant,
  };

  String _chipLabel(AppLocalizations l) => switch (state) {
    LearningState.notStarted => l.lessonStart,
    LearningState.started => l.lessonStateStarted,
    LearningState.known => l.lessonStateKnown,
    LearningState.unknown => l.lessonStateUnknown,
    LearningState.locked => l.lessonStateLocked,
  };

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    return Semantics(
      label: '$title, ${_chipLabel(l)}',
      button: true,
      excludeSemantics: true,
      child: Opacity(
        opacity: state == LearningState.locked ? 0.55 : 1.0,
        child: TappableSurface(
          decoration: BoxDecoration(
            color: t.cardBackground,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: Border.all(color: _borderColor(t)),
          ),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: AppDimens.spaceMd,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _iconBg(t),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: _iconChild(t)),
                ),
                const SizedBox(width: AppDimens.iconTextGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.body.copyWith(
                          color: t.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          DifficultyDots(
                            total: 3,
                            filled: difficulty,
                            color: accentColor,
                            emptyColor: t.outlineVariant,
                          ),
                          if (exerciseCount > 0) ...[
                            const SizedBox(width: AppDimens.spaceSm),
                            Text(
                              '· $exerciseCount ex.',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: t.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSm),
                PillBadge(
                  label: _chipLabel(l),
                  color: _chipFg(t),
                  background: _chipBg(t),
                  textStyle: AppTextStyles.labelSmall,
                ),
                const SizedBox(width: AppDimens.spaceXs),
                Icon(Icons.chevron_right_rounded, color: t.outlineVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
