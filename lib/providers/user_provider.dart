import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth/auth_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  String? _token;

  // Getters
  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoggedIn => _user != null && _token != null;

  // Getter and setter for currentUser
  UserModel? get currentUser => _user;
  
  set currentUser(UserModel? user) {
    _user = user;
    notifyListeners();
    print('UserProvider: Current user updated: ${user?.name}');
  }

  // Sign up method
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    try {
      print('UserProvider: Starting sign up for $email');
      
      final user = await AuthService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
      );

      _user = user;
      _token = user.token;

      // Save to SharedPreferences
      await _saveSession();
      
      print('UserProvider: Sign up successful for ${user.name}');
      notifyListeners();
      return true;
    } catch (e) {
      print('UserProvider: Sign up failed: $e');
      return false;
    }
  }

  // Login method
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      print('UserProvider: Starting login for $email'); 
      
      final user = await AuthService.login(
        email: email,
        password: password,
      );

      _user = user;
      _token = user.token;

      // Save to SharedPreferences
      await _saveSession();
      
      print('UserProvider: Login successful for ${user.name}');
      notifyListeners();
      return true;
    } catch (e) {
      print('UserProvider: Login failed: $e');
      return false;
    }
  }

  // Load session from SharedPreferences
  Future<void> loadSession() async {
    try {
      print('UserProvider: Loading session from SharedPreferences');
      
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('userId');
      final email = prefs.getString('email');
      final name = prefs.getString('name');
      final role = prefs.getString('role');

      if (token != null && userId != null && email != null) {
        // Create a user object from stored data
        _token = token;
        _user = UserModel(
          id: userId,
          name: name ?? '', 
          email: email,
          role: role ?? 'hire_help', // Default role if not found
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          token: token,
        );
        
        print('UserProvider: Session loaded for user ID: $userId, role: $role');
        notifyListeners();
      } else {
        print('UserProvider: No valid session found');
      }
    } catch (e) {
      print('UserProvider: Failed to load session: $e');
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      print('UserProvider: Logging out user: ${_user?.name}');
      
      _user = null;
      _token = null;

      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('userId');
      await prefs.remove('email');
      await prefs.remove('name');
      await prefs.remove('role');
      
      print('UserProvider: Logout successful');
      notifyListeners();
    } catch (e) {
      print('UserProvider: Logout error: $e');
    }
  }

  // Save session to SharedPreferences
  Future<void> _saveSession() async {
    try {
      if (_user != null && _token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setInt('userId', _user!.id);
        await prefs.setString('email', _user!.email);
        await prefs.setString('name', _user!.name);
        await prefs.setString('role', _user!.role);
        
        print('UserProvider: Session saved to SharedPreferences (role: ${_user!.role})');
      }
    } catch (e) {
      print('UserProvider: Failed to save session: $e');
    }
  }

  // Update user data
  Future<bool> updateUser(Map<String, dynamic> payload) async {
    try {
      if (_token == null) {
        print('UserProvider: No token available for update');
        return false;
      }

      print('UserProvider: Updating user data');
      
      final updatedUser = await AuthService.putUserJson(
        token: _token!,
        payload: payload,
      );

      _user = updatedUser;
      notifyListeners();
      
      print('UserProvider: User data updated successfully');
      return true;
    } catch (e) {
      print('UserProvider: Update failed: $e');
      return false;
    }
  }
}
