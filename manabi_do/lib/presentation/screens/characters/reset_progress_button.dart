import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../services/srs_service.dart';
import '../../widgets/widgets.dart';

/// Clears one character's SRS progress after asking. Used by the kana and
/// kanji detail screens, which show it once the character has a card.
class ResetProgressButton extends ConsumerWidget {
  final String srsType;
  final int id;
  final String confirmTitle;

  const ResetProgressButton({
    super.key,
    required this.srsType,
    required this.id,
    required this.confirmTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.tokens;
    return AppButton(
      label: l.resetCharacterProgress,
      icon: Icon(Icons.restart_alt_rounded, size: 18, color: t.error),
      variant: AppButtonVariant.text,
      foregroundColor: t.error,
      fullWidth: true,
      onPressed: () async {
        final confirmed = await showConfirmDialog(
          context,
          title: confirmTitle,
          body: l.resetKanaBody,
        );
        if (!confirmed) return;
        await ref.read(srsServiceProvider).resetCard(srsType, id);
      },
    );
  }
}
