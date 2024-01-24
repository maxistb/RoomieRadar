//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseAuth
import Foundation

final class AuthenticationViewModel: ObservableObject {
  @Published var viewState: ViewState = .login

  @Published var email: String
  @Published var password: String

  @Published var showAlert: Bool
  @Published var isUserLoggedIn: Bool

  @Published var hasError = false
  @Published var errorMessage = ""

  init() {
    self.viewState = .login
    self.email = ""
    self.password = ""
    self.showAlert = false
    self.isUserLoggedIn = false
  }

  func registerUser() async {
    do {
      try await Auth.auth().createUser(withEmail: email, password: password)
    } catch {
      hasError = true
      errorMessage = error.localizedDescription
    }
  }

  func loginUser() async {
    do {
      try await Auth.auth().signIn(withEmail: email, password: password)
      isUserLoggedIn = true

    } catch {
      hasError = true
      errorMessage = error.localizedDescription
    }
  }
}
