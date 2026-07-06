import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../providers/grammar_provider.dart';
import '../../widgets/widgets.dart';
import 'grammar_lesson_screen.dart';

class GrammarLessonListScreen extends StatelessWidget {
  final GrammarChapter chapter;
  final Color levelColor;

  const GrammarLessonListScreen({
    super.key,
    required this.chapter,
    required this.levelColor,
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
          chapter.title,
          style: AppTextStyles.title.copyWith(color: t.onSurface),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        itemCount: chapter.lessons.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppDimens.spaceXs),
        itemBuilder: (context, i) {
          final lesson = chapter.lessons[i];
          return TappableSurface(
            decoration: BoxDecoration(
              color: t.cardBackground,
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              border: Border.all(color: t.outlineVariant),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => GrammarLessonScreen(
                  title: lesson.title,
                  blocks: lesson.blocks,
                  levelColor: levelColor,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.spaceMd,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      lesson.title,
                      style: AppTextStyles.body.copyWith(color: t.onSurface),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: t.onSurfaceVariant),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
