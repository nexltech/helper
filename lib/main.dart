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
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  // Run app in error-handled zone
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Firebase first (required before Crashlytics)
    // Wrap in try-catch to prevent crash if Firebase initialization fails
    try {
      await Firebase.initializeApp();
      // Set up global error handlers (after Firebase initialization)
      _setupErrorHandlers();
    } catch (e, stackTrace) {
      // If Firebase initialization fails, log error but continue
      // This prevents app crash on startup if GoogleService-Info.plist is missing or invalid
      if (kDebugMode) {
        print('Firebase initialization failed: $e');
        print('Stack trace: $stackTrace');
      }
      // Continue without Crashlytics - app will still work but crashes won't be reported
      // Set up basic error handlers that don't use Crashlytics
      _setupBasicErrorHandlers();
    }
    
    // Initialize Stripe to prevent crashes when payment screens open
    try {
      await StripeService.instance.initializeStripe();
      if (kDebugMode) {
        print('Stripe initialized successfully');
      }
    } catch (e, stackTrace) {
      // Log error but don't crash app if Stripe fails
      if (kDebugMode) {
        print('Stripe initialization failed: $e');
      }
      // Record non-fatal error to Crashlytics (if available)
      try {
        FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: false);
      } catch (_) {
        // Crashlytics not available, skip
      }
    }
    
    // Initialize user provider and load session
    final userProvider = UserProvider();
    try {
      await userProvider.loadSession();
    } catch (e, stackTrace) {
      // If session loading fails, continue with empty provider
      if (kDebugMode) {
        print('Session loading failed: $e');
      }
      // Record non-fatal error to Crashlytics (if available)
      try {
        FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: false);
      } catch (_) {
        // Crashlytics not available, skip
      }
    }
    
    runApp(MyApp(userProvider: userProvider));
  }, (error, stack) {
    // Catch any errors not handled by FlutterError.onError
    if (kDebugMode) {
      print('Unhandled error in zone: $error\n$stack');
    }
    // Record fatal error to Crashlytics (if available)
    try {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } catch (_) {
      // Crashlytics not available, app will still run
    }
  });
}

/// Set up global error handlers to catch unhandled exceptions (with Crashlytics)
void _setupErrorHandlers() {
  // Handle Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log to console in debug mode
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
    // Always send to Crashlytics (works in both debug and release, but only reports in release)
    try {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    } catch (e) {
      // If Crashlytics fails, log to console as fallback
      if (kDebugMode) {
        print('Failed to record error to Crashlytics: $e');
      }
    }
  };

  // Handle async errors (Zones)
  PlatformDispatcher.instance.onError = (error, stack) {
    // Log error in debug mode
    if (kDebugMode) {
      print('Unhandled async error: $error\n$stack');
    }
    // Always send to Crashlytics (works in both debug and release, but only reports in release)
    try {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } catch (e) {
      // If Crashlytics fails, log to console as fallback
      if (kDebugMode) {
        print('Failed to record error to Crashlytics: $e');
      }
    }
    return true; // Prevent app from crashing immediately
  };
}

/// Set up basic error handlers when Firebase is not available
void _setupBasicErrorHandlers() {
  // Handle Flutter framework errors (without Crashlytics)
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log to console in debug mode
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
    // In release mode, errors won't be reported but app won't crash
  };

  // Handle async errors (Zones) - without Crashlytics
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
