import 'package:flutter/services.dart' show rootBundle;

class Env {
  static final Map<String, String> _values = {};
  static bool _loaded = false;

  static Future<void> load([String path = 'assets/env/.env']) async {
    final raw = await rootBundle.loadString(path);
    for (final line in raw.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      final idx = trimmed.indexOf('=');
      if (idx <= 0) continue;
      final key = trimmed.substring(0, idx).trim();
      final value = trimmed.substring(idx + 1).trim();
      _values[key] = value;
    }
    _loaded = true;
  }

  static String get(String key, {String defaultValue = ''}) =>
      _values[key] ?? defaultValue;

  static bool get isLoaded => _loaded;

  static String get strapiApiUrl =>
      get('STRAPI_API_URL', defaultValue: 'http://localhost:1337');
}
