import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job/Screen/jobBoarding/navbar.dart';
import 'package:job/Screen/admin/admin_notifications_screen.dart';
import 'package:job/Screen/jobBoarding/job_board_main_screen.dart';
import 'package:job/Screen/profile/change_email_screen.dart';
import 'package:job/Screen/profile/change_password_screen.dart';
import 'package:job/Screen/Auth/login_or_create_screen.dart';
import '../../providers/user_provider.dart';

class AdminMyAccountScreen extends StatefulWidget {
  const AdminMyAccountScreen({super.key});

  @override
  State<AdminMyAccountScreen> createState() => _AdminMyAccountScreenState();
}

class _AdminMyAccountScreenState extends State<AdminMyAccountScreen> {
  bool _isAccountSettingsExpanded = false;
  bool _isLegalPoliciesExpanded = false;

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
                // Quick Actions
                _buildQuickActions(),
                const SizedBox(height: 24),
                // Settings Section
                _buildSettingsSection(),
                const SizedBox(height: 24),
                // Support Section
                _buildSupportSection(),
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
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        return Container(
          padding: const EdgeInsets.all(20),
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
          child: Row(
            children: [
              // Profile Initial
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  (user?.name ?? 'Admin').substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'FrederickatheGreat',
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${user?.name ?? 'Admin'}',
                      style: const TextStyle(
                        fontFamily: 'HomemadeApple',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Administrator',
                      style: const TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // Notification Bell
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/Icons/Bell.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Job Board',
                  Icons.work_outline,
                  Colors.brown,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const JobBoardMainScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionButton(
                  'My Schedule',
                  Icons.calendar_today,
                  Colors.blue,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Schedule Management - Coming Soon'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionButton(
                  'My Reviews',
                  Icons.star_outline,
                  Colors.amber,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reviews Management - Coming Soon'),
                        backgroundColor: Colors.amber,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'LifeSavers',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        // Account Settings Container
        _buildAccountSettingsContainer(),
        const SizedBox(height: 12),
        // Payment Setup Container
        _buildPaymentSetupContainer(),
        const SizedBox(height: 12),
        // Notifications Container
        _buildNotificationsContainer(),
      ],
    );
  }

  Widget _buildAccountSettingsContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Account Settings Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Account Settings',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isAccountSettingsExpanded = !_isAccountSettingsExpanded;
                  });
                },
                child: Icon(
                  _isAccountSettingsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          // Nested containers for Change Email and Change Password
          if (_isAccountSettingsExpanded) ...[
            const SizedBox(height: 12),
            _buildNestedContainer(
              'Change Email',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangeEmailScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildNestedContainer(
              'Change Password',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentSetupContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.payment,
              color: Colors.amber,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Payment Setup',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment Setup - Coming Soon'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black54,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Notifications',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminNotificationsScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black54,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNestedContainer(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black54,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Support',
          style: TextStyle(
            fontFamily: 'LifeSavers',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        // Legal & Policies Container
        _buildLegalPoliciesContainer(),
      ],
    );
  }

  Widget _buildLegalPoliciesContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Legal & Policies Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.brown.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.description,
                  color: Colors.brown,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Legal & Policies',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isLegalPoliciesExpanded = !_isLegalPoliciesExpanded;
                  });
                },
                child: Icon(
                  _isLegalPoliciesExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          // Nested containers for policies
          if (_isLegalPoliciesExpanded) ...[
            const SizedBox(height: 12),
            _buildNestedContainer(
              'Privacy Policy',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Privacy Policy - Coming Soon'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildNestedContainer(
              'Terms of Service',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terms of Service - Coming Soon'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildNestedContainer(
              'Security & Data Protection',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Security & Data Protection - Coming Soon'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _showLogoutDialog();
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Log Out',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _showDeleteAccountDialog();
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Delete Account',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Log Out',
            style: TextStyle(
              fontFamily: 'HomemadeApple',
              fontSize: 20,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Log Out', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() async {
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
        print('AdminMyAccount: Navigating to LoginOrCreateScreen after logout');
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
        
        print('AdminMyAccount: Navigation to LoginOrCreateScreen completed');
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Delete Account',
            style: TextStyle(
              fontFamily: 'HomemadeApple',
              fontSize: 20,
              color: Colors.red,
            ),
          ),
          content: const Text(
            'This action cannot be undone. All your data will be permanently deleted.',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deletion - Coming Soon'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
