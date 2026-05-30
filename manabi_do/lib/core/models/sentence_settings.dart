enum TranslationMode { always, onDemand, never }

class SentenceSettings {
  final int? sessionLength;
  final int mcqChoiceCount;
  final bool autoAdvance;
  final bool showSentenceFurigana;
  final bool showChoiceFurigana;
  final TranslationMode translationMode;

  const SentenceSettings({
    this.sessionLength = 20,
    this.mcqChoiceCount = 4,
    this.autoAdvance = false,
    this.showSentenceFurigana = true,
    this.showChoiceFurigana = false,
    this.translationMode = TranslationMode.onDemand,
  });

  static const defaults = SentenceSettings();

  SentenceSettings copyWith({
    int? sessionLength,
    bool clearSessionLength = false,
    int? mcqChoiceCount,
    bool? autoAdvance,
    bool? showSentenceFurigana,
    bool? showChoiceFurigana,
    TranslationMode? translationMode,
  }) => SentenceSettings(
    sessionLength: clearSessionLength
        ? null
        : sessionLength ?? this.sessionLength,
    mcqChoiceCount: mcqChoiceCount ?? this.mcqChoiceCount,
    autoAdvance: autoAdvance ?? this.autoAdvance,
    showSentenceFurigana: showSentenceFurigana ?? this.showSentenceFurigana,
    showChoiceFurigana: showChoiceFurigana ?? this.showChoiceFurigana,
    translationMode: translationMode ?? this.translationMode,
  );

  Map<String, dynamic> toJson() => {
    'sessionLength': sessionLength,
    'mcqChoiceCount': mcqChoiceCount,
    'autoAdvance': autoAdvance,
    'showSentenceFurigana': showSentenceFurigana,
    'showChoiceFurigana': showChoiceFurigana,
    'translationMode': translationMode.index,
  };

  factory SentenceSettings.fromJson(Map<String, dynamic> json) =>
      SentenceSettings(
        sessionLength: json['sessionLength'] as int?,
        mcqChoiceCount: json['mcqChoiceCount'] as int? ?? 4,
        autoAdvance: json['autoAdvance'] as bool? ?? false,
        showSentenceFurigana: json['showSentenceFurigana'] as bool? ?? true,
        showChoiceFurigana: json['showChoiceFurigana'] as bool? ?? false,
        translationMode:
            TranslationMode.values[json['translationMode'] as int? ?? 1],
      );
}
