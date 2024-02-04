//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI
import UIComponents

struct WGOffererCardContent: View {
  let wgOfferer: WGOfferer
  let viewModel: SwipingCardViewModel

  @State private var showMoreInfo = false

  var body: some View {
    VStack {
      imageView
        .overlay(alignment: .bottomLeading) {
          VStack(alignment: .leading) {
            nameAndDescription
              .padding(10)
              .padding(.bottom, 20)
            buttons
              .padding(.bottom, 10)
          }
        }
    }
    .sheet(isPresented: $showMoreInfo, content: {
      wgOffererMoreInfo
        .presentationDragIndicator(.visible)
    })
  }

  @MainActor
  private var imageView: some View {
    LazyImage(url: URL(string: wgOfferer.imageString)) { state in
      if let image = state.image {
        image
          .resizable()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }

  private var nameAndDescription: some View {
    VStack(alignment: .leading) {
      Text(wgOfferer.name)
        .foregroundStyle(.white)
        .font(.title)
        .bold()

      HStack {
        Text(wgOfferer.wgDescription)
          .foregroundStyle(.white)
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
      Spacer()
      SwipingButton(state: .dislike) {
        withAnimation {
          showMoreInfo = false
          viewModel.offset = CGSize(width: -500, height: 0)
          viewModel.dislikeUser(dislikedUserID: wgOfferer.id)
        }
      }
      SwipingButton(state: .like) {
        withAnimation {
          showMoreInfo = false
          viewModel.offset = CGSize(width: 500, height: 0)
          viewModel.likeUser(likedUserID: wgOfferer.id)
        }
      }
      Spacer()
    }
  }

  @MainActor
  private var wgOffererMoreInfo: some View {
    ScrollView {
      LazyImage(url: URL(string: wgOfferer.imageString)) { state in
        if let image = state.image {
          image
            .resizable()
            .ignoresSafeArea(.all, edges: .top)
        }
      }

      HStack {
        Spacer()
        SwipingButton(state: .info) {
          showMoreInfo = false
        }
        .padding(.top, -40)
      }
      .padding(.horizontal, 12)

      VStack(alignment: .leading, spacing: 10) {
        Text(wgOfferer.name)
          .font(.title2)
          .bold()
        Text("\(Image(systemName: "mappin")) \(wgOfferer.address)")
        Text("\(wgOfferer.wgSize)m²")
        Text("\(wgOfferer.wgPrice)€ mtl.")
        Divider()
        Text("Wonach suchen wir?")
          .font(.title3)
          .bold()
        Text(wgOfferer.idealRoommate)
        Divider()
        Text("Beschreibung")
          .font(.title3)
          .bold()
        Text(wgOfferer.wgDescription)
        Divider()
        Text("Kontakt")
          .font(.title3)
          .bold()
        Text(wgOfferer.contactInfo)
      }
      .padding(12)
      .padding(.bottom, 60)
    }
    .multilineTextAlignment(.leading)
    .overlay(alignment: .bottom) {
      buttons
    }
  }
}
