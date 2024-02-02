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

  @State private var offset = CGSize.zero
  @State private var color: Color = .clear

  var body: some View {
    ZStack {
      if let wgOfferer = wgOfferer {
        WGOffererCardContent(wgOfferer: wgOfferer, offset: $offset)
      }
      if let wgSearcher = wgSearcher {
        WGSearcherCardContent(wgSearcher: wgSearcher, offset: $offset)
      }

      Rectangle()
        .foregroundStyle(color.opacity(0.6))
        .shadow(radius: 4)
    }
    .offset(x: offset.width, y: offset.height)
    .rotationEffect(.degrees(Double(offset.width / 40)))
    .gesture(DragGesture()
      .onChanged { gesture in
        offset = gesture.translation
        withAnimation {
          changeColor(width: offset.width)
        }
      }
      .onEnded { _ in
        withAnimation {
          swipeCard(width: offset.width)
          changeColor(width: offset.width)
        }
      })
  }

  private func swipeCard(width: CGFloat) {
    switch width {
    case -500 ... -130:
      print("REMOVED ")
      offset = CGSize(width: -500, height: 0)
    case 130 ... 500:
      print("ADDED")
      offset = CGSize(width: 500, height: 0)
    default:
      offset = .zero
    }
  }

  private func changeColor(width: CGFloat) {
    switch width {
    case -500 ... -130:
      color = .red
    case 130 ... 500:
      color = .green
    default:
      color = .clear
    }
  }
}
