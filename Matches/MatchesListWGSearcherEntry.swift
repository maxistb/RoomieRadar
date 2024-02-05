//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI

struct MatchesListWGSearcherEntry: View {
  let wgSearcher: WGSearcher

  var body: some View {
    HStack {
      LazyImage(url: URL(string: wgSearcher.imageString)) { state in
        if let image = state.image {
          image
            .resizable()
            .clipShape(Circle())
            .frame(width: 60, height: 60)
        }
      }
      .padding(.horizontal, 10)

      VStack {
        Text(wgSearcher.name)
        Text(wgSearcher.ownDescription)
          .lineLimit(2)
      }

      Spacer()

      Image(systemName: "arrow.right")
    }
    .padding(12)
  }
}
