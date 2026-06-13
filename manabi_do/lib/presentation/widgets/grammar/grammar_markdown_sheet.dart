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
    h1Padding: const EdgeInsets.only(top: AppDimens.spaceLg, bottom: AppDimens.spaceSm),
    h2Padding: const EdgeInsets.only(top: AppDimens.spaceLg, bottom: AppDimens.spaceSm),
    h3Padding: const EdgeInsets.only(top: AppDimens.spaceMd, bottom: AppDimens.spaceXs),
    p: AppTextStyles.body.copyWith(color: t.onSurface, height: 1.6),
    listBullet: AppTextStyles.body.copyWith(color: t.onSurfaceVariant, height: 1.6),
    strong: AppTextStyles.body.copyWith(color: t.onSurface, fontWeight: FontWeight.w600, height: 1.6),
    em: AppTextStyles.body.copyWith(color: t.onSurface, fontStyle: FontStyle.italic, height: 1.6),
    code: AppTextStyles.bodySmall.copyWith(
      fontFamily: 'monospace',
      color: t.onSurface,
      backgroundColor: t.surfaceVariant,
    ),
    codeblockDecoration: BoxDecoration(
      color: t.surfaceVariant,
      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
    ),
    codeblockPadding: const EdgeInsets.all(AppDimens.spaceMd),
    blockquote: AppTextStyles.body.copyWith(color: t.onSurfaceVariant, height: 1.6),
    blockquoteDecoration: BoxDecoration(
      color: t.surfaceVariant,
      border: Border(left: BorderSide(color: t.outlineVariant, width: 3)),
    ),
    blockquotePadding: const EdgeInsets.symmetric(
      horizontal: AppDimens.spaceMd,
      vertical: AppDimens.spaceSm,
    ),
    horizontalRuleDecoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: t.outlineVariant)),
    ),
    tableHead: AppTextStyles.bodySmall.copyWith(
      color: t.onSurface,
      fontWeight: FontWeight.w600,
    ),
    tableBody: AppTextStyles.body.copyWith(color: t.onSurface, height: 1.5),
    tableHeadAlign: TextAlign.left,
    tableBorder: TableBorder.all(color: t.outlineVariant, width: 1),
    tableCellsDecoration: BoxDecoration(color: t.cardBackground),
    tablePadding: const EdgeInsets.symmetric(
      horizontal: AppDimens.spaceSm,
      vertical: AppDimens.spaceSm,
    ),
    blockSpacing: AppDimens.spaceMd,
    listIndent: AppDimens.spaceLg,
  );
}
