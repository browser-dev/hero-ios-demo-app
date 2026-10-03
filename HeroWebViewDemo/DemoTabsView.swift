// Copyright 2026 The Hero Authors

import SwiftUI

/// How to add the SDK, and the SDK at work.
struct DemoTabsView: View {
  var body: some View {
    TabView {
      IntegrationGuideView()
        .tabItem { Label("Integrate", systemImage: "shippingbox") }
      BrowseView()
        .tabItem { Label("Browse", systemImage: "globe") }
    }
  }
}
