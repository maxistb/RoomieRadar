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
  var path: Binding<[SwipingNavigation]>

  init(isWGOffererState: Bool, path: Binding<[SwipingNavigation]>) {
    self.isWGOffererState = isWGOffererState
    self.path = path
  }

  var body: some View {
    NavigationStack(path: path) {
      switch viewModel.viewState {
      case .loading:
        loadingView
      case .success:
        normalView
      case .error:
        errorView
      }
    }
    .onChange(of: viewModel.viewState) { newValue in
      print("NEWVALUE: \(newValue)")
    }
  }

  private var loadingView: some View {
    ProgressView()
      .task {
        do {
          if !isWGOffererState {
            try await viewModel.getAllWGOfferer()
          } else {
            try await viewModel.getAllWGSearcher()
          }
        } catch {
          viewModel.viewState = .error
        }
      }
  }

  private var normalView: some View {
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
  }

  private var errorView: some View {
    VStack {
      Text("Ein Fehler ist aufgetreten.")

      Button("Erneut laden") {
        Task {
          if !isWGOffererState {
            try? await viewModel.getAllWGOfferer()
          } else {
            try? await viewModel.getAllWGSearcher()
          }
        }
      }
    }
  }
}
