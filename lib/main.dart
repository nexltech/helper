import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job/Screen/Auth/auth_gate_screen.dart';
import 'providers/user_provider.dart';
import 'providers/admin_provider.dart';
import 'providers/crud_job_provider.dart';
import 'providers/job_applicants_provider.dart';
import 'providers/my_applications_provider.dart';
import 'providers/profile_crud_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/review_provider.dart';
import 'services/stripe_service.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  // Run app in error-handled zone
  runZonedGuarded(() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      
      // Initialize Firebase (optional - app will work without it)
      bool firebaseInitialized = false;
      try {
        if (Firebase.apps.isEmpty) {
          // Try to initialize Firebase
          await Firebase.initializeApp();
          firebaseInitialized = true;
          if (kDebugMode) {
            print('✅ Firebase initialized successfully');
          }
        } else {
          firebaseInitialized = true;
          if (kDebugMode) {
            print('✅ Firebase already initialized');
          }
        }
      } catch (e) {
        // Firebase initialization failed - this is OK, app can continue
        firebaseInitialized = false;
        if (kDebugMode) {
          print('⚠️ Firebase initialization failed (this is OK, app will continue): $e');
        }
        // Continue without Firebase - app can still function
      }
      
      if (!firebaseInitialized && kDebugMode) {
        print('ℹ️ App running without Firebase. Some features may be unavailable.');
      }
    
      // Set up basic error handlers
      _setupErrorHandlers();
    
      // Initialize Stripe to prevent crashes when payment screens open
      try {
        await StripeService.instance.initializeStripe();
        if (kDebugMode) {
          print('Stripe initialized successfully');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Stripe initialization failed: $e');
        }
      }
      
      // Initialize user provider and load session
      try {
        final userProvider = UserProvider();
        
        try {
          await userProvider.loadSession();
        } catch (e) {
          if (kDebugMode) {
            print('Session loading failed: $e');
          }
        }
        
        runApp(MyApp(userProvider: userProvider));
      } catch (e, stackTrace) {
        if (kDebugMode) {
          print('Failed to initialize user provider: $e');
          print('Stack trace: $stackTrace');
        }
        // Try to create a basic user provider and continue
        final userProvider = UserProvider();
        runApp(MyApp(userProvider: userProvider));
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Fatal error during app startup: $e');
        print('Stack trace: $stackTrace');
      }
      // Re-throw to be caught by runZonedGuarded error handler
      rethrow;
    }
  }, (error, stack) {
    // Catch any errors not handled by FlutterError.onError
    if (kDebugMode) {
      print('Unhandled error in zone: $error');
      print('Stack trace: $stack');
    }
  });
}

/// Set up basic error handlers
void _setupErrorHandlers() {
  // Handle Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log to console in debug mode
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  };

  // Handle async errors (Zones)
  PlatformDispatcher.instance.onError = (error, stack) {
    // Log error in debug mode
    if (kDebugMode) {
      print('Unhandled async error: $error\n$stack');
    }
    return true; // Prevent app from crashing immediately
  };
}

class MyApp extends StatelessWidget {
  final UserProvider userProvider;
  const MyApp({super.key, required this.userProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: userProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => AdminProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CrudJobProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => JobApplicantsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyApplicationsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileCrudProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(),
        // Auth gate screen handles routing based on login status and user role
        home: const AuthGateScreen(),
      ),
    );
  }
}
