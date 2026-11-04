import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/home_provider.dart';

/// Hides the tab bar for as long as a practice session screen is open.
mixin MarksPracticeActive<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  late final PracticeActiveNotifier _practiceNotifier;

  @override
  void initState() {
    super.initState();
    _practiceNotifier = ref.read(practiceActiveProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _practiceNotifier.setActive(true);
    });
  }

  @override
  void dispose() {
    Future(() => _practiceNotifier.setActive(false));
    super.dispose();
  }
}

/// The session's history button, badged with how many items were answered.
/// Hidden by the caller until something has been answered.
class SessionHistoryButton extends StatelessWidget {
  final int count;
  final Color color;
  final VoidCallback onPressed;

  const SessionHistoryButton({
    super.key,
    required this.count,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return IconButton(
      iconSize: 20,
      tooltip: context.l10n.sessionReview,
      icon: Badge.count(
        count: count,
        backgroundColor: color,
        textColor: onAccentFor(color),
        child: Icon(Icons.history_rounded, color: t.onSurfaceVariant),
      ),
      onPressed: onPressed,
    );
  }
}

/// Opens the in-session settings sheet.
class SessionSettingsButton extends StatelessWidget {
  final WidgetBuilder sheetBuilder;

  const SessionSettingsButton({super.key, required this.sheetBuilder});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 18,
      icon: Icon(Icons.tune_rounded, color: context.tokens.onSurfaceVariant),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: sheetBuilder,
      ),
    );
  }
}
