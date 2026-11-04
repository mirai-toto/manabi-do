import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/drawing_settings.dart';
import '../../core/providers/shared_preferences_provider.dart';

const _kKey = 'drawing_settings_v1';

final drawingSettingsProvider =
    NotifierProvider<DrawingSettingsNotifier, DrawingSettings>(
      DrawingSettingsNotifier.new,
    );

class DrawingSettingsNotifier extends Notifier<DrawingSettings> {
  @override
  DrawingSettings build() => readJsonSetting(
    ref.read(sharedPreferencesProvider),
    _kKey,
    DrawingSettings.fromJson,
    DrawingSettings.defaults,
  );

  Future<void> update(DrawingSettings settings) async {
    state = settings;
    await writeJsonSetting(
      ref.read(sharedPreferencesProvider),
      _kKey,
      settings.toJson(),
    );
  }
}
