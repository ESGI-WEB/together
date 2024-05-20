import 'dart:convert';

import 'package:front/core/exceptions/unauthorized_exception.dart';
import 'package:front/core/models/jwt.dart';

import 'api_services.dart';

class LoginServices {
  static Future<JWT> login(String email, String password) async {
    try {
      final response = await ApiServices.post('/security/login', {
        'email': email,
        'password': password,
      });

      return JWT.fromJson(json.decode(response.body));
    } catch (e) {
      if (e is UnauthorizedException) {
        throw UnauthorizedException(message: 'Email ou mot de passe incorrect');
      } else {
        rethrow;
      }

    }
  }
}