import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_model.dart';

class ChatApiService {
  static const String baseUrl = 'http://helper.nexltech.com/public/api';
  String? _authToken;

  // Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Start Chat API
  Future<StartChatResponse> startChat({
    required int applicationId,
    required int receiverId,
  }) async {
    try {
      print('ChatApiService: Starting chat for application: $applicationId, receiver: $receiverId');
      
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
      };

      final request = http.Request(
        'POST',
        Uri.parse('$baseUrl/chats/start'),
      );
      
      request.headers.addAll(headers);
      request.body = jsonEncode({
        'application_id': applicationId,
        'receiver_id': receiverId,
      });

      print('ChatApiService: Making request to: ${request.url}');
      print('ChatApiService: Request body: ${request.body}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      print('ChatApiService: Response status: ${response.statusCode}');
      print('ChatApiService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return StartChatResponse.fromJson(responseData);
      } else {
        final errorMessage = 'Failed to start chat: ${response.statusCode}';
        print('ChatApiService: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('ChatApiService: Start chat error: $e');
      rethrow;
    }
  }

  // Send Message API
  Future<SendMessageResponse> sendMessage({
    required int chatId,
    required String message,
  }) async {
    try {
      print('ChatApiService: Sending message to chat: $chatId');
      
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
      };

      final request = http.Request(
        'POST',
        Uri.parse('$baseUrl/messages/send'),
      );
      
      request.headers.addAll(headers);
      request.body = jsonEncode({
        'chat_id': chatId,
        'message': message,
      });

      print('ChatApiService: Making request to: ${request.url}');
      print('ChatApiService: Request body: ${request.body}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      print('ChatApiService: Response status: ${response.statusCode}');
      print('ChatApiService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return SendMessageResponse.fromJson(responseData);
      } else {
        final errorMessage = 'Failed to send message: ${response.statusCode}';
        print('ChatApiService: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('ChatApiService: Send message error: $e');
      rethrow;
    }
  }

  // Get All Chats API
  Future<GetChatsResponse> getAllChats() async {
    try {
      print('ChatApiService: Fetching all chats');
      
      final headers = {
        'Authorization': 'Bearer $_authToken',
      };

      final request = http.Request(
        'GET',
        Uri.parse('$baseUrl/my-chats'),
      );
      
      request.headers.addAll(headers);

      print('ChatApiService: Making request to: ${request.url}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      print('ChatApiService: Response status: ${response.statusCode}');
      print('ChatApiService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          return GetChatsResponse.fromJson(responseData);
        } catch (parseError) {
          print('ChatApiService: JSON parsing error: $parseError');
          print('ChatApiService: Response body: ${response.body}');
          throw Exception('Failed to parse chat data: $parseError');
        }
      } else {
        final errorMessage = 'Failed to get chats: ${response.statusCode}';
        print('ChatApiService: $errorMessage');
        print('ChatApiService: Response body: ${response.body}');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('ChatApiService: Get chats error: $e');
      rethrow;
    }
  }

  // Get Chat Messages API
  Future<GetChatMessagesResponse> getChatMessages(int chatId) async {
    try {
      print('ChatApiService: Fetching messages for chat: $chatId');
      
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
      };

      final request = http.Request(
        'GET',
        Uri.parse('$baseUrl/chats/$chatId/messages'),
      );
      
      request.headers.addAll(headers);

      print('ChatApiService: Making request to: ${request.url}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      print('ChatApiService: Response status: ${response.statusCode}');
      print('ChatApiService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          return GetChatMessagesResponse.fromJson(responseData);
        } catch (parseError) {
          print('ChatApiService: JSON parsing error: $parseError');
          print('ChatApiService: Response body: ${response.body}');
          throw Exception('Failed to parse chat messages: $parseError');
        }
      } else {
        final errorMessage = 'Failed to get chat messages: ${response.statusCode}';
        print('ChatApiService: $errorMessage');
        print('ChatApiService: Response body: ${response.body}');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('ChatApiService: Get chat messages error: $e');
      rethrow;
    }
  }
}
