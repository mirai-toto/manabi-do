import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../action/app_filter_chip.dart';

/// A row of level chips that narrows a list of results.
///
/// Nothing selected means every level, which is what an empty filter should do
/// and saves an "All" chip that would only ever undo the others.
///
/// Wraps rather than scrolls: five short codes fit one line on a phone and two
/// on nothing, so a horizontal scroller would hide options for no gain.
class LevelFilterBar extends StatelessWidget {
  final List<String> levels;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const LevelFilterBar({
    super.key,
    required this.levels,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppDimens.spaceSm,
    runSpacing: AppDimens.spaceSm,
    children: [
      for (final level in levels)
        AppFilterChip(
          label: level,
          isActive: selected.contains(level),
          onTap: () => onToggle(level),
        ),
    ],
  );
}
