import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyNewCharactersPerDay = 'srs_new_characters_per_day';
const _keyNewVocabPerDay = 'srs_new_vocab_per_day';
const _keyLegacyNewCards = 'srs_new_cards_per_session';

class SrsSettings {
  final int newCharactersPerDay;
  final int newVocabPerDay;

  const SrsSettings({this.newCharactersPerDay = 10, this.newVocabPerDay = 10});

  SrsSettings copyWith({int? newCharactersPerDay, int? newVocabPerDay}) =>
      SrsSettings(
        newCharactersPerDay: newCharactersPerDay ?? this.newCharactersPerDay,
        newVocabPerDay: newVocabPerDay ?? this.newVocabPerDay,
      );
}

class SrsSettingsNotifier extends AsyncNotifier<SrsSettings> {
  @override
  Future<SrsSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final legacy = prefs.getInt(_keyLegacyNewCards) ?? 10;
    return SrsSettings(
      newCharactersPerDay: prefs.getInt(_keyNewCharactersPerDay) ?? legacy,
      newVocabPerDay: prefs.getInt(_keyNewVocabPerDay) ?? legacy,
    );
  }

  Future<void> setNewCharactersPerDay(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyNewCharactersPerDay, value);
    state = AsyncData(state.requireValue.copyWith(newCharactersPerDay: value));
  }

  Future<void> setNewVocabPerDay(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyNewVocabPerDay, value);
    state = AsyncData(state.requireValue.copyWith(newVocabPerDay: value));
  }
}

final srsSettingsProvider =
    AsyncNotifierProvider<SrsSettingsNotifier, SrsSettings>(
      SrsSettingsNotifier.new,
    );
