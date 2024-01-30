//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import FirebaseFirestore
import Foundation
import Styleguide

final class SwipingScreenViewModel: ObservableObject {
  @Published var hasError = false
  @Published var errorMessage = ""
  @Published var wgOffererArray: [WGOfferer] = []

  func getAllWGOfferer() {
    Firestore
      .firestore()
      .collection("WGOfferer")
      .getDocuments { [weak self] snapshot, error in
        guard let snapshot = snapshot, error == nil else {
          self?.hasError = true
          self?.errorMessage = error?.localizedDescription ?? L10n.genericError
          return
        }

        snapshot.documents.forEach { documentSnapshot in
          let documentData = documentSnapshot.data()

          if let address = documentData["address"] as? String,
             let contactInfo = documentData["contactInfo"] as? String,
             let idealRoommate = documentData["idealRoommate"] as? String,
             let imageString = documentData["imageString"] as? String,
             let name = documentData["name"] as? String,
             let wgDescription = documentData["wgDescription"] as? String,
             let wgPrice = documentData["wgPrice"] as? String,
             let wgSize = documentData["wgSize"] as? String
          {
            let wgOfferer = WGOfferer(
              address: address,
              contactInfo: contactInfo,
              id: documentSnapshot.documentID,
              idealRoommate: idealRoommate,
              imageString: imageString,
              name: name,
              wgDescription: wgDescription,
              wgPrice: wgPrice,
              wgSize: wgSize
            )

            self?.wgOffererArray.append(wgOfferer)
          }
        }
      }
  }
}
