//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI

struct MatchesListWGOffererEntry: View {
  let wgOfferer: WGOfferer

  var body: some View {
    HStack {
      LazyImage(url: URL(string: wgOfferer.imageString)) { state in
        if let image = state.image {
          image
            .resizable()
            .clipShape(Circle())
            .frame(width: 60, height: 60)
        }
      }
      .padding(.horizontal, 10)

      VStack {
        Text(wgOfferer.name)
        Text(wgOfferer.wgDescription)
          .lineLimit(2)
      }

      Spacer()

      Image(systemName: "arrow.right")
    }
    .padding(12)
  }
}
