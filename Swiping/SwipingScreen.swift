//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI
import UIComponents

struct SwipingScreen: View {
  let viewState: ViewState
  private let showsWGOfferer: Bool

  init(viewState: ViewState) {
    self.viewState = viewState
    // shows WGOfferer if current user is WGSearching User
    self.showsWGOfferer = viewState == .wgSearcher
  }

  var body: some View {
    VStack(alignment: .leading) {
      imageView
        .overlay(alignment: .bottomLeading) {
          VStack {
            nameAndDescription
              .padding(10)
              .padding(.bottom, 20)
            buttons
          }
        }
    }
  }

  @MainActor
  private var imageView: some View {
    LazyImage(url: URL(string:
      showsWGOfferer
        ? WGOfferer.shared.imageString
        : WGSearcher.shared.imageString)
    ) { state in
      if let image = state.image {
        image
          .resizable()
      }
    }
  }

  private var nameAndDescription: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(showsWGOfferer ? WGOfferer.shared.name : "\(WGSearcher.shared.name),")
          .font(.title)
          .bold()

        if !showsWGOfferer {
          Text(WGSearcher.shared.age)
            .font(.title2)
        }
      }

      Text(showsWGOfferer ? WGOfferer.shared.wgDescription : WGSearcher.shared.ownDescription)
        .font(.subheadline)
        .lineLimit(3)
    }
  }

  private var buttons: some View {
    HStack {
      SwipingButton(isLikeButton: false) {}
      SwipingButton(isLikeButton: true) {}
    }
  }
}

enum ViewState {
  case wgOfferer
  case wgSearcher
}
