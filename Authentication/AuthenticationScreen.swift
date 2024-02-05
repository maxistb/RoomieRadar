//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import CoreData
import Styleguide
import SwiftUI
import UIComponents

struct AuthenticationScreen: View {
  @ObservedObject private var viewModel = AuthenticationViewModel()

  private var isDisabled: Bool {
    if viewModel.viewState == .login {
      viewModel.email.isEmpty || viewModel.password.isEmpty
    } else {
      viewModel.email.isEmpty || viewModel.password.isEmpty || viewModel.registerSelection == .none
    }
  }

  var body: some View {
    NavigationView {
      if viewModel.isUserLoggedIn, let user = viewModel.authService.currentUser {
        BottomTabbar(user: user, isWGOffererState: viewModel.isWGOffererState)
      } else {
        VStack {
          header
          if viewModel.viewState == .login {
            mainImage
            textFields
          } else {
            textFields
              .padding(.bottom, 20)
            searchingSection
          }
          Spacer()
          bottomButtons
        }
        .padding(.horizontal, 15)
        .navigationBarBackButtonHidden()
        .alert(viewModel.errorMessage, isPresented: $viewModel.hasError) {}
      }
    }
  }

  private var header: some View {
    Text(viewModel.viewState.header)
      .font(.title2)
      .bold()
      .foregroundStyle(.gray)
      .multilineTextAlignment(.center)
      .padding(.top, 50)
      .padding(.bottom, 30)
      .onTapGesture {
        viewModel.email = "maximillian.stabe@studium.uni-hamburg.de"
        viewModel.password = "123456"
      }
  }

  private var mainImage: some View {
    Image(asset: Asset.Images.house)
      .resizable()
      .frame(width: 200, height: 200)
      .padding(.bottom, 20)
      .onTapGesture {
        viewModel.email = "maxjoesta@gmail.com"
        viewModel.password = "123456"
      }
  }

  private var searchingSection: some View {
    VStack {
      HStack {
        Text(L10n.searchingQuestion)
          .font(.title3)
          .bold()
          .foregroundStyle(.gray)
        Spacer()
      }

      HStack {
        createImageView(
          imageAsset: Asset.Images.examplePerson,
          foregroundColor: viewModel.registerSelection == .wgOfferer ? .green : .gray
        ) {
          viewModel.registerSelection = .wgOfferer
        }
        .padding(.trailing, 20)

        createImageView(
          imageAsset: Asset.Images.exampleWG,
          foregroundColor: viewModel.registerSelection == .wgSearcher ? .green : .gray
        ) {
          viewModel.registerSelection = .wgSearcher
        }
      }
    }
  }

  private func createImageView(
    imageAsset: ImageAsset,
    foregroundColor: Color,
    action: @escaping () -> Void
  ) -> some View {
    Image(asset: imageAsset)
      .resizable()
      .frame(width: 115, height: 115)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .onTapGesture { action() }
      .background {
        RoundedRectangle(cornerRadius: 12)
          .frame(width: 120, height: 120)
          .foregroundStyle(foregroundColor)
      }
  }

  private var textFields: some View {
    VStack {
      BorderedTextField(textInput: $viewModel.email, placeholder: L10n.email, isPasswordField: false)
        .padding(.bottom, 20)

      BorderedTextField(textInput: $viewModel.password, placeholder: L10n.password, isPasswordField: true)
    }
  }

  private var bottomButtons: some View {
    VStack {
      Button {
        if viewModel.viewState == .login {
          viewModel.loginUser()
        } else {
          viewModel.registerUser()
        }
      } label: {
        Text(viewModel.viewState.firstButtonTitle)
          .foregroundStyle(isDisabled ? Color.gray : Asset.Color.beatzColor.swiftUIColor)
      }
      .buttonStyle(PrimaryButtonStyle())
      .padding(.bottom, 10)
      .padding(.horizontal, 20)
      .disabled(isDisabled)

      Button {
        withAnimation {
          if viewModel.viewState == .login {
            viewModel.viewState = .register
          } else {
            viewModel.viewState = .login
          }
        }
      } label: {
        Text(viewModel.viewState.secondButtonTitle)
          .foregroundStyle(Asset.Color.beatzColor.swiftUIColor)
      }
      .buttonStyle(PrimaryButtonStyle())
      .padding(.bottom, 20)
      .padding(.horizontal, 20)
    }
  }
}

enum AuthenticationViewState {
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
