import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/flashcard_settings.dart';
import '../../core/providers/shared_preferences_provider.dart';

const _kKey = 'flashcard_settings_v1';

final flashcardSettingsProvider =
    NotifierProvider<FlashcardSettingsNotifier, FlashcardSettings>(
      FlashcardSettingsNotifier.new,
    );

class FlashcardSettingsNotifier extends Notifier<FlashcardSettings> {
  @override
  FlashcardSettings build() => readJsonSetting(
    ref.read(sharedPreferencesProvider),
    _kKey,
    FlashcardSettings.fromJson,
    FlashcardSettings.defaults,
  );

  Future<void> update(FlashcardSettings settings) async {
    state = settings;
    await writeJsonSetting(
      ref.read(sharedPreferencesProvider),
      _kKey,
      settings.toJson(),
    );
  }
}
