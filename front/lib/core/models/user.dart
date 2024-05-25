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
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      deletedAt: json['DeletedAt'] != null ? DateTime.parse(json['deleted_at']) : null,
      name: json['name'],
      email: json['email'],
      role: json['role'],
      biography: json['biography'],
      avatarPath: json['avatar_path'],
    );
  }

}
