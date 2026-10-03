// Copyright 2026 The Hero Authors

import XCTest

@testable import HeroWebViewDemo

final class AddressToURLTests: XCTestCase {
  func testABareNameLoadsOverHttps() {
    XCTAssertEqual(AddressToURL.url(for: "vitalik.eth")?.absoluteString, "https://vitalik.eth")
    XCTAssertEqual(AddressToURL.url(for: "  shakeshift/ ")?.absoluteString, "https://shakeshift/")
  }

  func testAnAddressWithASchemeLoadsAsTyped() {
    XCTAssertEqual(AddressToURL.url(for: "ens://vitalik.eth/")?.absoluteString,
                   "ens://vitalik.eth/")
    XCTAssertEqual(AddressToURL.url(for: "http://example.com")?.absoluteString,
                   "http://example.com")
  }

  func testNothingOrWordsAreNoAddress() {
    XCTAssertNil(AddressToURL.url(for: "   "))
    XCTAssertNil(AddressToURL.url(for: "two words"))
  }
}
