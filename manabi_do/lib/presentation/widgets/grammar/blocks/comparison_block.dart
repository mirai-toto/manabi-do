import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../common/card_container.dart';
import '../../common/japanese_text.dart';
import '../../common/pill_badge.dart';

class ComparisonSide {
  final String label;
  final String description;
  final String exampleJp;
  final String exampleEn;

  const ComparisonSide({
    required this.label,
    required this.description,
    required this.exampleJp,
    required this.exampleEn,
  });
}

class ComparisonBlock extends StatelessWidget {
  final ComparisonSide left;
  final ComparisonSide right;
  final Color? accentColor;

  const ComparisonBlock({
    super.key,
    required this.left,
    required this.right,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 380;
        if (stacked) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SideCard(side: left, accentColor: accentColor),
              const SizedBox(height: AppDimens.spaceSm),
              _SideCard(side: right, accentColor: accentColor),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: _SideCard(side: left, accentColor: accentColor),
            ),
            const SizedBox(width: AppDimens.spaceSm),
            Flexible(
              child: _SideCard(side: right, accentColor: accentColor),
            ),
          ],
        );
      },
    );
  }
}

class _SideCard extends StatelessWidget {
  final ComparisonSide side;
  final Color? accentColor;
  const _SideCard({required this.side, this.accentColor});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return CardContainer(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PillBadge(
            label: side.label,
            color: Colors.white,
            background: accentColor ?? t.primary,
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Text(
            side.description,
            style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          JapaneseText(
            word: side.exampleJp,
            reading: '',
            style: AppTextStyles.jpBody.copyWith(color: t.onSurface),
          ),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            side.exampleEn,
            style: AppTextStyles.bodySmall.copyWith(
              color: t.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
