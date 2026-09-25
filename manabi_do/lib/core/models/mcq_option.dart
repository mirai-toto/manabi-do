/// One choice in a multiple-choice question.
///
/// Plain data, so a session service can build the choices without importing
/// any widget code. `McqCard` decides how each [McqOptionState] is drawn.
enum McqOptionState { idle, selected, correct, wrong }

class McqOption {
  final String letter;
  final String text;
  final String? reading;
  final McqOptionState state;

  /// Japanese text needs the Japanese font; romaji and translations do not.
  final bool useJpFont;

  const McqOption({
    required this.letter,
    required this.text,
    this.reading,
    this.state = McqOptionState.idle,
    this.useJpFont = false,
  });

  McqOption copyWith({McqOptionState? state}) => McqOption(
    letter: letter,
    text: text,
    reading: reading,
    state: state ?? this.state,
    useJpFont: useJpFont,
  );
}
