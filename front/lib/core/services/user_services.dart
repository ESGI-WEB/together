import 'dart:convert';

import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/conflit_exception.dart';
import 'package:front/core/exceptions/unauthorized_exception.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/models/jwt.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/models/user.dart';

import 'api_services.dart';

class UserServices {
  static RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  static Future<JWT> login(
    String email,
    String password,
  ) async {
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
    UserCreateOrEdit user,
  ) async {
    try {
      final response = await ApiServices.post('/users', user.toJson());

      return User.fromJson(ApiServices.decodeResponse(response));
    } on ApiException catch (e) {
      if (e.response?.statusCode == 409) {
        throw ConflictException(message: 'Cet email est déjà utilisé');
      } else {
        rethrow;
      }
    }
  }

  static Future<User> registerAsAdmin(
    UserCreateOrEdit user,
  ) async {
    try {
      final response = await ApiServices.post('/admin/users', user.toJson());
      return User.fromJson(ApiServices.decodeResponse(response));
    } on ConflictException {
      throw ConflictException(message: 'Cet email est déjà utilisé');
    } catch (e) {
      rethrow;
    }
  }

  static Future<Paginated<User>> getUsers({
    String? search,
    page = 1,
  }) async {
    var baseUrl = '/users?page=$page';
    if (search != null) {
      baseUrl += '&search=$search';
    }

    final response = await ApiServices.get(baseUrl);

    return Paginated.fromJson(
      ApiServices.decodeResponse(response),
      (data) => User.fromJson(data),
    );
  }

  static Future<void> deleteUser(int id) async {
    await ApiServices.delete('/users/$id');
  }

  static Future<User> editUser(
    int id,
    UserCreateOrEdit user,
  ) async {
    try {
      final response = await ApiServices.put('/users/$id', user.toJson());

      return User.fromJson(ApiServices.decodeResponse(response));
    } on ConflictException {
      throw ConflictException(message: 'Cet email est déjà utilisé');
    } catch (e) {
      rethrow;
    }
  }

  static Future<User> findById(int id) async {
    try {
      final response = await ApiServices.get('/users/$id');
      return User.fromJson(ApiServices.decodeResponse(response));
    } on ApiException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException(message: 'Utilisateur non trouvé');
      } else {
        rethrow;
      }
    }
  }

  static Future<Paginated<Event>> getUserNextEvents({int page = 1}) async {
    final response = await ApiServices.get('/users/events?page=$page');
    return Paginated.fromJson(
      ApiServices.decodeResponse(response),
      (data) => Event.fromJson(data),
    );
  }
}
