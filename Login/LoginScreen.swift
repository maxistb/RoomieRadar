//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import Styleguide
import SwiftUI
import UIComponents

struct LoginScreen: View {
  @State private var email = ""
  @State private var password = ""

  var body: some View {
    NavigationStack {
      VStack {
        Text(L10n.loginScreenMainText)
          .font(.title2)
          .bold()
          .foregroundStyle(.gray)
          .multilineTextAlignment(.center)
          .padding(.top, 50)
          .padding(.bottom, 40)

        Image(asset: Asset.Images.house)
          .resizable()
          .frame(width: 200, height: 200)
          .padding(.bottom, 20)

        BorderedTextField(textInput: $email, placeholder: L10n.email, isPasswordField: false)
          .padding(.bottom, 20)

        BorderedTextField(textInput: $password, placeholder: L10n.password, isPasswordField: true)

        Spacer()

        PrimaryButton(isLoginButton: true)
          .padding(.top, 40)
          .padding(.horizontal, 20)
      }
      .padding(.horizontal, 15)
    }
  }
}
