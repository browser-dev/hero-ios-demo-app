// Copyright 2026 The Hero Authors

/// The sites the "Play all" button opens, one after another, and how each
/// one went.
struct DemoTour {
  private let sites: [DemoSite]
  private var opened = 0
  private(set) var outcomes: [DemoSite: Bool] = [:]

  init(sites: [DemoSite]) {
    self.sites = sites
  }

  var progress: String { "\(opened)/\(sites.count)" }

  var summary: String {
    let loaded = sites.filter { outcomes[$0] == true }.count
    let failed = sites.filter { outcomes[$0] == false }
    var text = "\(loaded)/\(sites.count) loaded"
    if !failed.isEmpty {
      text += " · failed: " + failed.map { "\($0.service) \($0.name)" }.joined(separator: ", ")
    }
    return text
  }

  mutating func next() -> DemoSite? {
    guard opened < sites.count else {
      return nil
    }
    opened += 1
    return sites[opened - 1]
  }

  /// The first outcome stands: a page that failed and then finished an error
  /// page did not load.
  mutating func record(_ site: DemoSite, loaded: Bool) {
    if outcomes[site] == nil {
      outcomes[site] = loaded
    }
  }
}
