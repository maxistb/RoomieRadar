//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI
import UIComponents

struct WGOffererCardContent: View {
  let wgOfferer: WGOfferer
  @State private var showMoreInfo = false
  @Binding var offset: CGSize

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
        .font(.title)
        .bold()

      HStack {
        Text(wgOfferer.wgDescription)
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
      SwipingButton(isLikeButton: false) {
        withAnimation {
          offset = CGSize(width: -500, height: 0)
        }
      }
      SwipingButton(isLikeButton: true) {
        withAnimation {
          offset = CGSize(width: 500, height: 0)
        }
      }
      Spacer()
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
}
