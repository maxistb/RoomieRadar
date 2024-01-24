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
  @State private var isUserLoggedIn = false
  @State private var viewState: ViewState = .login
  @State private var showAlert = false

  private var isDisabled: Bool {
    email.isEmpty || password.isEmpty
  }

  var body: some View {
    NavigationStack {
      if isUserLoggedIn {
        BottomTabbar()
      } else {
        VStack {
          header
          if viewState == .login {
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
  }

  private var header: some View {
    Text(viewState.header)
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
      Button {
        isUserLoggedIn.toggle()
      } label: {
        Text(viewState.firstButtonTitle)
          .foregroundStyle(isDisabled ? Color.gray : Asset.Color.beatzColor.swiftUIColor)
      }
      .buttonStyle(PrimaryButtonStyle(isEnabled: true))
      .padding(.bottom, 10)
      .padding(.horizontal, 20)
      .disabled(isDisabled)

      Button {
        if viewState == .login {
          viewState = .register
        } else {
          viewState = .login
        }
      } label: {
        Text(viewState.secondButtonTitle)
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
      }
      .buttonStyle(PrimaryButtonStyle(isEnabled: true))
      .padding(.bottom, 20)
      .padding(.horizontal, 20)
    }
  }
}

extension LoginScreen {
  enum ViewState {
    case login
    case register

    var header: String {
      switch self {
      case .login:
        L10n.loginScreenMainText
      case .register:
        L10n.registerScreenMainText
      }
    }

    var firstButtonTitle: String {
      switch self {
      case .login:
        L10n.login
      case .register:
        L10n.register
      }
    }

    var secondButtonTitle: String {
      switch self {
      case .login:
        L10n.register
      case .register:
        L10n.login
      }
    }
  }
}
