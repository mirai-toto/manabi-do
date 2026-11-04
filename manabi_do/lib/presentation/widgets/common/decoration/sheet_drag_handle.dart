import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_tokens.dart';

/// The 36×4 pill shown at the top of every bottom sheet. Centred,
/// `outlineVariant` colour, with a bottom margin (`spaceMd`) to separate it
/// from sheet content. Always `const`.
class SheetDragHandle extends StatelessWidget {
  const SheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: context.tokens.outlineVariant,
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        ),
      ),
    );
  }
}
