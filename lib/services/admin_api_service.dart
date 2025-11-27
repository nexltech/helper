import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminApiService {
  static const String baseUrl = 'http://helper.nexltech.com/public/api';
  String? _authToken;

  // Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Get headers with authorization
  Map<String, String> _getHeaders({bool includeBody = true}) {
    final headers = <String, String>{
      'Accept': 'application/json',
      if (includeBody) 'Content-Type': 'application/json',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  // 1. List Users by Status API
  Future<Map<String, dynamic>> getUsersByStatus(String status) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/users/$status'),
        headers: _getHeaders(includeBody: false),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch users: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // 2. Review User API (Approve/Reject)
  Future<Map<String, dynamic>> reviewUser({
    required int userId,
    required String action, // 'approve' or 'reject'
    required String comment,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/admin/users/$userId/review'),
        headers: _getHeaders(),
        body: json.encode({
          'action': action,
          'comment': comment,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to review user: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error reviewing user: $e');
    }
  }

  // 3. Suspend User API
  Future<Map<String, dynamic>> suspendUser({
    required int userId,
    required String comment,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/admin/users/$userId/suspend'),
        headers: _getHeaders(),
        body: json.encode({
          'comment': comment,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to suspend user: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error suspending user: $e');
    }
  }

  // 4. Reactivate User API
  Future<Map<String, dynamic>> reactivateUser({
    required int userId,
    required String comment,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/admin/users/$userId/reactivate'),
        headers: _getHeaders(),
        body: json.encode({
          'comment': comment,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to reactivate user: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error reactivating user: $e');
    }
  }

  // 5. Comment on User API
  Future<Map<String, dynamic>> commentOnUser({
    required int userId,
    required String comment,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin/users/$userId/comment'),
        headers: _getHeaders(),
        body: json.encode({
          'comment': comment,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add comment: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error adding comment: $e');
    }
  }

  // 6. View User Profile API
  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/users/$userId/profile'),
        headers: _getHeaders(includeBody: false),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch user profile: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  // Helper method to get all user statuses at once
  Future<Map<String, List<dynamic>>> getAllUsers() async {
    try {
      final results = await Future.wait([
        getUsersByStatus('pending'),
        getUsersByStatus('active'),
        getUsersByStatus('suspended'),
      ]);

      return {
        'pending': results[0]['users'] ?? [],
        'active': results[1]['users'] ?? [],
        'suspended': results[2]['users'] ?? [],
      };
    } catch (e) {
      throw Exception('Error fetching all users: $e');
    }
  }
}

