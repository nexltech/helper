import 'admin_user_model.dart';

class UserProfile {
  final AdminUser user;
  final Map<String, dynamic>? hireHelp;
  final Map<String, dynamic>? offerHelp;
  final Map<String, dynamic>? bothHelp;

  UserProfile({
    required this.user,
    this.hireHelp,
    this.offerHelp,
    this.bothHelp,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      user: AdminUser.fromJson(json['user']),
      hireHelp: json['user']['hire_help'],
      offerHelp: json['user']['offer_help'],
      bothHelp: json['user']['both_help'],
    );
  }
}
