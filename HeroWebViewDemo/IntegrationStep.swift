// Copyright 2026 The Hero Authors

/// One step of adding HeroWebView to an app, as the SDK's README gives it.
struct IntegrationStep: Identifiable {
  let id: Int
  let title: String
  let detail: String
  let code: String?

  static let all: [IntegrationStep] = [
    IntegrationStep(
      id: 1, title: "Add the framework",
      detail: "Drag HeroWebView.xcframework into the project and set it to "
        + "Embed & Sign. iOS 18 or later.",
      code: nil),
    IntegrationStep(
      id: 2, title: "Allow the local IPFS origin",
      detail: "IPFS sites are served inside the app, from "
        + "http://<cid>.ipfs.localhost. In Info.plist:",
      code: """
        NSAppTransportSecurity
          NSExceptionDomains
            ipfs.localhost
              NSIncludesSubdomains: YES
              NSExceptionAllowsInsecure
                HTTPLoads: YES
        """),
    IntegrationStep(
      id: 3, title: "Start the engine",
      detail: "Once, in application(_:willFinishLaunchingWithOptions:).",
      code: """
        import HeroWebView

        let state = CWVGlobalState.sharedInstance
        state.earlyInit()
        state.start()
        """),
    IntegrationStep(
      id: 4, title: "Open a name",
      detail: "CWVWebView works like WKWebView. The name stays in visibleURL.",
      code: """
        let webView = CWVWebView(
            frame: view.bounds,
            configuration: .default())
        view.addSubview(webView)
        let url = URL(string: "https://vitalik.eth")!
        webView.load(URLRequest(url: url))
        """),
  ]
}
