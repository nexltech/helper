import 'package:flutter/foundation.dart';
import '../models/chat_model.dart';
import '../services/chat_api_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatApiService _apiService = ChatApiService();
  
  // State variables
  List<Chat> _chats = [];
  Chat? _currentChat;
  List<ChatMessage> _currentChatMessages = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  List<Chat> get chats => _chats;
  Chat? get currentChat => _currentChat;
  List<ChatMessage> get currentChatMessages => _currentChatMessages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // Set auth token
  void setAuthToken(String token) {
    _apiService.setAuthToken(token);
  }

  // Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccess(String success) {
    _successMessage = success;
    _errorMessage = null;
    notifyListeners();
  }

  // Start a new chat
  Future<void> startChat({
    required int applicationId,
    required int receiverId,
  }) async {
    _setLoading(true);
    _setError('');

    try {
      final response = await _apiService.startChat(
        applicationId: applicationId,
        receiverId: receiverId,
      );
      
      _currentChat = response.chat;
      _currentChatMessages = response.chat.messages;
      _setSuccess(response.message);
      
      // Add to chats list if not already present
      if (!_chats.any((chat) => chat.id == response.chat.id)) {
        _chats.insert(0, response.chat);
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to start chat: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Send a message
  Future<void> sendMessage({
    required int chatId,
    required String message,
  }) async {
    _setLoading(true);
    _setError('');

    try {
      final response = await _apiService.sendMessage(
        chatId: chatId,
        message: message,
      );
      
      // Add message to current chat messages
      _currentChatMessages.add(response.data);
      
      // Update the chat in the chats list
      final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
      if (chatIndex != -1) {
        _chats[chatIndex] = Chat(
          id: _chats[chatIndex].id,
          applicationId: _chats[chatIndex].applicationId,
          senderId: _chats[chatIndex].senderId,
          receiverId: _chats[chatIndex].receiverId,
          createdAt: _chats[chatIndex].createdAt,
          updatedAt: _chats[chatIndex].updatedAt,
          application: _chats[chatIndex].application,
          sender: _chats[chatIndex].sender,
          receiver: _chats[chatIndex].receiver,
          messages: [..._chats[chatIndex].messages, response.data],
        );
      }
      
      _setSuccess(response.message);
      notifyListeners();
    } catch (e) {
      _setError('Failed to send message: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get all chats
  Future<void> getAllChats() async {
    _setLoading(true);
    _setError('');

    try {
      final response = await _apiService.getAllChats();
      _chats = response.data;
      _setSuccess(response.message);
      notifyListeners();
    } catch (e) {
      _setError('Failed to get chats: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get chat messages
  Future<void> getChatMessages(int chatId) async {
    _setLoading(true);
    _setError('');

    try {
      final response = await _apiService.getChatMessages(chatId);
      _currentChat = response.chat;
      _currentChatMessages = response.messages;
      _setSuccess('Messages loaded successfully');
      notifyListeners();
    } catch (e) {
      _setError('Failed to get chat messages: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Set current chat
  void setCurrentChat(Chat chat) {
    _currentChat = chat;
    _currentChatMessages = chat.messages;
    notifyListeners();
  }

  // Clear current chat
  void clearCurrentChat() {
    _currentChat = null;
    _currentChatMessages = [];
    notifyListeners();
  }

  // Get chat by ID
  Chat? getChatById(int chatId) {
    try {
      return _chats.firstWhere((chat) => chat.id == chatId);
    } catch (e) {
      return null;
    }
  }

  // Get unread message count for a chat
  int getUnreadMessageCount(int chatId) {
    final chat = getChatById(chatId);
    if (chat == null) return 0;
    
    return chat.messages.where((message) => !message.isRead).length;
  }

  // Get total unread message count
  int getTotalUnreadMessageCount() {
    int total = 0;
    for (final chat in _chats) {
      total += getUnreadMessageCount(chat.id);
    }
    return total;
  }

  // Get last message for a chat
  ChatMessage? getLastMessage(int chatId) {
    final chat = getChatById(chatId);
    if (chat == null || chat.messages.isEmpty) return null;
    
    return chat.messages.last;
  }

  // Format message time
  String formatMessageTime(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 0) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (difference.inHours > 0) {
        return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateTime;
    }
  }

  // Check if message is from current user
  bool isMessageFromCurrentUser(ChatMessage message, int currentUserId) {
    return message.senderId == currentUserId.toString();
  }

  // Refresh all data
  Future<void> refreshAllData() async {
    await getAllChats();
  }

  // Clear all data
  void clearAllData() {
    _chats.clear();
    _currentChat = null;
    _currentChatMessages.clear();
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
