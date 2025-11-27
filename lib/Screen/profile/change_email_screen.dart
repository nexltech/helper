import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_crud_provider.dart';
import '../../providers/user_provider.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newEmailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _newEmailController.dispose();
    _confirmEmailController.dispose();
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
                'Change Email',
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
                    // New Email Field
                    TextFormField(
                      controller: _newEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'New Email Address',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset('assets/Icons/Email.png',
                              width: 24, height: 24),
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
                          return 'New email is required';
                        }
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Confirm Email Field
                    TextFormField(
                      controller: _confirmEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Email Address',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset('assets/Icons/Lock.png',
                              width: 24, height: 24),
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
                          return 'Confirm email is required';
                        }
                        if (value != _newEmailController.text) {
                          return 'Emails do not match';
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
                  onPressed: _isLoading ? null : _changeEmail,
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
                          'Reset Email',
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

  Future<void> _changeEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final profileProvider = Provider.of<ProfileCrudProvider>(context, listen: false);
      
      final success = await profileProvider.changeEmail(
        newEmail: _newEmailController.text.trim(),
        confirmEmail: _confirmEmailController.text.trim(),
      );

      if (success) {
        // Update user data in UserProvider
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if (userProvider.user != null) {
          // Update the user's email in the provider using copyWith
          final updatedUser = userProvider.user!.copyWith(
            email: _newEmailController.text.trim(),
            updatedAt: DateTime.now(),
          );
          userProvider.currentUser = updatedUser;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(profileProvider.successMessage ?? 'Email changed successfully'),
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
              content: Text(profileProvider.errorMessage ?? 'Failed to change email'),
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
