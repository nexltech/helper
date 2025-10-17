class AdminComment {
  final int id;
  final int userId;
  final int adminId;
  final String comment;
  final String type;
  final String createdAt;
  final String updatedAt;

  AdminComment({
    required this.id,
    required this.userId,
    required this.adminId,
    required this.comment,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminComment.fromJson(Map<String, dynamic> json) {
    return AdminComment(
      id: json['id'],
      userId: json['user_id'],
      adminId: json['admin_id'],
      comment: json['comment'],
      type: json['type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
