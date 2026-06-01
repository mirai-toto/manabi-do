import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/app_button.dart';

class SummaryCard extends StatelessWidget {
  final int score;
  final int total;
  final String title;
  final String subtitle;
  final int correct;
  final int missed;
  final int markedKnown;
  final String timeSpent;
  final VoidCallback? onRetry;
  final VoidCallback? onNext;

  const SummaryCard({
    super.key,
    required this.score,
    required this.total,
    required this.title,
    required this.subtitle,
    required this.correct,
    required this.missed,
    required this.markedKnown,
    required this.timeSpent,
    this.onRetry,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        boxShadow: [
          BoxShadow(color: t.onSurface.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(AppDimens.spaceXl),
      child: Column(
        children: [
          _ScoreCircle(score: score, total: total),
          const SizedBox(height: AppDimens.spaceLg),
          Text(title, style: AppTextStyles.titleLarge.copyWith(color: t.onSurface)),
          const SizedBox(height: AppDimens.spaceXs),
          Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant)),
          const SizedBox(height: AppDimens.spaceLg),
          _StatsGrid(
            correct: correct,
            missed: missed,
            markedKnown: markedKnown,
            timeSpent: timeSpent,
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l.retry,
                  variant: AppButtonVariant.tonal,
                  fullWidth: true,
                  onPressed: onRetry,
                ),
              ),
              const SizedBox(width: AppDimens.spaceSm),
              Expanded(
                child: AppButton(
                  label: l.nextLesson,
                  fullWidth: true,
                  onPressed: onNext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreCircle extends StatelessWidget {
  final int score;
  final int total;
  const _ScoreCircle({required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [t.primary, t.primaryLight],
        ),
        boxShadow: [
          BoxShadow(
            color: t.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$score/$total',
          style: AppTextStyles.headline.copyWith(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final int correct;
  final int missed;
  final int markedKnown;
  final String timeSpent;

  const _StatsGrid({
    required this.correct,
    required this.missed,
    required this.markedKnown,
    required this.timeSpent,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppDimens.spaceSm,
      crossAxisSpacing: AppDimens.spaceSm,
      childAspectRatio: 2.2,
      children: [
        _StatBox(value: '$correct', label: l.correct, valueColor: t.success),
        _StatBox(value: '$missed', label: l.missed, valueColor: t.error),
        _StatBox(value: '$markedKnown', label: l.markedKnown),
        _StatBox(value: timeSpent, label: l.timeSpent),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;

  const _StatBox({required this.value, required this.label, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Container(
      decoration: BoxDecoration(
        color: t.surfaceContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.headline.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: valueColor ?? t.primary,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXxs),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: t.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
