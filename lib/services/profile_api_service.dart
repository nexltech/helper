import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileApiService {
  static const String baseUrl = 'http://helper.nexltech.com/public/api';
  
  // Get stored auth token
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Get stored user ID
  static Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  // Convert file to base64 string
  static Future<String?> _fileToBase64(File? file) async {
    if (file == null) return null;
    try {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print('Error converting file to base64: $e');
      return null;
    }
  }

  // Register Offer Help (Worker)
  static Future<Map<String, dynamic>?> registerOfferHelp({
    required String fullName,
    required String email,
    required String location,
    required String bio,
    required bool is18OrOlder,
    required bool authorizedToWork,
    required bool consentBackgroundCheck,
    required bool criminalConvictions,
    required bool reliableTransportation,
    File? resume,
    File? certification,
    File? portfolio,
    File? idCardPhoto,
  }) async {
    try {
      final token = await _getAuthToken();
      final userId = await _getUserId();
      
      if (token == null || userId == null) {
        throw Exception('Authentication token or user ID not found');
      }

      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = {
        'user_id': userId,
        'full_name': fullName,
        'email': email,
        'location': location,
        'bio': bio,
        'is_18_or_older': is18OrOlder,
        'authorized_to_work': authorizedToWork,
        'consent_background_check': consentBackgroundCheck,
        'criminal_convictions': criminalConvictions,
        'reliable_transportation': reliableTransportation,
        'resume': await _fileToBase64(resume),
        'certification': await _fileToBase64(certification),
        'portfolio': await _fileToBase64(portfolio),
        'id_card_photo': await _fileToBase64(idCardPhoto),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/register-offer-help'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to register: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in registerOfferHelp: $e');
      rethrow;
    }
  }

  // Register Hire Help (Client)
  static Future<Map<String, dynamic>?> registerHireHelp({
    required String fullName,
    required String email,
    required String location,
    required String bio,
    required bool is18OrOlder,
    required bool consentBackgroundCheck,
    required bool criminalConvictions,
    File? idCardPhoto,
  }) async {
    try {
      final token = await _getAuthToken();
      final userId = await _getUserId();
      
      if (token == null || userId == null) {
        throw Exception('Authentication token or user ID not found');
      }

      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = {
        'user_id': userId,
        'full_name': fullName,
        'email': email,
        'location': location,
        'bio': bio,
        'is_18_or_older': is18OrOlder,
        'consent_background_check': consentBackgroundCheck,
        'criminal_convictions': criminalConvictions,
        'id_card_photo': await _fileToBase64(idCardPhoto),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/register-hire-help'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to register: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in registerHireHelp: $e');
      rethrow;
    }
  }

  // Register Both Help
  static Future<Map<String, dynamic>?> registerBothHelp({
    required String fullName,
    required String email,
    required String location,
    required String bio,
    required bool is18OrOlder,
    required bool authorizedToWork,
    required bool consentBackgroundCheck,
    required bool criminalConvictions,
    required bool reliableTransportation,
    File? resume,
    File? certification,
    File? portfolio,
    File? idCardPhoto,
  }) async {
    try {
      final token = await _getAuthToken();
      final userId = await _getUserId();
      
      if (token == null || userId == null) {
        throw Exception('Authentication token or user ID not found');
      }

      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = {
        'user_id': userId,
        'full_name': fullName,
        'email': email,
        'location': location,
        'bio': bio,
        'is_18_or_older': is18OrOlder,
        'authorized_to_work': authorizedToWork,
        'consent_background_check': consentBackgroundCheck,
        'criminal_convictions': criminalConvictions,
        'reliable_transportation': reliableTransportation,
        'resume': await _fileToBase64(resume),
        'certification': await _fileToBase64(certification),
        'portfolio': await _fileToBase64(portfolio),
        'id_card_photo': await _fileToBase64(idCardPhoto),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/register-both-help'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to register: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in registerBothHelp: $e');
      rethrow;
    }
  }

  // Check user approval status
  static Future<Map<String, dynamic>?> checkUserStatus() async {
    try {
      final token = await _getAuthToken();
      final userId = await _getUserId();
      
      if (token == null || userId == null) {
        throw Exception('Authentication token or user ID not found');
      }

      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse('$baseUrl/user-status/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to check status: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in checkUserStatus: $e');
      rethrow;
    }
  }

  // Login with status checking
  static Future<Map<String, dynamic>?> loginWithStatusCheck({
    required String email,
    required String password,
  }) async {
    try {
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        final errorData = json.decode(response.body);
        final message = errorData['message'] ?? 'Login failed';
        
        // Check if it's the "account not active" message
        if (message.contains('not active') || message.contains('admin approval')) {
          return {
            'success': false,
            'message': message,
            'status': 'pending',
          };
        } else {
          return {
            'success': false,
            'message': message,
            'status': 'error',
          };
        }
      }
    } catch (e) {
      print('Error in loginWithStatusCheck: $e');
      return {
        'success': false,
        'message': e.toString(),
        'status': 'error',
      };
    }
  }

  // Change email API
  static Future<Map<String, dynamic>?> changeEmail({
    required String newEmail,
    required String confirmEmail,
  }) async {
    try {
      final token = await _getAuthToken();
      
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        Uri.parse('$baseUrl/user/change-email'),
        headers: headers,
        body: json.encode({
          'new_email': newEmail,
          'confirm_email': confirmEmail,
        }),
      );

      print('Change email response status: ${response.statusCode}');
      print('Change email response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to change email');
      }
    } catch (e) {
      print('Error in changeEmail: $e');
      rethrow;
    }
  }

  // Change password API
  static Future<Map<String, dynamic>?> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final token = await _getAuthToken();
      
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        Uri.parse('$baseUrl/user/change-password'),
        headers: headers,
        body: json.encode({
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        }),
      );

      print('Change password response status: ${response.statusCode}');
      print('Change password response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      print('Error in changePassword: $e');
      rethrow;
    }
  }
}
