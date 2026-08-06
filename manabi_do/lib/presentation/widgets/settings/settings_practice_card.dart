import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/srs_settings_provider.dart';
import '../../../l10n/l10n.dart';
import '../widgets.dart';

class SettingsPracticeCard extends ConsumerWidget {
  const SettingsPracticeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final srs = ref.watch(srsSettingsProvider);
    final newChars = srs.asData?.value.newCharactersPerDay ?? 10;
    final newVocab = srs.asData?.value.newVocabPerDay ?? 10;

    return SettingsCard(
      children: [
        SettingsStepper(
          icon: Icons.auto_stories_rounded,
          label: l.settingsPracticeNewCharacters,
          value: newChars,
          onDecrement: newChars > 0
              ? () => ref
                    .read(srsSettingsProvider.notifier)
                    .setNewCharactersPerDay((newChars - 5).clamp(0, 50))
              : null,
          onIncrement: newChars < 50
              ? () => ref
                    .read(srsSettingsProvider.notifier)
                    .setNewCharactersPerDay(newChars + 5)
              : null,
        ),
        SettingsStepper(
          icon: Icons.translate_rounded,
          label: l.settingsPracticeNewVocab,
          value: newVocab,
          onDecrement: newVocab > 0
              ? () => ref
                    .read(srsSettingsProvider.notifier)
                    .setNewVocabPerDay((newVocab - 5).clamp(0, 50))
              : null,
          onIncrement: newVocab < 50
              ? () => ref
                    .read(srsSettingsProvider.notifier)
                    .setNewVocabPerDay(newVocab + 5)
              : null,
        ),
      ],
    );
  }
}
