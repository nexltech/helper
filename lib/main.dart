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
    try {
      // Log app startup
      _logToCrashlytics('App startup: WidgetsFlutterBinding initialization starting');
      WidgetsFlutterBinding.ensureInitialized();
      _logToCrashlytics('App startup: WidgetsFlutterBinding initialized successfully');
      
      // Initialize Firebase (if not already initialized by AppDelegate)
      // Check if Firebase is already initialized to avoid double initialization
      bool firebaseInitialized = false;
      try {
        _logToCrashlytics('App startup: Firebase initialization starting');
        // If Firebase was already configured in AppDelegate, this will return the existing app
        await Firebase.initializeApp();
        firebaseInitialized = true;
        _logToCrashlytics('App startup: Firebase initialized successfully');
        
        // Set up global error handlers (after Firebase initialization)
        _setupErrorHandlers();
        _logToCrashlytics('App startup: Error handlers configured');
      } catch (e, stackTrace) {
        // If Firebase initialization fails, log error but continue
        // This prevents app crash on startup if GoogleService-Info.plist is missing or invalid
        final errorMsg = 'Firebase initialization failed: $e';
        if (kDebugMode) {
          print(errorMsg);
          print('Stack trace: $stackTrace');
        }
        _logToCrashlytics(errorMsg, isError: true);
        
        // Continue without Crashlytics - app will still work but crashes won't be reported
        // Set up basic error handlers that don't use Crashlytics
        firebaseInitialized = false;
        _setupBasicErrorHandlers();
      }
    
      // Initialize Stripe to prevent crashes when payment screens open
      try {
        _logToCrashlytics('App startup: Stripe initialization starting', firebaseInitialized: firebaseInitialized);
        await StripeService.instance.initializeStripe();
        _logToCrashlytics('App startup: Stripe initialized successfully', firebaseInitialized: firebaseInitialized);
        if (kDebugMode) {
          print('Stripe initialized successfully');
        }
      } catch (e, stackTrace) {
        // Log error but don't crash app if Stripe fails
        final errorMsg = 'Stripe initialization failed: $e';
        if (kDebugMode) {
          print(errorMsg);
        }
        _logToCrashlytics(errorMsg, isError: true, firebaseInitialized: firebaseInitialized);
        
        // Record non-fatal error to Crashlytics (if available)
        if (firebaseInitialized) {
          try {
            FirebaseCrashlytics.instance.log('Stripe initialization failed');
            FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: false);
          } catch (_) {
            // Crashlytics not available, skip
          }
        }
      }
      
      // Initialize user provider and load session
      try {
        _logToCrashlytics('App startup: User provider initialization starting', firebaseInitialized: firebaseInitialized);
        final userProvider = UserProvider();
        
        try {
          await userProvider.loadSession();
          _logToCrashlytics('App startup: User session loaded successfully', firebaseInitialized: firebaseInitialized);
        } catch (e, stackTrace) {
          // If session loading fails, continue with empty provider
          final errorMsg = 'Session loading failed: $e';
          if (kDebugMode) {
            print(errorMsg);
          }
          _logToCrashlytics(errorMsg, isError: true, firebaseInitialized: firebaseInitialized);
          
          // Record non-fatal error to Crashlytics (if available)
          if (firebaseInitialized) {
            try {
              FirebaseCrashlytics.instance.log('Session loading failed');
              FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: false);
            } catch (_) {
              // Crashlytics not available, skip
            }
          }
        }
        
        _logToCrashlytics('App startup: Running app', firebaseInitialized: firebaseInitialized);
        
        // ALWAYS test Crashlytics connectivity (not just debug mode)
        // This ensures we verify Firebase is working in release builds
        if (firebaseInitialized) {
          // Run comprehensive Firebase verification and test
          _testCrashlyticsConnection();
          
          // Also verify Firebase status and log it
          final status = _verifyFirebaseStatus();
          if (status['initialized'] == true && status['crashlytics_available'] == true) {
            _logToCrashlytics('App startup: Firebase and Crashlytics verified and ready', firebaseInitialized: true);
          } else {
            _logToCrashlytics('App startup: Firebase verification failed - ${status['error']}', isError: true, firebaseInitialized: false);
          }
        } else {
          _logToCrashlytics('App startup: Firebase not initialized - Crashlytics will not work', isError: true, firebaseInitialized: false);
        }
        
        runApp(MyApp(userProvider: userProvider));
        _logToCrashlytics('App startup: App running successfully', firebaseInitialized: firebaseInitialized);
      } catch (e, stackTrace) {
        final errorMsg = 'Failed to initialize user provider: $e';
        _logToCrashlytics(errorMsg, isError: true, firebaseInitialized: firebaseInitialized);
        if (kDebugMode) {
          print(errorMsg);
          print('Stack trace: $stackTrace');
        }
        // Try to create a basic user provider and continue
        final userProvider = UserProvider();
        runApp(MyApp(userProvider: userProvider));
      }
    } catch (e, stackTrace) {
      // Catch any errors during app startup
      final errorMsg = 'Fatal error during app startup: $e';
      _logToCrashlytics(errorMsg, isError: true);
      if (kDebugMode) {
        print(errorMsg);
        print('Stack trace: $stackTrace');
      }
      // Re-throw to be caught by runZonedGuarded error handler
      rethrow;
    }
  }, (error, stack) {
    // Catch any errors not handled by FlutterError.onError
    final errorMsg = 'Unhandled error in zone: $error';
    if (kDebugMode) {
      print(errorMsg);
      print('Stack trace: $stack');
    }
    
    // Record fatal error to Crashlytics (if available)
    // Note: We can't check firebaseInitialized here since it's in a different scope
    // The try-catch will handle if Crashlytics is not available
    try {
      FirebaseCrashlytics.instance.log('Fatal error in runZonedGuarded');
      FirebaseCrashlytics.instance.setCustomKey('error_type', 'zone_error');
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } catch (_) {
      // Crashlytics not available, app will still run
      if (kDebugMode) {
        print('Crashlytics not available to record fatal error');
      }
    }
  });
}

