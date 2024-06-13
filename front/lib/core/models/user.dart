import 'package:flutter/material.dart';
import 'package:front/core/services/color_services.dart';

class User {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String email;
  final UserRole role;
  final String? biography;
  final String? avatarPath;
  final Color color;
  final Color textColor;

  User({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.email,
    required this.role,
    this.biography,
    this.avatarPath,
    required this.color,
    required this.textColor,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    late final Color color;
    try {
      if (json['color_hex'] == null) {
        throw Exception('Color hex not found');
      }

      color = ColorServices.hexToColor(json['color_hex']);
    } catch (e) {
      // if color_hex is not found or invalid, set a default color
      color = Colors.white70;
    }

    return User(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      deletedAt:
          json['DeletedAt'] != null ? DateTime.parse(json['deleted_at']) : null,
      name: json['name'],
      email: json['email'],
      role: json['role'] == 'admin' ? UserRole.admin : UserRole.user,
      biography: json['biography'],
      avatarPath: json['avatar_path'],
      color: color,
      textColor: ColorServices.getContrastingTextColor(color),
    );
  }
}

enum UserRole {
  admin,
  user,
}

class UserCreateOrEdit {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final UserRole? role;
  final String? biography;
  final Color? color;

  UserCreateOrEdit({
    this.id,
    this.name,
    this.email,
    this.password,
    this.role,
    this.biography,
    this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role?.name,
      'biography': biography,
      'color_hex': color?.toString(),
    };
  }

  UserCreateOrEdit copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    UserRole? role,
    String? biography,
    Color? color,
  }) {
    return UserCreateOrEdit(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      biography: biography ?? this.biography,
      color: color ?? this.color,
    );
  }
}
