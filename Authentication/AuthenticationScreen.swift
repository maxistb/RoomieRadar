//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import CoreData
import RoomieRadarCoreData
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
    NavigationStack {
      if viewModel.isUserLoggedIn {
        BottomTabbar()
      } else {
        VStack {
          header
          if viewModel.viewState == .login {
            mainImage
            textFields
          } else {
            textFields
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

      HStack {
        RoundedRectangle(cornerRadius: 12)
          .frame(width: 50, height: 50)
          .padding(.trailing, 20)
          .foregroundStyle(viewModel.registerSelection == .wgOfferer ? .green : .gray)
          .onTapGesture {
            viewModel.registerSelection = .wgOfferer
          }

        RoundedRectangle(cornerRadius: 12)
          .frame(width: 50, height: 50)
          .foregroundStyle(viewModel.registerSelection == .wgSearcher ? .green : .gray)
          .onTapGesture {
            viewModel.registerSelection = .wgSearcher
          }
      }
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
      .buttonStyle(PrimaryButtonStyle(isEnabled: true))
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
      .buttonStyle(PrimaryButtonStyle(isEnabled: true))
      .padding(.bottom, 20)
      .padding(.horizontal, 20)
    }
  }
}

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