/// Helper function to log messages to Crashlytics (if available)
/// This allows logging even before Firebase is fully initialized
void _logToCrashlytics(String message, {bool isError = false, bool? firebaseInitialized}) {
  if (kDebugMode) {
    print(message);
  }
  
  // Try to log to Crashlytics if Firebase is initialized
  try {
    final apps = Firebase.apps;
    if (apps.isNotEmpty) {
      if (isError) {
        FirebaseCrashlytics.instance.log('ERROR: $message');
      } else {
        FirebaseCrashlytics.instance.log(message);
      }
    }
  } catch (_) {
    // Firebase not initialized yet, just print to console
  }
}

/// Verify Firebase is properly initialized
/// Returns detailed status information
Map<String, dynamic> _verifyFirebaseStatus() {
  final status = <String, dynamic>{
    'initialized': false,
    'app_count': 0,
    'app_name': 'none',
    'crashlytics_available': false,
    'error': null,
  };
  
  try {
    // Check if Firebase is initialized
    final apps = Firebase.apps;
    status['app_count'] = apps.length;
    
    if (apps.isEmpty) {
      status['error'] = 'Firebase.apps is empty - Firebase not initialized!';
      if (kDebugMode) {
        print('FIREBASE VERIFICATION: ❌ FAILED');
        print('FIREBASE VERIFICATION: ${status['error']}');
        print('FIREBASE VERIFICATION: Check bundle ID match between app and GoogleService-Info.plist');
      }
      return status;
    }
    
    // Get default Firebase app
    final app = Firebase.app();
    status['app_name'] = app.name;
    status['initialized'] = true;
    
    // Check if Crashlytics is available
    try {
      FirebaseCrashlytics.instance.log('Firebase verification: Crashlytics is available');
      status['crashlytics_available'] = true;
    } catch (e) {
      status['crashlytics_available'] = false;
      status['error'] = 'Crashlytics not available: $e';
    }
    
    if (kDebugMode) {
      print('FIREBASE VERIFICATION: ✅ SUCCESS');
      print('FIREBASE VERIFICATION: App count: ${status['app_count']}');
      print('FIREBASE VERIFICATION: App name: ${status['app_name']}');
      print('FIREBASE VERIFICATION: Crashlytics available: ${status['crashlytics_available']}');
    }
  } catch (e, stackTrace) {
    status['error'] = 'Firebase verification failed: $e';
    if (kDebugMode) {
      print('FIREBASE VERIFICATION: ❌ ERROR');
      print('FIREBASE VERIFICATION: ${status['error']}');
      print('FIREBASE VERIFICATION: Stack trace: $stackTrace');
    }
  }
  
  return status;
}

