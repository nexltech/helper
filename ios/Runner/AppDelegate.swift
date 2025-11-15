import Flutter
import UIKit
import FirebaseCore
import FirebaseCrashlytics

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // CRITICAL: Initialize Firebase FIRST, before ANY other code
    // This ensures Crashlytics can catch crashes even in plugin registration
    var firebaseInitialized = false
    var firebaseError: Error?
    
    do {
      // Initialize Firebase as early as possible
      if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
        // GoogleService-Info.plist exists
        print("INFO: GoogleService-Info.plist found at: \(path)")
        
        // Get bundle ID from plist for verification
        if let plist = NSDictionary(contentsOfFile: path),
           let bundleId = plist["BUNDLE_ID"] as? String {
          let currentBundleId = Bundle.main.bundleIdentifier ?? "unknown"
          print("INFO: Bundle ID in plist: \(bundleId)")
          print("INFO: Current Bundle ID: \(currentBundleId)")
          
          if bundleId != currentBundleId {
            print("ERROR: Bundle ID mismatch! Plist has '\(bundleId)' but app has '\(currentBundleId)'")
            print("ERROR: Firebase will NOT initialize correctly with this mismatch")
          }
        }
        
        // Configure Firebase - wrap in do-catch to handle any errors
        FirebaseApp.configure()
        
        // Verify Firebase initialized
        if FirebaseApp.app() != nil {
          firebaseInitialized = true
          print("INFO: Firebase initialized successfully")
        } else {
          print("ERROR: FirebaseApp.configure() was called but Firebase.app() is nil")
        }
      } else {
        // GoogleService-Info.plist is missing
        print("ERROR: GoogleService-Info.plist not found in bundle")
        print("ERROR: Firebase will NOT initialize - Crashlytics will not work")
      }
    } catch {
      firebaseError = error
      print("ERROR: Firebase initialization threw error: \(error.localizedDescription)")
    }
    
    // Configure Crashlytics
    // Note: Crashlytics will automatically catch native crashes
    // Only works if Firebase was successfully configured above
    if !firebaseInitialized {
      print("WARNING: Crashlytics will NOT work because Firebase failed to initialize")
      print("WARNING: Check bundle ID mismatch or missing GoogleService-Info.plist")
      if let error = firebaseError {
        print("WARNING: Firebase error: \(error.localizedDescription)")
      }
    }
    
    // CRITICAL: Wrap plugin registration in try-catch
    // GeneratedPluginRegistrant.register() can crash if plugins are misconfigured
    // This ensures the app doesn't crash silently before Flutter starts
    do {
      print("INFO: Registering Flutter plugins...")
      GeneratedPluginRegistrant.register(with: self)
      print("INFO: Flutter plugins registered successfully")
    } catch {
      // Plugin registration failed - log error but try to continue
      print("ERROR: GeneratedPluginRegistrant.register() failed: \(error.localizedDescription)")
      
      // Try to record error to Crashlytics if Firebase is initialized
      if firebaseInitialized {
        // Create an NSError from the Swift error
        let nsError = error as NSError
        let errorInfo = [
          NSLocalizedDescriptionKey: "Plugin registration failed: \(error.localizedDescription)",
          NSLocalizedFailureReasonErrorKey: "GeneratedPluginRegistrant.register() threw an exception"
        ]
        let detailedError = NSError(domain: "AppDelegate", code: 1001, userInfo: errorInfo)
        
        // Record to Crashlytics
        Crashlytics.crashlytics().record(error: detailedError)
        Crashlytics.crashlytics().log("CRITICAL: Plugin registration failed on app launch")
      }
      
      // Re-throw to allow system to handle (but Crashlytics will have the error)
      // Actually, let's try to continue - maybe some plugins work
      print("WARNING: Attempting to continue despite plugin registration failure...")
    }
    
    // Call super AFTER everything is initialized
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    if firebaseInitialized {
      print("INFO: App delegate initialization complete - Firebase/Crashlytics ready")
    } else {
      print("WARNING: App delegate initialization complete - Firebase/Crashlytics NOT ready")
    }
    
    return result
  }
}
