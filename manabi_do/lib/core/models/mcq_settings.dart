class McqSettings {
  final int? sessionLength;
  final int mcqChoiceCount;
  final bool autoAdvance;

  const McqSettings({
    this.sessionLength = 20,
    this.mcqChoiceCount = 4,
    this.autoAdvance = false,
  });

  static const defaults = McqSettings();

  McqSettings copyWith({
    int? sessionLength,
    bool clearSessionLength = false,
    int? mcqChoiceCount,
    bool? autoAdvance,
  }) => McqSettings(
    sessionLength: clearSessionLength
        ? null
        : sessionLength ?? this.sessionLength,
    mcqChoiceCount: mcqChoiceCount ?? this.mcqChoiceCount,
    autoAdvance: autoAdvance ?? this.autoAdvance,
  );

  Map<String, dynamic> toJson() => {
    'sessionLength': sessionLength,
    'mcqChoiceCount': mcqChoiceCount,
    'autoAdvance': autoAdvance,
  };

  factory McqSettings.fromJson(Map<String, dynamic> json) => McqSettings(
    sessionLength: json['sessionLength'] as int?,
    mcqChoiceCount: json['mcqChoiceCount'] as int? ?? 4,
    autoAdvance: json['autoAdvance'] as bool? ?? false,
  );
}
