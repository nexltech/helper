import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/applicant_model.dart';
import '../models/my_application_model.dart';

class CrudJobApiService {
  static const String baseUrl = 'http://helper.nexltech.com/public/api';
  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
  }

  // Get auth token from SharedPreferences if not set
  Future<String?> _getAuthToken() async {
    print('_getAuthToken: Checking _authToken field...');
    if (_authToken != null && _authToken!.isNotEmpty) {
      print('_getAuthToken: Using existing _authToken (length: ${_authToken!.length})');
      return _authToken;
    }
    
    print('_getAuthToken: _authToken not set, checking SharedPreferences...');
    // Try to get from SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? prefs.getString('auth_token');
      print('_getAuthToken: Token from prefs: ${token != null ? (token.isNotEmpty ? "Found (length: ${token.length})" : "Empty string") : "NULL"}');
      
      if (token != null && token.isNotEmpty) {
        _authToken = token;
        print('_getAuthToken: Token set to _authToken field');
        return token;
      } else {
        print('_getAuthToken: WARNING - No token found in SharedPreferences!');
      }
    } catch (e) {
      print('_getAuthToken: Error getting token from SharedPreferences: $e');
    }
    
    print('_getAuthToken: Returning null/empty token');
    return _authToken;
  }

  Future<Map<String, String>> _getHeaders({String contentType = 'application/json', bool includeBody = true}) async {
    final token = await _getAuthToken();
    
    if (token == null || token.isEmpty) {
      throw Exception('Auth token not set. Please log in again.');
    }
    
    final headers = <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    
    if (includeBody) {
      headers['Content-Type'] = contentType;
    }
    
    return headers;
  }

  // 1. Create Job Post API
  Future<Map<String, dynamic>> createJobPost({
    required String jobTitle,
    required int jobCategoryId,
    required double payment,
    required String address,
    required String dateTime,
    required String jobDescription,
    String? image,
  }) async {
    final token = await _getAuthToken();
    if (token == null || token.isEmpty) {
      throw Exception('Auth token not set. Please log in again.');
    }

    try {
      // Format the date_time to match API expectations (YYYY-MM-DD HH:mm:ss)
      String formattedDateTime = _formatDateTime(dateTime);
      print('=== DATE TIME DEBUG ===');
      print('Original dateTime: $dateTime');
      print('Formatted dateTime: $formattedDateTime');
      print('Expected format: YYYY-MM-DD HH:MM:SS');
      print('Format matches expected: ${RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$').hasMatch(formattedDateTime)}');
      print('========================');
      
      // Check if image is a file path and convert to multipart if needed
      if (image != null && image.isNotEmpty && File(image).existsSync()) {
        return await _createJobPostWithImage(
          jobTitle: jobTitle,
          jobCategoryId: jobCategoryId,
          payment: payment,
          address: address,
          dateTime: formattedDateTime,
          jobDescription: jobDescription,
          imageFile: File(image),
        );
      } else {
        // Create job post without image
        final Map<String, dynamic> requestBody = {
          'job_title': jobTitle,
          'job_category_id': jobCategoryId,
          'payment': payment,
          'address': address,
          'date_time': formattedDateTime,
          'job_description': jobDescription,
        };

        print('Sending request to: $baseUrl/job-post');
        print('Request body: $requestBody');

        final headers = await _getHeaders();
        final response = await http.post(
          Uri.parse('$baseUrl/job-post'),
          headers: headers,
          body: json.encode(requestBody),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          return json.decode(response.body);
        } else {
          // Try to parse error response for more details
          try {
            final errorBody = json.decode(response.body);
            if (errorBody['message'] != null) {
              throw Exception('Failed to create job: ${errorBody['message']}');
            } else if (errorBody['errors'] != null) {
              final errors = errorBody['errors'];
              final errorMessages = <String>[];
              errors.forEach((key, value) {
                if (value is List) {
                  errorMessages.addAll(value.map((e) => '$key: $e'));
                } else {
                  errorMessages.add('$key: $value');
                }
              });
              throw Exception('Validation errors: ${errorMessages.join(', ')}');
            }
          } catch (e) {
            // If we can't parse the error response, use the raw response
          }
          throw Exception('Failed to create job: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}');
        }
      }
    } catch (e) {
      throw Exception('Error creating job: $e');
    }
  }

  // Helper method to create job post with image using multipart
  Future<Map<String, dynamic>> _createJobPostWithImage({
    required String jobTitle,
    required int jobCategoryId,
    required double payment,
    required String address,
    required String dateTime,
    required String jobDescription,
    required File imageFile,
  }) async {
    try {
      // Get token first and verify
      final token = await _getAuthToken();
      print('=== MULTIPART REQUEST DEBUG ===');
      print('Token retrieved: ${token != null ? "${token.substring(0, token.length > 10 ? 10 : token.length)}..." : "NULL"}');
      
      if (token == null || token.isEmpty) {
        throw Exception('Auth token not set. Please log in again.');
      }
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/job-post'),
      );

      // Add headers
      final headers = await _getHeaders(contentType: 'multipart/form-data', includeBody: false);
      print('Headers being added: ${headers.keys}');
      print('Authorization header present: ${headers.containsKey('Authorization')}');
      if (headers.containsKey('Authorization')) {
        print('Authorization value: ${headers['Authorization']?.substring(0, headers['Authorization']!.length > 30 ? 30 : headers['Authorization']!.length)}...');
      }
      request.headers.addAll(headers);
      print('Request headers after adding: ${request.headers.keys}');
      print('Request Authorization: ${request.headers['Authorization']?.substring(0, request.headers['Authorization']!.length > 30 ? 30 : request.headers['Authorization']!.length)}...');
      print('==============================');

      // Add text fields
      request.fields['job_title'] = jobTitle;
      request.fields['job_category_id'] = jobCategoryId.toString();
      request.fields['payment'] = payment.toString();
      request.fields['address'] = address;
      request.fields['date_time'] = dateTime;
      request.fields['job_description'] = jobDescription;
      
      print('Multipart date_time field: ${request.fields['date_time']}');

      // Add image file
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ));

      print('Sending multipart request to: $baseUrl/job-post');
      print('Request URL: ${request.url}');
      print('Request Method: ${request.method}');
      print('Request Headers: ${request.headers}');
      print('Authorization Header: ${request.headers['Authorization'] ?? "MISSING!"}');
      print('Fields: ${request.fields}');
      print('Files: ${request.files.length}');

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        // Try to parse error response for more details
        try {
          final errorBody = json.decode(response.body);
          if (errorBody['message'] != null) {
            throw Exception('Failed to create job: ${errorBody['message']}');
          } else if (errorBody['errors'] != null) {
            final errors = errorBody['errors'];
            final errorMessages = <String>[];
            errors.forEach((key, value) {
              if (value is List) {
                errorMessages.addAll(value.map((e) => '$key: $e'));
              } else {
                errorMessages.add('$key: $value');
              }
            });
            throw Exception('Validation errors: ${errorMessages.join(', ')}');
          }
        } catch (e) {
          // If we can't parse the error response, use the raw response
        }
        throw Exception('Failed to create job: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating job with image: $e');
    }
  }

  // 2. Update Job Post API
  Future<Map<String, dynamic>> updateJobPost({
    required int jobId,
    String? jobTitle,
    int? jobCategoryId,
    double? payment,
    String? address,
    String? dateTime,
    String? jobDescription,
    String? image,
  }) async {
    if (_authToken == null) {
      throw Exception('Auth token not set');
    }

    try {
      final Map<String, dynamic> body = {};
      if (jobTitle != null) body['job_title'] = jobTitle;
      if (jobCategoryId != null) body['job_category_id'] = jobCategoryId;
      if (payment != null) body['payment'] = payment;
      if (address != null) body['address'] = address;
      if (dateTime != null) body['date_time'] = _formatDateTime(dateTime);
      if (jobDescription != null) body['job_description'] = jobDescription;
      if (image != null && image.isNotEmpty) body['image'] = image;

      final headers = await _getHeaders();
      final response = await http.patch(
        Uri.parse('$baseUrl/job-post/$jobId'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update job: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating job: $e');
    }
  }

  // 3. Delete Job Post API
  Future<Map<String, dynamic>> deleteJobPost(int jobId) async {
    if (_authToken == null) {
      throw Exception('Auth token not set');
    }

    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/job-post/$jobId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete job: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error deleting job: $e');
    }
  }

  // 4. List All Jobs API
  Future<List<Map<String, dynamic>>> getAllJobs() async {
    if (_authToken == null) {
      throw Exception('Auth token not set');
    }

    try {
      final headers = await _getHeaders(includeBody: false);
      final response = await http.get(
        Uri.parse('$baseUrl/job-posts'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      } else {
        throw Exception('Failed to fetch jobs: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching jobs: $e');
    }
  }

  // 5. Show Single Job API
  Future<Map<String, dynamic>> getJobById(int jobId) async {
    if (_authToken == null) {
      throw Exception('Auth token not set');
    }

    try {
      final headers = await _getHeaders(includeBody: false);
      final response = await http.get(
        Uri.parse('$baseUrl/job-post/$jobId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to fetch job: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching job: $e');
    }
  }

  // 6. Get Job Applicants API
  Future<JobApplicantsResponse> getJobApplicants(int jobId) async {
    if (_authToken == null) {
      throw Exception('Auth token not set');
    }

    try {
      final headers = await _getHeaders(includeBody: false);
      final response = await http.get(
        Uri.parse('$baseUrl/jobs/$jobId/applications'),
        headers: headers,
      );

      print('Get Job Applicants Response status: ${response.statusCode}');
      print('Get Job Applicants Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return JobApplicantsResponse.fromJson(data);
      } else {
        throw Exception('Failed to fetch job applicants: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching job applicants: $e');
    }
  }

  // 7. Accept Application API
  Future<Map<String, dynamic>> acceptApplication(int applicationId) async {
    if (_authToken == null) {
      throw Exception('Auth token not set');
    }

    try {
      final headers = await _getHeaders(includeBody: false);
      final response = await http.post(
        Uri.parse('$baseUrl/applications/$applicationId/accept'),
        headers: headers,
      );

      print('Accept Application Response status: ${response.statusCode}');
      print('Accept Application Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to accept application: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error accepting application: $e');
    }
  }

  // 8. Cancel Application API
  Future<Map<String, dynamic>> cancelApplication(int applicationId) async {
    if (_authToken == null) {
      throw Exception('Auth token not set');
    }

    try {
      final headers = await _getHeaders(includeBody: false);
      final response = await http.post(
        Uri.parse('$baseUrl/applications/$applicationId/cancel'),
        headers: headers,
      );

      print('Cancel Application Response status: ${response.statusCode}');
      print('Cancel Application Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to cancel application: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error cancelling application: $e');
    }
  }

  // 9. Start Application API
  Future<Map<String, dynamic>> startApplication(int applicationId) async {
    if (_authToken == null) {
      throw Exception('Auth token not set');
    }

    try {
      final headers = await _getHeaders(includeBody: false);
      final response = await http.post(
        Uri.parse('$baseUrl/applications/$applicationId/start'),
        headers: headers,
      );

      print('Start Application Response status: ${response.statusCode}');
      print('Start Application Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to start application: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error starting application: $e');
    }
  }

  // 9. Get My Applications API
  Future<MyApplicationsResponse> getMyApplications() async {
    if (_authToken == null) {
      throw Exception('Auth token not set');
    }

    try {
      final headers = await _getHeaders(includeBody: false);
      final response = await http.get(
        Uri.parse('$baseUrl/my-applications'),
        headers: headers,
      );

      print('Get My Applications Response status: ${response.statusCode}');
      print('Get My Applications Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return MyApplicationsResponse.fromJson(data);
      } else {
        throw Exception('Failed to fetch my applications: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching my applications: $e');
    }
  }

  // 10. Apply for Job API
  Future<Map<String, dynamic>> applyForJob({
    required int jobId,
    required String coverLetter,
    required List<String> availability,
  }) async {
    final token = await _getAuthToken();
    if (token == null || token.isEmpty) {
      throw Exception('Auth token not set. Please log in again.');
    }

    print('=== APPLY FOR JOB API DEBUG ===');
    print('Job ID: $jobId');
    print('Cover Letter: $coverLetter');
    print('Availability: $availability');
    print('Auth Token: ${_authToken?.substring(0, 10)}...');
    print('API URL: $baseUrl/jobs/$jobId/apply');

    try {
      final requestBody = {
        'cover_letter': coverLetter,
        'availability': availability,
      };
      
      print('Request Body: ${json.encode(requestBody)}');

      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/jobs/$jobId/apply'),
        headers: headers,
        body: json.encode(requestBody),
      );

      print('Apply for Job Response status: ${response.statusCode}');
      print('Apply for Job Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('Success! Application submitted: ${responseData['message']}');
        return responseData;
      } else if (response.statusCode == 422) {
        // Validation error
        final errorData = json.decode(response.body);
        print('Validation Error: $errorData');
        throw Exception('Validation error: ${errorData['message'] ?? 'Invalid data provided'}');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please check your authentication token');
      } else if (response.statusCode == 404) {
        throw Exception('Job not found: The job you\'re trying to apply for doesn\'t exist');
      } else {
        throw Exception('Failed to apply for job: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}');
      }
    } catch (e) {
      print('Apply for Job Error: $e');
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error: Please check your internet connection');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout: Please try again');
      } else {
        throw Exception('Error applying for job: $e');
      }
    }
  }

  // 11. Get Active Jobs API
  Future<List<Map<String, dynamic>>> getActiveJobs() async {
    if (_authToken == null) {
      throw Exception('Auth token not set');
    }

    try {
      final headers = await _getHeaders(includeBody: false);
      final response = await http.get(
        Uri.parse('$baseUrl/jobs/active'),
        headers: headers,
      );

      print('Get Active Jobs Response status: ${response.statusCode}');
      print('Get Active Jobs Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to fetch active jobs: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching active jobs: $e');
    }
  }

  // Helper method to format date time to API expected format
  String _formatDateTime(String dateTime) {
    try {
      print('_formatDateTime input: $dateTime');
      
      // If the dateTime is already in the correct format (YYYY-MM-DD HH:mm:ss), return as is
      if (RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$').hasMatch(dateTime)) {
        print('Already in correct format: $dateTime');
        return dateTime;
      }
      
      // If it's in format like "31/10/2025 at 10:30", parse and convert (DD/MM/YYYY format)
      if (dateTime.contains(' at ')) {
        final parts = dateTime.split(' at ');
        final datePart = parts[0];
        final timePart = parts[1];
        
        print('Date part: $datePart, Time part: $timePart');
        
        // Parse date (DD/MM/YYYY format - original working format)
        final dateComponents = datePart.split('/');
        if (dateComponents.length == 3) {
          final day = dateComponents[0].padLeft(2, '0');
          final month = dateComponents[1].padLeft(2, '0');
          final year = dateComponents[2];
          
          print('Parsed date - Day: $day, Month: $month, Year: $year');
          
          // Format time properly - ensure it has seconds and remove AM/PM
          String formattedTime;
          if (timePart.contains(':')) {
            // Remove AM/PM from time part
            String cleanTime = timePart.replaceAll(RegExp(r'\s*(AM|PM)', caseSensitive: false), '');
            final timeComponents = cleanTime.split(':');
            if (timeComponents.length == 2) {
              // Add seconds if not present
              formattedTime = '${timeComponents[0].padLeft(2, '0')}:${timeComponents[1].padLeft(2, '0')}:00';
            } else {
              formattedTime = cleanTime;
            }
          } else {
            formattedTime = '10:00:00'; // Default time
          }
          
          final result = '$year-$month-$day $formattedTime';
          print('Formatted result: $result');
          return result;
        }
      }
      
      // If it's in format like "31/10/2025", add default time (DD/MM/YYYY format)
      if (dateTime.contains('/')) {
        final dateComponents = dateTime.split('/');
        if (dateComponents.length == 3) {
          final day = dateComponents[0].padLeft(2, '0');
          final month = dateComponents[1].padLeft(2, '0');
          final year = dateComponents[2];
          
          final result = '$year-$month-$day 10:00:00';
          print('Date only result: $result');
          return result;
        }
      }
      
      // Try to parse as DateTime and format
      try {
        final parsedDate = DateTime.parse(dateTime);
        final result = '${parsedDate.year.toString().padLeft(4, '0')}-'
               '${parsedDate.month.toString().padLeft(2, '0')}-'
               '${parsedDate.day.toString().padLeft(2, '0')} '
               '${parsedDate.hour.toString().padLeft(2, '0')}:'
               '${parsedDate.minute.toString().padLeft(2, '0')}:'
               '${parsedDate.second.toString().padLeft(2, '0')}';
        print('DateTime.parse result: $result');
        return result;
      } catch (e) {
        print('DateTime.parse failed: $e');
        // If all parsing fails, return a default datetime
        final result = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')} 10:00:00';
        print('Fallback result: $result');
        return result;
      }
    } catch (e) {
      print('_formatDateTime error: $e');
      // Fallback to current date and time
      final now = DateTime.now();
      final result = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      print('Final fallback result: $result');
      return result;
    }
  }

  // Complete Application API
  Future<Map<String, dynamic>> completeApplication(int applicationId) async {
    try {
      print('CrudJobApiService: Starting complete application for ID: $applicationId');
      
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_authToken',
      };

      final request = http.Request(
        'POST', 
        Uri.parse('$baseUrl/applications/$applicationId/complete')
      );
      
      request.headers.addAll(headers);

      print('CrudJobApiService: Making request to: ${request.url}');
      print('CrudJobApiService: Headers: $headers');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      print('CrudJobApiService: Response status: ${response.statusCode}');
      print('CrudJobApiService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('CrudJobApiService: Complete application successful');
        return responseData;
      } else {
        final errorMessage = 'Failed to complete application: ${response.statusCode}';
        print('CrudJobApiService: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('CrudJobApiService: Complete application error: $e');
      rethrow;
    }
  }

}
