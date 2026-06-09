import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

MarkdownStyleSheet grammarMarkdownSheet(BuildContext context) {
  final t = context.tokens;
  return MarkdownStyleSheet(
    h1: AppTextStyles.headline.copyWith(color: t.onSurface),
    h2: AppTextStyles.title.copyWith(color: t.onSurface),
    h3: AppTextStyles.labelLarge.copyWith(color: t.onSurface),
    p: AppTextStyles.body.copyWith(color: t.onSurface),
    listBullet: AppTextStyles.body.copyWith(color: t.onSurfaceVariant),
    strong: AppTextStyles.body.copyWith(color: t.onSurface, fontWeight: FontWeight.w600),
    em: AppTextStyles.body.copyWith(color: t.onSurface, fontStyle: FontStyle.italic),
    code: AppTextStyles.bodySmall.copyWith(
      fontFamily: 'monospace',
      color: t.onSurface,
      backgroundColor: t.surfaceVariant,
    ),
    codeblockDecoration: BoxDecoration(
      color: t.surfaceVariant,
      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
    ),
    blockquote: AppTextStyles.body.copyWith(color: t.onSurfaceVariant),
    blockquoteDecoration: BoxDecoration(
      color: t.surfaceVariant,
      border: Border(left: BorderSide(color: t.outlineVariant, width: 3)),
    ),
    horizontalRuleDecoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: t.outlineVariant)),
    ),
    blockSpacing: AppDimens.spaceSm,
    listIndent: AppDimens.spaceLg,
  );
}
