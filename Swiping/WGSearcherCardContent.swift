//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import NukeUI
import SwiftUI
import UIComponents

struct WGSearcherCardContent: View {
  let wgSearcher: WGSearcher
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
      wgSearcherMoreInfo
        .presentationDragIndicator(.visible)
    })
  }

  @MainActor
  private var imageView: some View {
    LazyImage(url: URL(string: wgSearcher.imageString)) { state in
      if let image = state.image {
        image
          .resizable()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }

  private var nameAndDescription: some View {
    VStack(alignment: .leading) {
      Text(wgSearcher.name)
        .font(.title)
        .bold()

      HStack {
        Text(wgSearcher.ownDescription)
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
          viewModel.offset = CGSize(width: -500, height: 0)
          viewModel.dislikeUser(dislikedUserID: wgSearcher.id)
        }
      }
      SwipingButton(state: .like) {
        withAnimation {
          viewModel.offset = CGSize(width: 500, height: 0)
          viewModel.likeUser(likedUserID: wgSearcher.id)
        }
      }
      Spacer()
    }
  }

  @MainActor
  private var wgSearcherMoreInfo: some View {
    ScrollView {
      LazyImage(url: URL(string: wgSearcher.imageString)) { state in
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
        Text("\(wgSearcher.name), \(wgSearcher.age)")
          .font(.title2)
          .bold()
        Text(wgSearcher.gender)
        Divider()
        Text("Beschreibung")
          .font(.title3)
          .bold()
        Text(wgSearcher.ownDescription)
        Divider()
        Text("Hobbies")
          .font(.title3)
          .bold()
        Text(wgSearcher.hobbies)
        Divider()
        Text("Kontakt")
          .font(.title3)
          .bold()
        Text(wgSearcher.contactInfo)
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
