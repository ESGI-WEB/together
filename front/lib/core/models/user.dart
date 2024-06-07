import 'package:flutter/material.dart';
import 'package:front/core/services/color_services.dart';

class User {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String email;
  final String role;
  final String? biography;
  final String? avatarPath;
  final Color? colorHex;
  final Color? textColorHex;

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
    this.colorHex,
    this.textColorHex,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final colorHex = json['color_hex'] != null ? ColorServices.hexToColor(json['color_hex']) : null;

    return User(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      deletedAt:
          json['DeletedAt'] != null ? DateTime.parse(json['deleted_at']) : null,
      name: json['name'],
      email: json['email'],
      role: json['role'],
      biography: json['biography'],
      avatarPath: json['avatar_path'],
      colorHex: colorHex,
      textColorHex: colorHex != null ? ColorServices.getContrastingTextColor(colorHex) : null,
    );
  }
}

enum UserRole {
  admin,
  user,
}
