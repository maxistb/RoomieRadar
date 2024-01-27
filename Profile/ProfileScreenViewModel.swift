//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage
import Foundation
import PhotosUI
import SwiftUI

class ProfileScreenViewModel: ObservableObject {
  @Published var avatarItem: PhotosPickerItem?
  @Published var avatarImage: Image?
  @Published var showError = false
  @Published var errorMessage = ""

  private let storageRef = Storage.storage().reference()
  private let database = Firestore.firestore()

  var imageURL: URL? {
    URL(string: WGOfferer.shared.imageString)
  }

  let isWGOffererState: Bool

  init(isWGOffererState: Bool) {
    self.isWGOffererState = isWGOffererState
  }

  func saveChanges() {
    let docRef = database.collection("WGOfferer").document(WGOfferer.shared.id)
    WGOfferer.shared.updateFirestoreWGOfferer(docRef: docRef)
  }

  func getURL(item: PhotosPickerItem?, completionHandler: @escaping (_ result: Result<URL, Error>) -> Void) {
    // Step 1: Load as Data object.
    if let item = item {
      item.loadTransferable(type: Data.self) { result in
        switch result {
        case .success(let data):
          if let contentType = item.supportedContentTypes.first {
            // Step 2: make the URL file name and a get a file extention.
            let url = self.getDocumentsDirectory().appendingPathComponent("\(UUID().uuidString).\(contentType.preferredFilenameExtension ?? "")")
            if let data = data {
              do {
                // Step 3: write to temp App file directory and return in completionHandler
                try data.write(to: url)
                completionHandler(.success(url))
              } catch {
                completionHandler(.failure(error))
              }
            }
          }
        case .failure(let failure):
          completionHandler(.failure(failure))
        }
      }
    }
  }

  func getDocumentsDirectory() -> URL {
    // find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    // just send back the first one, which ought to be the only one
    return paths[0]
  }
}
