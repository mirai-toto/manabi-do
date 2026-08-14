import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Where user feedback is sent. Shown to the user as a fallback when no mail
/// app can handle the link.
const String feedbackEmailAddress = 'manabi.do-dev@outlook.fr';

/// Opens the user's mail app with a feedback message already addressed and
/// prefilled with the details we would otherwise have to ask for.
///
/// Returns false when no mail app could handle the link — common on emulators
/// and on devices with no account set up — so the caller can show the address
/// instead of leaving the tap doing nothing.
Future<bool> openFeedbackEmail({
  required String subject,
  required String bodyHint,
  required String version,
  required String buildNumber,
  required String languageCode,
}) async {
  final String details = [
    'Version: $version ($buildNumber)',
    'Platform: ${defaultTargetPlatform.name}',
    'Language: $languageCode',
  ].join('\n');

  final String body = '$bodyHint\n\n\n---\n$details';

  // Built by hand rather than with Uri(queryParameters:), which encodes spaces
  // as '+'. Several mail apps show that literally in the subject line.
  final Uri uri = Uri.parse(
    'mailto:$feedbackEmailAddress'
    '?subject=${Uri.encodeComponent(subject)}'
    '&body=${Uri.encodeComponent(body)}',
  );

  try {
    return await launchUrl(uri);
  } catch (_) {
    return false;
  }
}
