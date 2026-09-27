import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card;

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../common/indicator/app_spinner.dart';
import '../common/indicator/review_progress_info.dart';

/// Full-width `surfaceContainer` card wrapping `ReviewProgressInfo`. Shows a
/// small `CircularProgressIndicator` while loading; shows SRS state once
/// loaded.
class SrsProgressCard extends StatelessWidget {
  final bool isLoaded;
  final Card? srsCard;

  const SrsProgressCard({
    super.key,
    required this.isLoaded,
    required this.srsCard,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: t.surfaceContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: isLoaded
          ? ReviewProgressInfo(srsCard: srsCard)
          : const Center(child: AppSpinner()),
    );
  }
}
