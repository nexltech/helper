import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:job/Screen/Auth/login_or_create_screen.dart';
import 'package:job/Screen/My_jobs/my_jobs_screen.dart';
import 'package:job/Screen/admin/admin_dashboard_screen.dart';
import '../../providers/user_provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  @override
  void initState() {
    super.initState();
    // Verify Firebase when first screen loads
    _verifyAndLogFirebase();
  }

  /// Verify Firebase is working and log to Crashlytics
  void _verifyAndLogFirebase() {
    try {
      // Check if Firebase is initialized
      final apps = Firebase.apps;
      if (apps.isEmpty) {
        if (kDebugMode) {
          print('AUTH GATE: ❌ Firebase not initialized');
        }
        return;
      }

      final app = Firebase.app();
      if (kDebugMode) {
        print('AUTH GATE: ✅ Firebase initialized - App: ${app.name}');
      }

      // Log to Crashlytics that we reached first screen
      try {
        FirebaseCrashlytics.instance.log('App reached AuthGateScreen - First screen loaded');
        FirebaseCrashlytics.instance.setCustomKey('screen_reached', 'AuthGateScreen');
        FirebaseCrashlytics.instance.setCustomKey('first_screen_load_time', DateTime.now().toIso8601String());
        
        // Send a verification log
        FirebaseCrashlytics.instance.recordError(
          Exception('VERIFICATION: App successfully reached first screen'),
          StackTrace.current,
          fatal: false,
          reason: 'This confirms the app launched successfully and Crashlytics is working',
        );

        if (kDebugMode) {
          print('AUTH GATE: ✅ Verification error sent to Crashlytics');
          print('AUTH GATE: Check Firebase Console in 1-5 minutes');
        }
      } catch (e) {
        if (kDebugMode) {
          print('AUTH GATE: ❌ Failed to log to Crashlytics: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('AUTH GATE: ❌ Firebase verification failed: $e');
      }
    }
  }

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
