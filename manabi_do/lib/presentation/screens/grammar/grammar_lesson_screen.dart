import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/accent_theme.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../providers/database_provider.dart';
import '../../providers/grammar_provider.dart';
import '../../widgets/grammar/grammar_block_renderer.dart';
import '../../widgets/widgets.dart';

class GrammarLessonScreen extends ConsumerWidget {
  final String lessonId;
  final String title;
  final List<GrammarBlock> blocks;
  final Color levelColor;

  const GrammarLessonScreen({
    super.key,
    required this.lessonId,
    required this.title,
    required this.blocks,
    this.levelColor = const Color(0xFF795548),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final readLessons =
        ref.watch(grammarReadLessonsProvider).asData?.value ?? {};
    final isRead = readLessons.contains(lessonId);
    final db = ref.read(databaseProvider);

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
      body: AccentTheme(
        accent: levelColor,
        child: ScrollFade(
          builder: (controller) => GrammarBlockRenderer(
            blocks: blocks,
            levelColor: levelColor,
            controller: controller,
            trailing: LessonReadToggle(
              isRead: isRead,
              onTap: () {
                if (isRead) {
                  db.unmarkGrammarLessonRead(lessonId);
                } else {
                  db.markGrammarLessonRead(lessonId);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
