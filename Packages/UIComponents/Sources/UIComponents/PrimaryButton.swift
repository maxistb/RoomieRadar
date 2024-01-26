//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

public struct PrimaryButton: View {
  let isLoginButton: Bool
  let isEnabled: Bool
  let action: () -> Void

  public init(isLoginButton: Bool, action: @escaping () -> Void) {
    self.isLoginButton = isLoginButton
    self.isEnabled = true
    self.action = action
  }

  public var body: some View {
    Button {
      action()
    } label: {
      ZStack {
        Text(isLoginButton ? L10n.login : L10n.register)
          .foregroundStyle(isEnabled ? Asset.Color.beatzColor.swiftUIColor : Color.gray)
          .frame(minHeight: 24)
      }
    }
    .buttonStyle(
      PrimaryButtonStyle(isEnabled: isEnabled)
    )
    .disabled(!isEnabled)
  }
}

public struct PrimaryButtonStyle: ButtonStyle {
  @Environment(\.colorScheme) var colorScheme
  let isEnabled: Bool

  private var borderColor: Color {
    if isEnabled {
      colorScheme == .light ? Color.gray : Asset.Color.darkSecondary.swiftUIColor
    } else {
      Color.gray
    }
  }

  public init(isEnabled: Bool) {
    self.isEnabled = isEnabled
  }

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
