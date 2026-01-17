import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Call super to ensure Flutter is ready
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)
    
    return result
  }
}
