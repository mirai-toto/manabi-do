import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/grammar/grammar_models.dart';
import '../../widgets/grammar/grammar_block_renderer.dart';
import '../../widgets/grammar/grammar_markdown_sheet.dart';

class GrammarLessonScreen extends StatelessWidget {
  final String title;

  // Markdown path (N5 and other non-migrated levels).
  final String content;

  // JSON block path (basics and future migrated levels).
  final List<GrammarBlock>? blocks;
  final Color levelColor;

  const GrammarLessonScreen({
    super.key,
    required this.title,
    this.content = '',
    this.blocks,
    this.levelColor = const Color(0xFF795548),
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Scaffold(
      backgroundColor: t.surface,
      appBar: AppBar(
        backgroundColor: t.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: t.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: AppTextStyles.title.copyWith(color: t.onSurface),
        ),
      ),
      body: blocks != null
          ? GrammarBlockRenderer(blocks: blocks!, levelColor: levelColor)
          : Markdown(
              data: content,
              styleSheet: grammarMarkdownSheet(context),
              extensionSet: md.ExtensionSet.gitHubFlavored,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.spaceMd,
              ),
            ),
    );
  }
}
