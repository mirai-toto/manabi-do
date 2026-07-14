class FlashcardSettings {
  final int? sessionLength;
  final bool showExample;

  const FlashcardSettings({this.sessionLength = 20, this.showExample = true});

  static const defaults = FlashcardSettings();

  FlashcardSettings copyWith({
    int? sessionLength,
    bool clearSessionLength = false,
    bool? showExample,
  }) => FlashcardSettings(
    sessionLength: clearSessionLength
        ? null
        : sessionLength ?? this.sessionLength,
    showExample: showExample ?? this.showExample,
  );

  Map<String, dynamic> toJson() => {
    'sessionLength': sessionLength,
    'showExample': showExample,
  };

  factory FlashcardSettings.fromJson(Map<String, dynamic> json) =>
      FlashcardSettings(
        sessionLength: json['sessionLength'] as int?,
        showExample: json['showExample'] as bool? ?? true,
      );
}
