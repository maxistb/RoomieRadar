//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseAuth
import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
  @Published var viewState: ViewState

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

  func registerUser() {
    Auth.auth().createUser(withEmail: email, password: password) { _, error in
      if let error = error {
        self.hasError = true
        self.errorMessage = error.localizedDescription

      } else {
        Auth.auth().currentUser?.sendEmailVerification()
      }
    }
  }

  func loginUser() {
    Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
      if let error = error {
        self.hasError = true
        self.errorMessage = error.localizedDescription

      } else {
        if let user = authDataResult?.user {
          if user.isEmailVerified {
            self.isUserLoggedIn = true
          } else {
            self.hasError = true
            self.errorMessage = "Bitte verifiziere deine E-Mail"
          }
        }
      }
    }
  }
}
