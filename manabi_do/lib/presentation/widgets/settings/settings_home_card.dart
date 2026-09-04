import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/home_settings_provider.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../widgets.dart';

/// Toggles for which decks appear on the home screen.
class SettingsHomeCard extends ConsumerWidget {
  const SettingsHomeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.tokens;
    final settings =
        ref.watch(homeSettingsProvider).asData?.value ?? const HomeSettings();
    final notifier = ref.read(homeSettingsProvider.notifier);

    Widget glyph(String char) => SizedBox(
      width: 20,
      child: Text(
        char,
        textAlign: TextAlign.center,
        style: AppTextStyles.jpBody.copyWith(color: t.onSurfaceVariant),
      ),
    );

    return SettingsCard(
      children: [
        SettingsToggle(
          leading: glyph('か'),
          label: l.kana,
          value: settings.showKana,
          onChanged: notifier.setShowKana,
        ),
        SettingsToggle(
          leading: glyph('字'),
          label: l.tabKanji,
          value: settings.showKanji,
          onChanged: notifier.setShowKanji,
        ),
        SettingsToggle(
          leading: glyph('語'),
          label: l.sectionVocabulary,
          value: settings.showVocab,
          onChanged: notifier.setShowVocab,
        ),
      ],
    );
  }
}
