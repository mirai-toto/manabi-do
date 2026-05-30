import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/drawing_settings.dart';
import '../../core/providers/shared_preferences_provider.dart';

const _kKey = 'drawing_settings_v1';

final drawingSettingsProvider =
    NotifierProvider<DrawingSettingsNotifier, DrawingSettings>(
      DrawingSettingsNotifier.new,
    );

class DrawingSettingsNotifier extends Notifier<DrawingSettings> {
  @override
  DrawingSettings build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString(_kKey);
    if (raw == null) return DrawingSettings.defaults;
    try {
      return DrawingSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return DrawingSettings.defaults;
    }
  }

  Future<void> update(DrawingSettings settings) async {
    state = settings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, jsonEncode(settings.toJson()));
  }
}
