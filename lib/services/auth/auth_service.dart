import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'http://helper.nexltech.com/public/api';
  
  static const Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Register user
  static Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    try {
      print('AuthService: Starting registration for $email');
      
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'role': role,
        }),
      );

      print('AuthService: Registration response status: ${response.statusCode}');
      print('AuthService: Registration response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return UserModel.fromRegisterJson(responseData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception('Registration failed: ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('AuthService: Registration error: $e');
      rethrow;
    }
  }

  // Login user
  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      print('AuthService: Starting login for $email');
      
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('AuthService: Login response status: ${response.statusCode}');
      print('AuthService: Login response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return UserModel.fromLoginJson(responseData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception('Login failed: ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('AuthService: Login error: $e');
      rethrow;
    }
  }

  // Update user data
  static Future<UserModel> putUserJson({
    required String token,
    required Map<String, dynamic> payload,
  }) async {
    try {
      print('AuthService: Starting user update');
      
      final Map<String, String> authHeaders = {
        ...headers,
        'Authorization': 'Bearer $token',
      };

      final response = await http.put(
        Uri.parse('$baseUrl/user'),
        headers: authHeaders,
        body: jsonEncode(payload),
      );

      print('AuthService: Update response status: ${response.statusCode}');
      print('AuthService: Update response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return UserModel.fromLoginJson(responseData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception('Update failed: ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('AuthService: Update error: $e');
      rethrow;
    }
  }
}
