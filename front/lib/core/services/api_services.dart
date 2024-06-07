import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/conflit_exception.dart';
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
  
  static String getFullUrlFromPath(String path) {
    if (path.startsWith('http')) {
      return path;
    }
    
    return '$baseUrl$path';
  }

  static Future<Response> get(String path,
      [Map<String, String>? headers]) async {
    final response = await http.get(
      Uri.parse(getFullUrlFromPath(path)),
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
      Uri.parse(getFullUrlFromPath(path)),
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
      Uri.parse(getFullUrlFromPath(path)),
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
      Uri.parse(getFullUrlFromPath(path)),
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
      Uri.parse(getFullUrlFromPath(path)),
      headers: {}
        ..addAll(await getAllBasicHeaders())
        ..addAll(headers ?? {}),
    );

    handleResponse(response);
    return response;
  }

  static Future<Response> multipartRequest(String verb, String path,
      [Map<String, dynamic>? body, Map<String, String>? headers]) async {
    final request = http.MultipartRequest(verb, Uri.parse(getFullUrlFromPath(path)));
    request.headers.addAll(await getAllBasicHeaders());
    request.headers.addAll(headers ?? {});

    if (body != null) {
      for (var key in body.keys) {
        if (body[key] is http.MultipartFile) {
          request.files.add(body[key]);
        } else {
          request.fields[key] = body[key].toString();
        }
      }
    }

    final responseStreamed = await request.send();
    final response = await http.Response.fromStream(responseStreamed);

    handleResponse(response);
    return response;
  }

  static void handleResponse(Response response) {
    if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 503) {
      throw FeatureDisabledException();
    } else if (response.statusCode == 409) {
      throw ConflictException(response: response);
    } else if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response: response, statusCode: response.statusCode, message: response.body);
    }
  }

  static dynamic decodeResponse(Response response) {
    if (response.body.isEmpty) {
      return null;
    }

    final decodedResponse = utf8.decode(response.bodyBytes);
    final jsonResponse = json.decode(decodedResponse);
    return jsonResponse;
  }
}
