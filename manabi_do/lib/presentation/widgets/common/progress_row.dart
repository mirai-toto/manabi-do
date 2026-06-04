import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import 'progress_bar.dart';

class ProgressRow extends StatelessWidget {
  final int known;
  final int total;
  final Color? color;

  const ProgressRow({super.key, required this.known, required this.total, this.color});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMd, AppDimens.spaceSm, AppDimens.spaceMd, AppDimens.spaceMd,
      ),
      child: Row(
        children: [
          Text(
            context.l10n.knownProgress(known, total),
            style: AppTextStyles.labelLarge.copyWith(color: t.onSurface),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(
            child: AppProgressBar(
              progress: total > 0 ? known / total : 0,
              color: color ?? t.primary,
            ),
          ),
        ],
      ),
    );
  }
}
