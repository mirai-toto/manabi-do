import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:manabi_do/core/providers/onboarding_provider.dart';
import 'package:manabi_do/core/providers/shared_preferences_provider.dart';

/// The flag decides which screen the app opens on, so it is read
/// synchronously. These cover the three states it can be in.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> containerWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    final prefs = await SharedPreferences.getInstance();
    return ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
  }

  test('a fresh install has not seen it', () async {
    final c = await containerWith({});
    expect(c.read(onboardingSeenProvider), isFalse);
  });

  test('marking it seen sticks', () async {
    final c = await containerWith({});
    await c.read(onboardingSeenProvider.notifier).markSeen();
    expect(c.read(onboardingSeenProvider), isTrue);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('onboarding_seen'), isTrue);
  });

  test('an install that has seen it opens straight into the app', () async {
    final c = await containerWith({'flutter.onboarding_seen': true});
    expect(c.read(onboardingSeenProvider), isTrue);
  });

  test('reset puts it back, for the wipe-progress flow', () async {
    final c = await containerWith({'flutter.onboarding_seen': true});
    await c.read(onboardingSeenProvider.notifier).reset();
    expect(c.read(onboardingSeenProvider), isFalse);
  });
}
