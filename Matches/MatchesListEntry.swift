//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI

protocol WGListEntry: Equatable, Hashable {
  var imageString: String { get }
  var name: String { get }
  var ownDescription: String { get }
  var contactInfo: String { get }
}

struct MatchesListEntry<T: WGListEntry>: View {
  @Environment(\.colorScheme) var colorScheme
  @State private var showContactInfo = false
  let entry: T

  var body: some View {
    HStack {
      LazyImage(url: URL(string: entry.imageString)) { state in
        if let image = state.image {
          image
            .resizable()
            .clipShape(Circle())
            .frame(width: 60, height: 60)
        }
      }
      .padding(.horizontal, 10)

      VStack {
        Text(entry.name)
          .bold()
        VStack(alignment: .leading) {
          Text(entry.ownDescription)
            .foregroundStyle(.gray)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
        }
      }

      Spacer()

      Image(systemName: "arrow.right")
    }
    .foregroundStyle(colorScheme == .light ? .black : .white)
    .padding(12)
    .onTapGesture {
      showContactInfo = true
    }
    .alert("\(entry.name) ist zu erreichen unter \(entry.contactInfo)", isPresented: $showContactInfo, actions: {})
  }
}
