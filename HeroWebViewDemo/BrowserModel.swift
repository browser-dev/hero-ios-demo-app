// Copyright 2026 The Hero Authors

import Combine
import HeroWebView
import UIKit

/// The demo's one web view, the line that says what it shows, and the tour
/// through every name service.
final class BrowserModel: NSObject, ObservableObject, CWVNavigationDelegate {
  /// How long a page stays on screen before the tour moves on.
  private static let dwell: TimeInterval = 7
  /// How long the tour waits for a page that does not finish.
  private static let pageTimeout: TimeInterval = 40

  let webView: CWVWebView
  @Published private(set) var status = "Tap a name, or Play all"
  @Published private(set) var touring = false
  /// Whether each site of the last tour loaded.
  @Published private(set) var outcomes: [DemoSite: Bool] = [:]

  private var tour: DemoTour?
  private var current: DemoSite?
  private var advance: DispatchWorkItem?

  override init() {
    webView = CWVWebView(frame: .zero, configuration: .default())
    super.init()
    webView.navigationDelegate = self
  }

  func open(_ address: String) {
    stopTour()
    current = nil
    load(address)
  }

  func open(_ site: DemoSite) {
    stopTour()
    current = site
    load(site.name)
  }

  func playAll() {
    tour = DemoTour(sites: DemoSite.all)
    current = nil
    outcomes = [:]
    touring = true
    openNextInTour()
  }

  func stopTour() {
    advance?.cancel()
    tour = nil
    touring = false
  }

  func webViewDidFinishNavigation(_ webView: CWVWebView) {
    let address = webView.visibleURL?.absoluteString ?? ""
    status = prefixed("\(webView.title ?? "") · \(address)")
    recordCurrent(loaded: true)
    scheduleNext(after: Self.dwell)
  }

  func webView(_ webView: CWVWebView, didFailNavigationWithError error: Error) {
    // A cancelled navigation gave way to another, which reports for itself.
    if (error as NSError).code == NSURLErrorCancelled {
      return
    }
    status = prefixed("Failed: \(error.localizedDescription)")
    recordCurrent(loaded: false)
    scheduleNext(after: Self.dwell)
  }

  private func load(_ address: String) {
    guard let url = AddressToURL.url(for: address) else {
      status = "Not an address: \(address)"
      return
    }
    status = prefixed("Opening \(url.absoluteString)")
    webView.load(URLRequest(url: url))
  }

  private func openNextInTour() {
    // A page still loading when its time is up did not load.
    recordCurrent(loaded: false)
    guard var running = tour, let site = running.next() else {
      let summary = tour?.summary ?? ""
      stopTour()
      status = "Played all \(DemoSite.all.count) name services: \(summary)"
      return
    }
    tour = running
    current = site
    load(site.name)
    scheduleNext(after: Self.pageTimeout)
  }

  private func recordCurrent(loaded: Bool) {
    guard touring, let current else {
      return
    }
    tour?.record(current, loaded: loaded)
    outcomes = tour?.outcomes ?? [:]
  }

  private func scheduleNext(after delay: TimeInterval) {
    guard touring else {
      return
    }
    advance?.cancel()
    let work = DispatchWorkItem { [weak self] in self?.openNextInTour() }
    advance = work
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
  }

  private func prefixed(_ text: String) -> String {
    var parts: [String] = []
    if let tour, touring {
      parts.append(tour.progress)
    }
    if let current {
      parts.append(current.service)
    }
    parts.append(text)
    return parts.joined(separator: " · ")
  }
}
