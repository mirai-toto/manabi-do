import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../widgets.dart';

const int _minPerDay = 0;
const int _maxPerDay = 50;
const int _stepPerDay = 5;

/// Steppers for how many new characters and vocabulary words to introduce per day.
class PracticeSettingsCard extends StatelessWidget {
  final int newCharactersPerDay;
  final int newVocabularyPerDay;
  final ValueChanged<int> onNewCharactersChanged;
  final ValueChanged<int> onNewVocabularyChanged;

  const PracticeSettingsCard({
    super.key,
    required this.newCharactersPerDay,
    required this.newVocabularyPerDay,
    required this.onNewCharactersChanged,
    required this.onNewVocabularyChanged,
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
          label: l.settingsPracticeNewVocabulary,
          value: newVocabularyPerDay,
          onDecrement: newVocabularyPerDay > _minPerDay
              ? () => onNewVocabularyChanged(_stepDown(newVocabularyPerDay))
              : null,
          onIncrement: newVocabularyPerDay < _maxPerDay
              ? () => onNewVocabularyChanged(_stepUp(newVocabularyPerDay))
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
