import 'package:flutter/material.dart';
import '../services/admin_api_service.dart';
import '../models/admin_user_model.dart';
import '../models/user_profile_model.dart';

class AdminProvider extends ChangeNotifier {
  final AdminApiService _apiService = AdminApiService();
  
  // State variables
  List<AdminUser> _pendingUsers = [];
  List<AdminUser> _activeUsers = [];
  List<AdminUser> _suspendedUsers = [];
  UserProfile? _selectedUserProfile;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  List<AdminUser> get pendingUsers => _pendingUsers;
  List<AdminUser> get activeUsers => _activeUsers;
  List<AdminUser> get suspendedUsers => _suspendedUsers;
  UserProfile? get selectedUserProfile => _selectedUserProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // Set authentication token
  void setAuthToken(String token) {
    _apiService.setAuthToken(token);
  }

  // Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setError(String error) {
    _errorMessage = error;
    _successMessage = null;
    notifyListeners();
  }

  // Set success message
  void _setSuccess(String success) {
    _successMessage = success;
    _errorMessage = null;
    notifyListeners();
  }

  // 1. Fetch all users by status
  Future<void> fetchAllUsers() async {
    _setLoading(true);
    _setError('');
    
    try {
      final result = await _apiService.getAllUsers();
      
      _pendingUsers = (result['pending'] as List)
          .map((user) => AdminUser.fromJson(user))
          .toList();
      
      _activeUsers = (result['active'] as List)
          .map((user) => AdminUser.fromJson(user))
          .toList();
      
      _suspendedUsers = (result['suspended'] as List)
          .map((user) => AdminUser.fromJson(user))
          .toList();
      
      _setSuccess('Users fetched successfully');
    } catch (e) {
      _setError('Failed to fetch users: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 2. Fetch users by specific status
  Future<void> fetchUsersByStatus(String status) async {
    _setLoading(true);
    _setError('');
    
    try {
      final result = await _apiService.getUsersByStatus(status);
      final users = (result['users'] as List)
          .map((user) => AdminUser.fromJson(user))
          .toList();
      
      switch (status) {
        case 'pending':
          _pendingUsers = users;
          break;
        case 'active':
          _activeUsers = users;
          break;
        case 'suspended':
          _suspendedUsers = users;
          break;
      }
      
      _setSuccess('$status users fetched successfully');
    } catch (e) {
      _setError('Failed to fetch $status users: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 3. Review user (approve/reject)
  Future<void> reviewUser({
    required int userId,
    required String action,
    required String comment,
  }) async {
    _setLoading(true);
    _setError('');
    
    try {
      final result = await _apiService.reviewUser(
        userId: userId,
        action: action,
        comment: comment,
      );
      
      // Update the user in the appropriate list
      final updatedUser = AdminUser.fromJson(result['user']);
      _updateUserInLists(updatedUser);
      
      _setSuccess(result['message'] ?? 'User $action successfully');
    } catch (e) {
      _setError('Failed to $action user: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 4. Suspend user
  Future<void> suspendUser({
    required int userId,
    required String comment,
  }) async {
    _setLoading(true);
    _setError('');
    
    try {
      final result = await _apiService.suspendUser(
        userId: userId,
        comment: comment,
      );
      
      // Update the user in the appropriate list
      final updatedUser = AdminUser.fromJson(result['user']);
      _updateUserInLists(updatedUser);
      
      _setSuccess(result['message'] ?? 'User suspended successfully');
    } catch (e) {
      _setError('Failed to suspend user: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 5. Reactivate user
  Future<void> reactivateUser({
    required int userId,
    required String comment,
  }) async {
    _setLoading(true);
    _setError('');
    
    try {
      final result = await _apiService.reactivateUser(
        userId: userId,
        comment: comment,
      );
      
      // Update the user in the appropriate list
      final updatedUser = AdminUser.fromJson(result['user']);
      _updateUserInLists(updatedUser);
      
      _setSuccess(result['message'] ?? 'User reactivated successfully');
    } catch (e) {
      _setError('Failed to reactivate user: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 6. Add comment to user
  Future<void> addCommentToUser({
    required int userId,
    required String comment,
  }) async {
    _setLoading(true);
    _setError('');
    
    try {
      final result = await _apiService.commentOnUser(
        userId: userId,
        comment: comment,
      );
      
      _setSuccess(result['message'] ?? 'Comment added successfully');
    } catch (e) {
      _setError('Failed to add comment: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 7. Get user profile
  Future<void> getUserProfile(int userId) async {
    _setLoading(true);
    _setError('');
    
    try {
      final result = await _apiService.getUserProfile(userId);
      _selectedUserProfile = UserProfile.fromJson(result);
      _setSuccess('User profile loaded successfully');
    } catch (e) {
      _setError('Failed to load user profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Helper method to update user in appropriate lists
  void _updateUserInLists(AdminUser updatedUser) {
    // Remove from all lists first
    _pendingUsers.removeWhere((user) => user.id == updatedUser.id);
    _activeUsers.removeWhere((user) => user.id == updatedUser.id);
    _suspendedUsers.removeWhere((user) => user.id == updatedUser.id);
    
    // Add to appropriate list based on status
    switch (updatedUser.status) {
      case 'pending':
        _pendingUsers.add(updatedUser);
        break;
      case 'active':
        _activeUsers.add(updatedUser);
        break;
      case 'suspended':
        _suspendedUsers.add(updatedUser);
        break;
    }
    
    notifyListeners();
  }

  // Helper method to get user by ID from any list
  AdminUser? getUserById(int userId) {
    final allUsers = [..._pendingUsers, ..._activeUsers, ..._suspendedUsers];
    try {
      return allUsers.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  // Helper method to get users by role
  List<AdminUser> getUsersByRole(String role) {
    final allUsers = [..._pendingUsers, ..._activeUsers, ..._suspendedUsers];
    return allUsers.where((user) => user.role == role).toList();
  }

  // Helper method to get user statistics
  Map<String, int> getUserStatistics() {
    return {
      'pending': _pendingUsers.length,
      'active': _activeUsers.length,
      'suspended': _suspendedUsers.length,
      'total': _pendingUsers.length + _activeUsers.length + _suspendedUsers.length,
    };
  }

  // Clear all data
  void clearAllData() {
    _pendingUsers.clear();
    _activeUsers.clear();
    _suspendedUsers.clear();
    _selectedUserProfile = null;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // Refresh all data
  Future<void> refreshAllData() async {
    await fetchAllUsers();
  }
}
