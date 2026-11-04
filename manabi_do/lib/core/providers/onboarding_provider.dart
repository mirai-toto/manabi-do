import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_provider.dart';

const _kOnboardingSeen = 'onboarding_seen';

/// Whether the first-run screens have been shown.
///
/// Read synchronously at startup, like the locale, because the app has to
/// decide which screen to open on and an async gate there would flash the home
/// screen first. An install from before this existed reads false and sees
/// onboarding once; everything it sets has a sane default already, so nothing
/// is lost by that.
class OnboardingSeenNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(_kOnboardingSeen) ?? false;
  }

  Future<void> markSeen() async {
    state = true;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_kOnboardingSeen, true);
  }

  /// For the reset-progress flow, which puts the app back to a fresh install.
  Future<void> reset() async {
    state = false;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_kOnboardingSeen);
  }
}

final onboardingSeenProvider = NotifierProvider<OnboardingSeenNotifier, bool>(
  OnboardingSeenNotifier.new,
);
