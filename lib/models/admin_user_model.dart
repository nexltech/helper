class AdminUser {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String role;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      role: json['role'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'role': role,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
