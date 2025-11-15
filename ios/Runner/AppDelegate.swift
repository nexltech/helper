import Flutter
import UIKit
// Uncomment when Firebase Crashlytics is configured:
// import FirebaseCore
// import FirebaseCrashlytics

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase (uncomment when configured)
    // FirebaseApp.configure()
    
    // Configure Crashlytics (uncomment when configured)
    // Note: Crashlytics will automatically catch native crashes
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
