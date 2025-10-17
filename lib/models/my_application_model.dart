class MyApplication {
  final int id;
  final String jobPostId;
  final String userId;
  final String coverLetter;
  final String status;
  final String createdAt;
  final String updatedAt;
  final JobPostInfo jobPost;

  MyApplication({
    required this.id,
    required this.jobPostId,
    required this.userId,
    required this.coverLetter,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.jobPost,
  });

  factory MyApplication.fromJson(Map<String, dynamic> json) {
    return MyApplication(
      id: json['id'],
      jobPostId: json['job_post_id'].toString(),
      userId: json['user_id'].toString(),
      coverLetter: json['cover_letter'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      jobPost: JobPostInfo.fromJson(json['job_post']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_post_id': jobPostId,
      'user_id': userId,
      'cover_letter': coverLetter,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'job_post': jobPost.toJson(),
    };
  }
}

class JobPostInfo {
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

  JobPostInfo({
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
  });

  factory JobPostInfo.fromJson(Map<String, dynamic> json) {
    return JobPostInfo(
      id: json['id'],
      userId: json['user_id'].toString(),
      jobTitle: json['job_title'],
      jobCategoryId: json['job_category_id'].toString(),
      payment: json['payment'],
      address: json['address'],
      dateTime: json['date_time'],
      jobDescription: json['job_description'],
      image: json['image'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
    };
  }
}

class MyApplicationsResponse {
  final String message;
  final List<MyApplication> data;

  MyApplicationsResponse({
    required this.message,
    required this.data,
  });

  factory MyApplicationsResponse.fromJson(Map<String, dynamic> json) {
    return MyApplicationsResponse(
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => MyApplication.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
