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

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // Helper to get current screen type
  Type? _getCurrentScreenType() {
    final route = ModalRoute.of(context);
    if (route is MaterialPageRoute) {
      try {
        final widget = route.builder(context);
        return widget.runtimeType;
      } catch (e) {
        // If we can't build the widget, return null
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        final isAdmin = user?.role == 'admin';
        
        // Determine current screen to show active state
        final currentScreen = _getCurrentScreenType();
        final dashboardType = isAdmin ? AdminDashboardScreen : MyJobsScreen;
        final profileType = isAdmin ? AdminMyAccountScreen : HireHelpProfileScreen;
        final isDashboardActive = currentScreen != null && currentScreen == dashboardType;
        final isJobsActive = currentScreen != null && currentScreen == JobBoardMainScreen;
        final isMessagesActive = currentScreen != null && currentScreen == ChatListScreen;
        final isProfileActive = currentScreen != null && currentScreen == profileType;
        
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
                      _buildNavItemWithIcon(
                        iconPath: isDashboardActive 
                            ? 'assets/Icons/1st Job Seeker active state.png'
                            : 'assets/Icons/1st Job Seeker inactive state.png',
                        label: isAdmin ? 'Admin' : 'Dashboard',
                        isActive: isDashboardActive,
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
                      _buildNavItemWithIcon(
                        iconPath: isJobsActive 
                            ? 'assets/Icons/2nd Test Passed active state.png'
                            : 'assets/Icons/2nd Test Passed inactive state.png',
                        label: isAdmin ? 'Reports' : 'Jobs',
                        isActive: isJobsActive,
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
                      _buildNavItemWithIcon(
                        iconPath: isMessagesActive 
                            ? 'assets/Icons/3rd Speech Bubble active state.png.png'
                            : 'assets/Icons/3rd Speech Bubble inactive state.png',
                        label: 'Messages',
                        isActive: isMessagesActive,
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
                      _buildProfileNavItemWithIcon(
                        iconPath: isProfileActive 
                            ? 'assets/Icons/4th Test Account active state.png'
                            : 'assets/Icons/4th Test Account inactive state.png',
                        isAdmin: isAdmin,
                        isActive: isProfileActive,
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


  Widget _buildNavItemWithIcon({
    required String iconPath,
    required String label,
    required bool isActive,
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
            color: isActive ? Colors.blue.withOpacity(0.08) : Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
              width: isActive ? 2 : 1,
            ),
            boxShadow: isActive ? [
              BoxShadow(
                color: Colors.blue.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ] : [],
          ),
          child: Image.asset(
            iconPath,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to default icon if asset not found
              return Icon(
                Icons.error_outline,
                color: Colors.grey,
                size: 20,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileNavItemWithIcon({
    required String iconPath,
    required bool isAdmin,
    required bool isActive,
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
                color: isActive ? color.withOpacity(0.08) : Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
                  width: isActive ? 2 : 1,
                ),
                boxShadow: isActive ? [
                  BoxShadow(
                    color: color.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ] : [],
              ),
              child: Image.asset(
                iconPath,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to default icon if asset not found
                  return Icon(
                    Icons.person,
                    color: color,
                    size: 20,
                  );
                },
              ),
            ),
            // Role indicator badge (only show when active)
            if (isActive)
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
