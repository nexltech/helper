import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job/Screen/Auth/login_or_create_screen.dart';
import 'package:job/Screen/My_jobs/my_jobs_screen.dart';
import 'package:job/Screen/admin/admin_dashboard_screen.dart';
import '../../providers/user_provider.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Show loading screen while checking authentication
        if (userProvider.user == null) {
          // Check if we're still loading the session
          return FutureBuilder(
            future: _checkAuthStatus(userProvider),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'H',
                          style: TextStyle(
                            fontFamily: 'FrederickaTheGreat',
                            fontSize: 90,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              // If no user after loading, show login screen
              return const LoginOrCreateScreen();
            },
          );
        }

        // User is logged in, route based on role
        final user = userProvider.user!;
        
        print('AuthGate: User role detected: ${user.role}');
        
        if (user.role.toLowerCase() == 'admin') {
          print('AuthGate: Routing to Admin Dashboard');
          return const AdminDashboardScreen();
        } else {
          print('AuthGate: Routing to My Jobs Screen for role: ${user.role}');
          // For regular users (hire_help, offer_help, etc.)
          return const MyJobsScreen();
        }
      },
    );
  }

  Future<void> _checkAuthStatus(UserProvider userProvider) async {
    // Give some time for the session to load
    await Future.delayed(const Duration(milliseconds: 500));
    
    // The session loading is already triggered in main.dart
    // This just ensures we wait for it to complete
  }
}
