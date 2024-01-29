//
//  SwiftUIView.swift
//
//
//  Created by Maximillian Stabe on 29.01.24.
//

import SwiftUI

public struct SwipingButton: View {
  private let isLikeButton: Bool
  private let action: () -> Void

  public init(isLikeButton: Bool, action: @escaping () -> Void) {
    self.isLikeButton = isLikeButton
    self.action = action
  }

  public var body: some View {
    Button {
      action()
    } label: {
      Circle()
        .strokeBorder(style: StrokeStyle(lineWidth: 1))
        .foregroundStyle(isLikeButton ? .green : .pink)
        .background {
          Circle()
            .frame(width: 60, height: 60)
            .foregroundStyle(.black.opacity(0.7))
        }
        .frame(width: 60, height: 60)
        .overlay {
          Image(systemName: isLikeButton ? "heart.fill" : "xmark")
            .foregroundStyle(isLikeButton ? .green : .pink)
        }
    }
  }
}

#Preview {
  SwipingButton(isLikeButton: true) {}
}
