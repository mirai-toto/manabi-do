import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  /// Only applies where the grade is kept. A session that writes nothing
  /// back always asks the short way — there is no precision to be had.
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

class SrsSettingsNotifier extends AsyncNotifier<SrsSettings> {
  @override
  Future<SrsSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final legacy = prefs.getInt(_keyLegacyNewCards) ?? 10;
    return SrsSettings(
      newCharactersPerDay: prefs.getInt(_keyNewCharactersPerDay) ?? legacy,
      newVocabularyPerDay: prefs.getInt(_keyNewVocabularyPerDay) ?? legacy,
      autoAdvance: prefs.getBool(_keyAutoAdvance) ?? false,
      detailedGrading: prefs.getBool(_keyDetailedGrading) ?? true,
    );
  }

  Future<void> setNewCharactersPerDay(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyNewCharactersPerDay, value);
    state = AsyncData(state.requireValue.copyWith(newCharactersPerDay: value));
  }

  Future<void> setNewVocabularyPerDay(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyNewVocabularyPerDay, value);
    state = AsyncData(state.requireValue.copyWith(newVocabularyPerDay: value));
  }

  Future<void> setAutoAdvance(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoAdvance, value);
    state = AsyncData(state.requireValue.copyWith(autoAdvance: value));
  }

  Future<void> setDetailedGrading(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDetailedGrading, value);
    state = AsyncData(state.requireValue.copyWith(detailedGrading: value));
  }
}

final srsSettingsProvider =
    AsyncNotifierProvider<SrsSettingsNotifier, SrsSettings>(
      SrsSettingsNotifier.new,
    );
