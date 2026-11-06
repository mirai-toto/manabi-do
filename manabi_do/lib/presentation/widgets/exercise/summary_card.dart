import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../../core/theme/app_motion.dart';
import '../common/action/app_button.dart';
import '../common/decoration/fade_slide_in.dart';
import '../common/indicator/animated_count.dart';

/// End-of-session results card. Shows score, correct/missed counts, time spent,
/// and retry/next actions.
class SummaryCard extends StatelessWidget {
  final int score;
  final int total;
  final String title;
  final String subtitle;
  final int correct;
  final int missed;
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
          BoxShadow(
            color: t.onSurface.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppDimens.spaceXl),
      child: Column(
        children: [
          _ScoreCircle(score: score, total: total),
          const SizedBox(height: AppDimens.spaceLg),
          FadeSlideIn(
            order: 2,
            child: Column(
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleLarge.copyWith(color: t.onSurface),
                ),
                const SizedBox(height: AppDimens.spaceXs),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: t.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          FadeSlideIn(
            order: 4,
            child: _StatsGrid(
              correct: correct,
              missed: missed,
              timeSpent: timeSpent,
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          FadeSlideIn(
            order: 6,
            child: Row(
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
          ),
        ],
      ),
    );
  }
}

/// The score, arriving as the session's small celebration: the circle pops in
/// with a slight overshoot, a ring ripples out from it once, and the score
/// counts up.
class _ScoreCircle extends StatefulWidget {
  final int score;
  final int total;
  const _ScoreCircle({required this.score, required this.total});

  static const double _size = 100;

  /// How far past the circle the ripple spreads before it fades out.
  static const double _rippleSpread = 1.6;

  @override
  State<_ScoreCircle> createState() => _ScoreCircleState();
}

class _ScoreCircleState extends State<_ScoreCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.long * 2,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.status != AnimationStatus.dismissed) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    const double size = _ScoreCircle._size;
    final Animation<double> pop = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.6, curve: AppMotion.pop),
    );
    final Animation<double> ripple = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 1, curve: AppMotion.enter),
    );

    final Widget circle = Container(
      width: size,
      height: size,
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
        child: AnimatedCount(
          value: widget.score,
          format: (n) => '$n/${widget.total}',
          style: AppTextStyles.headlineLarge.copyWith(
            color: t.onPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _controller,
        child: circle,
        builder: (context, child) => Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (ripple.value > 0 && ripple.value < 1)
              Transform.scale(
                scale: 1 + (_ScoreCircle._rippleSpread - 1) * ripple.value,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: t.primary.withValues(
                        alpha: 0.5 * (1 - ripple.value),
                      ),
                      width: 3,
                    ),
                  ),
                ),
              ),
            Transform.scale(scale: 0.6 + 0.4 * pop.value, child: child),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final int correct;
  final int missed;
  final String timeSpent;

  const _StatsGrid({
    required this.correct,
    required this.missed,
    required this.timeSpent,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    final boxes = [
      _StatBox(value: '$correct', label: l.correct, valueColor: t.success),
      _StatBox(value: '$missed', label: l.missed, valueColor: t.error),
      _StatBox(value: timeSpent, label: l.timeSpent),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppDimens.spaceSm,
      crossAxisSpacing: AppDimens.spaceSm,
      childAspectRatio: 2.2,
      children: boxes,
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
            style: AppTextStyles.headlineLarge.copyWith(
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
