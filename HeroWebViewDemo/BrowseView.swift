// Copyright 2026 The Hero Authors

import SwiftUI

/// An address field, a button per name service, the tour, and the page.
struct BrowseView: View {
  @StateObject private var browser = BrowserModel()
  @State private var address = ""

  var body: some View {
    VStack(spacing: 8) {
      HStack {
        TextField("Name or address", text: $address)
          .textFieldStyle(.roundedBorder)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()
          .onSubmit { browser.open(address) }
        Button("Go") { browser.open(address) }
      }
      .padding(.horizontal)

      LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 3),
                spacing: 6) {
        ForEach(DemoSite.all) { site in
          Button {
            address = site.name
            browser.open(site)
          } label: {
            VStack(spacing: 0) {
              HStack(spacing: 3) {
                Text(site.service)
                if let badge = badge(site) {
                  Image(systemName: badge)
                }
              }
              .font(.caption2)
              .opacity(0.8)
              Text(site.name).font(.caption).bold()
            }
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .frame(maxWidth: .infinity)
          }
          .buttonStyle(.borderedProminent)
          .tint(tint(site))
        }
      }
      .padding(.horizontal)

      Button {
        if browser.touring {
          browser.stopTour()
        } else {
          browser.playAll()
        }
      } label: {
        Label(browser.touring ? "Stop" : "Play all name services",
              systemImage: browser.touring ? "stop.fill" : "play.fill")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.bordered)
      .padding(.horizontal)

      Text(browser.status)
        .font(.footnote)
        .lineLimit(2)
        .truncationMode(.middle)
        .padding(.horizontal)

      WebViewContainer(webView: browser.webView)
    }
    .padding(.top, 8)
  }

  private func badge(_ site: DemoSite) -> String? {
    switch browser.outcomes[site] {
    case true?: "checkmark.circle.fill"
    case false?: "xmark.circle.fill"
    case nil: nil
    }
  }

  private func tint(_ site: DemoSite) -> Color? {
    switch browser.outcomes[site] {
    case true?: .green
    case false?: .red
    case nil: nil
    }
  }
}
