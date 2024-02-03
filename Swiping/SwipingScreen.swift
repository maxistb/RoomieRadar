//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseFirestore
import SwiftUI

struct SwipingScreen: View {
  @ObservedObject private var viewModel = SwipingScreenViewModel()

  // is true if the current user is wgofferer
  let isWGOffererState: Bool

  var body: some View {
    VStack {
      ZStack {
        if !isWGOffererState {
          ForEach(viewModel.wgOffererArray, id: \.id) { wgOfferer in
            SwipingCardView(wgOfferer: wgOfferer, wgSearcher: nil)
          }
        } else {
          ForEach(viewModel.wgSearcherArray, id: \.id) { wgSearcher in
            SwipingCardView(wgOfferer: nil, wgSearcher: wgSearcher)
          }
        }
      }
    }
    .onAppear {
      if !isWGOffererState {
        viewModel.getAllWGOfferer()
      } else {
        viewModel.getAllWGSearcher { wgSearcher, _ in
          if let wgSearcher = wgSearcher {
            viewModel.wgSearcherArray = wgSearcher
          }
        }
      }
    }
  }
}
