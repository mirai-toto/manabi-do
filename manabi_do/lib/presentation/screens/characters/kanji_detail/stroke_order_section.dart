import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/database/app_database.dart';
import '../../../../l10n/l10n.dart';
import '../../../widgets/widgets.dart';

class StrokeOrderSection extends StatelessWidget {
  final Kanji kanji;
  const StrokeOrderSection({super.key, required this.kanji});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(context.l10n.strokeOrder),
        const SizedBox(height: AppDimens.spaceSm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          decoration: BoxDecoration(
            color: t.cardBackground,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: Border.all(color: t.outlineVariant),
          ),
          child: StrokeOrderAnimator(kanjiId: kanji.id),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        StrokeStepRow(kanjiId: kanji.id),
      ],
    );
  }
}
