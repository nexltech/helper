import 'dart:convert';
import 'package:http/http.dart' as http;

class ReviewApiService {
  static const String baseUrl = 'http://helper.nexltech.com/public/api';

  // Add review for an application
  static Future<Map<String, dynamic>?> addReview({
    required String token,
    required int applicationId,
    required int rating,
    required String comment,
  }) async {
    try {
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final request = http.Request(
        'POST',
        Uri.parse('$baseUrl/applications/$applicationId/review'),
      );

      request.body = json.encode({
        'rating': rating,
        'comment': comment,
      });
      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return json.decode(responseBody);
      } else if (response.statusCode == 409) {
        // Handle conflict - review already exists
        final responseBody = await response.stream.bytesToString();
        final errorData = json.decode(responseBody);
        return {
          'error': true,
          'message': errorData['message'] ?? 'Review already exists',
          'statusCode': 409,
        };
      } else {
        print('Error adding review: ${response.reasonPhrase}');
        return {
          'error': true,
          'message': 'Failed to add review: ${response.reasonPhrase}',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print('Exception in addReview: $e');
      return null;
    }
  }

  // Get user reviews
  static Future<List<dynamic>?> getUserReviews({
    required String token,
    required int userId,
  }) async {
    try {
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final request = http.Request(
        'GET',
        Uri.parse('$baseUrl/users/$userId/reviews'),
      );

      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return json.decode(responseBody);
      } else {
        print('Error getting user reviews: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception in getUserReviews: $e');
      return null;
    }
  }

  // Get reviews for a specific user (for profile display)
  static Future<List<dynamic>?> getReviewsForUser({
    required String token,
    required int userId,
  }) async {
    try {
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final request = http.Request(
        'GET',
        Uri.parse('$baseUrl/users/$userId/reviews'),
      );

      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return json.decode(responseBody);
      } else {
        print('Error getting reviews for user: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception in getReviewsForUser: $e');
      return null;
    }
  }
}
