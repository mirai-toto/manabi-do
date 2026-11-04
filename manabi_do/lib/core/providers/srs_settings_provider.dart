import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_provider.dart';

const _keyNewCharactersPerDay = 'srs_new_characters_per_day';
const _keyNewVocabularyPerDay = 'srs_new_vocab_per_day';
const _keyAutoAdvance = 'srs_auto_advance';
const _keyDetailedGrading = 'srs_detailed_grading';
const _keyLegacyNewCards = 'srs_new_cards_per_session';

class SrsSettings {
  final int newCharactersPerDay;
  final int newVocabularyPerDay;

  /// Move on by itself and let the answer decide the grade, instead of
  /// stopping for a self-assessment. One switch for the whole queue: a review
  /// session mixes exercise types, and being asked by only some of them would
  /// be incoherent.
  final bool autoAdvance;

  /// Offer the full Again / Hard / Good / Easy scale when you grade, rather
  /// than just Not yet / Got it. One switch for the whole app: a review
  /// mixes exercise types, and a scale that changed between them would make
  /// your own grades incomparable.
  ///
  /// Applies wherever you grade, including free practice. The grade is
  /// discarded there, but each button still previews the interval it would
  /// schedule, so the finer scale is informative either way.
  final bool detailedGrading;

  const SrsSettings({
    this.newCharactersPerDay = 10,
    this.newVocabularyPerDay = 10,
    this.autoAdvance = false,
    this.detailedGrading = true,
  });

  SrsSettings copyWith({
    int? newCharactersPerDay,
    int? newVocabularyPerDay,
    bool? autoAdvance,
    bool? detailedGrading,
  }) => SrsSettings(
    newCharactersPerDay: newCharactersPerDay ?? this.newCharactersPerDay,
    newVocabularyPerDay: newVocabularyPerDay ?? this.newVocabularyPerDay,
    autoAdvance: autoAdvance ?? this.autoAdvance,
    detailedGrading: detailedGrading ?? this.detailedGrading,
  );
}

class SrsSettingsNotifier extends Notifier<SrsSettings> {
  @override
  SrsSettings build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final legacy = prefs.getInt(_keyLegacyNewCards) ?? 10;
    return SrsSettings(
      newCharactersPerDay: prefs.getInt(_keyNewCharactersPerDay) ?? legacy,
      newVocabularyPerDay: prefs.getInt(_keyNewVocabularyPerDay) ?? legacy,
      autoAdvance: prefs.getBool(_keyAutoAdvance) ?? false,
      detailedGrading: prefs.getBool(_keyDetailedGrading) ?? true,
    );
  }

  Future<void> setNewCharactersPerDay(int value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_keyNewCharactersPerDay, value);
    state = state.copyWith(newCharactersPerDay: value);
  }

  Future<void> setNewVocabularyPerDay(int value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_keyNewVocabularyPerDay, value);
    state = state.copyWith(newVocabularyPerDay: value);
  }

  Future<void> setAutoAdvance(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyAutoAdvance, value);
    state = state.copyWith(autoAdvance: value);
  }

  Future<void> setDetailedGrading(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyDetailedGrading, value);
    state = state.copyWith(detailedGrading: value);
  }
}

final srsSettingsProvider = NotifierProvider<SrsSettingsNotifier, SrsSettings>(
  SrsSettingsNotifier.new,
);
