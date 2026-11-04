import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

/// The small label above a segmented field.
class SettingsFieldLabel extends StatelessWidget {
  final String text;
  const SettingsFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppTextStyles.labelSmall.copyWith(
      color: context.tokens.onSurfaceVariant,
    ),
  );
}

/// The explanatory line under a segmented field.
class SettingsFieldHint extends StatelessWidget {
  final String text;
  const SettingsFieldHint(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppTextStyles.bodySmall.copyWith(
      color: context.tokens.onSurfaceVariant,
    ),
  );
}
