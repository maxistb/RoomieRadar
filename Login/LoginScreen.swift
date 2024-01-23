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
  @State private var navigationPath = NavigationPath()
  let isLoginScreen: Bool

  @State private var showAlert = false

  private var isDisabled: Bool {
    email.isEmpty || password.isEmpty
  }

  var body: some View {
    NavigationStack(path: $navigationPath) {
      VStack {
        header
        if isLoginScreen {
          mainImage
          textFields
        } else {
          textFields
        }
        Spacer()
        bottomButtons
      }
      .padding(.horizontal, 15)
      .navigationBarBackButtonHidden()
    }
  }

  private var header: some View {
    Text(isLoginScreen ? L10n.loginScreenMainText : L10n.registerScreenMainText)
      .font(.title2)
      .bold()
      .foregroundStyle(.gray)
      .multilineTextAlignment(.center)
      .padding(.top, 50)
      .padding(.bottom, 30)
  }

  private var mainImage: some View {
    Image(asset: Asset.Images.house)
      .resizable()
      .frame(width: 200, height: 200)
      .padding(.bottom, 20)
  }

  private var searchingSection: some View {
    VStack {
      Text(L10n.searchingQuestion)

      HStack {}
    }
  }

  private var textFields: some View {
    VStack {
      BorderedTextField(textInput: $email, placeholder: L10n.email, isPasswordField: false)
        .padding(.bottom, 20)

      BorderedTextField(textInput: $password, placeholder: L10n.password, isPasswordField: true)
    }
  }

  private var bottomButtons: some View {
    VStack {
      NavigationLink {
        isLoginScreen ? AnyView(BottomTabbar()) : AnyView(LoginScreen(isLoginScreen: true))
      } label: {
        Text(isLoginScreen ? L10n.login : L10n.register)
          .foregroundStyle(isDisabled ? Color.gray : Asset.Color.beatzColor.swiftUIColor)
      }
      .buttonStyle(PrimaryButtonStyle(isEnabled: true))
      .padding(.bottom, 10)
      .padding(.horizontal, 20)
      .disabled(isDisabled)

      NavigationLink {
        isLoginScreen ? LoginScreen(isLoginScreen: false) : LoginScreen(isLoginScreen: true)
      } label: {
        Text(isLoginScreen ? L10n.register : L10n.login)
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
      }
      .buttonStyle(PrimaryButtonStyle(isEnabled: true))
      .padding(.bottom, 20)
      .padding(.horizontal, 20)
    }
  }
}
