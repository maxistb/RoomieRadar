//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI
import UIComponents

struct OldSwipingScreen: View {
  @ObservedObject var viewModel = SwipingScreenViewModel()
  @State private var showMoreInfo = false

  let viewState: ViewState
  private let showsWGOfferer: Bool

  init(viewState: ViewState) {
    self.viewState = viewState
    // shows WGOfferer if current user is WGSearching User
    self.showsWGOfferer = viewState == .wgSearcher
  }

  var body: some View {
    if let currentWGOfferer = viewModel.currentWGOfferer {
      createNormalView(currentWGOfferer: currentWGOfferer)
    } else {
      createNormalView(currentWGOfferer: WGOfferer.shared)
    }
  }

  private func createNormalView(currentWGOfferer: WGOfferer) -> some View {
    VStack(alignment: .leading) {
      imageView(currentWGOfferer: currentWGOfferer)
        .overlay(alignment: .bottomLeading) {
          VStack {
            nameAndDescription(currentWGOfferer: currentWGOfferer)
              .padding(10)
              .padding(.bottom, 20)
            buttons
              .padding(.bottom, 10)
          }
        }
    }
    .sheet(isPresented: $showMoreInfo, content: {
      Group {
        if showsWGOfferer {
          wgOffererMoreInfo
        } else {
          wgSearcherMoreInfo
        }
      }
      .presentationDragIndicator(.visible)
    })
    .ignoresSafeArea(edges: .top)
  }

  @MainActor
  private func imageView(currentWGOfferer: WGOfferer) -> some View {
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

  private func nameAndDescription(currentWGOfferer: WGOfferer) -> some View {
    VStack(alignment: .leading) {
      Text(currentWGOfferer.name)
        .font(.title)
        .bold()

      HStack {
        Text(currentWGOfferer.wgDescription)
          .font(.subheadline)
          .lineLimit(3)
        Button {
          showMoreInfo = true
        } label: {
          Image(systemName: "info.circle")
            .foregroundStyle(.yellow)
        }
      }
    }
  }

  private var buttons: some View {
    HStack(spacing: 30) {
      SwipingButton(isLikeButton: false) {
        if viewModel.wgOffererArray.count > 1 {
          viewModel.wgOffererArray.removeFirst(1)
        }
      }
      SwipingButton(isLikeButton: true) {}
    }
  }

  @MainActor
  private var wgOffererMoreInfo: some View {
    VStack {
      LazyImage(url: URL(string: WGOfferer.shared.imageString)) { state in
        if let image = state.image {
          image
            .resizable()
            .clipShape(Circle())
            .frame(width: 60, height: 60)
        }
      }
      Text(WGOfferer.shared.name)
      Text(WGOfferer.shared.address)
      Text(WGOfferer.shared.contactInfo)
      Text(WGOfferer.shared.idealRoommate)
      Text(WGOfferer.shared.wgDescription)
      Text(WGOfferer.shared.wgSize)
      Text(WGOfferer.shared.wgPrice)
    }
  }

  @MainActor
  private var wgSearcherMoreInfo: some View {
    VStack {
      LazyImage(url: URL(string: WGSearcher.shared.imageString)) { state in
        if let image = state.image {
          image
            .resizable()
            .clipShape(Circle())
            .frame(width: 60, height: 60)
        }
      }
      Text(WGSearcher.shared.name)
      Text(WGSearcher.shared.age)
      Text(WGSearcher.shared.gender)
      Text(WGSearcher.shared.contactInfo)
      Text(WGSearcher.shared.hobbies)
      Text(WGSearcher.shared.ownDescription)
    }
  }
}

enum ViewState {
  case wgOfferer
  case wgSearcher
}
