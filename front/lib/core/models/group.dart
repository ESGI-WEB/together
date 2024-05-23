import 'package:front/core/models/user.dart';

class Group {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String? description;
  final String code;
  final List<User>? users;

  Group({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    this.description,
    required this.code,
    this.users,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      deletedAt: json['DeletedAt'] != null ? DateTime.parse(json['DeletedAt']) : null,
      name: json['name'],
      description: json['description'],
      code: json['code'],
      users: json['users'] != null ? List<User>.from(json['users'].map((user) => User.fromJson(user))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'CreatedAt': createdAt.toIso8601String(),
      'UpdatedAt': updatedAt.toIso8601String(),
      'DeletedAt': deletedAt?.toIso8601String(),
      'Name': name,
      'Description': description,
      'Code': code,
      'Users': [],
    };
  }
}
//users?.map((user) => user.toJson()).toList()
