import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../action/app_filter_chip.dart';

/// A row of chips that narrows a list of results.
///
/// Nothing selected means every option, which is what an empty filter should do
/// and saves an "All" chip that would only ever undo the others.
///
/// Wraps rather than scrolls: five short labels fit one line on a phone and two
/// on nothing, so a horizontal scroller would hide options for no gain.
///
/// Generic over the option, because kanji filter by JLPT level — a string — and
/// words by vocabulary level — a number. One bar with a label function rather
/// than two that drift apart.
class FilterChipBar<T> extends StatelessWidget {
  final List<T> options;
  final Set<T> selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onToggle;

  const FilterChipBar({
    super.key,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppDimens.spaceSm,
    runSpacing: AppDimens.spaceSm,
    children: [
      for (final option in options)
        AppFilterChip(
          label: labelOf(option),
          isActive: selected.contains(option),
          onTap: () => onToggle(option),
        ),
    ],
  );
}
