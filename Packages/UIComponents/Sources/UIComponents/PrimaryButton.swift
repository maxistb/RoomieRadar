//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

public struct PrimaryButton: View {
  let isLoginButton: Bool
  let action: () -> Void

  public init(isLoginButton: Bool, action: @escaping () -> Void) {
    self.isLoginButton = isLoginButton
    self.action = action
  }

  public var body: some View {
    Button {
      action()
    } label: {
      ZStack {
        Text(isLoginButton ? L10n.login : L10n.register)
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
          .frame(minHeight: 24)
      }
    }
    .buttonStyle(
      PrimaryButtonStyle()
    )
  }
}

public struct PrimaryButtonStyle: ButtonStyle {
  @Environment(\.colorScheme) var colorScheme

  private var borderColor: Color {
    colorScheme == .light ? Color.gray : Asset.Color.darkSecondary.swiftUIColor
  }

  public init() {}

  public func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .frame(maxWidth: .infinity)
      .padding(12)
      .background(
        RoundedRectangle(cornerRadius: 24)
          .fill(configuration.isPressed ? borderColor : Color.clear)
      )
      .overlay(
        RoundedRectangle(cornerRadius: 24)
          .strokeBorder(borderColor, lineWidth: 2)
      )
  }
}
