import 'package:url_launcher/url_launcher.dart';

/// Where users can support development. Shown to the user as a fallback when
/// no browser can handle the link.
const String supportPageUrl = 'https://ko-fi.com/miraitoto';

/// Opens the support page in the device browser.
///
/// [LaunchMode.externalApplication] is deliberate rather than the default: both
/// stores expect donations to be collected outside the app, and an in-app
/// webview blurs that line.
///
/// Returns false when no browser could handle the link, so the caller can show
/// the address instead of leaving the tap doing nothing.
Future<bool> openSupportPage() async {
  try {
    return await launchUrl(
      Uri.parse(supportPageUrl),
      mode: LaunchMode.externalApplication,
    );
  } catch (_) {
    return false;
  }
}
