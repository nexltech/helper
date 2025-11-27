class JobCategory {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  JobCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobCategory.fromJson(Map<String, dynamic> json) {
    return JobCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class JobUser {
  final int id;
  final String name;
  final String email;

  JobUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory JobUser.fromJson(Map<String, dynamic> json) {
    return JobUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

class JobPost {
  final int id;
  final String userId;
  final String jobTitle;
  final String jobCategoryId;
  final String payment;
  final String address;
  final String dateTime;
  final String jobDescription;
  final String? image;
  final String status;
  final String createdAt;
  final String updatedAt;
  final JobCategory category;
  final JobUser? user;

  JobPost({
    required this.id,
    required this.userId,
    required this.jobTitle,
    required this.jobCategoryId,
    required this.payment,
    required this.address,
    required this.dateTime,
    required this.jobDescription,
    this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    this.user,
  });

  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      jobTitle: json['job_title'] ?? '',
      jobCategoryId: json['job_category_id']?.toString() ?? '',
      payment: json['payment']?.toString() ?? '0',
      address: json['address'] ?? '',
      dateTime: json['date_time'] ?? '',
      jobDescription: json['job_description'] ?? '',
      image: json['image'],
      status: json['status'] ?? 'active', // Default to 'active' if status is null
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      category: JobCategory.fromJson(json['category'] ?? {}),
      user: json['user'] != null ? JobUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'job_title': jobTitle,
      'job_category_id': jobCategoryId,
      'payment': payment,
      'address': address,
      'date_time': dateTime,
      'job_description': jobDescription,
      'image': image,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category': category.toJson(),
      'user': user?.toJson(),
    };
  }
}

class CreateJobRequest {
  final String jobTitle;
  final int jobCategoryId;
  final double payment;
  final String address;
  final String dateTime;
  final String jobDescription;
  final String? image;

  CreateJobRequest({
    required this.jobTitle,
    required this.jobCategoryId,
    required this.payment,
    required this.address,
    required this.dateTime,
    required this.jobDescription,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'job_title': jobTitle,
      'job_category_id': jobCategoryId,
      'payment': payment,
      'address': address,
      'date_time': dateTime,
      'job_description': jobDescription,
      if (image != null) 'image': image,
    };
  }
}

class UpdateJobRequest {
  final String? jobTitle;
  final int? jobCategoryId;
  final double? payment;
  final String? address;
  final String? dateTime;
  final String? jobDescription;
  final String? image;

  UpdateJobRequest({
    this.jobTitle,
    this.jobCategoryId,
    this.payment,
    this.address,
    this.dateTime,
    this.jobDescription,
    this.image,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (jobTitle != null) data['job_title'] = jobTitle;
    if (jobCategoryId != null) data['job_category_id'] = jobCategoryId;
    if (payment != null) data['payment'] = payment;
    if (address != null) data['address'] = address;
    if (dateTime != null) data['date_time'] = dateTime;
    if (jobDescription != null) data['job_description'] = jobDescription;
    if (image != null) data['image'] = image;
    return data;
  }
}
