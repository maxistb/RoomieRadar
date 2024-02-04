//
//  SwiftUIView.swift
//
//
//  Created by Maximillian Stabe on 29.01.24.
//

import SwiftUI

public struct SwipingButton: View {
  private let state: ViewState
  private let action: () -> Void

  public init(state: ViewState, action: @escaping () -> Void) {
    self.state = state
    self.action = action
  }

  public var body: some View {
    Button {
      action()
    } label: {
      Circle()
        .strokeBorder(style: StrokeStyle(lineWidth: 1))
        .foregroundStyle(state.color)
        .background {
          Circle()
            .frame(width: 60, height: 60)
            .foregroundStyle(.black.opacity(0.7))
        }
        .frame(width: 60, height: 60)
        .overlay {
          state.image
            .foregroundStyle(state.color)
        }
    }
  }
}

extension SwipingButton {
  public enum ViewState {
    case like
    case dislike
    case info

    var color: Color {
      switch self {
      case .like:
        Color.green
      case .dislike:
        Color.pink
      case .info:
        Color.yellow
      }
    }

    var image: Image {
      switch self {
      case .like:
        Image(systemName: "heart.fill")
      case .dislike:
        Image(systemName: "xmark")
      case .info:
        Image(systemName: "arrow.down")
      }
    }
  }
}
