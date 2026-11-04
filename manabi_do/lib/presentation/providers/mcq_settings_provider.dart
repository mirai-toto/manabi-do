import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/mcq_settings.dart';
import '../../core/providers/shared_preferences_provider.dart';

const _kKey = 'mcq_settings_v1';

final mcqSettingsProvider = NotifierProvider<McqSettingsNotifier, McqSettings>(
  McqSettingsNotifier.new,
);

class McqSettingsNotifier extends Notifier<McqSettings> {
  @override
  McqSettings build() => readJsonSetting(
    ref.read(sharedPreferencesProvider),
    _kKey,
    McqSettings.fromJson,
    McqSettings.defaults,
  );

  Future<void> update(McqSettings settings) async {
    state = settings;
    await writeJsonSetting(
      ref.read(sharedPreferencesProvider),
      _kKey,
      settings.toJson(),
    );
  }
}
