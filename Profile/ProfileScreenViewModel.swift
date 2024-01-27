//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Foundation
import PhotosUI
import SwiftUI

class ProfileScreenViewModel: ObservableObject {
  @Published var avatarImage: UIImage?
  @Published var showImagePicker = false
  @Published var showError = false
  @Published var errorMessage = ""

  private let storageRef = Storage.storage().reference()
  private let database = Firestore.firestore()

  var imageURL: URL? {
    URL(string: WGOfferer.shared.imageString)
  }

  let isWGOffererState: Bool
  let user: User

  init(isWGOffererState: Bool, user: User) {
    self.isWGOffererState = isWGOffererState
    self.user = user
  }

  func saveChanges() {
    if isWGOffererState {
      let docRef = database.collection("WGOfferer").document(WGOfferer.shared.id)
      WGOfferer.shared.updateFirestoreWGOfferer(docRef: docRef)
    } else {
      let docRef = database.collection("WGSearcher").document(WGSearcher.shared.id)
      WGSearcher.shared.updateFirestoreWGOfferer(docRef: docRef)
    }
  }

  func persistImageToStorage() {
    guard let imageData = avatarImage?.jpegData(compressionQuality: 0.5) else { return }
    let docRef = storageRef.child("\(user.uid)/profileImage.png")

    docRef.putData(imageData, metadata: nil) { _, err in
      if let err = err {
        self.showError = true
        self.errorMessage = "Failed to push image to Storage: \(err)"
        return
      }

      docRef.downloadURL { url, err in
        if let err = err {
          self.showError = true
          self.errorMessage = "Failed to retrieve downloadURL: \(err)"
          return
        }

        if let url = url {
          if self.isWGOffererState {
            WGOfferer.shared.imageString = url.absoluteString
          } else {
            WGSearcher.shared.imageString = url.absoluteString
          }
        }
      }
    }
  }
}
