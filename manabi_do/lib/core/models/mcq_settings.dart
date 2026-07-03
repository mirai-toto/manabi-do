class McqSettings {
  final int? sessionLength;
  final int mcqChoiceCount;
  final bool autoAdvance;
  final bool showPromptFurigana;

  const McqSettings({
    this.sessionLength = 20,
    this.mcqChoiceCount = 4,
    this.autoAdvance = false,
    this.showPromptFurigana = true,
  });

  static const defaults = McqSettings();

  McqSettings copyWith({
    int? sessionLength,
    bool clearSessionLength = false,
    int? mcqChoiceCount,
    bool? autoAdvance,
    bool? showPromptFurigana,
  }) => McqSettings(
    sessionLength: clearSessionLength
        ? null
        : sessionLength ?? this.sessionLength,
    mcqChoiceCount: mcqChoiceCount ?? this.mcqChoiceCount,
    autoAdvance: autoAdvance ?? this.autoAdvance,
    showPromptFurigana: showPromptFurigana ?? this.showPromptFurigana,
  );

  Map<String, dynamic> toJson() => {
    'sessionLength': sessionLength,
    'mcqChoiceCount': mcqChoiceCount,
    'autoAdvance': autoAdvance,
    'showPromptFurigana': showPromptFurigana,
  };

  factory McqSettings.fromJson(Map<String, dynamic> json) => McqSettings(
    sessionLength: json['sessionLength'] as int?,
    mcqChoiceCount: json['mcqChoiceCount'] as int? ?? 4,
    autoAdvance: json['autoAdvance'] as bool? ?? false,
    showPromptFurigana: json['showPromptFurigana'] as bool? ?? true,
  );
}
