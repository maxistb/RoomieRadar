//
//  SwiftUIView.swift
//
//
//  Created by Maximillian Stabe on 07.02.24.
//

import SwiftUI

public struct TextMessage: View {
  let message: String
  let isMessageReceived: Bool

  private var backgroundColor: Color {
    isMessageReceived ? .white : .blue
  }

  private var paddingEdges: Edge.Set {
    isMessageReceived ? .leading : .trailing
  }

  public init(message: String, isMessageReceived: Bool) {
    self.message = message
    self.isMessageReceived = isMessageReceived
  }

  public var body: some View {
    GeometryReader { geometry in
      HStack {
        if !isMessageReceived {
          Spacer()
        }

        Text(message)
          .multilineTextAlignment(.leading)
          .frame(maxWidth: geometry.size.width * 0.75)
          .background {
            RoundedRectangle(cornerRadius: 8)
              .foregroundStyle(backgroundColor)
              .padding(-10)
          }
          .padding(paddingEdges, 10)

        if isMessageReceived {
          Spacer()
        }
      }
      .padding(.horizontal, 10)
    }
  }
}
