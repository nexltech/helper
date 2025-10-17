class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? status;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.status,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.token,
  });

  // Factory constructor for registration response
  factory UserModel.fromRegisterJson(Map<String, dynamic> json) {
    final userData = json['user'] as Map<String, dynamic>;
    return UserModel(
      id: userData['id'] as int,
      name: userData['name'] as String,
      email: userData['email'] as String,
      role: userData['role'] as String,
      status: userData['status'] as String?,
      emailVerifiedAt: userData['email_verified_at'] != null
          ? DateTime.parse(userData['email_verified_at'] as String)
          : null,
      createdAt: DateTime.parse(userData['created_at'] as String),
      updatedAt: DateTime.parse(userData['updated_at'] as String),
      deletedAt: userData['deleted_at'] != null
          ? DateTime.parse(userData['deleted_at'] as String)
          : null,
      token: json['token'] as String?,
    );
  }

  // Factory constructor for login response
  factory UserModel.fromLoginJson(Map<String, dynamic> json) {
    final userData = json['user'] as Map<String, dynamic>;
    return UserModel(
      id: userData['id'] as int,
      name: userData['name'] as String,
      email: userData['email'] as String,
      role: userData['role'] as String,
      status: userData['status'] as String?,
      emailVerifiedAt: userData['email_verified_at'] != null
          ? DateTime.parse(userData['email_verified_at'] as String)
          : null,
      createdAt: DateTime.parse(userData['created_at'] as String),
      updatedAt: DateTime.parse(userData['updated_at'] as String),
      deletedAt: userData['deleted_at'] != null
          ? DateTime.parse(userData['deleted_at'] as String)
          : null,
      token: json['token'] as String?, // Login may not return token
    );
  }

  // Convert to JSON for updates
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'status': status,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'token': token,
    };
  }

  // Create a copy with updated fields
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? status,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      token: token ?? this.token,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role, status: $status, token: $token)';
  }
}
