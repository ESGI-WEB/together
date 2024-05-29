import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/feature_disabled_exception.dart';
import 'package:front/core/exceptions/unauthorized_exception.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiServices {
  static String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:8080';
  static const Map<String, String> baseHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static Future<Map<String, String>> getAllBasicHeaders() async {
    var headers = {...baseHeaders};

    final token = await StorageService.readToken();
    if (token != null) {
      headers.addAll({
        'Authorization': 'Bearer $token',
      });
    }

    return headers;
  }

  static Future<Response> get(String path,
      [Map<String, String>? headers]) async {
    final response = await http.get(
      Uri.parse(baseUrl + path),
      headers: {}
        ..addAll(await getAllBasicHeaders())
        ..addAll(headers ?? {}),
    );

    handleResponse(response);
    return response;
  }

  static Future<Response> post(String path,
      [Map<String, dynamic>? body, Map<String, String>? headers]) async {
    final response = await http.post(
      Uri.parse(baseUrl + path),
      headers: {}
        ..addAll(await getAllBasicHeaders())
        ..addAll(headers ?? {}),
      body: body != null ? jsonEncode(body) : null,
    );

    handleResponse(response);
    return response;
  }

  static Future<Response> put(String path,
      [Map<String, dynamic>? body, Map<String, String>? headers]) async {
    final response = await http.put(
      Uri.parse(baseUrl + path),
      headers: {}
        ..addAll(await getAllBasicHeaders())
        ..addAll(headers ?? {}),
      body: body != null ? jsonEncode(body) : null,
    );

    handleResponse(response);
    return response;
  }

  static Future<Response> patch(String path,
      [Map<String, dynamic>? body, Map<String, String>? headers]) async {
    final response = await http.patch(
      Uri.parse(baseUrl + path),
      headers: {}
        ..addAll(await getAllBasicHeaders())
        ..addAll(headers ?? {}),
      body: body != null ? jsonEncode(body) : null,
    );

    handleResponse(response);
    return response;
  }

  static Future<Response> delete(String path,
      [Map<String, String>? headers]) async {
    final response = await http.delete(
      Uri.parse(baseUrl + path),
      headers: {}
        ..addAll(await getAllBasicHeaders())
        ..addAll(headers ?? {}),
    );

    handleResponse(response);
    return response;
  }

  static void handleResponse(Response response) {
    if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 503) {
      throw FeatureDisabledException();
    } else if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response: response, statusCode: response.statusCode);
    }
  }
}
