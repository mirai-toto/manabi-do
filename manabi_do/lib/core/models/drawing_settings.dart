enum RecognitionTolerance { strict, normal, lenient }

enum KanjiHintMode { meaningOnly, readingsOnly, both }

class DrawingSettings {
  final int? sessionLength;
  final bool autoAdvance;
  final RecognitionTolerance tolerance;
  final bool ghostKanji;
  final bool snapToReference;
  final bool showStrokeCount;
  final KanjiHintMode hintMode;

  const DrawingSettings({
    this.sessionLength = 20,
    this.autoAdvance = false,
    this.tolerance = RecognitionTolerance.normal,
    this.ghostKanji = false,
    this.snapToReference = true,
    this.showStrokeCount = false,
    this.hintMode = KanjiHintMode.meaningOnly,
  });

  static const defaults = DrawingSettings();

  double get toleranceThreshold => switch (tolerance) {
    RecognitionTolerance.strict => 15.0,
    RecognitionTolerance.normal => 25.0,
    RecognitionTolerance.lenient => 35.0,
  };

  DrawingSettings copyWith({
    int? sessionLength,
    bool clearSessionLength = false,
    bool? autoAdvance,
    RecognitionTolerance? tolerance,
    bool? ghostKanji,
    bool? snapToReference,
    bool? showStrokeCount,
    KanjiHintMode? hintMode,
  }) => DrawingSettings(
    sessionLength: clearSessionLength
        ? null
        : sessionLength ?? this.sessionLength,
    autoAdvance: autoAdvance ?? this.autoAdvance,
    tolerance: tolerance ?? this.tolerance,
    ghostKanji: ghostKanji ?? this.ghostKanji,
    snapToReference: snapToReference ?? this.snapToReference,
    showStrokeCount: showStrokeCount ?? this.showStrokeCount,
    hintMode: hintMode ?? this.hintMode,
  );

  Map<String, dynamic> toJson() => {
    'sessionLength': sessionLength,
    'autoAdvance': autoAdvance,
    'tolerance': tolerance.index,
    'ghostKanji': ghostKanji,
    'snapToReference': snapToReference,
    'showStrokeCount': showStrokeCount,
    'hintMode': hintMode.index,
  };

  factory DrawingSettings.fromJson(Map<String, dynamic> json) =>
      DrawingSettings(
        sessionLength: json['sessionLength'] as int?,
        autoAdvance: json['autoAdvance'] as bool? ?? false,
        tolerance: RecognitionTolerance.values[json['tolerance'] as int? ?? 1],
        ghostKanji: json['ghostKanji'] as bool? ?? false,
        snapToReference: json['snapToReference'] as bool? ?? true,
        showStrokeCount: json['showStrokeCount'] as bool? ?? false,
        hintMode: KanjiHintMode.values[json['hintMode'] as int? ?? 0],
      );
}
