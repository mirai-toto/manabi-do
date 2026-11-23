import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/widgets.dart';

class PracticeMode {
  final IconData icon;
  final String title;
  final Future<void> Function() onTap;

  PracticeMode({required this.icon, required this.title, required this.onTap});
}

class PracticeSelectionScreen extends StatelessWidget {
  final String title;
  final Color color;
  final List<PracticeMode> modes;

  const PracticeSelectionScreen({
    super.key,
    required this.title,
    required this.color,
    required this.modes,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Scaffold(
      backgroundColor: t.surface,
      appBar: AppBar(
        backgroundColor: t.surface,
        title: Text(
          title,
          style: AppTextStyles.title.copyWith(color: t.onSurface),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Said up front: a learner expecting this to count toward their
            // reviews would otherwise only find out on the summary.
            Text(
              context.l10n.practiceNotRecordedNote,
              style: AppTextStyles.bodySmall.copyWith(
                color: t.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimens.spaceMd),
            for (int i = 0; i < modes.length; i++) ...[
              if (i > 0) const SizedBox(height: AppDimens.spaceMd),
              PracticeModeCard(
                title: modes[i].title,
                icon: modes[i].icon,
                color: color,
                onTap: modes[i].onTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
