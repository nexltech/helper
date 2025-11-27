import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';
import '../profile/choose_role_screen.dart';
import '../../providers/user_provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Dedicated signup method
  Future<void> _performSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      final success = await userProvider.signUp(
        name: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        role: 'both', // Default role, can be changed later
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Account created successfully!'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const ChooseRoleScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Failed to create account. Please try again.'),
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
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'H',
                    style: const TextStyle(
                      fontFamily: 'FrederickaTheGreat',
                      fontSize: 96,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Create Account',
                  style: const TextStyle(
                    fontFamily: 'HomemadeApple',
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildFullNameField(),
                      const SizedBox(height: 12),
                      _buildTextField('Email Address', Icons.email_outlined,
                          controller: _emailController, validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      }),
                      const SizedBox(height: 12),
                      _buildPasswordField(),
                      const SizedBox(height: 12),
                      _buildConfirmPasswordField(),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.green, size: 16),
                    const SizedBox(width: 6),
                    Text('Accept the ',
                        style: TextStyle(color: Colors.black54)),
                    GestureDetector(
                      onTap: () {},
                      child: Text('Terms',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black)),
                    ),
                    Text(' and ', style: TextStyle(color: Colors.black54)),
                    GestureDetector(
                      onTap: () {},
                      child: Text('Conditions.',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black)),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                OutlinedButton(
                  onPressed: _isLoading ? null : _performSignUp,
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
                              'Creating Account...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.7),
                                fontFamily: 'LifeSavers',
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    'Already have an account? Log In',
                    style: TextStyle(
                      color: Colors.black54,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullNameField() {
    return TextFormField(
      controller: _fullNameController,
      keyboardType: TextInputType.name,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[^0-9]')),
      ],
      decoration: InputDecoration(
        labelText: 'Full Name',
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset('assets/Icons/name.png', width: 24, height: 24),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.black),
        ),
        labelStyle:
            const TextStyle(color: Colors.black38, fontFamily: 'LifeSavers'),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Full Name is required';
        if (RegExp(r'[0-9]').hasMatch(value)) {
          return 'Full Name cannot contain numbers';
        }
        return null;
      },
    );
  }

  Widget _buildTextField(String label, IconData icon,
      {TextEditingController? controller,
      String? Function(String?)? validator,
      bool obscure = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: label == 'Email Address'
              ? Image.asset('assets/Icons/Email.png', width: 24, height: 24)
              : null,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.black),
        ),
        labelStyle:
            const TextStyle(color: Colors.black38, fontFamily: 'LifeSavers'),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset('assets/Icons/Lock.png', width: 24, height: 24),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.black),
        ),
        labelStyle:
            const TextStyle(color: Colors.black38, fontFamily: 'LifeSavers'),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 8) return 'Password must be at least 8 characters';
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset('assets/Icons/Lock.png', width: 24, height: 24),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.black),
        ),
        labelStyle:
            const TextStyle(color: Colors.black38, fontFamily: 'LifeSavers'),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) return 'Passwords do not match';
        return null;
      },
    );
  }
}
