import 'package:url_launcher/url_launcher.dart';

Future<bool> makePhoneCall(String phoneNumber) async {
  final uri = Uri(scheme: 'tel', path: phoneNumber);
  return _launchSafely(uri);
}

Future<bool> sendEmail({
  required String email,
  String? subject,
  String? body,
}) async {
  final uri = Uri(
    scheme: 'mailto',
    path: email,
    query: _encodeQueryParameters({
      if (subject != null) 'subject': subject,
      if (body != null) 'body': body,
    }),
  );

  return _launchSafely(uri);
}

Future<bool> openUrl(String url) async {
  final uri = Uri.parse(url.trim());
  return _launchSafely(uri);
}

Future<bool> _launchSafely(Uri uri) async {
  try {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (ok) return true;

    return await launchUrl(uri);
  } catch (e) {
    // ignore: avoid_print
    print('Could not open $uri: $e');
    return false;
  }
}

String? _encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}