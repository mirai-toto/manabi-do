import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/app_emoji.dart';

class SessionSummary extends StatelessWidget {
  final int gotIt;
  final int notYet;
  final Color color;
  final VoidCallback onDone;

  const SessionSummary({
    super.key,
    required this.gotIt,
    required this.notYet,
    required this.color,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final total = gotIt + notYet;

    if (total == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppEmoji('🎉', size: 56),
              const SizedBox(height: AppDimens.spaceMd),
              Text(l.practiceEmpty,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(color: t.onSurfaceVariant)),
              const SizedBox(height: AppDimens.spaceLg),
              _DoneButton(onDone: onDone, color: color, label: l.practiceDone),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppEmoji('🎉', size: 56),
            const SizedBox(height: AppDimens.spaceMd),
            Text(l.practiceSessionDone, style: AppTextStyles.title.copyWith(color: t.onSurface)),
            const SizedBox(height: AppDimens.spaceLg),
            _StatRow(icon: Icons.check_circle_rounded, color: t.success, label: l.practiceGotIt(gotIt)),
            const SizedBox(height: AppDimens.spaceSm),
            _StatRow(icon: Icons.cancel_rounded, color: t.error, label: l.practiceNotYet(notYet)),
            const SizedBox(height: AppDimens.spaceLg),
            _DoneButton(onDone: onDone, color: color, label: l.practiceDone),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  const _StatRow({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(width: AppDimens.spaceSm),
      Text(label, style: AppTextStyles.body.copyWith(color: color, fontWeight: FontWeight.w600)),
    ],
  );
}

class _DoneButton extends StatelessWidget {
  final VoidCallback onDone;
  final Color color;
  final String label;
  const _DoneButton({required this.onDone, required this.color, required this.label});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: onDone,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusMd)),
      ),
      child: Text(label, style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
    ),
  );
}
