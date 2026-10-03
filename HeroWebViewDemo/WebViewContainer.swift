// Copyright 2026 The Hero Authors

import HeroWebView
import SwiftUI

/// Puts a CWVWebView in SwiftUI, as any UIKit view.
struct WebViewContainer: UIViewRepresentable {
  let webView: CWVWebView

  func makeUIView(context: Context) -> CWVWebView {
    webView
  }

  func updateUIView(_ uiView: CWVWebView, context: Context) {}
}
