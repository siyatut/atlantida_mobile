import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/env.dart';

class StrapiClient {
  final http.Client _http;

  StrapiClient([http.Client? client]) : _http = client ?? http.Client();

  String get _baseUrl =>
      Env.get('STRAPI_API_URL', defaultValue: 'http://localhost:1337');

  Future<Map<String, dynamic>> _fetch(
    String path,
    Map<String, String> params,
  ) async {
    final uri =
        Uri.parse('$_baseUrl$path').replace(queryParameters: params);
    final response =
        await _http.get(uri, headers: {'Accept': 'application/json'});
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Strapi request failed: ${response.statusCode} $path',
      );
    }
    return json.decode(response.body) as Map<String, dynamic>;
  }

  /// Fetches all pages of a paginated collection in parallel after the first.
  Future<List<dynamic>> fetchAll(
    String path, {
    Map<String, String>? query,
  }) async {
    const pageSize = 100;
    final firstParams = {
      ...?query,
      'pagination[page]': '1',
      'pagination[pageSize]': '$pageSize',
    };

    final first = await _fetch(path, firstParams);
    final data = (first['data'] as List?) ?? const [];
    final pageCount =
        ((first['meta'] as Map?)?['pagination'] as Map?)?['pageCount'] as int? ??
            1;

    if (pageCount <= 1) return data;

    final remaining = await Future.wait(
      List.generate(
        pageCount - 1,
        (i) => _fetch(path, {
          ...?query,
          'pagination[page]': '${i + 2}',
          'pagination[pageSize]': '$pageSize',
        }),
      ),
    );

    return [
      ...data,
      ...remaining.expand((r) => (r['data'] as List?) ?? const []),
    ];
  }
}
