import 'package:flutter/material.dart';
import 'package:job/Screen/My_jobs/my_jobs_screen.dart';
import 'package:job/Screen/admin/admin_dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_account_screen.dart';
import 'forgot_password_screen.dart';
import '../../providers/user_provider.dart';
import '../../services/profile_api_service.dart';
import '../../models/user_model.dart';
import '../profile/profile_pending_review_screen.dart';
import '../profile/profile_not_approved_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Dedicated login method
  Future<void> _performLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      // Use the new login method that handles status checking
      final loginResult = await ProfileApiService.loginWithStatusCheck(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (loginResult != null && loginResult['success'] == true) {
        // Login successful, save user data and proceed
        final userData = loginResult['data'];
        final user = UserModel.fromLoginJson(userData);
        userProvider.currentUser = user;
        
        // Save session
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', user.token ?? '');
        await prefs.setInt('userId', user.id);
        await prefs.setString('email', user.email);
        await prefs.setString('name', user.name);
        await prefs.setString('role', user.role);
        
        if (mounted) {
          
          // Check if user is admin first
          if (user.role.toLowerCase() == 'admin') {
            // Admin users go directly to dashboard
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('Welcome back, ${user.name}!'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
            );
          } else {
            // For regular users, check their status from the login response first
            final userStatus = user.status?.toLowerCase() ?? 'pending';
            print('User status from login: $userStatus');
            
            Widget destinationScreen;
            String screenName;
            Color snackBarColor;
            String message;
            
            switch (userStatus) {
              case 'active':
              case 'approved':
                destinationScreen = const MyJobsScreen();
                screenName = 'Job Post Screen';
                snackBarColor = Colors.green;
                message = 'Welcome back, ${user.name}! Redirecting to $screenName...';
                break;
              case 'rejected':
                destinationScreen = const ProfileNotApprovedScreen();
                screenName = 'Profile Not Approved';
                snackBarColor = Colors.red;
                message = 'Your profile was not approved. Redirecting to review...';
                break;
              case 'pending':
              default:
                destinationScreen = const ProfilePendingReviewScreen();
                screenName = 'Profile Pending Review';
                snackBarColor = Colors.orange;
                message = 'Your account is not active. Please wait for admin approval.';
                break;
            }
            
            // Show appropriate message based on status
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: snackBarColor,
                duration: const Duration(seconds: 3),
              ),
            );
            
            // Small delay to show the message
            await Future.delayed(const Duration(milliseconds: 1000));
            
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => destinationScreen),
            );
          }
        }
      } else if (loginResult != null && loginResult['status'] == 'pending') {
        // Account is not active, show message and redirect to pending review
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loginResult['message'] ?? 'Your account is not active. Please wait for admin approval.'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
          
          // Small delay to show the message
          await Future.delayed(const Duration(milliseconds: 1000));
          
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfilePendingReviewScreen()),
          );
        }
      } else {
        if (mounted) {
          final errorMessage = loginResult != null 
              ? loginResult['message'] ?? 'Login failed. Please check your credentials.'
              : 'Login failed. Please check your credentials.';
              
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(errorMessage)),
                ],
              ),
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
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Error: ${e.toString()}')),
              ],
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
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
                Text(
                  'Log In',
                  style: const TextStyle(
                    fontFamily: 'HomemadeApple',
                    fontSize: 32,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
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
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
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
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (val) {
                        setState(() {
                          _rememberMe = val ?? false;
                        });
                      },
                      shape: const CircleBorder(),
                      activeColor: Colors.black,
                    ),
                    const Text('Remember Me',
                        style: TextStyle(fontFamily: 'LifeSavers')),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text('Forgot Password?',
                          style: TextStyle(
                              color: Colors.black54, fontFamily: 'LifeSavers')),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _isLoading ? null : _performLogin,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    side: const BorderSide(color: Colors.black, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Logging in...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.7),
                                fontFamily: 'BioRhyme',
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          'Log In',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'BioRhyme'),
                        ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ",
                        style: TextStyle(
                            color: Colors.black54, fontFamily: 'LifeSavers')),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const CreateAccountScreen()),
                        );
                      },
                      child: const Text('Create Account',
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'LifeSavers',
                              decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
