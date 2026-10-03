// Copyright 2026 The Hero Authors

import XCTest

@testable import HeroWebViewDemo

final class DemoTourTests: XCTestCase {
  private let sites = [
    DemoSite(service: "ENS", name: "vitalik.eth"),
    DemoSite(service: "Filecoin", name: "654321.fil"),
  ]

  func testTheTourOpensEverySiteInOrderThenEnds() {
    var tour = DemoTour(sites: sites)
    XCTAssertEqual(tour.next(), sites[0])
    XCTAssertEqual(tour.next(), sites[1])
    XCTAssertNil(tour.next())
    XCTAssertNil(tour.next())
  }

  func testTheTourSaysHowFarItGot() {
    var tour = DemoTour(sites: sites)
    XCTAssertEqual(tour.progress, "0/2")
    _ = tour.next()
    XCTAssertEqual(tour.progress, "1/2")
  }

  func testTheSummaryCountsTheLoadedAndNamesTheFailed() {
    var tour = DemoTour(sites: sites)
    tour.record(sites[0], loaded: true)
    XCTAssertEqual(tour.summary, "1/2 loaded")
    tour.record(sites[1], loaded: false)
    XCTAssertEqual(tour.summary, "1/2 loaded · failed: Filecoin 654321.fil")
  }

  func testASiteIsRecordedOnce() {
    var tour = DemoTour(sites: sites)
    tour.record(sites[0], loaded: false)
    tour.record(sites[0], loaded: true)
    XCTAssertEqual(tour.summary, "0/2 loaded · failed: ENS vitalik.eth")
  }

  func testEverySiteHasAServiceAndADistinctName() {
    XCTAssertEqual(Set(DemoSite.all.map(\.name)).count, DemoSite.all.count)
    XCTAssertFalse(DemoSite.all.contains { $0.service.isEmpty })
  }
}
