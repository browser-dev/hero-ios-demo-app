// Copyright 2026 The Hero Authors

import Foundation

/// What the address field loads: an address as typed, or a bare name over
/// HTTPS, which is how the SDK resolves it.
enum AddressToURL {
  static func url(for address: String) -> URL? {
    let trimmed = address.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.isEmpty || trimmed.contains(" ") {
      return nil
    }
    if trimmed.contains("://") {
      return URL(string: trimmed)
    }
    return URL(string: "https://\(trimmed)")
  }
}
