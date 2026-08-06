import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card;

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../common/review_progress_info.dart';

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
          : const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
    );
  }
}
