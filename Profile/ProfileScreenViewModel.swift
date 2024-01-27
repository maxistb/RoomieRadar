//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage
import Foundation
import PhotosUI
import RoomieRadarCoreData
import SwiftUI

class ProfileScreenViewModel: ObservableObject {
  @Published var avatarItem: PhotosPickerItem?
  @Published var avatarImage: Image?
  @Published var showError = false
  @Published var errorMessage = ""

  let wgOfferer: WGOfferer?
  let wgSearcher: WGSearcher?
  private let storageRef = Storage.storage().reference()
  private let database = Firestore.firestore()

  var imageURL: URL? {
    if let wgOfferer = wgOfferer {
      return URL(string: wgOfferer.imageString)
    } else if let wgSearcher = wgSearcher {
      return URL(string: wgSearcher.imageString)
    } else {
      return nil
    }
  }

  init(wgOfferer: WGOfferer?, wgSearcher: WGSearcher?) {
    self.wgOfferer = wgOfferer
    self.wgSearcher = wgSearcher
  }

  func saveChanges() {
    if let wgOfferer = wgOfferer {
      let docRef = database.collection("WGOfferer").document(wgOfferer.id)
      WGOfferer.updateFirestoreWGOfferer(docRef: docRef, newWGOfferer: wgOfferer)
    } else if let wgSearcher = wgSearcher {
      let docRef = database.collection("WGSearcher").document(wgSearcher.id)
      WGSearcher.updateFirestoreWGOfferer(docRef: docRef, wgSearcher: wgSearcher)
    }
    try? CoreDataStack.shared.mainContext.save()
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
