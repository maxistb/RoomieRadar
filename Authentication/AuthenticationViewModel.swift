//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import CoreData
import Firebase
import FirebaseAuth
import Foundation
import RoomieRadarCoreData
import Styleguide

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
  private let db = Firestore.firestore()

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
        let user: User? = self?.authService.currentUser
        user?.sendEmailVerification()
        if self?.registerSelection == .wgOfferer {
          self?.createWGOfferer(user: user)
        } else if self?.registerSelection == .wgSearcher {
          self?.createWGSearcher(user: user)
        }
        self?.hasError = true
        self?.errorMessage = L10n.createAccountVerifyEmail
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
            self?.errorMessage = L10n.verifyEmail
          }
        } else {
          self?.hasError = true
          self?.errorMessage = L10n.genericError
        }
      }
    }
  }

  func createWGOfferer(user: User?) {
    if let user = user {
      let newWGOfferer = WGOfferer.createWGOfferer(uid: user.uid)
      let docRef = db.collection("WGOfferer").document(user.uid)

      docRef.setData(["address": newWGOfferer.address])
      docRef.setData(["contactInfo": newWGOfferer.contactInfo])
      docRef.setData(["idealRoommate": newWGOfferer.idealRoommate])
      docRef.setData(["imageString": newWGOfferer.imageString])
      docRef.setData(["name": newWGOfferer.name])
      docRef.setData(["wgDescription": newWGOfferer.wgDescription])
      docRef.setData(["wgPrice": newWGOfferer.wgPrice])
      docRef.setData(["wgSize": newWGOfferer.wgSize])

    } else {
      hasError = true
      errorMessage = L10n.genericError
    }
  }

  func createWGSearcher(user: User?) {
    if let user = user {
      let newWGSearcher = WGSearcher.createWGSearcher(uid: user.uid)
      let docRef = db.collection("WGSearcher").document(user.uid)

      docRef.setData(["age": newWGSearcher.age])
      docRef.setData(["contactInfo": newWGSearcher.contactInfo])
      docRef.setData(["gender": newWGSearcher.gender])
      docRef.setData(["hobbies": newWGSearcher.hobbies])
      docRef.setData(["imageString": newWGSearcher.imageString])
      docRef.setData(["name": newWGSearcher.name])
      docRef.setData(["ownDescription": newWGSearcher.ownDescription])
    } else {
      hasError = true
      errorMessage = L10n.genericError
    }
  }
}
