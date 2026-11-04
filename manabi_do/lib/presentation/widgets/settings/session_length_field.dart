import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../l10n/l10n.dart';
import '../common/input/segmented_control.dart';
import 'settings_field_text.dart';

/// How many questions a session runs for. `null` is "no limit".
class SessionLengthField extends StatelessWidget {
  final int? value;
  final void Function(int?) onSelect;

  const SessionLengthField({
    super.key,
    required this.value,
    required this.onSelect,
  });

  static const List<int?> _lengths = [10, 20, 50, null];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsFieldLabel(l.practiceSettingsSessionLength),
        const SizedBox(height: AppDimens.spaceXs),
        SegmentedControl(
          options: const ['10', '20', '50', '∞'],
          selected: switch (value) {
            10 => 0,
            20 => 1,
            50 => 2,
            _ => value == null ? 3 : 1,
          },
          onSelect: (i) => onSelect(_lengths[i]),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        SettingsFieldHint(l.sessionLengthHint),
      ],
    );
  }
}
