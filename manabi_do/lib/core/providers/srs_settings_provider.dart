import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyNewCharactersPerDay = 'srs_new_characters_per_day';
const _keyNewVocabularyPerDay = 'srs_new_vocab_per_day';
const _keyLegacyNewCards = 'srs_new_cards_per_session';

class SrsSettings {
  final int newCharactersPerDay;
  final int newVocabularyPerDay;

  const SrsSettings({
    this.newCharactersPerDay = 10,
    this.newVocabularyPerDay = 10,
  });

  SrsSettings copyWith({int? newCharactersPerDay, int? newVocabularyPerDay}) =>
      SrsSettings(
        newCharactersPerDay: newCharactersPerDay ?? this.newCharactersPerDay,
        newVocabularyPerDay: newVocabularyPerDay ?? this.newVocabularyPerDay,
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
}

final srsSettingsProvider =
    AsyncNotifierProvider<SrsSettingsNotifier, SrsSettings>(
      SrsSettingsNotifier.new,
    );
