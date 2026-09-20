import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../widgets.dart';

const int _minPerDay = 0;
const int _maxPerDay = 50;
const int _stepPerDay = 5;

/// Steppers for how many new characters and vocab words to introduce per day.
class PracticeSettingsCard extends StatelessWidget {
  final int newCharactersPerDay;
  final int newVocabPerDay;
  final ValueChanged<int> onNewCharactersChanged;
  final ValueChanged<int> onNewVocabChanged;

  const PracticeSettingsCard({
    super.key,
    required this.newCharactersPerDay,
    required this.newVocabPerDay,
    required this.onNewCharactersChanged,
    required this.onNewVocabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = context.l10n;

    return SettingsCard(
      children: [
        SettingsStepper(
          icon: Icons.auto_stories_rounded,
          label: l.settingsPracticeNewCharacters,
          value: newCharactersPerDay,
          onDecrement: newCharactersPerDay > _minPerDay
              ? () => onNewCharactersChanged(_stepDown(newCharactersPerDay))
              : null,
          onIncrement: newCharactersPerDay < _maxPerDay
              ? () => onNewCharactersChanged(_stepUp(newCharactersPerDay))
              : null,
        ),
        SettingsStepper(
          icon: Icons.translate_rounded,
          label: l.settingsPracticeNewVocab,
          value: newVocabPerDay,
          onDecrement: newVocabPerDay > _minPerDay
              ? () => onNewVocabChanged(_stepDown(newVocabPerDay))
              : null,
          onIncrement: newVocabPerDay < _maxPerDay
              ? () => onNewVocabChanged(_stepUp(newVocabPerDay))
              : null,
        ),
      ],
    );
  }

  static int _stepDown(int value) =>
      (value - _stepPerDay).clamp(_minPerDay, _maxPerDay);

  static int _stepUp(int value) =>
      (value + _stepPerDay).clamp(_minPerDay, _maxPerDay);
}
