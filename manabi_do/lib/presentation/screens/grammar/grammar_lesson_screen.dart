import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/grammar/grammar_models.dart';
import '../../widgets/grammar/grammar_block_renderer.dart';

class GrammarLessonScreen extends StatelessWidget {
  final String title;
  final List<GrammarBlock> blocks;
  final Color levelColor;

  const GrammarLessonScreen({
    super.key,
    required this.title,
    required this.blocks,
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
      body: GrammarBlockRenderer(blocks: blocks, levelColor: levelColor),
    );
  }
}
