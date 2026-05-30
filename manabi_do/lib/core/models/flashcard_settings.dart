class FlashcardSettings {
  final int? sessionLength;

  const FlashcardSettings({this.sessionLength = 20});

  static const defaults = FlashcardSettings();

  FlashcardSettings copyWith({
    int? sessionLength,
    bool clearSessionLength = false,
  }) => FlashcardSettings(
    sessionLength: clearSessionLength
        ? null
        : sessionLength ?? this.sessionLength,
  );

  Map<String, dynamic> toJson() => {'sessionLength': sessionLength};

  factory FlashcardSettings.fromJson(Map<String, dynamic> json) =>
      FlashcardSettings(sessionLength: json['sessionLength'] as int?);
}
