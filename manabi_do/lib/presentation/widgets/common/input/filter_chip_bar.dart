import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../action/app_filter_chip.dart';

/// A row of chips that narrows a list of results.
///
/// Nothing selected means every option, which is what an empty filter should do
/// and saves an "All" chip that would only ever undo the others.
///
/// Scrolls on one line rather than wrapping: the five commonness labels took two
/// lines even on a Pixel 10 Pro XL, pushing the results down by a whole row.
/// The bar pads itself, so chips scroll to the screen edge instead of being
/// cut at the margin.
///
/// Generic over the option, because kanji filter by JLPT level — a string — and
/// words by vocabulary level — a number. One bar with a label function rather
/// than two that drift apart.
class FilterChipBar<T> extends StatelessWidget {
  final List<T> options;
  final Set<T> selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onToggle;

  /// Space before the first chip and after the last.
  final double horizontalPadding;

  const FilterChipBar({
    super.key,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onToggle,
    this.horizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
    child: Row(
      spacing: AppDimens.spaceSm,
      children: [
        for (final option in options)
          AppFilterChip(
            label: labelOf(option),
            isActive: selected.contains(option),
            onTap: () => onToggle(option),
          ),
      ],
    ),
  );
}
