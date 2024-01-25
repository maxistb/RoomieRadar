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
  @Published var registerSelection: RegisterSelection = .none
  private let authService: Auth

  enum RegisterSelection {
    case none
    case wgOfferer
    case wgSearcher
  }

  init() {
    self.viewState = .login
    self.email = ""
    self.password = ""
    self.showAlert = false
    self.isUserLoggedIn = false
    self.authService = Auth.auth()
  }

  func registerUser() {
    authService.createUser(withEmail: email, password: password) { [weak self] _, error in
      if let error = error {
        self?.hasError = true
        self?.errorMessage = error.localizedDescription

      } else {
        self?.authService.currentUser?.sendEmailVerification()
      }
    }
  }

  func loginUser() {
    authService.signIn(withEmail: email, password: password) { [weak self] authDataResult, error in
      if let error = error {
        self?.hasError = true
        self?.errorMessage = error.localizedDescription

      } else {
        if let user = authDataResult?.user {
          if user.isEmailVerified {
            self?.isUserLoggedIn = true
          } else {
            self?.hasError = true
            self?.errorMessage = "Bitte verifiziere deine E-Mail"
          }
        } else {
          self?.hasError = true
          self?.errorMessage = "Ein Fehler ist aufgetreten"
        }
      }
    }
  }

  func createWGOfferer() {

  }

  func createWGSearcher() {

  }
}
