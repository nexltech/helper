import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job/Screen/admin/admin_dashboard_screen.dart';
import 'package:job/Screen/admin/admin_my_account_screen.dart';
import 'package:job/Screen/My_jobs/my_jobs_screen.dart';
import 'package:job/Screen/My_jobs/hire_help_profile.dart';
import 'package:job/Screen/jobBoarding/job_board_main_screen.dart';
import 'package:job/Screen/Chat/chat_list_screen.dart';
import '../../providers/user_provider.dart';
import '../../providers/chat_provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        final isAdmin = user?.role == 'admin';
        
        return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: const Color(0xFFFFFFFF), // Pure white
          elevation: 12,
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF), // Ensure pure white background
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Side Icons - Role-based navigation
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // First navigation button - role-specific dashboard
                      _buildNavItem(
                        icon: Icons.admin_panel_settings,
                        label: isAdmin ? 'Admin' : 'Dashboard',
                        color: isAdmin ? Colors.red : Colors.blue,
                        onTap: () {
                          if (isAdmin) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminDashboardScreen(),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyJobsScreen(),
                              ),
                            );
                          }
                        },
                      ),
                      // Second navigation button - Job Board/Reports (role-based)
                      _buildNavItem(
                        icon: isAdmin ? Icons.assessment : Icons.work_outline,
                        label: isAdmin ? 'Reports' : 'Jobs',
                        color: Colors.green,
                        onTap: () {
                          if (isAdmin) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reports section is not available for admin'),
                                backgroundColor: Colors.orange,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const JobBoardMainScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // Right Side Icons - Universal features
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Messages
                      _buildNavItem(
                        icon: Icons.message_outlined,
                        label: 'Messages',
                        color: Colors.purple,
                        onTap: () {
                          if (isAdmin) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Chat section is not available for admin'),
                                backgroundColor: Colors.orange,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            // Set auth token for chat provider
                            final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                            final userProvider = Provider.of<UserProvider>(context, listen: false);
                            if (userProvider.user?.token != null) {
                              chatProvider.setAuthToken(userProvider.user!.token!);
                            }
                            
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatListScreen(),
                              ),
                            );
                          }
                        },
                      ),
                      // Profile with role indicator
                      _buildProfileNavItem(
                        isAdmin: isAdmin,
                        onTap: () {
                          if (isAdmin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminMyAccountScreen(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HireHelpProfileScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileNavItem({
    required bool isAdmin,
    required VoidCallback onTap,
  }) {
    final color = isAdmin ? Colors.red : Colors.blue;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.person,
                color: color,
                size: 20,
              ),
            ),
            // Role indicator badge
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    isAdmin ? 'A' : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
