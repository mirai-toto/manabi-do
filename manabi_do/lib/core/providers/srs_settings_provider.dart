import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyNewCardsPerSession = 'srs_new_cards_per_session';

class SrsSettings {
  final int newCardsPerSession;
  const SrsSettings({this.newCardsPerSession = 10});
  SrsSettings copyWith({int? newCardsPerSession}) =>
      SrsSettings(newCardsPerSession: newCardsPerSession ?? this.newCardsPerSession);
}

class SrsSettingsNotifier extends AsyncNotifier<SrsSettings> {
  @override
  Future<SrsSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return SrsSettings(
      newCardsPerSession: prefs.getInt(_keyNewCardsPerSession) ?? 10,
    );
  }

  Future<void> setNewCardsPerSession(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyNewCardsPerSession, value);
    state = AsyncData(state.requireValue.copyWith(newCardsPerSession: value));
  }
}

final srsSettingsProvider =
    AsyncNotifierProvider<SrsSettingsNotifier, SrsSettings>(SrsSettingsNotifier.new);
