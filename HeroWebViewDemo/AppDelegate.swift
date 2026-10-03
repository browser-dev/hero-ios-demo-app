// Copyright 2026 The Hero Authors

import HeroWebView
import UIKit

/// Starts the engine before the first web view exists and stops it on exit,
/// as the SDK's README asks of every app.
final class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    willFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    CWVGlobalState.sharedInstance.earlyInit()
    CWVGlobalState.sharedInstance.start()
    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    CWVGlobalState.sharedInstance.stop()
  }
}
