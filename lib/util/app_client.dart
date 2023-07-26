import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:valve_controller/util/platform_exception.dart';

class AppClient {
  final log = Logger('AppClient');
  final http.Client client;
  final String? appApiKey;

  AppClient(this.client, {this.appApiKey});

  Future<Map<String, dynamic>> get(
    Uri uri, {
    bool useUserCredential = true,
    Map<String, String>? preferHeader,
    bool validateResponseFormat = true,
  }) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      headers.addAll({});

      if (preferHeader != null) headers.addAll(preferHeader);

      log.fine('GET: $uri');
      log.fine('headers $headers');

      var response = await client.get(uri, headers: headers);
      await _validateResponseStatus(uri.toString(), response);
      Map<String, dynamic> json = {};
      if (response.body.isEmpty) return json;

      if (response.body.isNotEmpty) {
        json = jsonDecode(response.body);
      }

      // if (validateResponseFormat) _validateResponsePattern(json);

      return json;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
    Uri uri, {
    required Map<String, dynamic> body,
    bool useUserCredential = true,
    Map<String, String>? preferHeader,
    bool shouldRemoveAuthorizedHeaderFields = false,
    bool validateResponseFormat = true,
  }) async {
    try {
      log.fine('POST: body = $body');

      Map<String, String> headers = {};

      headers.addAll({});

      if (preferHeader != null) headers.addAll(preferHeader);

      headers['Content-Type'] = 'application/json';

      log.fine('POST: $uri');
      log.fine('headers $headers');

      var response = await client.post(
        uri,
        body: jsonEncode(body),
        headers: headers,
      );

      await _validateResponseStatus(uri.toString(), response);

      var json = jsonDecode(response.body);

      if (validateResponseFormat) _validateResponsePattern(json);

      return json;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _validateResponseStatus(
    String url,
    http.Response response,
  ) async {
    log.fine('validate response status from $url, code ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
        return;
      case 201:
        return;
      case 400:
        throw HttpException(response);
      case 401:
        throw HttpException(response);
      case 403:
        throw HttpException(response);
      case 404:
        throw HttpException(response);
      case 422:
        throw HttpException(response);
      case 500:
        throw HttpException(response);
      default:
        log.fine(response.body);
        throw Exception(
          'Invalid response status code ${response.statusCode}: ${response.body}',
        );
    }
  }

  void _validateResponsePattern(Map<String, dynamic> json) {
    if (json['data'] == null) {
      throw Exception('Invalid response pattern: $json');
    }
    return;
  }
}
