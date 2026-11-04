import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../l10n/l10n.dart';
import '../common/input/segmented_control.dart';
import 'settings_field_text.dart';

/// How many options a multiple-choice question offers.
class ChoiceCountField extends StatelessWidget {
  final int value;
  final void Function(int) onSelect;

  const ChoiceCountField({
    super.key,
    required this.value,
    required this.onSelect,
  });

  static const List<int> _counts = [4, 6, 8];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsFieldLabel(l.practiceSettingsMcqChoices),
        const SizedBox(height: AppDimens.spaceXs),
        SegmentedControl(
          options: const ['4', '6', '8'],
          selected: switch (value) {
            6 => 1,
            8 => 2,
            _ => 0,
          },
          onSelect: (i) => onSelect(_counts[i]),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        SettingsFieldHint(l.sessionLengthHint),
      ],
    );
  }
}
