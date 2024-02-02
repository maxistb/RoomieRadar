//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//
// swiftlint:disable opening_brace

import FirebaseFirestore
import Foundation
import Styleguide

final class SwipingScreenViewModel: ObservableObject {
  @Published var wgOffererArray: [WGOfferer] = []
  @Published var wgSearcherArray: [WGSearcher] = []

  func getAllWGOfferer() {
    Firestore
      .firestore()
      .collection("WGOfferer")
      .getDocuments { snapshot, error in
        guard let snapshot = snapshot, error == nil else { return }

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

            self.wgOffererArray.append(wgOfferer)
          }
        }
      }
  }

  func getAllWGSearcher() {
    Firestore
      .firestore()
      .collection("WGSearcher")
      .getDocuments { snapshot, error in
        guard let snapshot = snapshot, error == nil else { return }

        snapshot.documents.forEach { documentSnapshot in
          let documentData = documentSnapshot.data()

          if let age = documentData["age"] as? String,
             let contactInfo = documentData["contactInfo"] as? String,
             let gender = documentData["gender"] as? String,
             let hobbies = documentData["hobbies"] as? String,
             let imageString = documentData["imageString"] as? String,
             let name = documentData["name"] as? String,
             let ownDescription = documentData["ownDescription"] as? String
          {
            let wgSearcher = WGSearcher(
              age: age,
              contactInfo: contactInfo,
              gender: gender,
              hobbies: hobbies,
              id: documentSnapshot.documentID,
              imageString: imageString,
              name: name,
              ownDescription: ownDescription
            )

            self.wgSearcherArray.append(wgSearcher)
          }
        }
      }
  }
}

// swiftlint:enable opening_brace
