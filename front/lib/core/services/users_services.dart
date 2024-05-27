import 'dart:convert';

import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/conflit_exception.dart';
import 'package:front/core/exceptions/unauthorized_exception.dart';
import 'package:front/core/models/jwt.dart';
import 'package:front/core/models/user.dart';

import 'api_services.dart';

class UsersServices {
  static RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

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

  static Future<User> register(
      String name, String email, String password) async {
    try {
      final response = await ApiServices.post('/users', {
        'name': name,
        'email': email,
        'password': password,
      });

      return User.fromJson(json.decode(response.body));
    } on ApiException catch (e) {
      if (e.response?.statusCode == 409) {
        throw ConflictException(message: 'Cet email est déjà utilisé');
      } else {
        rethrow;
      }
    }
  }
}
