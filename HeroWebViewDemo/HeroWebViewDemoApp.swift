// Copyright 2026 The Hero Authors

import SwiftUI

@main
struct HeroWebViewDemoApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

  var body: some Scene {
    WindowGroup {
      DemoTabsView()
    }
  }
}
