import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/sentence_settings.dart';
import '../../core/providers/shared_preferences_provider.dart';

const _kKey = 'sentence_settings_v1';

final sentenceSettingsProvider =
    NotifierProvider<SentenceSettingsNotifier, SentenceSettings>(
      SentenceSettingsNotifier.new,
    );

class SentenceSettingsNotifier extends Notifier<SentenceSettings> {
  @override
  SentenceSettings build() => readJsonSetting(
    ref.read(sharedPreferencesProvider),
    _kKey,
    SentenceSettings.fromJson,
    SentenceSettings.defaults,
  );

  Future<void> update(SentenceSettings settings) async {
    state = settings;
    await writeJsonSetting(
      ref.read(sharedPreferencesProvider),
      _kKey,
      settings.toJson(),
    );
  }
}
