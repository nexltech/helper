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
    // Initialize Firebase with detailed diagnostics
    // Note: Bundle ID must match GoogleService-Info.plist or Firebase will fail silently
    var firebaseInitialized = false
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
      
      // Configure Firebase
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
    
    // Configure Crashlytics
    // Note: Crashlytics will automatically catch native crashes
    // Only works if Firebase was successfully configured above
    if !firebaseInitialized {
      print("WARNING: Crashlytics will NOT work because Firebase failed to initialize")
      print("WARNING: Check bundle ID mismatch or missing GoogleService-Info.plist")
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
