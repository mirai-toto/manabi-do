import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/grammar_provider.dart';
import '../../services/grammar_session_service.dart';
import '../../widgets/grammar/grammar_block_renderer.dart';
import '../practice/practice_session_screen.dart';

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
    final hasExercises = ref.watch(grammarHasExercisesProvider(lessonId));

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
      floatingActionButton: hasExercises.maybeWhen(
        data: (exists) => exists
            ? FloatingActionButton.extended(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PracticeSessionScreen(
                      title: title,
                      color: levelColor,
                      persistSrs: false,
                      settingsContexts: const {
                        SettingsContext.flashcard,
                        SettingsContext.grammar,
                      },
                      hasExamples: true,
                      loadQueue: (ref) => ref
                          .read(grammarSessionServiceProvider)
                          .buildQueue(
                            lessonPath: lessonId,
                            ref: ref,
                            color: levelColor,
                          ),
                    ),
                  ),
                ),
                icon: const Icon(Icons.school_rounded),
                label: Text(context.l10n.grammarPractice),
                backgroundColor: levelColor,
                foregroundColor: Colors.white,
              )
            : null,
        orElse: () => null,
      ),
    );
  }
}
