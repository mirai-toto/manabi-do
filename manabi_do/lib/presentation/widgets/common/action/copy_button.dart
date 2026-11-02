import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/l10n.dart';

/// One thing the learner can put on the clipboard.
class CopyChoice {
  final String label;
  final String text;
  const CopyChoice({required this.label, required this.text});
}

/// A bordered copy icon that offers each of [choices] in a dialog.
///
/// Lifted out of the sentence exercise, which had it first and kept it to
/// itself. A sentence is worth copying wherever it appears — to paste into a
/// notes app, a dictionary, a message — so the affordance belongs with the
/// other sentence controls rather than inside one exercise.
///
/// A dialog rather than copying on tap, because there is always more than one
/// thing a person might want: the Japanese or the translation.
class CopyButton extends StatelessWidget {
  final List<CopyChoice> choices;

  const CopyButton({super.key, required this.choices});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return InkWell(
      onTap: () => _show(context, t),
      borderRadius: BorderRadius.circular(AppDimens.radiusXs),
      child: Semantics(
        button: true,
        label: context.l10n.copy,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceTight,
            vertical: AppDimens.spaceXs,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: t.outlineVariant,
              width: AppDimens.borderWidthContainer,
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusXs),
          ),
          child: Icon(Icons.copy_rounded, size: 14, color: t.onSurfaceVariant),
        ),
      ),
    );
  }

  void _show(BuildContext context, AppTokens t) {
    final l = context.l10n;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.copy_rounded, size: 18, color: t.onSurfaceVariant),
            const SizedBox(width: AppDimens.spaceXs),
            Text(
              l.copy,
              style: AppTextStyles.title.copyWith(color: t.onSurface),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(0, AppDimens.spaceSm, 0, 0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final choice in choices)
              _Option(
                choice: choice,
                tokens: t,
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await Clipboard.setData(ClipboardData(text: choice.text));
                },
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.cancel),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final CopyChoice choice;
  final AppTokens tokens;
  final VoidCallback onTap;

  const _Option({
    required this.choice,
    required this.tokens,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceLg,
        vertical: AppDimens.spaceMd,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  choice.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: tokens.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXxs),
                Text(
                  choice.text,
                  style: AppTextStyles.body.copyWith(color: tokens.onSurface),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.copy_rounded, size: 16, color: tokens.onSurfaceVariant),
        ],
      ),
    ),
  );
}
