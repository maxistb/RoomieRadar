//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI
import UIComponents

struct SwipingCardView: View {
  let wgOfferer: WGOfferer?
  let wgSearcher: WGSearcher?

  @ObservedObject private var viewModel = SwipingCardViewModel()

  var body: some View {
    ZStack {
      if let wgOfferer = wgOfferer {
        WGOffererCardContent(wgOfferer: wgOfferer, viewModel: viewModel)
      }
      if let wgSearcher = wgSearcher {
        WGSearcherCardContent(wgSearcher: wgSearcher, viewModel: viewModel)
      }

      Rectangle()
        .foregroundStyle(viewModel.color.opacity(0.6))
        .shadow(radius: 4)
    }
    .offset(x: viewModel.offset.width, y: viewModel.offset.height)
    .rotationEffect(.degrees(Double(viewModel.offset.width / 40)))
    .gesture(DragGesture()
      .onChanged { gesture in
        viewModel.offset = gesture.translation
        withAnimation {
          viewModel.changeColor(width: viewModel.offset.width)
        }
      }
      .onEnded { _ in
        withAnimation {
          if let wgOfferer = wgOfferer {
            viewModel.swipeCard(likedUserID: wgOfferer.id)
          }
          if let wgSearcher = wgSearcher {
            viewModel.swipeCard(likedUserID: wgSearcher.id)
          }

          viewModel.changeColor(width: viewModel.offset.width)
        }
      })
  }
}
