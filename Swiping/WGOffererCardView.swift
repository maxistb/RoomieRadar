//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import SwiftUI

struct WGOffererCardView: View {
  let wgOfferer: WGOfferer

  @State private var offset = CGSize.zero
  @State private var color: Color = .black

  var body: some View {
    ZStack {
      Rectangle()
        .frame(width: 320, height: 420)
        .border(.white, width: 6)
        .foregroundStyle(color.opacity(0.9))
        .shadow(radius: 4)

      HStack {
        Text(wgOfferer.name)
          .font(.largeTitle)
          .foregroundStyle(.white)
          .bold()
        Image(systemName: "heart.fill")
          .foregroundStyle(.red)
      }
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
    case -500 ... -150:
      print("REMOVED ")
      offset = CGSize(width: -500, height: 0)
    case 150 ... 500:
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
      color = .black
    }
  }
}
