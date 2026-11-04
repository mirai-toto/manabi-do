import 'package:flutter/widgets.dart';
import 'package:fsrs/fsrs.dart' show Rating;

import '../../../core/models/mcq_option.dart';
import '../../../core/models/practice_answer.dart';

/// The answer flow shared by exercises that pick one of several options.
///
/// A tap marks the pick, and the right answer as well when the pick was
/// wrong. With auto-advance the answer is graded from the pick after a short
/// beat; otherwise the body shows its self-assessment and reports [given].
mixin ChoiceAnswer<T extends StatefulWidget> on State<T> {
  List<McqOptionState> _states = const [];
  bool answered = false;
  bool autoAdvancing = false;

  /// Kept so the self-assessment path reports the choice too, not just the
  /// auto-advance one.
  String? given;

  /// [options] with the state each one is drawn in.
  List<McqOption> withAnswerStates(List<McqOption> options) => [
    for (int i = 0; i < options.length; i++)
      options[i].copyWith(
        state: i < _states.length ? _states[i] : McqOptionState.idle,
      ),
  ];

  void answerChoice(
    int i, {
    required List<McqOption> options,
    required int correctIndex,
    required bool autoAdvance,
    required AnswerCallback onAnswer,
  }) {
    if (answered) return;
    final bool isCorrect = i == correctIndex;
    setState(() {
      answered = true;
      autoAdvancing = autoAdvance;
      given = options[i].text;
      _states = List.generate(options.length, (j) {
        if (j == i) {
          return isCorrect ? McqOptionState.correct : McqOptionState.wrong;
        }
        if (!isCorrect && j == correctIndex) return McqOptionState.correct;
        return McqOptionState.idle;
      });
    });
    if (autoAdvance) {
      Future<void>.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          onAnswer(isCorrect ? Rating.good : Rating.again, given: given);
        }
      });
    }
  }
}
