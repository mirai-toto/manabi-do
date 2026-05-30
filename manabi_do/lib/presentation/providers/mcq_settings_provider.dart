import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/mcq_settings.dart';
import '../../core/providers/shared_preferences_provider.dart';

const _kKey = 'mcq_settings_v1';

final mcqSettingsProvider = NotifierProvider<McqSettingsNotifier, McqSettings>(
  McqSettingsNotifier.new,
);

class McqSettingsNotifier extends Notifier<McqSettings> {
  @override
  McqSettings build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString(_kKey);
    if (raw == null) return McqSettings.defaults;
    try {
      return McqSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return McqSettings.defaults;
    }
  }

  Future<void> update(McqSettings settings) async {
    state = settings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, jsonEncode(settings.toJson()));
  }
}
