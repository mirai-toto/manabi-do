import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main',
  );
});

/// A setting stored as JSON under [key], or [defaults] when it is missing or
/// no longer parses.
T readJsonSetting<T>(
  SharedPreferences prefs,
  String key,
  T Function(Map<String, dynamic>) fromJson,
  T defaults,
) {
  final String? raw = prefs.getString(key);
  if (raw == null) return defaults;
  try {
    return fromJson(jsonDecode(raw) as Map<String, dynamic>);
  } catch (_) {
    return defaults;
  }
}

Future<void> writeJsonSetting(
  SharedPreferences prefs,
  String key,
  Map<String, dynamic> json,
) => prefs.setString(key, jsonEncode(json));
