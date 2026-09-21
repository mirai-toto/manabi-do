import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyNewCharactersPerDay = 'srs_new_characters_per_day';
const _keyNewVocabularyPerDay = 'srs_new_vocab_per_day';
const _keyAutoEvaluate = 'srs_auto_evaluate';
const _keyLegacyNewCards = 'srs_new_cards_per_session';

class SrsSettings {
  final int newCharactersPerDay;
  final int newVocabularyPerDay;

  /// Let the answer decide the review grade instead of asking for a
  /// self-assessment. Every review exercise can be marked right or wrong on
  /// its own, so the rating step is optional.
  final bool autoEvaluate;

  const SrsSettings({
    this.newCharactersPerDay = 10,
    this.newVocabularyPerDay = 10,
    this.autoEvaluate = false,
  });

  SrsSettings copyWith({
    int? newCharactersPerDay,
    int? newVocabularyPerDay,
    bool? autoEvaluate,
  }) => SrsSettings(
    newCharactersPerDay: newCharactersPerDay ?? this.newCharactersPerDay,
    newVocabularyPerDay: newVocabularyPerDay ?? this.newVocabularyPerDay,
    autoEvaluate: autoEvaluate ?? this.autoEvaluate,
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
      autoEvaluate: prefs.getBool(_keyAutoEvaluate) ?? false,
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

  Future<void> setAutoEvaluate(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoEvaluate, value);
    state = AsyncData(state.requireValue.copyWith(autoEvaluate: value));
  }
}

final srsSettingsProvider =
    AsyncNotifierProvider<SrsSettingsNotifier, SrsSettings>(
      SrsSettingsNotifier.new,
    );
