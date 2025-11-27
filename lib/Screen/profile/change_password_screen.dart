import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_crud_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo
              Center(
                child: Text(
                  'H',
                  style: const TextStyle(
                    fontFamily: 'FrederickaTheGreat',
                    fontSize: 90,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                'Change Password',
                style: const TextStyle(
                  fontFamily: 'HomemadeApple',
                  fontSize: 32,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Current Password Field
                    TextFormField(
                      controller: _currentPasswordController,
                      obscureText: _obscureCurrentPassword,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset('assets/Icons/Lock.png',
                              width: 24, height: 24),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureCurrentPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureCurrentPassword = !_obscureCurrentPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: const BorderSide(color: Colors.black26),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        labelStyle: const TextStyle(
                            color: Colors.black38, fontFamily: 'LifeSavers'),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Current password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // New Password Field
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset('assets/Icons/Lock.png',
                              width: 24, height: 24),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureNewPassword = !_obscureNewPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: const BorderSide(color: Colors.black26),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        labelStyle: const TextStyle(
                            color: Colors.black38, fontFamily: 'LifeSavers'),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'New password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Confirm Password Field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset('assets/Icons/Lock.png',
                              width: 24, height: 24),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: const BorderSide(color: Colors.black26),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        labelStyle: const TextStyle(
                            color: Colors.black38, fontFamily: 'LifeSavers'),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm password is required';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    side: const BorderSide(color: Colors.black, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text(
                          'Reset Password',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'BioRhyme'),
                        ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final profileProvider = Provider.of<ProfileCrudProvider>(context, listen: false);
      
      final success = await profileProvider.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        newPasswordConfirmation: _confirmPasswordController.text,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(profileProvider.successMessage ?? 'Password changed successfully'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          
          // Navigate back
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(profileProvider.errorMessage ?? 'Failed to change password'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
