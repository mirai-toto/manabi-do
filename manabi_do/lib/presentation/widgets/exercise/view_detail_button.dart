import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../common/action/app_button.dart';

/// The quiet text button that opens the detail screen of the item being
/// practised. A preset of `AppButton`, not a second button engine.
class ViewDetailButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const ViewDetailButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      icon: const Icon(Icons.open_in_new_rounded, size: 16),
      variant: AppButtonVariant.text,
      foregroundColor: context.tokens.onSurfaceVariant,
      onPressed: onPressed,
    );
  }
}
