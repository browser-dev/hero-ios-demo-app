// Copyright 2026 The Hero Authors

import SwiftUI

/// The README's steps, on the phone.
struct IntegrationGuideView: View {
  var body: some View {
    NavigationStack {
      List(IntegrationStep.all) { step in
        VStack(alignment: .leading, spacing: 8) {
          Text("\(step.id). \(step.title)").font(.headline)
          Text(step.detail).font(.subheadline)
          if let code = step.code {
            Text(code)
              .font(.system(.caption, design: .monospaced))
              .padding(8)
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(Color(.secondarySystemBackground))
              .clipShape(RoundedRectangle(cornerRadius: 6))
          }
        }
        .padding(.vertical, 4)
      }
      .navigationTitle("HeroWebView SDK")
    }
  }
}
