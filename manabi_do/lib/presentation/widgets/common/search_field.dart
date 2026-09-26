import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import 'app_text_field.dart';

/// How long typing has to settle before the query is reported.
const Duration _debounce = Duration(milliseconds: 250);

/// A search box that reports its query once typing pauses.
///
/// Reporting every keystroke made typing stutter: each letter scanned the whole
/// table, ranked every match, and rebuilt the result list, so the work piled up
/// faster than the frames. Clearing reports immediately — there is nothing to
/// wait for.
///
/// [onChanged] receives the trimmed query, `''` when the box is empty.
class SearchField extends StatefulWidget {
  final String label;
  final String hint;
  final ValueChanged<String> onChanged;

  const SearchField({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _controller = TextEditingController();
  Timer? _timer;
  bool _hasText = false;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTyped(String text) {
    final hasText = text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
    _timer?.cancel();
    _timer = Timer(_debounce, () => widget.onChanged(text.trim()));
  }

  void _clear() {
    _timer?.cancel();
    _controller.clear();
    setState(() => _hasText = false);
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return AppTextField(
      label: widget.label,
      hint: widget.hint,
      controller: _controller,
      onChanged: _onTyped,
      prefixIcon: Icon(Icons.search_rounded, color: t.onSurfaceVariant),
      suffixIcon: _hasText
          ? IconButton(icon: const Icon(Icons.clear), onPressed: _clear)
          : null,
    );
  }
}

/// Whether [query] is worth searching for.
///
/// A single latin letter matches most of the dictionary and answers nothing, so
/// it waits for a second character. A single kanji or kana is a real query and
/// searches straight away.
bool isSearchableQuery(String query) =>
    query.length >= 2 || query.codeUnits.any((unit) => unit > 0x7F);
