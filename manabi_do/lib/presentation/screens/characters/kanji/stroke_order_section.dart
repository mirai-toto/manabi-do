import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../data/database/app_database.dart';
import '../../../../l10n/l10n.dart';
import '../../../widgets/widgets.dart';

class StrokeOrderSection extends StatelessWidget {
  final Kanji kanji;
  const StrokeOrderSection({super.key, required this.kanji});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(context.l10n.strokeOrder),
        const SizedBox(height: AppDimens.spaceSm),
        CardContainer(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: StrokeOrderAnimator(kanjiId: kanji.id),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        StrokeStepRow(kanjiId: kanji.id),
      ],
    );
  }
}
