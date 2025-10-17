class Applicant {
  final int id;
  final String userId;
  final String coverLetter;
  final String status;
  final String createdAt;
  final ApplicantUser user;

  Applicant({
    required this.id,
    required this.userId,
    required this.coverLetter,
    required this.status,
    required this.createdAt,
    required this.user,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      id: json['id'],
      userId: json['user_id'].toString(),
      coverLetter: json['cover_letter'],
      status: json['status'],
      createdAt: json['created_at'],
      user: ApplicantUser.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'cover_letter': coverLetter,
      'status': status,
      'created_at': createdAt,
      'user': user.toJson(),
    };
  }
}

class ApplicantUser {
  final int id;
  final String name;
  final String email;

  ApplicantUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory ApplicantUser.fromJson(Map<String, dynamic> json) {
    return ApplicantUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
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

class JobApplicantsResponse {
  final String message;
  final JobInfo job;
  final List<Applicant> applicants;

  JobApplicantsResponse({
    required this.message,
    required this.job,
    required this.applicants,
  });

  factory JobApplicantsResponse.fromJson(Map<String, dynamic> json) {
    return JobApplicantsResponse(
      message: json['message'],
      job: JobInfo.fromJson(json['job']),
      applicants: (json['applicants'] as List)
          .map((applicant) => Applicant.fromJson(applicant))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'job': job.toJson(),
      'applicants': applicants.map((applicant) => applicant.toJson()).toList(),
    };
  }
}

class JobInfo {
  final int id;
  final String jobTitle;
  final String jobStatus;
  final String category;

  JobInfo({
    required this.id,
    required this.jobTitle,
    required this.jobStatus,
    required this.category,
  });

  factory JobInfo.fromJson(Map<String, dynamic> json) {
    return JobInfo(
      id: json['id'],
      jobTitle: json['job_title'],
      jobStatus: json['job_status'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_title': jobTitle,
      'job_status': jobStatus,
      'category': category,
    };
  }
}
