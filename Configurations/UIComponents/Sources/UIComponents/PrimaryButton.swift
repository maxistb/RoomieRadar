//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

public struct PrimaryButton: View {
  let isLoginButton: Bool
  let isEnabled: Bool

  public init(isLoginButton: Bool) {
    self.isLoginButton = isLoginButton
    self.isEnabled = true
  }

  public var body: some View {
    Button {} label: {
      ZStack {
        Text(isLoginButton ? L10n.login : L10n.register)
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
          .frame(minHeight: 24)
      }
    }
    .buttonStyle(
      PrimaryButtonStyle()
    )
    .disabled(!isEnabled)
  }
}

public struct PrimaryButtonStyle: ButtonStyle {
  public func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .frame(maxWidth: .infinity)
      .padding(12)
      .background(
        RoundedRectangle(cornerRadius: 24)
          .fill(configuration.isPressed ? Asset.Color.beatzColor.swiftUIColor : Color.clear)
      )
      .overlay(
        RoundedRectangle(cornerRadius: 24)
          .strokeBorder(Color.black, lineWidth: 2)
      )
  }
}
