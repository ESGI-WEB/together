import 'package:front/core/models/user.dart';

class JwtData {
  final int id;
  final String name;
  final String email;
  final String role;
  final DateTime exp;
  final DateTime iat;

  JwtData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.exp,
    required this.iat,
  });

  factory JwtData.fromJson(Map<String, dynamic> json) {
    return JwtData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      exp: DateTime.fromMillisecondsSinceEpoch(json['exp'] * 1000),
      iat: DateTime.fromMillisecondsSinceEpoch(json['iat'] * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'exp': exp.millisecondsSinceEpoch ~/ 1000,
      'iat': iat.millisecondsSinceEpoch ~/ 1000,
    };
  }
}
