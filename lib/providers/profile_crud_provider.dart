import 'package:flutter/foundation.dart';
import '../services/profile_api_service.dart';

class ProfileCrudProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  String? get successMessage => _successMessage;
  String? get errorMessage => _errorMessage;

  // Clear messages
  void clearMessages() {
    _successMessage = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Change email method
  Future<bool> changeEmail({
    required String newEmail,
    required String confirmEmail,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await ProfileApiService.changeEmail(
        newEmail: newEmail,
        confirmEmail: confirmEmail,
      );

      if (response != null) {
        _successMessage = response['message'] ?? 'Email changed successfully';
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to change email';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Change password method
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await ProfileApiService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );

      if (response != null) {
        _successMessage = response['message'] ?? 'Password changed successfully';
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to change password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
