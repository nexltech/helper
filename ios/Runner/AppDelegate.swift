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
    // Initialize Firebase
    // Note: FirebaseApp.configure() doesn't throw, but may fail silently if
    // GoogleService-Info.plist is missing or invalid. The app will still launch.
    // Check Firebase Console if Crashlytics isn't working.
    if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
      // GoogleService-Info.plist exists, safe to configure Firebase
      FirebaseApp.configure()
    } else {
      // GoogleService-Info.plist is missing - log warning but continue
      // App will launch without Firebase/Crashlytics
      print("WARNING: GoogleService-Info.plist not found. Firebase will not be initialized.")
    }
    
    // Configure Crashlytics
    // Note: Crashlytics will automatically catch native crashes
    // Only works if Firebase was successfully configured above
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