/// Test Crashlytics connection by sending test logs and errors
/// This helps verify Crashlytics is properly configured
void _testCrashlyticsConnection() {
  try {
    // First verify Firebase is initialized
    final status = _verifyFirebaseStatus();
    
    if (!status['initialized'] as bool) {
      if (kDebugMode) {
        print('CRASHLYTICS TEST: ❌ SKIPPED - Firebase not initialized');
        print('CRASHLYTICS TEST: ${status['error']}');
      }
      return;
    }
    
    if (!status['crashlytics_available'] as bool) {
      if (kDebugMode) {
        print('CRASHLYTICS TEST: ❌ SKIPPED - Crashlytics not available');
        print('CRASHLYTICS TEST: ${status['error']}');
      }
      return;
    }
    
    if (kDebugMode) {
      print('CRASHLYTICS TEST: ✅ Starting comprehensive test...');
    }
    
    // Get app version - update this to match pubspec.yaml
    final appVersion = '1.0.3';
    final buildNumber = '11';
    
    // Set custom keys for debugging
    FirebaseCrashlytics.instance.setCustomKey('app_version', appVersion);
    FirebaseCrashlytics.instance.setCustomKey('build_number', buildNumber);
    FirebaseCrashlytics.instance.setCustomKey('platform', 'iOS');
    FirebaseCrashlytics.instance.setCustomKey('test_type', 'comprehensive_startup_test');
    FirebaseCrashlytics.instance.setCustomKey('firebase_app_name', status['app_name'] as String);
    FirebaseCrashlytics.instance.setCustomKey('test_timestamp', DateTime.now().toIso8601String());
    
    // Send multiple test logs
    FirebaseCrashlytics.instance.log('TEST LOG 1: App startup initiated');
    FirebaseCrashlytics.instance.log('TEST LOG 2: Firebase initialized successfully');
    FirebaseCrashlytics.instance.log('TEST LOG 3: Crashlytics verification passed');
    FirebaseCrashlytics.instance.log('TEST LOG 4: Ready to receive crash reports');
    
    // Send a test non-fatal error to verify reporting works
    // This will appear in Firebase Console as a non-fatal error
    FirebaseCrashlytics.instance.recordError(
      Exception('TEST: Crashlytics is working correctly - This is a test error'),
      StackTrace.current,
      fatal: false,
      reason: 'This is a comprehensive test to verify Crashlytics is configured properly and receiving data',
    );
    
    // Send another test error with different type
    FirebaseCrashlytics.instance.log('TEST LOG 5: Sending second test error');
    FirebaseCrashlytics.instance.recordError(
      Exception('TEST: Crashlytics connectivity verified'),
      StackTrace.current,
      fatal: false,
      reason: 'Second test to confirm Crashlytics can receive multiple errors',
    );
    
    if (kDebugMode) {
      print('CRASHLYTICS TEST: ✅ COMPLETE');
      print('CRASHLYTICS TEST: Test logs and errors sent successfully');
      print('CRASHLYTICS TEST: Check Firebase Console → Crashlytics in 1-5 minutes');
      print('CRASHLYTICS TEST: You should see:');
      print('CRASHLYTICS TEST:   - "TEST: Crashlytics is working correctly"');
      print('CRASHLYTICS TEST:   - "TEST: Crashlytics connectivity verified"');
      print('CRASHLYTICS TEST:   - Custom keys with app version, build number, etc.');
      print('CRASHLYTICS TEST: If you DON\'T see these in Firebase Console:');
      print('CRASHLYTICS TEST:   1. Check bundle ID matches GoogleService-Info.plist');
      print('CRASHLYTICS TEST:   2. Verify GoogleService-Info.plist is in Xcode project');
      print('CRASHLYTICS TEST:   3. Check Firebase Console → Crashlytics → Settings');
      print('CRASHLYTICS TEST:   4. Verify app is registered in Firebase project');
    }
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('CRASHLYTICS TEST: ❌ FAILED');
      print('CRASHLYTICS TEST: Error: $e');
      print('CRASHLYTICS TEST: Stack trace: $stackTrace');
      print('CRASHLYTICS TEST: This means Crashlytics is not working properly');
    }
  }
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
      // Add context about the error
      FirebaseCrashlytics.instance.log('Flutter framework error occurred');
      FirebaseCrashlytics.instance.setCustomKey('error_type', 'flutter_error');
      FirebaseCrashlytics.instance.setCustomKey('error_message', details.exceptionAsString());
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
      // Add context about the error
      FirebaseCrashlytics.instance.log('Unhandled async error occurred');
      FirebaseCrashlytics.instance.setCustomKey('error_type', 'async_error');
      FirebaseCrashlytics.instance.setCustomKey('error_message', error.toString());
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
