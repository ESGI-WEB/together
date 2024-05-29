import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/core/models/jwt-data.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class StorageService {
  static const jwtKey = 'jwt_token';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> writeToken(String token) async {
    await _storage.write(key: jwtKey, value: token);
  }

  static Future<String?> readToken() async {
    return await _storage.read(key: jwtKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: jwtKey);
  }

  static Future<JwtData?> readJwtDataFromToken() async {
    final token = await readToken();
    if (token == null) {
      return null;
    }

    return JwtData.fromJson(JwtDecoder.decode(token));
  }
}
