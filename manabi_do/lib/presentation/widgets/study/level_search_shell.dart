import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../common/input/filter_chip_bar.dart';
import '../common/input/search_field.dart';

/// A pinned search field over a level list. Typing swaps the list for
/// [results], with chips to narrow them to some levels. Shared by the kanji
/// and vocabulary sections.
class LevelSearchShell<T> extends StatefulWidget {
  final String searchLabel;
  final String searchHint;
  final List<T> filterOptions;
  final String Function(T) filterLabelOf;

  /// Shown while there is no query.
  final Widget levels;

  /// The matches for a query, narrowed to the chosen levels (none = all).
  final Widget Function(String query, Set<T> filter) results;

  const LevelSearchShell({
    super.key,
    required this.searchLabel,
    required this.searchHint,
    required this.filterOptions,
    required this.filterLabelOf,
    required this.levels,
    required this.results,
  });

  @override
  State<LevelSearchShell<T>> createState() => _LevelSearchShellState<T>();
}

class _LevelSearchShellState<T> extends State<LevelSearchShell<T>> {
  String _query = '';
  final Set<T> _filter = <T>{};

  @override
  Widget build(BuildContext context) {
    final bool searching = isSearchableQuery(_query);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sits outside the scrollables below, so switching between the level
        // list and results never rebuilds the field or drops the keyboard.
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceMd,
            AppDimens.spaceMd,
            AppDimens.spaceMd,
            AppDimens.spaceSm,
          ),
          child: SearchField(
            label: widget.searchLabel,
            hint: widget.searchHint,
            onChanged: (query) => setState(() => _query = query),
          ),
        ),
        // Only while searching: without a query the level list below already
        // is the level picker, and two ways to do one thing reads as a bug.
        if (searching)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spaceMd,
              0,
              AppDimens.spaceMd,
              AppDimens.spaceSm,
            ),
            child: FilterChipBar<T>(
              options: widget.filterOptions,
              selected: _filter,
              labelOf: widget.filterLabelOf,
              onToggle: (level) => setState(
                () => _filter.contains(level)
                    ? _filter.remove(level)
                    : _filter.add(level),
              ),
            ),
          ),
        Expanded(
          child: searching ? widget.results(_query, _filter) : widget.levels,
        ),
      ],
    );
  }
}

/// The message in place of search results when nothing matched.
class SearchNoResults extends StatelessWidget {
  final String message;

  const SearchNoResults({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTextStyles.body.copyWith(
          color: context.tokens.onSurfaceVariant,
        ),
      ),
    );
  }
}
