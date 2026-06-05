import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
}) async {
  final l = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l.resetConfirm, style: TextStyle(color: ctx.tokens.error)),
        ),
      ],
    ),
  );
  return result == true;
}
