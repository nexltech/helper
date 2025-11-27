import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job/Screen/jobBoarding/navbar.dart';
import 'package:job/Screen/admin/admin_profile_edit_screen.dart';
import 'package:job/Screen/Auth/login_or_create_screen.dart';
import 'package:job/Screen/profile/change_email_screen.dart';
import 'package:job/Screen/profile/change_password_screen.dart';
import '../../providers/user_provider.dart';

class AdminProfileViewScreen extends StatefulWidget {
  const AdminProfileViewScreen({super.key});

  @override
  State<AdminProfileViewScreen> createState() => _AdminProfileViewScreenState();
}

class _AdminProfileViewScreenState extends State<AdminProfileViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header
                _buildHeader(),
                const SizedBox(height: 24),
                // Profile Card
                _buildProfileCard(),
                const SizedBox(height: 24),
                // Action Buttons
                _buildActionButtons(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Admin Quick Action - Coming Soon'),
                backgroundColor: Colors.green,
              ),
            );
          },
          backgroundColor: Colors.white,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.green, size: 40),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 8),
        const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'HomemadeApple',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture and Name
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black26, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.pink[100],
                      child: const Icon(
                        Icons.admin_panel_settings,
                        size: 40,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Admin User',
                          style: const TextStyle(
                            fontFamily: 'HomemadeApple',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            const Text(
                              'Rating: 4.5',
                              style: TextStyle(
                                fontFamily: 'LifeSavers',
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Location: Admin Center',
                          style: TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Bio Section
              const Text(
                'Bio:',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  'Hi there! I\'m a system administrator with full access to the Helpr platform. I manage user accounts, moderate content, and ensure the platform runs smoothly. I have the authority to approve or deny user registrations, manage job postings, and maintain platform security. Clear communication and reliability are my top priorities as I work to create a safe and trustworthy community for all users.',
                  style: const TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Edit Profile Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminProfileEditScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B4513),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 2,
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Change Email Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              print('Admin: Change Email button pressed');
              _navigateToChangeEmail();
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.orange, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Change Email',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Change Password Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              print('Admin: Change Password button pressed');
              _navigateToChangePassword();
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.purple, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Change Password',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Logout Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _showLogoutDialog(),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontFamily: 'LifeSavers',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToChangeEmail() {
    print('Admin: Navigating to ChangeEmailScreen');
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ChangeEmailScreen(),
        ),
      );
      print('Admin: Navigation to ChangeEmailScreen completed');
    } catch (e) {
      print('Admin: Error navigating to ChangeEmailScreen: $e');
    }
  }

  void _navigateToChangePassword() {
    print('Admin: Navigating to ChangePasswordScreen');
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ChangePasswordScreen(),
        ),
      );
      print('Admin: Navigation to ChangePasswordScreen completed');
    } catch (e) {
      print('Admin: Error navigating to ChangePasswordScreen: $e');
    }
  }

  void _logout() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Get the user provider and logout
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.logout();

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      if (mounted) {
        print('AdminProfileView: Navigating to LoginOrCreateScreen after logout');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginOrCreateScreen(),
          ),
          (route) => false, // Remove all previous routes
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        print('AdminProfileView: Navigation to LoginOrCreateScreen completed');
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
